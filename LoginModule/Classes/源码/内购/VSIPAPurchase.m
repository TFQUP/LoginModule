//
//  VSIPAPurchase.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSIPAPurchase.h"
#import "VSSDKDefine.h"

static BOOL isRedeemGift = NO;

@interface VSIPAPurchase()<SKPaymentTransactionObserver,
SKProductsRequestDelegate>{
    
    SKProductsRequest *request;
    NSMutableArray * promoArr;
}

//产品ID
@property (nonnull,copy)NSString * profductId;

@end

static VSIPAPurchase * manager = nil;

@implementation VSIPAPurchase
#pragma mark -- 单例方法
+ (instancetype)manager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!manager) {
            manager = [[VSIPAPurchase alloc] init];
        }
        
    });
    
    return manager;
}

#pragma mark -- 添加内购监听者
-(void)vsdk_startIapManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
    });

}

#pragma mark -- 移除内购监听者
-(void)vsdk_stopIapManager{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        
    });
    
}

#pragma mark -- 发起购买的方法
-(void)vsdk_purchaseWithProductID:(NSString *)productID iapResult:(purchaseResult)iapResult{
    
    SKPaymentTransaction * transaction = [[SKPaymentQueue defaultQueue].transactions firstObject];
    
    if ([SKPaymentQueue defaultQueue].transactions.count > 0 && transaction.payment.applicationUsername == nil &&[productID isEqualToString:transaction.payment.productIdentifier]&&self.isSubProduct == NO) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:VSLocalString(@"You have a redeemable item, redeem it to the current character?") preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"Not now") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.iapResultBlock = iapResult; [self startRequestProductInfowithPid:productID];

        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"Redeem now") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            VS_SHOW_TIPS_MSG(@"Redeeming...")
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            NSString * base64String = [[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [dic setValue: base64String forKey:VSDK_RECEIPT_KEY];
            [dic setValue:transaction.transactionIdentifier forKey:VSDK_TRANSID_KEY];
            [dic setValue: self.vsdk_order forKey:VSDK_PARAM_ORDER];
            [dic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
            [dic setValue: self.vsdk_userId forKey:VSDK_PARAM_USER_ID];
            [dic setValue:@"consumption" forKey:VSDK_PARAM_PRODUCT_TYPE];
            NSString *savedPath = VS_UNFINISH_ORDER_PATH_PLIST(transaction.transactionIdentifier);
            [dic writeToFile:savedPath atomically:YES];
        
            isRedeemGift = YES;
            [self sendAppStoreRequestToPhpWithReceipt:base64String userId:self.vsdk_userId paltFormOrder:self.vsdk_order trans:transaction];
            
        }]];
        
        [VS_RootVC presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        self.iapResultBlock = iapResult;
        [self startRequestProductInfowithPid:productID];
        
    }
}



-(void)startRequestProductInfowithPid:(NSString *)pid{
    
    VS_SHOW_TIPS_MSG(@"Purchasing...")

    self.profductId = pid;
    
    if (!self.profductId.length) {
        
        [VSDeviceHelper showSystemTipsAlertWithTitle:@"Warm prompt" message:@"There is no corresponding product." comfirmTitle:@"OK"];
    }
 
    if ([SKPaymentQueue canMakePayments]) {
        
        [self requestProductInfo:self.profductId];
        
    }else{
    
        [VSDeviceHelper showSystemTipsAlertWithTitle:@"Warm prompt" message:@"Please turn on the in-app paid purchase function first." comfirmTitle:@"OK"];
    }
    
}

#pragma mark -- 发起本地化查询请求
-(void)requestProductLocalInfo:(NSArray *)productIDArr{
        [VSIPAPurchase manager].chekTag = YES;
        NSSet * IDSet = [NSSet setWithArray:productIDArr];
        request = [[SKProductsRequest alloc]initWithProductIdentifiers:IDSet];
        request.delegate = self;
        [request start];

}

#pragma mark -- 发起购买请求
-(void)requestProductInfo:(NSString *)productID{
    
    NSArray * productArray = [[NSArray alloc]initWithObjects:productID,nil];
    NSSet * IDSet = [NSSet setWithArray:productArray];
    request = [[SKProductsRequest alloc]initWithProductIdentifiers:IDSet];
    request.delegate = self;
    [request start];
    
}



