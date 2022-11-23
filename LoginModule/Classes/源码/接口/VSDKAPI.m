//
//  VSDKAPI.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSDKAPI.h"
#import "VSSDKDefine.h"
#import "Pic_PatModel.h"
@interface VSDKAPI ()

@end
static VSDKAPI * _API;


@implementation VSDKAPI
//单例方法
+(VSDKAPI * )shareAPI{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        _API = [[VSDKAPI alloc]init];
        
    });
    
    return _API;
}


//平台账号登录接口
-(void)loginWithEmail:(NSString *)email passWord:(NSString *)password success:(LoginSuccess)success failure:(LoginFailure)failure{
    
    self.loginsuccess =  success;
    self.loginfailure  = failure;
    
   NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    [params setValue:[VSEncryption md5:password] forKey:VSDK_PARAM_PASSWORD];
    
      if ([email length] >0 && [VSDeviceHelper isPureInt:email]) {
          [params setValue:email forKey:VSDK_PARAM_UID];
      }else{
          [params setValue:email forKey:VSDK_PARAM_USERNAME];
      }
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    if ([email length] >0 && [VSDeviceHelper isPureInt:email]) {
        [self vsdK_loginWithUrl:VSDK_UID_LOGIN_API Params:params];
    }else{
        [self vsdK_loginWithUrl:VSDK_LOGIN_API Params:params];
    }
    
}


//三方登录调用接口
-(void)loginWithUserType:(NSString *)userType token:(NSString *)token success:(LoginSuccess)success failure:(LoginFailure)failure{
    
    self.loginsuccess  = success;
    self.loginfailure  = failure;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    NSString * open_type = userType; //类型
    NSString * open_id = [VSDeviceHelper vsdk_keychainOpenId];
    [params setValue:open_type forKey: VSDK_PARAM_OPEN_TYPE];
    NSString  * signStr = [NSString stringWithFormat:@"%@%@",open_id,VSDK_GAME_KEY];
    NSString * signMd5 = [VSEncryption md5:signStr];

    if ([userType isEqualToString:VSDK_PARAM_GUEST_TYPE]) {
        
        NSString * Token = [[NSJSONSerialization dataWithJSONObject:@{VSDK_PARAM_OPEN_ID:open_id,VSDK_PARAM_SIGN:signMd5} options:NSJSONWritingPrettyPrinted error:nil]base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [params setValue:Token forKey:VSDK_PARAM_TOKEN];
        NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
        NSString * sign = [VSEncryption md5:mD5str];
        [params setValue:sign forKey:VSDK_PARAM_SIGN];
        
    }else if([userType isEqualToString:VSDK_APPLE]){
        [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_APPLE_AUTH_CODE] forKey:@"authcode"];
        [params setValue:token forKey:VSDK_PARAM_TOKEN];
        NSString * mD5str =  [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
        NSString * sign = [VSEncryption md5:mD5str];
        [params setValue:sign forKey:VSDK_PARAM_SIGN];
    }else{
        
        [params setValue:token forKey:VSDK_PARAM_TOKEN];
        NSString * mD5str =  [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
        NSString * sign = [VSEncryption md5:mD5str];
        [params setValue:sign forKey:VSDK_PARAM_SIGN];
    }
    
    [self vsdK_loginWithUrl:VSDK_THIRD_LOGIN_API Params:params];
    
}


//三方登录调用接口
-(void)vsdk_bindAccountWithUserType:(NSString *)userType token:(NSString *)token guestToken:(NSString *)gusetToken success:(void(^)(VSDKAPI * api,id responseObject))success
                       failure:(void(^)(VSDKAPI *api,NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    NSString * open_type = userType; //类型
    [params setValue:open_type forKey:VSDK_PARAM_OPEN_TYPE];
    [params setValue:gusetToken forKey:VSDK_PARAM_GUEST_TOKEN];
    [params setValue:token forKey:VSDK_PARAM_TOKEN];
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_THIRD_BIND_GUEST_API parameters:params success:^(id responseObject) {
            success(self,responseObject);
    } failure:^(NSError *error) {
           failure(self, @"域名不存在");
    }];
}



#pragma mark - 注册
-(void)vsdk_registerWithEmial:(NSString * )email passWord:(NSString *)password success:(void(^)(VSDKAPI * api,id responseObject))success failure:(void(^)(VSDKAPI *api,NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    [params setValue:email forKey:VSDK_PARAM_USERNAME];
    [params setValue:[VSEncryption md5:password] forKey:VSDK_PARAM_PASSWORD];
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    
    NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_REGISTER_API parameters:params success:^(id responseObject) {
        
        [self vsdk_saveBindEmailAndBindPhoneNumWithObj:responseObject];
        success(self,responseObject);
        
    } failure:^(NSError *error) {
        
        failure(self, @"域名不存在");
        
    }];

}


#pragma mark - 找回密码
-(void)vsdk_retrievePwdWithEmail:(NSString *)email success:(void(^)(VSDKAPI * api,id responseObject))success
                  failure:(void(^)(VSDKAPI *api,NSString * failure))failure{

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    NSString  * signStr = [NSString stringWithFormat:@"%@%@",email,VSDK_GAME_KEY];
    NSString * signMd5 = [VSEncryption md5:signStr];
    NSDictionary * jsonToken = @{VSDK_PARAM_BIND_MAIL:email,VSDK_PARAM_SIGN:signMd5};
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonToken options:NSJSONWritingPrettyPrinted error:nil];
    NSString * Token= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [params setValue:Token forKey:VSDK_PARAM_TOKEN];
    [params setValue:email forKey:VSDK_PARAM_BIND_EMAIL];

    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_SEND_EMAIL_API parameters:params success:^(id responseObject) {

            success(self,responseObject);

    } failure:^(NSError *error) {

            failure(self, @"域名不存在");

    }];
    
}



//提交密码验证
-(void)vsdk_vertifyMailboxWithToken:(NSString *)token vertifyCode:(NSString *)vertifycode success:(void(^)(VSDKAPI * api,id responseObject))success
                       failure:(void(^)(VSDKAPI *api,NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    NSString * userToken  = token;
    NSString * code  = vertifycode;
    
    [params setValue:userToken forKey:VSDK_PARAM_TOKEN];
    [params setValue:code forKey:VSDK_PARAM_CODE];
    
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_CHECK_MAIL_CODE_API parameters:params success:^(id responseObject) {

            success(self,responseObject);

    } failure:^(NSError *error) {

           failure(self, @"域名不存在");

    }];
}


#pragma mark -- 平台账号注册绑定
-(void)vsdk_registerAndBindWithToken:(NSString *)touristToken Email:(NSString *)email  Password:(NSString *)passWord success:(void(^)(VSDKAPI * api,id responseObject))success failure:(void(^)(VSDKAPI *api,NSString * failure))failure{

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:touristToken forKey:VSDK_PARAM_TOKEN];
    [params setValue:email forKey:VSDK_PARAM_USERNAME];
    [params setValue:[VSEncryption md5:passWord] forKey:VSDK_PARAM_PASSWORD];
    
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    
    [VSHttpHelper POST:VSDK_BIND_REGISTER_API parameters:params success:^(id responseObject) {

            success(self,responseObject);

    } failure:^(NSError *error) {

            failure(self, @"域名不存在");
    }];
}