#pragma mark -- SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if ([VSIPAPurchase manager].chekTag == YES) {
        NSArray *Product = response.products;
        for(SKProduct * pro in Product){
            NSNumberFormatter *_priceFormatter = [[NSNumberFormatter alloc] init];
            NSString *moneyType = _priceFormatter.internationalCurrencySymbol;
          DEBUGLog(@"Product id: %@\nSKProduct 描述信息%@ \n产品标题 %@ \n产品描述信息: %@\n价格: %@ \n货币类型: %@", pro.productIdentifier,[pro description],pro.localizedTitle,pro.localizedDescription,pro.price,moneyType);
        }
        [VSIPAPurchase manager].qCllback(Product);
        [VSIPAPurchase manager].chekTag = NO;
        return;
    }
    
    
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            VS_HUD_HIDE;
            VS_SHOW_ERROR_STATUS(@"No Product Info");
        });
        
        if (self.iapResultBlock) {
            self.iapResultBlock(NO, nil, @"无法获取商品信息，购买失败");
        }
        
        return;
    }
    
    SKProduct * product = nil;
    
    for(SKProduct * pro in myProduct){
     
      DEBUGLog(@"Product id: %@\nSKProduct 描述信息%@ \n产品标题 %@ \n产品描述信息: %@\n价格: %@", pro.productIdentifier,[pro description],pro.localizedTitle,pro.localizedDescription,pro.price);

        if ([pro.productIdentifier isEqualToString:self.profductId]) {
            
            product = pro;
            
            break;
        }
    }
    
    if (product) {
        __weak typeof(self) ws = self;
        SKProduct *nowProduct = myProduct[0];
        NSString *nowMoney = [NSString stringWithFormat:@"%@",nowProduct.price];
        NSNumberFormatter *_priceFormatter = [[NSNumberFormatter alloc] init];
        NSString *moneyType = _priceFormatter.internationalCurrencySymbol;
        
        NSLocale *storeLocale = nowProduct.priceLocale;
        moneyType = (NSString*)CFLocaleGetValue((CFLocaleRef)storeLocale, kCFLocaleCurrencyCode);
        
        VSIPAPurchase *ipamanager = [VSIPAPurchase manager];
        [[VSDKAPI shareAPI]  vsdk_cpOrderWithUserId:VSDK_GAME_USERID Money:nowMoney MoneyType:moneyType Extend:ipamanager.extend FFType:VSDK_PARAM_FF_TYPE ServerId:ipamanager.serverId ServerName:ipamanager.serverName RoleId:VS_CONVERT_TYPE(ipamanager.roleId) RoleName:ipamanager.rolename RoleLevel:VS_CONVERT_TYPE(ipamanager.roleLevel) GoodId:ipamanager.goodId GoodsName:ipamanager.goodName CPTradeSn:ipamanager.tradeSn ExtData:ipamanager.extData ThirdGoodId:ipamanager.productId ThirdGoodName:ipamanager.productName ifSub:ipamanager.subProduct success:^(VSDKAPI *api, id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    [VSIPAPurchase manager].vsdk_order = [GETRESPONSEDATA:VSDK_PARAM_ORDER];
                    
                    if ([[VSIPAPurchase manager].vsdk_order length] != 0) {
                        
                        SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
//                        payment.quantity = 10;
                        //使用苹果提供的属性,将平台订单号复制给这个属性作为透传参数
                        payment.applicationUsername = ws.vsdk_order;
                     
                        [[SKPaymentQueue defaultQueue] addPayment:payment];
                        
                    }else{VS_SHOW_ERROR_STATUS(@"Parameter Error!");}
                    
                }else{VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);}
                
            }else{VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);}
            
        } failure:^(VSDKAPI *api, NSString *failure) {VS_SHOW_ERROR_STATUS(@"Request failed,please retry");}];
        
        
        
    }else{
        
    }
}

//查询失败后的回调
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    if (self.iapResultBlock) {
        self.iapResultBlock(NO, nil, [error localizedDescription]);
    }
}

//如果没有设置监听购买结果将直接跳至反馈结束；
-(void)requestDidFinish:(SKRequest *)request{
    
}



#pragma mark -- 监听结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    //当用户购买的操作有结果时，就会触发下面的回调函数，
    for (SKPaymentTransaction * transaction in transactions) {
        
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchased:{
//                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                 [self completeTransaction:transaction];

            }break;
                
            case SKPaymentTransactionStateFailed:{
                
                [self failedTransaction:transaction];
                
            }break;
                
            case SKPaymentTransactionStateRestored:{//已经购买过该商品
                
                [self restoreTransaction:transaction];
                
            }break;
                
            case SKPaymentTransactionStatePurchasing:{
                
              //DEBUGLog(@"正在购买中...");
                
            }break;
                
            case SKPaymentTransactionStateDeferred:{
                
              //DEBUGLog(@"最终状态未确定");
                
            }break;
                
            default:
                break;
        }
    }
}



//完成交易
#pragma mark -- 交易完成的回调
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
#pragma mark -- 获取购买凭证并且发送服务器验证
    
    //订阅类商品
    if (self.isSubProduct||transaction.originalTransaction) {
        //存储订阅标识
        if (transaction.originalTransaction.transactionIdentifier) {
        
            VS_USERDEFAULTS_SETVALUE(transaction.originalTransaction.transactionIdentifier, VSDK_SUBSCRIBTION_TRANSID);
        }else{
        
            VS_USERDEFAULTS_SETVALUE(transaction.transactionIdentifier, VSDK_SUBSCRIBTION_TRANSID);
            
        }
        
        if (self.vsdk_order) {
          
            [self saveSubscriptionFlagWithTransaction:transaction];
        }
    
        [self getAndSaveSubscriptionReceiptWithTrans:transaction];
        
    }
    
    if(!self.isSubProduct&&!transaction.originalTransaction){

   
        if ([transaction.payment.productIdentifier hasPrefix:@"sub"]) {
           
            if (self.vsdk_order) {
                    
                  [self saveSubscriptionFlagWithTransaction:transaction];
            }
              
                [self getAndSaveSubscriptionReceiptWithTrans:transaction];
            
        }else{
          
        if (self.vsdk_order) {
            
            [self saveOrderByInAppPurchase:transaction];
            
        }
            
        NSURL * receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        NSString * base64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        if (![VSTool isBlankString:self.vsdk_order] && ![VSTool isBlankString:self.vsdk_userId] && ![VSTool isBlankString:transaction.payment.productIdentifier] && ![VSTool isBlankString:base64String]) {
            //此处用钥匙串保存支付参数，防止掉单
            NSMutableDictionary * iapDic = [[NSMutableDictionary alloc]init];
            NSString * order = self.vsdk_order;
            NSString * userId = self.vsdk_userId;
            NSString * productId = transaction.payment.productIdentifier;
            [iapDic setObject:base64String forKey:@"receipt"];
            [iapDic setObject:order forKey:@"order"];
            [iapDic setObject:userId forKey:@"userId"];
            [iapDic setObject:productId forKey:@"productId"];
            
            //获取之前的掉单
            NSArray *arr = [VSChainTool objectForKey:VSDK_IAPKEY];
            //保存全部的掉单
            NSMutableArray *allIapArr = [NSMutableArray array];
            [allIapArr setArray:arr];
            [allIapArr addObject:iapDic];
                
            [VSChainTool setObject:allIapArr forKey:VSDK_IAPKEY];
        }
            
        //消耗型内购处理方法
        [self getAndSaveConsumptionReceiptWithTrans:transaction]; //获取交易成功后的购买凭证
    
        }
    }
}

#pragma mark -- 处理交易失败回调
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    
     VS_HUD_HIDE;

    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
    NSString * error = nil;

    if(transaction.error.code != SKErrorPaymentCancelled) {
        
        VS_SHOW_INFO_MSG(@"Purchase Failed");
        
        error = [NSString stringWithFormat:@"%ld",(long)transaction.error.code];
        
        [[VSDKAPI shareAPI]  vsdk_sendPayErrorLogWithUser:VSDK_GAME_USERID roleId:self.vsdk_roleId ServerId:self.vsdk_serverId ServerName:self.vsdk_serverName RoleName:self.vsdk_roleName RoleLevel:self.vsdk_roleName ErrorCode:[NSString stringWithFormat:@"%ld",(long)transaction.error.code] errorMsg:@"内购购买失败"];
        
    } else {
        
        VS_SHOW_INFO_MSG(@"Cancel Purchase");
        error = [NSString stringWithFormat:@"%ld",(long)transaction.error.code];
        
    }
    
    if (self.iapResultBlock) {
        self.iapResultBlock(NO, nil, error);
    }
   
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
    
    VS_HUD_HIDE;
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark -- 存储订单,防止走漏单流程是获取不到Order 且苹果返回order为nil
-(void)saveOrderByInAppPurchase:(SKPaymentTransaction *)transaction{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    NSString * order = self.vsdk_order;
    
    [dic setValue:order forKey:transaction.transactionIdentifier];
    
    NSString *savedPath = VS_TEMP_ORDER_PATH_PLIST(transaction.transactionIdentifier);
    
    [dic writeToFile:savedPath atomically:YES];
    //防止用户充值成功后删除app,这里采用keychain保存更新
    [VSChainTool setObject:self.vsdk_order forKey:transaction.transactionIdentifier];
}

//根据这个来判断这个是不是订阅类型的商品
-(void)saveSubscriptionFlagWithTransaction:(SKPaymentTransaction *)transaction{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString *savedPath;
 
    if (transaction.originalTransaction) {
      
        [dic setValue:self.vsdk_order forKey:transaction.transactionIdentifier];
        savedPath = VS_SUBSCRIPTION_FLAG_PATH_PLIST(transaction.originalTransaction.transactionIdentifier);
        
    }else{
        
        [dic setValue:self.vsdk_order forKey:transaction.transactionIdentifier];
        savedPath = VS_SUBSCRIPTION_FLAG_PATH_PLIST(transaction.transactionIdentifier);
    }

    [dic writeToFile:savedPath atomically:YES];

}