#pragma mark -- 首次初始化
-(void)vsdk_initVsdSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString *errorDes))failure{

    //SDK初始化上报埋点
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_INIT_API parameters:params success:^(id responseObject) {

        success(responseObject);


    } failure:^(NSError *error) {

        failure([NSString stringWithFormat:@"%ld",(long)error.code]);

    }];

}

//首次拉起登录激活上报埋点
-(void)vsdk_activedVsdkSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString *errorDes))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_ACTIVE_API parameters:params success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure([NSString stringWithFormat:@"%ld",(long)error.code]);

    }];
}


#pragma mark -- 登录事件的网络请求
-(void)vsdK_loginWithUrl:(NSString *)url Params:(id)params{
    
     [VSHttpHelper POST:url parameters:params success:^(id responseObject) {
         //判断是否是申请了账号删除
         if (REQUESTSUCCESS) {
             NSNumber *stateNub = [[responseObject objectForKey:@"data"]objectForKey:@"account_state"];
             NSString *state = [stateNub stringValue];
             if ([state isEqualToString:@"3"]) {
                 
                 VS_SHOW_INFO_MSG(@"Account Invalid!");
                 return;
                 
             }else{
                 
                 if ([[responseObject objectForKey:@"data"]objectForKey:@"account_state"] != nil) {
                    
                     VS_USERDEFAULTS_SETVALUE([[responseObject objectForKey:@"data"]objectForKey:@"account_state"], @"vsdk_account_state");
                 }
             }
             
             [self vsdk_saveBindEmailAndBindPhoneNumWithObj:responseObject];
         }
         
         if (self.loginsuccess) {
             //保存此次登录信息
             [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:VSDKLOGINOBJ];
             [[NSUserDefaults standardUserDefaults] synchronize];
             self.loginsuccess(self,responseObject);
         }

    } failure:^(NSError *error) {
        
        if (self.loginfailure) {
            self.loginfailure(self, @"Request timed out, please try again!");
        }
        VS_HUD_HIDE;
        VS_SHOW_ERROR_STATUS(@"Request failed,please retry");[VS_USERDEFAULTS removeObjectForKey:VSDK_AUTO_LOGIN_KEY];
        [self vsdk_sendLoginErrorLogWithErrorCode:@"404" errorMsg:@"Request timed out"];
        
    }];
}


-(void)vsdk_saveBindEmailAndBindPhoneNumWithObj:(id)responseObj{
    
    NSDictionary * responseObject  = (NSDictionary *)responseObj;
    
    if (REQUESTSUCCESS) {
      
        NSString * userTypeInt = [GETRESPONSEDATA:VSDK_PARAM_USER_TYPE];
        NSString * userType;
        switch ([userTypeInt integerValue]) {
            case 1:
               userType = @"Email";
                break;
            case 2:
               userType = @"Facebook";
               break;
            case 3:
               userType = @"Google";
               break;
            case 4:
               userType = @"Guest";
               break;
            case 5:
               userType = @"Twitter";
               break;
            case 9:
               userType = @"Naver";
               break;
            case 10:
               userType = @"Apple";
               break;
                
            default:
                break;
        }
            
        VS_USERDEFAULTS_SETVALUE([[GETRESPONSEDATA:VSDK_BIND_MAIL_EVENT] length]>0?[GETRESPONSEDATA:VSDK_BIND_MAIL_EVENT]:@"", VSDK_ASSISTANT_BIND_MAIL);
        VS_USERDEFAULTS_SETVALUE([[GETRESPONSEDATA:VSDK_BIND_PHONE_EVENT]length]>0?[GETRESPONSEDATA:VSDK_BIND_PHONE_EVENT]:@"", VSDK_ASSISTANT_BIND_PHOME);
        VS_USERDEFAULTS_SETVALUE([VS_CONVERT_TYPE([GETRESPONSEDATA:VSDK_BIND_UID_EVENT]) length]>0?[GETRESPONSEDATA:VSDK_BIND_UID_EVENT]:@"", VSDK_ASSISTANT_BIND_UID);
        VS_USERDEFAULTS_SETVALUE(userType, VSDK_ASSISTANT_USER_TYPE);
    }
    
}


-(void)vsdk_cpOrderWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype Extend:(NSString *)extend FFType:(NSString *)ffType ServerId:(NSString *)serverId ServerName:(NSString *)servername RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ThirdGoodId:(NSString *)thirdGoodId ThirdGoodName:(NSString *)thirdGoodName ifSub:(BOOL)subProduct success:(void(^)(VSDKAPI *api,id responseObject))success failure:(void(^)(VSDKAPI *api,NSString * failure))failure{
    
 
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:userId forKey:VSDK_PARAM_USER_ID];
    [params setValue:money forKey:VSDK_PARAM_MONEY];
    [params setValue:moneytype forKey:VSDK_PARAM_MONEY_TYPE];
    [params setValue:extend forKey:VSDK_PARAM_EXTEND];
    [params setValue:ffType forKey:VSDK_PARAM_PAY_TYPE];
    [params setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
    [params setValue:rolename forKey:VSDK_PARAM_ROLE_NAME];
    [params setValue:servername forKey:VSDK_PARAM_SERVER_NAME];
    [params setValue:roleLevel forKey:VSDK_PARAM_ROLE_LEVEL];
    [params setValue:goodId forKey:VSDK_PARAM_GOODS_ID];
    [params setValue:goodName forKey:VSDK_PARAM_GOODS_NAME];
    [params setValue:tradeSn forKey:VSDK_PARAM_CP_TRADE_SN];
    [params setValue:extData forKey:VSDK_PARAM_EXT_DATA];
    [params setValue:thirdGoodId forKey:VSDK_PARAM_THIRD_GOODS_ID];
    [params setValue:thirdGoodName forKey:VSDK_PARAM_THIRD_GOODS_NAME];
    
    if (!subProduct) {
        
        [params setValue:VS_USERDEFAULTS_GETVALUE(@"vsdk_authorize") forKey:@"authorize"];
    }
 
    
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    NSString * orderUrl = subProduct ? VSDK_PAY_SUB_ORDER_API : VSDK_PAY_ORDER_API;
    
    [VSHttpHelper POST:orderUrl parameters:params success:^(id responseObject) {

        success(self,responseObject);

    } failure:^(NSError *error) {

        failure(self, @"域名不存在");

    }];
}

-(void)vsdk_platformAmountWithOrder:(NSString *)order success:(void(^)(id responseObject))success failure:(void(^)(NSString *failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [params setValue:order forKey:VSDK_PARAM_ORDER];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_PRODUCT_INFO_API parameters:params success:^(id responseObject) {

        if (success) {
            success(responseObject);
        }

    } failure:^(NSError *error) {

    }];
    
}