-(NSString *)getSubscriptionTranscationFlagWithTransactionId:(NSString *)transId{
    
    NSString * subscriptionOrder;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray * cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper SubscriptionFlagPath] error:&error];
   
    for (NSString * name in cacheFileNameArray) {
        
        NSString * filePath = VS_SUBSCRIPTION_FLAG_PATH(name);
        
        NSMutableDictionary *localdic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        
        if ([localdic valueForKey:transId]) {
            
            subscriptionOrder = [localdic valueForKey:transId];
            
        }else{
            
            continue;
        }
    }
    
    if ([subscriptionOrder length]>0) {
        
        return subscriptionOrder;
        
    }else{
        
        return @"";
        
    }
}



#pragma mark -- 根据凭证存储的列表里获取Order
-(NSString *)getOrderWithTransactionId:(NSString *)transId{
    
    NSString * order;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray * cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper tempOrderPath] error:&error];
    
    for (NSString * name in cacheFileNameArray) {
        
        NSString * filePath = VS_TEMP_ORDER_PATH(name);
        
        NSMutableDictionary *localdic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if ([localdic valueForKey:transId]) {
            
            order = [localdic valueForKey:transId];
            
        }else{
            continue;
        }
    }
    
    if ([order length]>0) {
        
      return order;
        
    }else{
        
        //本地存储的被删除了，此次需要从钥匙串中取出走漏单流程
        if (![VSChainTool objectForKey:transId]) {
            order = [VSChainTool objectForKey:transId];
            return order;
        }else{
            return @"";
        }
        
    }
}


#pragma mark -- 获取消耗型购买凭证
-(void)getAndSaveConsumptionReceiptWithTrans:(SKPaymentTransaction *)transaction{
    
    //获取交易凭证
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSURL * receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * base64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString * order = transaction.payment.applicationUsername;
    NSString * userId;
    
    if (self.vsdk_userId) {
        
        userId = self.vsdk_userId;
    
        VS_USERDEFAULTS_SETVALUE(userId, @"vsdk_iap_userId");
        
    }else{
        
        userId = [VS_USERDEFAULTS
                  valueForKey:@"vsdk_iap_userId"];
    }
    
    if (userId == nil||[userId length] == 0) {
        
        userId = @"走漏单流程未传入userId";
    }
    
    if (order == nil||[order length] == 0) {
        
        if (self.vsdk_order) {
            
            order = self.vsdk_order;
            
        }else{
            
            if ([[self getOrderWithTransactionId:transaction.transactionIdentifier] length] > 0) {
              
                order = [self getOrderWithTransactionId:transaction.transactionIdentifier];
                
            }else{
                
                order = @"消耗型内购苹果返回透传参数为nil";
            }
        }
    }
    
        [dic setValue: base64String forKey:VSDK_RECEIPT_KEY];
        [dic setValue:transaction.transactionIdentifier forKey:VSDK_TRANSID_KEY];
        [dic setValue: order forKey:VSDK_PARAM_ORDER];
        [dic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
        [dic setValue: userId forKey:VSDK_PARAM_USER_ID];
        [dic setValue:@"consumption" forKey:VSDK_PARAM_PRODUCT_TYPE];
        NSString *savedPath = VS_UNFINISH_ORDER_PATH_PLIST(transaction.transactionIdentifier);

        [dic writeToFile:savedPath atomically:YES];
    
    if (base64String == nil) {
        
        VS_HUD_HIDE;
        
    }else{
        
        [self sendAppStoreRequestToPhpWithReceipt:base64String userId:userId paltFormOrder:order trans:transaction];
    }
  
}

#pragma mark -- 获取订阅型购买凭证
-(void)getAndSaveSubscriptionReceiptWithTrans:(SKPaymentTransaction *)transaction{
    //获取交易凭证
    NSURL * receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * base64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //初始化字典
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString * order = transaction.payment.applicationUsername;
    NSString * userId;
    
    if (self.vsdk_userId) {
        
        userId = self.vsdk_userId;
        VS_USERDEFAULTS_SETVALUE(userId, @"vsdk_iap_userId");
        
    }else{
        
        userId = [VS_USERDEFAULTS
                  valueForKey:@"vsdk_iap_userId"];
    }
    
    if (userId == nil||[userId length] == 0) {
        
        userId = @"走漏单流程未传入userId";
    }
    
    if (order == nil||[order length] == 0) {
        
        if (self.vsdk_order) {
            
            order = self.vsdk_order;
            
        }else{
            
            if (self.isSubProduct){
                
                if (!transaction.originalTransaction) {
                    
                    if ([[self getSubscriptionTranscationFlagWithTransactionId:transaction.transactionIdentifier] length] > 0) {

                            order = [self getSubscriptionTranscationFlagWithTransactionId:transaction.transactionIdentifier];

                        }else{

                             order = @"订阅型苹果返回透传参数为nil";
                    }
                }
            }
        }
    }
    
    NSString *savedPath;
    
    if (self.isSubProduct) {
        
        if (transaction.originalTransaction) {
            savedPath = VS_UNFINISH_ORDER_PATH_PLIST(transaction.originalTransaction.transactionIdentifier);
            [dic setValue: base64String forKey:VSDK_RECEIPT_KEY];
            [dic setValue:transaction.originalTransaction.transactionIdentifier forKey:VSDK_TRANSID_KEY];
            [dic setValue: order forKey:VSDK_PARAM_ORDER];
            [dic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
            [dic setValue: userId forKey:VSDK_PARAM_USER_ID];
            [dic setValue:@"subscription" forKey:VSDK_PARAM_PRODUCT_TYPE];
            
        }else{
          
            savedPath = VS_UNFINISH_ORDER_PATH_PLIST(transaction.transactionIdentifier);
            [dic setValue: base64String forKey:VSDK_RECEIPT_KEY];
            [dic setValue:transaction.transactionIdentifier forKey:VSDK_TRANSID_KEY];
            [dic setValue: order forKey:VSDK_PARAM_ORDER];
            [dic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
            [dic setValue: userId forKey:VSDK_PARAM_USER_ID];
            [dic setValue:@"subscription" forKey:VSDK_PARAM_PRODUCT_TYPE];
        }
       
    }else{
        
        if (transaction.originalTransaction) {
           
            savedPath = VS_UNFINISH_ORDER_PATH_PLIST(transaction.originalTransaction.transactionIdentifier);
            [dic setValue: base64String forKey:VSDK_RECEIPT_KEY];
            [dic setValue:transaction.originalTransaction.transactionIdentifier forKey:VSDK_TRANSID_KEY];
            [dic setValue: order forKey:VSDK_PARAM_ORDER];
            [dic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
            [dic setValue: userId forKey:VSDK_PARAM_USER_ID];
            [dic setValue:@"subscription" forKey:VSDK_PARAM_PRODUCT_TYPE];
            
        }else{
            
            savedPath = VS_UNFINISH_ORDER_PATH_PLIST(transaction.transactionIdentifier);
            [dic setValue: base64String forKey:VSDK_RECEIPT_KEY];
            [dic setValue:transaction.transactionIdentifier forKey:VSDK_TRANSID_KEY];
            [dic setValue: order forKey:VSDK_PARAM_ORDER];
            [dic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
            [dic setValue: userId forKey:VSDK_PARAM_USER_ID];
            [dic setValue:@"subscription" forKey:VSDK_PARAM_PRODUCT_TYPE];
        }
        
    }
    
        [dic writeToFile:savedPath atomically:YES];

    if (self.isSubProduct) {
        
        if (transaction.originalTransaction) {
            
            if (base64String != nil) {
                
                [self sendSubscriptionRequestToPhpWithReceipt:base64String userId:userId paltFormOrder:order ifXudingReceipt:NO trans:transaction];
            }else{
                VS_HUD_HIDE;
            }
            
        }else{
            
            if (base64String != nil) {
             
                 [self sendSubscriptionRequestToPhpWithReceipt:base64String userId:userId paltFormOrder:order ifXudingReceipt:YES trans:transaction];
            }else{
                
                 VS_HUD_HIDE;
               
            }
        }
    }
}

#pragma mark -- 获取平台订单号去后台获取订单先关的订单信息
-(void)getPlatformAmountInfoWithOrder:(NSString *)transOrder{
    
    [[VSDKAPI shareAPI]  vsdk_platformAmountWithOrder:transOrder success:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            self.platformAmount = [GETRESPONSEDATA:@"amount"];
            self.vsdk_amountType = [GETRESPONSEDATA:@"amount_type"];
            self->_third_goods_id = [GETRESPONSEDATA:VSDK_PARAM_THIRD_GOODS_ID];

        }
        
    } failure:^(NSString *failure) {

    }];
    
}

#pragma mark -- 存储成功订单
-(void)SaveIapSuccessReceiptDataWithReceipt:(NSString *)receipt Order:(NSString *)order UserId:(NSString *)userId transId:(NSString *)transactionId productType:(NSString *)type{
    
    NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
    [mdic setValue:[self getCurrentZoneTime] forKey:VSDK_PARAM_TIME];
    [mdic setValue:order forKey:VSDK_PARAM_ORDER];
    [mdic setValue:userId forKey:VSDK_PARAM_USER_ID];
    [mdic setValue:receipt forKey:VSDK_RECEIPT_KEY];
    [mdic setValue:type forKey:VSDK_PARAM_PRODUCT_TYPE];
    
    NSString * successReceiptPath;
    
    if ([type isEqualToString:@"subscription"]) {
        
      successReceiptPath = VS_SUB_SUCCESS_ORDER_PATH_PLIST(transactionId);
        
      [self insertSubReceiptWithReceiptByReceipt:receipt withDic:mdic  inReceiptPath:successReceiptPath];
        
    }else{
        
      successReceiptPath = VS_SUCCESS_ORDER_PATH_PLIST(transactionId);
    
      [self insertReceiptWithReceiptByReceipt:receipt withDic:mdic  inReceiptPath:successReceiptPath];
    }

}


-(void)insertSubReceiptWithReceiptByReceipt:(NSString *)receipt withDic:(NSDictionary *)dic inReceiptPath:(NSString *)receiptfilePath{
   
     BOOL isContain = NO;
      
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSError * error;
      NSArray * cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper SuccessSubPath] error:&error];
      
      if (cacheFileNameArray.count == 0) {
          
          [dic writeToFile:receiptfilePath atomically:YES];
  
      }else{
         
          if (error == nil) {
           
              for (NSString * name in cacheFileNameArray) {

                  NSString * filePath = VS_SUB_SUCCESS_ORDER_PATH(name);
                  
                  NSMutableDictionary *localdic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                  
                  if ([localdic.allValues containsObject:receipt]) {
                      
                      isContain = YES;
                      
                  }else{
                      
                      continue;
                  }
              }
          }
      }
      
      if (isContain == NO) {
          
        [dic writeToFile:receiptfilePath atomically:YES];

      }
    
}

#pragma mark -- 写入购买成功的凭证
-(void)insertReceiptWithReceiptByReceipt:(NSString *)receipt withDic:(NSDictionary *)dic inReceiptPath:(NSString *)receiptfilePath{
    
    BOOL isContain = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray * cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper SuccessIapPath] error:&error];
    
    if (cacheFileNameArray.count == 0) {
        
      [dic writeToFile:receiptfilePath atomically:YES];

    }else{
       
        if (error == nil) {
         
            for (NSString * name in cacheFileNameArray) {

                NSString * filePath = VS_SUCCESS_ORDER_PATH(name);
                
                NSMutableDictionary *localdic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                
                if ([localdic.allValues containsObject:receipt]) {
                    
                    isContain = YES;
                    
                }else{
                    
                    continue;
                }
            }
        }
    }
    
    if (!isContain) {
        
        [dic writeToFile:receiptfilePath atomically:YES];

    }
    
}