-(void)vsdk_sendVertifyWithReceipt:(NSString *)VerfityStr order:(NSString *)ordersn userId:(NSString *)userid  productId:(NSString *)pid success:(void(^)(VSDKAPI *api,id responseObject))vertifySuccess failure:(void(^)( VSDKAPI *api,NSString * msg))vertifyFailure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:[VSEncryption md5:VerfityStr] forKey:VSDK_PARAM_ORDER_PROOF_MD5];
    [params setValue:VerfityStr forKey:VSDK_PARAM_RECEIPT_DATA];
    [params setValue:ordersn forKey:VSDK_PARAM_ORDER];
    [params setValue:VSDK_PARAM_FF_TYPE forKey:VSDK_PARAM_PAY_TYPE];
    [params setValue:userid forKey:VSDK_PARAM_USER_ID];
    [params setValue:pid forKey:VSDK_PARAM_PID];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_PAY_CALLBACK_API parameters:params success:^(id responseObject) {

        vertifySuccess(self,responseObject);

    } failure:^(NSError *error) {

        vertifyFailure(self, [NSString stringWithFormat:@"%ld",(long)error.code]);

    }];
    
}


-(void)sendSubscriptionVertifyWithReceipt:(NSString *)VerfityStr order:(NSString *)ordersn userId:(NSString *)userid transcation:(SKPaymentTransaction *)trans success:(void(^)(VSDKAPI *api,id responseObject))vertifySuccess failure:(void(^)( VSDKAPI *api,NSString * msg))vertifyFailure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:[VSEncryption md5:VerfityStr] forKey:VSDK_PARAM_ORDER_PROOF_MD5];
    [params setValue:VerfityStr forKey:VSDK_PARAM_RECEIPT_DATA];
    [params setValue:ordersn forKey:VSDK_PARAM_ORDER];
    [params setValue:VSDK_PARAM_FF_TYPE forKey:VSDK_PARAM_PAY_TYPE];
    [params setValue:[NSString stringWithFormat:@"%.f", [trans.transactionDate timeIntervalSince1970]*1000] forKey:VSDK_PARAM_PURCHASE_DATE];
    [params setValue:trans.transactionIdentifier forKey:VSDK_PARAM_TRANSACTION_ID];
    [params setValue:userid forKey:VSDK_PARAM_USER_ID];
    [params setValue:trans.payment.productIdentifier forKey:VSDK_PARAM_PID];
    
    if ([VS_USERDEFAULTS valueForKey:VSDK_SUBSCRIBTION_TRANSID]) {
        
         [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SUBSCRIBTION_TRANSID] forKey:VSDK_PARAM_ORIGINAL_TRANSACTION_ID];
    }
  
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    BOOL ifContain = [self getSignWithReceiptSign:trans.transactionIdentifier];

    if (ifContain) {
        
        VS_HUD_HIDE;
        
    }else{
        
        [VSHttpHelper POST:VSDK_PAY_SUB_CALLBACK_API parameters:params success:^(id responseObject) {

            [self saveSignWithReceiptSign:trans.transactionIdentifier];

            vertifySuccess(self,responseObject);

         }failure:^(NSError *error) {

            vertifyFailure(self, [NSString stringWithFormat:@"%ld",(long)error.code]);

        }];
    }

}


-(BOOL)getSignWithReceiptSign:(NSString *)sign{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * savePath =  [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_RECEIPT_SIGN_PATH];
    
    if ([manager fileExistsAtPath:savePath]) {
        
        NSArray * arr = [[NSArray alloc]initWithContentsOfFile:savePath];
        
        if([arr containsObject:sign]) {return YES;}
        
    }else{return NO;}
    
    return NO;
}


-(void)saveSignWithReceiptSign:(NSString *)sign{
    
    if([sign length] != 0){
        
    NSString * savePath =  [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_RECEIPT_SIGN_PATH];
    NSArray * arr  = [[NSArray alloc]initWithContentsOfFile:savePath];
    NSMutableArray * marr = [[NSMutableArray alloc]initWithArray:arr];
    
    if (![marr containsObject:sign]) {

        [marr addObject:sign];
        NSArray * arr = [NSArray arrayWithArray:marr];
        [arr writeToFile:savePath atomically:YES];
     
        }
    }
}


#pragma mark -- 上报崩溃信息至服务器
-(void)vsdk_reportBugWithCrashInfo:(NSString *)crashInfo success:(void(^)(VSDKAPI *api, id responseObject))success failure:(void(^)(VSDKAPI *api, NSString * failure))failure{

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:crashInfo forKey:@"crash_info"];

    [VSHttpHelper POST:VSDK_APPLE_ERROR_LOG_API parameters:params success:^(id responseObject) {

        if (success) {
            success(self,responseObject);
        }

    } failure:^(NSError *error) {

    }];
}

-(void)vsdk_sendLoginErrorLogWithErrorCode:(NSString *)errCode errorMsg:(NSString *)errMsg{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:errCode forKey:VSDK_PARAM_ERROR_CODE];
    [params setValue:errMsg forKey:VSDK_PARAM_ERROR_MSG];
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    
    [VSHttpHelper POST:VSDK_LOGIN_ERROR_LOG_API parameters:params success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
}