#pragma mark -- 获取系统时间的方法
-(NSString *)getCurrentZoneTime{
    
    NSDate * date = [NSDate date];
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:date];
    return dateTime;
    
}

#pragma mark -- 服务器凭证校验
-(void)sendAppStoreRequestToPhpWithReceipt:(NSString *)receipt userId:(NSString *)userId paltFormOrder:(NSString * )order trans:(SKPaymentTransaction *)transaction{
    
    [[VSDKAPI shareAPI]  vsdk_sendVertifyWithReceipt:receipt order:order userId:userId  productId:transaction.payment.productIdentifier success:^(VSDKAPI *api, id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                VS_HUD_HIDE;
                
                if (isRedeemGift) {
                    
                    VS_SHOW_SUCCESS_STATUS(@"Redeemed");
                    
                }else{
                    
                    VS_SHOW_SUCCESS_STATUS(@"Purchased");
                }
                
                //结束交易方法
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                
                [self getPlatformAmountInfoWithOrder:order];
                
                NSData * data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
                NSString *result = [data base64EncodedStringWithOptions:0];
                
                //这里将成功但存储起来
                [self SaveIapSuccessReceiptDataWithReceipt:receipt Order:order UserId:userId transId:transaction.transactionIdentifier productType:@"consumption"];
                [self successConsumptionOfGoodsWithTransId:transaction.transactionIdentifier];
                
                [VSChainTool delegateValueForKey:transaction.transactionIdentifier];
                //删除钥匙串里面请求成功的掉单
//                [VSChainTool delegateValueForKey:order];
                NSArray *arr = [VSChainTool objectForKey:VSDK_IAPKEY];
                NSMutableArray *mutableArr = [NSMutableArray array];
                [mutableArr setArray:arr];
                NSMutableArray *copyArr = [mutableArr mutableCopy];
                if (mutableArr.count > 0) {
                    for (NSDictionary *iapDic in copyArr) {
//                        NSString *receipt = [iapDic objectForKey:@"receipt"];
//                        NSString *userId = [iapDic objectForKey:@"userId"];
                        NSString *kcorder = [iapDic objectForKey:@"order"];
//                        NSString *productId = [iapDic objectForKey:@"productId"];
                        if ([order isEqualToString:kcorder]) {
                            [mutableArr removeObject:iapDic];
                            [VSChainTool setObject:mutableArr forKey:VSDK_IAPKEY];
                        }
                    }
                }
                
                 //adjust 上报充值次数打点
                [self userRechargeTotalEventWithUserId:userId order:order];
                
                if (self.iapResultBlock) {
                    self.iapResultBlock(YES, result, nil);
                }
                
            }else{
#pragma mark -- callBack 回调
                [api vsdk_sendVertifyWithReceipt:receipt order:order userId:userId productId:transaction.payment.productIdentifier success:^(VSDKAPI *api, id responseObject) {
                    
                    if (REQUESTSUCCESS) {
                        
                        VS_HUD_HIDE;
                        
                        if (isRedeemGift) {
                            
//                            VS_SHOW_SUCCESS_STATUS(@"兑换成功");
                            VS_SHOW_SUCCESS_STATUS(@"Redeemed");
                            
                        }else{
                            
                            VS_SHOW_SUCCESS_STATUS(@"Purchased");
                        }
                        
                        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                        
                        [self getPlatformAmountInfoWithOrder:order];
                        
                        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
                        NSString *result = [data base64EncodedStringWithOptions:0];
                        
                        //存储成功订单
                        [self SaveIapSuccessReceiptDataWithReceipt:receipt Order:order UserId:userId transId:transaction.transactionIdentifier productType:@"consumption"];
                        //删除已成功订单
                        [self successConsumptionOfGoodsWithTransId:transaction.transactionIdentifier];
                         [self userRechargeTotalEventWithUserId:userId order:order];
                        
                        [VSChainTool delegateValueForKey:transaction.transactionIdentifier];
                        //删除钥匙串里面请求成功的掉单
//                        [VSChainTool delegateValueForKey:order];
                        NSArray *arr = [VSChainTool objectForKey:VSDK_IAPKEY];
                        NSMutableArray *mutableArr = [NSMutableArray array];
                        [mutableArr setArray:arr];
                        NSMutableArray *copyArr = [mutableArr mutableCopy];
                        if (mutableArr.count > 0) {
                            for (NSDictionary *iapDic in copyArr) {
        //                        NSString *receipt = [iapDic objectForKey:@"receipt"];
        //                        NSString *userId = [iapDic objectForKey:@"userId"];
                                NSString *kcorder = [iapDic objectForKey:@"order"];
        //                        NSString *productId = [iapDic objectForKey:@"productId"];
                                if ([order isEqualToString:kcorder]) {
                                    [mutableArr removeObject:iapDic];
                                    [VSChainTool setObject:mutableArr forKey:VSDK_IAPKEY];
                                }
                            }
                        }
                        
                        
                        if (self.iapResultBlock) {
                            self.iapResultBlock(YES, result, nil);
                        }
                        
                    }else{
                        
                        VS_HUD_HIDE;
                        VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
                        [[VSDKAPI shareAPI]  vsdk_sendPayErrorLogWithUser:VSDK_GAME_USERID roleId:self.vsdk_roleId ServerId:self.vsdk_serverId ServerName:self.vsdk_serverName RoleName:self.vsdk_roleName RoleLevel:self.vsdk_roleName ErrorCode:[NSString stringWithFormat:@"%ld",(long)transaction.error.code] errorMsg:@"内购购买失败"];
                        
                    }
                    
                } failure:^(VSDKAPI *api, NSString *failure) {
                    VS_HUD_HIDE;
                    
                }];
            }
            
        } failure:^(VSDKAPI *api, NSString *failure) {
            
            VS_HUD_HIDE;
            
       }];

}

#pragma mark -- 订阅类型凭证验证回调
-(void)sendSubscriptionRequestToPhpWithReceipt:(NSString *)receipt userId:(NSString *)userId paltFormOrder:(NSString *)order ifXudingReceipt:(BOOL)xuding trans:(SKPaymentTransaction *)transaction{
    
    [[VSDKAPI shareAPI] sendSubscriptionVertifyWithReceipt:receipt order:order userId:userId transcation:transaction success:^(VSDKAPI *api, id responseObject) {

            if (REQUESTSUCCESS) {

                VS_HUD_HIDE;
                
                if (!xuding) {
                    VS_SHOW_SUCCESS_STATUS(@"Subscribed");
                }
                
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                NSData * data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
                NSString *result = [data base64EncodedStringWithOptions:0];

                //这里将成功但存储起来
                if (xuding) {
                    
                 [self SaveIapSuccessReceiptDataWithReceipt:receipt Order:order UserId:userId transId:transaction.originalTransaction.transactionIdentifier productType:@"subscription"];
                 [self successConsumptionOfGoodsWithTransId:transaction.originalTransaction.transactionIdentifier];
                    
                }else{
                    
                  [self SaveIapSuccessReceiptDataWithReceipt:receipt Order:order UserId:userId transId:transaction.transactionIdentifier productType:@"subscription"];
                }
                
                [self successConsumptionOfGoodsWithTransId:transaction.transactionIdentifier];
     
                if (self.iapResultBlock) {
                    self.iapResultBlock(YES, result, nil);
                }

            }else{

                [[VSDKAPI shareAPI]  sendSubscriptionVertifyWithReceipt:receipt order:order userId:userId  transcation:transaction success:^(VSDKAPI *api, id responseObject) {

                    if (REQUESTSUCCESS) {

                        VS_HUD_HIDE;
                        
                        if (!xuding) {
                            VS_SHOW_SUCCESS_STATUS(@"Subscribed");
                        }

                        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                        NSData * data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
                        NSString *result = [data base64EncodedStringWithOptions:0];

                        if (xuding) {
                            
                            [self SaveIapSuccessReceiptDataWithReceipt:receipt Order:order UserId:userId transId:transaction.originalTransaction.transactionIdentifier productType:@"subscription"];
                             [self successConsumptionOfGoodsWithTransId:transaction.originalTransaction.transactionIdentifier];
                            
                        }else{
                            
                            [self SaveIapSuccessReceiptDataWithReceipt:receipt Order:order UserId:userId transId:transaction.transactionIdentifier productType:@"subscription"];
                            [self successConsumptionOfGoodsWithTransId:transaction.transactionIdentifier];
                        }

                        if (self.iapResultBlock) {
                            self.iapResultBlock(YES, result, nil);
                        }

                    }else{

                        VS_HUD_HIDE;
                    }

                } failure:^(VSDKAPI *api, NSString *msg) {

                    VS_HUD_HIDE;
                
                }];
            }

        } failure:^(VSDKAPI *api, NSString *msg) {

            VS_HUD_HIDE;

        }];
    
}