-(void)vsdk_sendPayErrorLogWithUser:(NSString *)userid roleId:(NSString *)roleid ServerId:(NSString *)serverId ServerName:(NSString *)servername RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel ErrorCode:(NSString *)errCode errorMsg:(NSString *)errMsg{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
        
    if (errCode!=nil&&errCode.length > 0) {
           
           [params setValue:errCode forKey:VSDK_PARAM_ERROR_CODE];
           
       }else{
           
           [params setValue:@"unknown error code" forKey:VSDK_PARAM_ERROR_CODE];
       }
    
    if (errMsg!=nil&&errMsg.length > 0) {
        
        [params setValue:errMsg forKey:VSDK_PARAM_ERROR_MSG];
        
    }else{
        
        [params setValue:@"unknown error code" forKey:VSDK_PARAM_ERROR_MSG];
    }
    
     [params setValue:userid forKey:VSDK_PARAM_USER_ID];
    
      if (serverId!=nil&&serverId.length > 0) {
           
           [params setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
           
       }else{
          
           [params setValue:@"漏单流程serverId为空" forKey:VSDK_PARAM_SERVER_ID];
       }
       
    
       if (servername!=nil&&servername.length > 0) {
             
             [params setValue:servername forKey:VSDK_PARAM_SERVER_NAME];
             
         }else{
            
             [params setValue:@"漏单流程servername为空" forKey:VSDK_PARAM_SERVER_NAME];
         }
       
       if (rolename!=nil&&rolename.length > 0) {
              
              [params setValue:rolename forKey:VSDK_PARAM_ROLE_NAME];
              
          }else{
             
              [params setValue:@"漏单流程rolename为空" forKey:VSDK_PARAM_ROLE_NAME];
          }
       
       
       if (roleid!=nil&&roleid.length > 0) {
                
                [params setValue:roleid forKey:VSDK_PARAM_ROLE_ID];
                
            }else{
               
                [params setValue:@"漏单流程roleid为空" forKey:VSDK_PARAM_ROLE_ID];
            }
         
       if (roleLevel!=nil&&roleLevel.length > 0) {
                
                [params setValue:roleid forKey:VSDK_PARAM_ROLE_LEVEL];
                
            }else{
               
                [params setValue:@"漏单流程roleLevel为空" forKey:VSDK_PARAM_ROLE_LEVEL];
       }
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    
    [VSHttpHelper POST:VSDK_PAY_ERROR_LOG_API parameters:params success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)vsdk_storedAdjustEventTokenSuccess:(void(^)(id responseObject))evenSuccess Failure:(void(^)(NSString * failure))evenFailure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    [VSHttpHelper POST:VSDK_EVEN_TOKEN_API parameters:params success:^(id responseObject) {
          evenSuccess(responseObject);

    } failure:^(NSError *error) {

          evenFailure([NSString stringWithFormat:@"%@",error]);

    }];
}

-(void)vsdk_upLoadApnsDeviceTokenWithToken:(NSString *)apnsToken{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [params setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [params setValue:apnsToken forKey:VSDK_PARAM_PUSH_TOKEN];
    [params setValue:VSDK_PALTFORM forKey:@"token_type"];
    
    [VSHttpHelper POST:VSDK_APNS_TOKEN_API parameters:params success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
    
}


-(void)vsdk_reportDeviceToServiceWithEquipment_uuid:(NSString *)uuid{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:uuid forKey:@"ulsdk_equipment_uuid"];
    [params setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID ];

    [VSHttpHelper POST:VSDK_UNIQUETAG_API parameters:params success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
}


-(void)vsdk_reportFialedCdnResourceWithDataList:(NSMutableArray *)datalist{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:datalist forKey:@"data"];
    [params setValue:@"error_link" forKey:VSDK_PARAM_REPORT_TYPE];

    [VSHttpHelper POST:VSDK_CDN_SLOW_API parameters:params success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
}


-(void)vsdk_refreshTokenWitholdToken:(NSString *)token Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    [params setValue:token forKey:VSDK_PARAM_TOKEN];
   
    [VSHttpHelper POST:VSDK_REFRESH_TOKEN_API parameters:params success:^(id responseObject) {
        success(responseObject);
         
     } failure:^(NSError *error) {
         
     }];

}

-(void)vsdk_playerIsVipWithServiceId:(NSString *)serviceid ServerName:(NSString *)servername RoleId:(NSString *)roleid RoleName:(NSString *)roleName RoleLevel:(NSString *)rolelevel vipSuccess:(void(^)(id responseObject))success vipFailure:(void(^)(NSString * failureMsg))failure{

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:serviceid forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:servername forKey:VSDK_PARAM_SERVER_NAME];
    [params setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID ];
    [params setValue:roleid forKey:VSDK_PARAM_ROLE_ID];
    [params setValue:roleName forKey:VSDK_PARAM_ROLE_NAME];
    [params setValue:rolelevel forKey:VSDK_PARAM_ROLE_LEVEL] ;

    [VSHttpHelper POST:VSDK_VIP_USER_API parameters:params success:^(id responseObject) {

            success(responseObject);

    } failure:^(NSError *error) {

            failure(@"域名不存在");

    }];
    
}

-(void)vsdk_beatPointWithType:(NSString *)type state:(NSString *)state{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:type forKey:VSDK_PARAM_REPORT_TYPE];
    [params setValue:state forKey:VSDK_PARAM_REPORT_STATE];
    
    [VSHttpHelper POST:VSDK_REPORT_API(type) parameters:params success:^(id responseObject) {

        
        
    } failure:^(NSError *error) {

    }];
}

-(void)avliablePingtaiSuccess:(void(^)(id responseObject))openSuccess Failure:(void(^)(NSString * failure))openFailure{

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    [VSHttpHelper POST:VSDK_OPEN_LOGIN_TYPE_API parameters:params success:^(id responseObject) {

        openSuccess(responseObject);

    } failure:^(NSError *error) {

        openFailure([NSString stringWithFormat:@"%@",error]);

    }];
}


#pragma mark - 更改密码
- (void)updateNewPwd:(NSString *)newPwd tokenStr:(NSString *)tokenStr
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSString * failure))failure{

    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:[VSEncryption md5:newPwd] forKey:VSDK_PARAM_PASSWORD];
    [params setValue:tokenStr forKey:VSDK_PARAM_TOKEN];
    
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_EDIT_PASSWORD_API parameters:params success:^(id responseObject) {

            success(responseObject);

    } failure:^(NSError *error) {

            failure( @"域名不存在");
    }];
}



-(void)ucComfirmBindPhoneNumWithCode:(NSString * )code PhoneFormatNum:(NSString *)phoneNum Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
     NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
      
      [params setValue:phoneNum forKey:VSDK_BIND_PHONE_EVENT];
      [params setValue:code forKey:VSDK_PARAM_CODE];
      [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY) forKey:VSDK_PARAM_TOKEN];
    
      NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
          NSString * sign = [VSEncryption md5:mD5str];
      [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
      [VSHttpHelper POST:VSDK_BIND_PHONE_NUM_API parameters:params success:^(id responseObject) {
              success(responseObject);
               
           } failure:^(NSError *error) {
               
      }];
    
}

#pragma mark -- 发送绑定邮箱验证码的方法
-(void)postSecurityCodeWithToken:(NSString *)token BindMail:(NSString *)bindEmail success:(void(^)(id responseObject))success failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:token forKey:VSDK_PARAM_TOKEN];
    [params setValue:bindEmail forKey:VSDK_PARAM_BIND_MAIL];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_SEND_EMAIL_CODE_API parameters:params success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"域名不存在");
    }];
    
}



-(void)ucGetVertifyCodeWithPhoneNum:(NSString *)phoneNum Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
      NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    [params setValue:phoneNum forKey:VSDK_BIND_PHONE_EVENT];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY) forKey:VSDK_PARAM_TOKEN];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
        NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_GET_BING_PHONE_CODE_API parameters:params success:^(id responseObject) {
              success(responseObject);
               
           } failure:^(NSError *error) {
               
       }];
    
}

-(void)ucBindSecurityEmainWithToken:(NSString *)token BindMail:(NSString *)bindEmail VertifyCode:(NSString *)code success:(void(^)(id responseObject))success failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:token forKey:VSDK_PARAM_TOKEN];
    [params setValue:bindEmail forKey:VSDK_PARAM_BIND_MAIL];
    [params setValue:code forKey:VSDK_PARAM_CODE];
    
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_BIND_SAFE_EMAIL_API parameters:params success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"域名不存在");

    }];
 
}

-(void)ucGetGiftStateSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
   NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
   NSString * sign = [VSEncryption md5:mD5str];
   [params setValue:sign forKey:VSDK_PARAM_SIGN];

   [VSHttpHelper POST:VSDK_BIND_GIFT_STATE_API parameters:params success:^(id responseObject) {
         
          success(responseObject);
          
   }failure:^(NSError *error) {
      
      
  }];
    
}



-(void)ucReportReceiveBindGiftWithEvent:(NSString *)eventType Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_GAME_NAME) forKey:VSDK_PARAM_GAME_NAME];
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID) forKey:VSDK_PARAM_SERVER_ID];
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME) forKey:VSDK_PARAM_SERVER_NAME];
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID) forKey:VSDK_PARAM_ROLE_ID];
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME) forKey:VSDK_PARAM_ROLE_NAME];
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL) forKey:VSDK_PARAM_ROLE_LEVEL];
     [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_BIND_GIFT_CRET) forKey:VSDK_BIND_GIFT_CRET];
     [params setValue:eventType forKey:VSDK_PARAM_BIND_VER_TYPE];
     [params setValue:@"prize_code" forKey:VSDK_PARAM_BIND_VER_TYPE];

    [params setValue:eventType forKey:VSDK_PARAM_EVENT];
     NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
     NSString * sign = [VSEncryption md5:mD5str];
     [params setValue:sign forKey:VSDK_PARAM_SIGN];

     [VSHttpHelper POST:VSDK_BIND_REWARD_RECEIVED_API parameters:params success:^(id responseObject) {
           
            success(responseObject);
            
     }failure:^(NSError *error) {
        
        
    }];
}


-(void)ssRequestSocialDataSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_GAME_NAME) forKey:VSDK_PARAM_GAME_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID) forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME) forKey:VSDK_PARAM_SERVER_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID) forKey:VSDK_PARAM_ROLE_ID];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME) forKey:VSDK_PARAM_ROLE_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL) forKey:VSDK_PARAM_ROLE_LEVEL];
    [params setValue:@"prize_url" forKey:VSDK_PARAM_GAM_VER_TYPE];
    
    if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {

        [params setValue:@"prize_code" forKey:VSDK_PARAM_GAM_VER_TYPE];

    }
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_SOCIAL_DATA_API parameters:params success:^(id responseObject) {
          
           success(responseObject);
           
       } failure:^(NSError *error) {
           
           
       }];
}


-(void)ssLikeRewardWithEventType:(NSString *)type EventId:(NSString *)eventId EventCert:(NSString *)eventCert Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{

    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_GAME_NAME) forKey:VSDK_PARAM_GAME_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID) forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME) forKey:VSDK_PARAM_SERVER_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID) forKey:VSDK_PARAM_ROLE_ID];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME) forKey:VSDK_PARAM_ROLE_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL) forKey:VSDK_PARAM_ROLE_LEVEL];
    [params setValue:type forKey:VSDK_PARAM_EVENT];
    [params setValue:eventId forKey:VSDK_PARAM_EVENT_ID];
    [params setValue:eventCert forKey:VSDK_PARAM_EVENT_CERT];
    
    [params setValue:@"prize_url" forKey:VSDK_PARAM_GAM_VER_TYPE];
    
    if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {

        [params setValue:@"prize_code" forKey:VSDK_PARAM_GAM_VER_TYPE];

    }
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
      NSString * sign = [VSEncryption md5:mD5str];
      [params setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_LIKE_REWARD_API parameters:params success:^(id responseObject) {
           
        success(responseObject);
            
    } failure:^(NSError *error) {
        
    }];
}

-(void)ssSocialEventReportWithEvent:(NSString *)event Type:(NSString *)type{
    
     NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
      
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_GAME_NAME] forKey:VSDK_PARAM_GAME_NAME];
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_SERVER_ID] forKey:VSDK_PARAM_SERVER_ID];
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_SERVER_NAME] forKey:VSDK_PARAM_SERVER_NAME];
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_ROLE_ID] forKey:VSDK_PARAM_ROLE_ID];
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_ROLE_NAME] forKey:VSDK_PARAM_ROLE_NAME];
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_ROLE_LEVEL] forKey:VSDK_PARAM_ROLE_LEVEL];
     [params setValue:event forKey:VSDK_PARAM_EVENT];
     [params setValue:type forKey:VSDK_PARAM_REPORT_TYPE];
     [params setValue:@"prize_url" forKey:VSDK_PARAM_GAM_VER_TYPE];
    
    if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {

        [params setValue:@"prize_code" forKey:VSDK_PARAM_GAM_VER_TYPE];

    }
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
      NSString * sign = [VSEncryption md5:mD5str];
      [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_SOCAIL_EVENT_REPORT_API parameters:params success:^(id responseObject) {
        
         
     } failure:^(NSError *error) {
         
     }];
}


-(void)ssBindInviteCodeWithInviteCode:(NSString *)code Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
     
     [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_GAME_NAME] forKey:VSDK_PARAM_GAME_NAME];
      [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_SERVER_ID] forKey:VSDK_PARAM_SERVER_ID];
      [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_SERVER_NAME] forKey:VSDK_PARAM_SERVER_NAME];
      [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_ROLE_ID] forKey:VSDK_PARAM_ROLE_ID];
      [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_ROLE_NAME] forKey:VSDK_PARAM_ROLE_NAME];
      [params setValue:[VS_USERDEFAULTS valueForKey:VSDK_SOCIAL_ROLE_LEVEL] forKey:VSDK_PARAM_ROLE_LEVEL];
      [params setValue:code forKey:VSDK_PARAM_INVITE_CODE];
      [params setValue:@"prize_url" forKey:VSDK_PARAM_GAM_VER_TYPE];
   
     if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {

       [params setValue:@"prize_code" forKey:VSDK_PARAM_GAM_VER_TYPE];
 
    }
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
      NSString * sign = [VSEncryption md5:mD5str];
      [params setValue:sign forKey:VSDK_PARAM_SIGN];
      
     [VSHttpHelper POST:VSDK_BIND_INVITE_API parameters:params success:^(id responseObject) {
           
            success(responseObject);
            
        } failure:^(NSError *error) {
            
        }];
    
}


-(void)requestAssistantReomteDataSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
     
     NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
           NSString * sign = [VSEncryption md5:mD5str];
       [params setValue:sign forKey:VSDK_PARAM_SIGN];
     
       [VSHttpHelper POST:VSDK_ASSISTANT_CONFIG_INFO parameters:params success:^(id responseObject) {
            success(responseObject);
             
         } failure:^(NSError *error) {
             
     }];
    
}

-(void)vsdk_normalBullteinDataSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
        NSString * sign = [VSEncryption md5:mD5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
  
    [VSHttpHelper POST:VSDK_NORMAL_BULLTEIN_API parameters:params success:^(id responseObject) {
         success(responseObject);
          
      } failure:^(NSError *error) {
          
      }];
}


-(void)vsdk_tempBullteinDataSuccess:(void (^)(id))success Failure:(void (^)(NSString *))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
          NSString * sign = [VSEncryption md5:mD5str];
      [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
      [VSHttpHelper POST:VSDK_TEMP_BULLTEIN_API parameters:params success:^(id responseObject) {
           success(responseObject);
            
      } failure:^(NSError *error) {
        
      }];
}

-(void)vsdk_cdnReportInitWithSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
 
    [VSHttpHelper POST:VSDK_CDN_INIR_API parameters:params success:^(id responseObject) {
       
        success(responseObject);
        
    } failure:^(NSError *error) {
        
    }];
    
}