#pragma mark  -- 玩家累计成功充值次数

-(void)userRechargeTotalEventWithUserId:(NSString *)userId order:(NSString *)orderSn{
    
    if ([VS_CONVERT_TYPE(userId) length] == 0) {
        
        userId = VSDK_GAME_USERID;
    }
    
    if (![VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"%@_AccumulatedThreeTimesSuccessfulPayment",userId]]) {
        
         [VS_USERDEFAULTS setValue:@"1" forKey:[NSString stringWithFormat:@"%@_AccumulatedThreeTimesSuccessfulPayment",userId]];
        
    }else{
        
        NSInteger successPayCount = [[VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"%@_AccumulatedThreeTimesSuccessfulPayment",userId]]integerValue];
        
        successPayCount += 1 ;

        //存储充值次数
        [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%ld",(long)successPayCount] forKey:[NSString stringWithFormat:@"%@_AccumulatedThreeTimesSuccessfulPayment",userId]];
        
        
       if (successPayCount >= 3 && successPayCount < 10){
           [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_ThreeTimesSuccessfulPayment];
       }

        if (successPayCount >= 10) {
        [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_TenTimesSuccessfulPayment];
     
        }
    }
    
      [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_NumberOfSuccessfulPayment];

}

#pragma mark -- 根据购买凭证来移除本地凭证的方法
-(void)successConsumptionOfGoodsWithTransId:(NSString * )transcationId{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    if ([fileManager fileExistsAtPath:[VSSandBoxHelper iapReceiptPath]]) {
        
        NSArray * cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper iapReceiptPath] error:&error];
        
        if (error == nil) {
            
            for (NSString * name in cacheFileNameArray) {
                
                NSString * filePath = VS_UNFINISH_ORDER_PATH(name);
                
                [self removeReceiptWithPlistPath:filePath BytransId:transcationId];
            }
        }
    }
}

#pragma mark -- 根据订单号来删除存储的凭证
-(void)removeReceiptWithPlistPath:(NSString *)plistPath BytransId:(NSString *)transactionId{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSString * localTransId = [dic objectForKey:VSDK_TRANSID_KEY];
    //通过凭证进行对比
    if ([transactionId isEqualToString:localTransId]) {
      
        [fileManager removeItemAtPath:plistPath error:&error];
    }
}
@end