-(void)vsdk_calitionLoginSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    NSString * open_id;
    //引继码或者twitter引继导入
    if ([VS_USERDEFAULTS valueForKey:VSDK_CALITION_UNIQUE_ID]) {
        
        open_id = [VS_USERDEFAULTS valueForKey:VSDK_CALITION_UNIQUE_ID];
        
    }else{

        if ([VSDK_IDFA isEqualToString:VSDK_INVALID_IDFA]) {

            open_id = [NSString stringWithFormat:@"%@_%@",[VSOpenIDFA sameDayVSOpenIDFA],[VSDeviceHelper getSystemTime]];
             VS_USERDEFAULTS_SETVALUE(open_id, VSDK_CALITION_UNIQUE_ID);
            
        }else{
            
            open_id = [NSString stringWithFormat:@"%@_%@",VSDK_IDFA,[VSDeviceHelper getSystemTime]];
            VS_USERDEFAULTS_SETVALUE(open_id, VSDK_CALITION_UNIQUE_ID);
        }
    }
    
    [paramDic setValue:VSDK_PARAM_GUEST_TYPE forKey:VSDK_PARAM_OPEN_TYPE];
    //所有的参数
    NSString * signStr = [NSString stringWithFormat:@"%@%@",open_id,VSDK_GAME_KEY];
    NSString * signMd5 = [VSEncryption md5:signStr];
    NSDictionary * jsonToken = @{VSDK_PARAM_OPEN_ID:open_id,VSDK_PARAM_SIGN:signMd5};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonToken options:NSJSONWritingPrettyPrinted error:nil];
    NSString *Token = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [paramDic setValue:Token forKey:VSDK_PARAM_TOKEN];
    
    NSString * mD5str =  [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_THIRD_LOGIN_API parameters:paramDic success:^(id responseObject) {
    
        if (REQUESTSUCCESS) {
            
            if ([[[responseObject objectForKey:@"data"]objectForKey:@"account_state"]isEqual:@3]) {
                
                VS_SHOW_INFO_MSG(@"Account Invalid!");
                
            }else{
                
                if ([[responseObject objectForKey:@"data"]objectForKey:@"account_state"] != nil) {
                    
                    VS_USERDEFAULTS_SETVALUE([[responseObject objectForKey:@"data"]objectForKey:@"account_state"], @"vsdk_account_state");
                }
            }
            
            [self vsdk_saveBindEmailAndBindPhoneNumWithObj:responseObject];
        }
        
        success(responseObject);
   
    } failure:^(NSError *error) {
        
        failure(@"request error");
    }];
}


-(void)vsdk_calitionLoginWithAccount:(NSString *)username Password:(NSString *)password Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:username forKey:VSDK_PARAM_USERNAME];
    [paramDic setValue:[VSEncryption md5:password] forKey:VSDK_PARAM_PASSWORD];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_CITATION_LOGIN_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];
}



-(void)vsdk_getCalitionAccountWithToken:(NSString *)token Password:(NSString *)pwd Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:[VSEncryption md5:pwd] forKey:VSDK_PARAM_PASSWORD];
    [paramDic setValue:token forKey:VSDK_PARAM_GUEST_TOKEN];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_CITATION_REGISTER_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];

}

-(void)vsdk_calitionImportWithType:(NSString *)type Token:(NSString *)token Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:token forKey:VSDK_PARAM_TOKEN];
    [paramDic setValue:type forKey:VSDK_PARAM_OPEN_TYPE];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_THIRD_CONNECT_GUEST_LOGIN_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];
}


-(void)vsdk_platformConnectStateWithToken:(NSString *)token Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:token forKey:VSDK_PARAM_GUEST_TOKEN];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
  
    [VSHttpHelper POST:VSDK_THIRD_CONNECT_STATE_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];
}



-(void)vsdk_connectPlatformWithType:(NSString *)type Token:(NSString *)token GuestToken:(NSString *)guestToken  Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:guestToken forKey:VSDK_PARAM_GUEST_TOKEN];
    [paramDic setValue:token forKey:VSDK_PARAM_TOKEN];
    [paramDic setValue:type forKey:VSDK_PARAM_OPEN_TYPE];
    
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_THIRD_CONNECT_BUND_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];
}


-(void)vsdk_disconnectPlatformWithType:(NSString*)type GuestToken:(NSString *)guestToken Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:guestToken forKey:VSDK_PARAM_GUEST_TOKEN];
    [paramDic setValue:type forKey:VSDK_PARAM_OPEN_TYPE];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_THIRD_CONNECT_UNBUND_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];
}


-(void)vsdk_clearCitationDataWithUniqueId:(NSString *)uniqueid{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    [paramDic setValue:uniqueid forKey:VSDK_PARAM_OPEN_ID];
    [paramDic setValue:VSDK_PARAM_GUEST_TYPE forKey: VSDK_PARAM_OPEN_TYPE];
    //所有的参数
    NSString  * signStr = [NSString stringWithFormat:@"%@%@",uniqueid,VSDK_GAME_KEY];
    NSString * signMd5 = [VSEncryption md5:signStr];
    NSString * token;
    
    if ([VS_USERDEFAULTS objectForKey:VSDK_CALITION_GUEST_TOKEN]) {
        
        token = [VS_USERDEFAULTS objectForKey:VSDK_CALITION_GUEST_TOKEN];
        
    }else{
        
        NSDictionary * jsonToken = @{VSDK_PARAM_OPEN_ID:uniqueid,VSDK_PARAM_SIGN:signMd5};
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonToken options:NSJSONWritingPrettyPrinted error:nil];
        token = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
       VS_USERDEFAULTS_SETVALUE(token, VSDK_CALITION_GUEST_TOKEN);
    }
    
    [paramDic setValue:token forKey:VSDK_PARAM_TOKEN];
    
    NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_CLEAN_CALITION_DATA_API parameters:paramDic success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
}


-(void)vsdk_citationCleanLocalCacheSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure{
    
     NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
   
    NSString * calition_open_id = [VS_USERDEFAULTS valueForKey:VSDK_CALITION_UNIQUE_ID];
    NSString * open_id = [VSDeviceHelper vsdk_keychainOpenId];
    NSString  * signStr = [NSString stringWithFormat:@"%@%@",open_id,VSDK_GAME_KEY];
    NSString * signMd5 = [VSEncryption md5:signStr];
    VS_USERDEFAULTS_SETVALUE(signMd5, VSDK_CALITION_MD5_SIGN_KEY);
    
    NSString * Token = [[NSJSONSerialization dataWithJSONObject:@{VSDK_PARAM_OPEN_ID:open_id,VSDK_PARAM_SIGN:signMd5} options:NSJSONWritingPrettyPrinted error:nil]base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [paramDic setValue:Token forKey:VSDK_PARAM_GUEST_TOKEN];

    NSString * calition_signStr = [NSString stringWithFormat:@"%@%@",calition_open_id,VSDK_GAME_KEY];
    NSString * calition_signMd5 = [VSEncryption md5:calition_signStr];
    NSDictionary * calition_jsonToken = @{VSDK_PARAM_OPEN_ID:calition_open_id,VSDK_PARAM_SIGN:calition_signMd5};
    NSData *calition_data = [NSJSONSerialization dataWithJSONObject:calition_jsonToken options:NSJSONWritingPrettyPrinted error:nil];
    NSString * calition_Token = [calition_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [paramDic setValue:calition_Token forKey:VSDK_PARAM_TOKEN];
    NSString * mD5str =  [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];

    [VSHttpHelper POST:VSDK_APP_GUEST_API parameters:paramDic success:^(id responseObject) {

        success(responseObject);

    } failure:^(NSError *error) {

        failure(@"request error");
    }];

}

-(void)vsdk_trueLoveChallengeDataWithServerId:(NSString *)serverId RoleId:(NSString *)roleId Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
     NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_BIG_CHALLENGE_DATA_API parameters:paramDic success:^(id responseObject) {
             
           success(responseObject);
              
       }failure:^(NSError *error) {
          
           failure(@"request error");
          
      }];
}


-(void)vsdk_bigChanllengeEventSubmitShareWithServerId:(NSString *)serverId RoleId:(NSString *)roleId  Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
        [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
        [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
        [paramDic setValue:@"share" forKey:VSDK_PARAM_EVENT];
        NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
        NSString * sign = [VSEncryption md5:mD5str];
        [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
       
        [VSHttpHelper POST:VSDK_SHARE_BREAK_POINT_API parameters:paramDic success:^(id responseObject) {
               
                success(responseObject);
                
          }failure:^(NSError *error) {
            
             failure(@"request error");
            
        }];
    
}


-(void)vsdk_bigChallengeShareRewardClaimWithServerId:(NSString *)serverId RoleId:(NSString *)roleId  Cert:(NSString *)event_cert Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
      
      [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
      [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
      [paramDic setValue:event_cert forKey:VSDK_PARAM_EVENT_CERT];
      
      NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
       NSString * sign = [VSEncryption md5:mD5str];
     [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_BC_SHARE_REWARD_CLAIM_API parameters:paramDic success:^(id responseObject) {
             
              success(responseObject);
              
        }failure:^(NSError *error) {
          
           failure(@"request error");
          
      }];
}


-(void)vsdk_bigChallengeRewardClaimWithServerId:(NSString *)serverId RoleId:(NSString *)roleId  Cert:(NSString *)event_cert Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
      
      [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
      [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
      [paramDic setValue:event_cert forKey:VSDK_PARAM_EVENT_CERT];
      
      NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
       NSString * sign = [VSEncryption md5:mD5str];
     [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
       
     [VSHttpHelper POST:VSDK_BIG_CHALLENGE_PRIZE_API parameters:paramDic success:^(id responseObject) {
            
             success(responseObject);
             
       }failure:^(NSError *error) {
         
          failure(@"request error");
         
     }];
    
}


-(void)vsdk_bigChanllengeEventSubmitActivePointWithServerId:(NSString *)serverId RoleId:(NSString *)roleId activeNum:(NSNumber *)num Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
     [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
     [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
     [paramDic setValue:@"active_point" forKey:VSDK_PARAM_EVENT];
     [paramDic setValue:num forKey:@"num"];
     NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
     NSString * sign = [VSEncryption md5:mD5str];
     [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
     [VSHttpHelper POST:VSDK_ACTIVE_BREAK_POINT_API parameters:paramDic success:^(id responseObject) {
            
             success(responseObject);
             
       }failure:^(NSError *error) {
         
          failure(@"request error");
         
     }];
}




-(void)vsdk_dpBagDataWithServerId:(NSString *)serverId RoleId:(NSString *)roleId RoleLevel:(NSString *)roleLevel Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
   
   [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
   [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:roleLevel forKey:VSDK_PARAM_ROLE_LEVEL];
   NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
   NSString * sign = [VSEncryption md5:mD5str];
   [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
   
   [VSHttpHelper POST:VSDK_DPB_INFO_API parameters:paramDic success:^(id responseObject) {
            
             success(responseObject);
             
      }failure:^(NSError *error) {
         
          failure(@"request error");
         
     }];
}


-(void)vsdk_dpBagCheckOrderBuyExistWithServerId:(NSString *)serverId RoleId:(NSString *)roleId RoleLevel:(NSString *)roleLevel ProductId:(NSString *)pid Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{

    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
   
   [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
   [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
   [paramDic setValue:roleLevel forKey:VSDK_PARAM_ROLE_LEVEL];
   [paramDic setValue:pid forKey:@"product_id"];
   NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
   NSString * sign = [VSEncryption md5:mD5str];
  [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_ORDER_EXIST_BUY_API parameters:paramDic success:^(id responseObject) {
             
              success(responseObject);
              
       }failure:^(NSError *error) {
          
           failure(@"request error");
          
      }];
    
}


-(void)vsdk_dpBagUploadOrderWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName OrderSn:(NSString *)orderSn{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [paramDic setValue:userId forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:money forKey:VSDK_PARAM_MONEY];
    [paramDic setValue:moneytype forKey:VSDK_PARAM_MONEY_TYPE];
    [paramDic setValue:@"" forKey:VSDK_PARAM_EXTEND];
    [paramDic setValue:moneytype forKey:VSDK_PARAM_PAY_TYPE];
    [paramDic setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:rolename forKey:VSDK_PARAM_ROLE_NAME];
    [paramDic setValue:serverName forKey:VSDK_PARAM_SERVER_NAME];
    [paramDic setValue:roleLevel forKey:VSDK_PARAM_ROLE_LEVEL];
    [paramDic setValue:goodId forKey:VSDK_PARAM_GOODS_ID];
    [paramDic setValue:goodName forKey:VSDK_PARAM_GOODS_NAME];
    [paramDic setValue:tradeSn forKey:VSDK_PARAM_CP_TRADE_SN];
    [paramDic setValue:extData forKey:VSDK_PARAM_EXT_DATA];
    [paramDic setValue:productId forKey:VSDK_PARAM_THIRD_GOODS_ID];
    [paramDic setValue:productName forKey:VSDK_PARAM_THIRD_GOODS_NAME];
    [paramDic setValue:productId forKey:@"product_id"];
    [paramDic setValue:orderSn forKey:@"order_sn"];
    
   NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
   NSString * sign = [VSEncryption md5:mD5str];
   [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_ORDERSN_UPLOAD_API parameters:paramDic success:^(id responseObject) {

       }failure:^(NSError *error) {
            
    }];
    
}

-(void)vsdk_loginAndPurchaseStateWithSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    [VSHttpHelper POST:VSDK_CLOSE_SERVER_API parameters:paramDic success:^(id responseObject) {
        success(responseObject);
       }failure:^(NSError *error) {
           failure(@"请求失败");
    }];
}


-(void)vsdk_getproductInfoBeforeOrderWithPid:(NSString *)pid Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    [paramDic setValue:pid forKey:VSDK_PARAM_THIRD_GOODS_ID];
    //添加参数配置
    NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    NSString * serviceid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid");
    NSString * servername = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_servername") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_servername");
    NSString * roleid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid");
    NSString * rolename = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_rolename") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_rolename");
    [paramDic setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(servername) forKey:VSDK_PARAM_SERVER_NAME];
    [paramDic setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_CONVERT_TYPE(rolename) forKey:VSDK_PARAM_ROLE_NAME];
    [paramDic setValue:VS_CONVERT_TYPE(roleLevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
     
     [VSHttpHelper POST:VSDK_GET_PRODUCT_INFO_API parameters:paramDic success:^(id responseObject) {

         success(responseObject);
         
        }failure:^(NSError *error) {
            
        failure(@"request error");
     }];
}

-(void)vsdk_getRedpacketAlertStateSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME) forKey:VSDK_PARAM_SERVER_NAME];
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME) forKey:VSDK_PARAM_ROLE_NAME];
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL) forKey:VSDK_PARAM_ROLE_LEVEL];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    NSString *redactivityUrl = [NSString stringWithFormat:@"%@?method=activityRedPacket.getReceiveState",GAMHOSTNAME];
    [VSHttpHelper POST:redactivityUrl parameters:paramDic success:^(id  _Nonnull responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        
        failure(@"request error");
    }];

}

- (BOOL)isBlankString:(NSString *)string{
       if(string == nil) {
            
            return YES;
            
        }
        
        if (string == NULL) {
            
            return YES;
            
        }
        
        if ([string isKindOfClass:[NSNull class]]) {
            
            return YES;
            
        }
        
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
            
            return YES;
            
        }
    return NO;
}

-(void)vsdk_delOrRecoverUserAccountWithType:(NSNumber *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure{

    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    NSString *aucode = [VS_USERDEFAULTS valueForKey:VSDK_APPLE_AUTH_CODE];
    if ([self isBlankString:aucode]) {
        aucode = @"";
    }
    
    
    NSString * delSign =  [VSEncryption md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",VSDK_APP_ID,aucode,[VSDeviceHelper getSystemTime],VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY),type,VSDK_GAME_KEY]];
    
    NSDictionary * delSignDic = @{@"token":VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY),@"time":[VSDeviceHelper getSystemTime],@"type":type,@"sign":delSign,@"app_id":VSDK_APP_ID,@"authcode":aucode};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:delSignDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSData * base64Data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
 
    NSString * base64Str = [base64Data base64EncodedStringWithOptions:0];
    
    [paramDic setValue:type forKey:@"type"];
    [paramDic setValue:base64Str forKey:@"certificate"];
    
    NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    
    [paramDic setValue:sign forKey:@"sign"];
    
    [VSHttpHelper POST:VSDK_DELETE_ACCOUNT_API parameters:paramDic success:^(id  _Nonnull responseObject) {
       success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

-(void)vsdk_activityPageDataSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:@"sign"];
    
    [VSHttpHelper POST:VSDK_GRAPHIC_BULLETIN_API parameters:paramDic success:^(id  _Nonnull responseObject) {
       success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        
    }];

    
}

-(void)vsdk_acquirePatFaceDateSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure{
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    
    //添加参数配置
    NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    NSString * serviceid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid");
    NSString * roleid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid");
    [paramDic setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleLevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    [paramDic setValue:[Pic_PatModel shareInstance].open_server_time forKey:@"open_server_time"];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_PATFACE_API parameters:paramDic success:^(id  _Nonnull responseObject) {
       success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)vsdk_reportPatFaceDateWithImgID:(NSString *)img_id WithImgtitle:(NSString *)img_title WithImgUrl:(NSString *)imgurl WithType:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure{
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    //添加参数配置
    NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    NSString * serviceid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid");
    NSString * roleid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid");
    [paramDic setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleLevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    [paramDic setValue:img_id forKey:@"img_id"];
    [paramDic setValue:img_title forKey:@"img_title"];
    [paramDic setValue:imgurl forKey:@"img"];
    [paramDic setValue:type forKey:@"type"];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    [VSHttpHelper POST:VSDK_PATFACEREPORT_API parameters:paramDic success:^(id  _Nonnull responseObject) {
       success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)vsdk_initPlatformIntegralWithType:(int)type Success:(void (^)(id))success Failure:(void (^)(NSString *))failure{
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    //添加参数配置
    NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    NSString * serviceid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid");
    NSString * roleid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid");
    [paramDic setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleLevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    NSString *token = [[VSDKHelper sharedHelper] vsdk_latestRefreshedLoginToken];
    [paramDic setValue:token forKey:@"token"];
    [paramDic setValue:VSDK_APP_ID forKey:@"app_id"];
    [paramDic setValue:VSDK_GAME_USERID forKey:@"user_id"];
    [paramDic setValue:VSDK_GAME_ID forKey:@"game_id"];
    [paramDic setValue:VSDK_APP_DISPLAY_NAME forKey:VSDK_PARAM_GAME_NAME];
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME) forKey:VSDK_PARAM_SERVER_NAME];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    NSString *requestUrl = @"";
    switch (type) {
        case 0:
            requestUrl = VSDK_PlatformIntegral_API;
            break;
        case 1:
            requestUrl = VSDK_PlatformIntegralSignin_API;
            break;
        case 2:
            requestUrl = VSDK_PlatformIntegralDetail_API;
            break;
        case 3:
            requestUrl = VSDK_PlatformIntegralQuery_API;
            break;
        case 4:
            requestUrl = VSDK_PlatformIntegralMall_API;
            break;
            
        default:
            break;
    }
    
    [VSHttpHelper POST:requestUrl parameters:paramDic success:^(id  _Nonnull responseObject) {
       success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)vsdk_PlatformDeliveryWithType:(int)type AndGoodid:(NSString *)goodid Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure{
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    //添加参数配置
    NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    NSString * serviceid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid");
    NSString * roleid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid");
    [paramDic setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleLevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    NSString *token = [[VSDKHelper sharedHelper] vsdk_latestRefreshedLoginToken];
    [paramDic setValue:token forKey:@"token"];
    [paramDic setValue:VSDK_APP_ID forKey:@"app_id"];
    [paramDic setValue:VSDK_GAME_USERID forKey:@"user_id"];
    [paramDic setValue:VSDK_GAME_ID forKey:@"game_id"];
    [paramDic setValue:VSDK_APP_DISPLAY_NAME forKey:VSDK_PARAM_GAME_NAME];
    [paramDic setValue:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME) forKey:VSDK_PARAM_SERVER_NAME];
    [paramDic setValue:goodid forKey:@"goods_id"];
    
    NSString * mD5str =   [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    NSString *requestUrl = @"";
    switch (type) {
        case 1:
            requestUrl = VSDK_Autodelive_API;
            break;
        case 2:
            requestUrl = VSDK_Manualdelive_API;
            break;
        default:
            break;
    }
    
    [VSHttpHelper POST:requestUrl parameters:paramDic success:^(id  _Nonnull responseObject) {
       success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)vsdk_loginClickWithType:(NSString *)type Success:(void (^)(id))success Failure:(void (^)(NSString *))failure{
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [paramDic setValue:type forKey:@"click_type"];
    NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:@"sign"];
    [VSHttpHelper POST:VSDk_LoginClick_API parameters:paramDic success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
