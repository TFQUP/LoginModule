//
//  VSDeviceHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSDeviceHelper.h"
#import <sys/utsname.h>
#import "QZSSKeychain.h"
#import "VSSDKDefine.h"
#import "AFNetworking.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import<SystemConfiguration/CaptiveNetwork.h>
#import <AdSupport/AdSupport.h>
#import <Photos/Photos.h>

#define SERVERNAME  @"RR_GAME_iOSSDK_2017_SERVERNAME"
#define UUID        @"RR_GAME_iOSSDK_2017_UUID"

@implementation VSDeviceHelper


+(NSString *)vsdk_systemLanguage{
    
    NSArray *appLanguages = [VS_USERDEFAULTS  objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    return [[languageName componentsSeparatedByString:@"-"]firstObject];
}


+(NSInteger)getDifferenceByDate:(NSString *)date{
    
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
  
}

#pragma mark -- 对字段元素根据key进行排序
+(NSString *)MD5SignWithDic:(NSDictionary *)dict{
    
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];

    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
   
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",afterSortKeyArray[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];

    return signString;
    
}
//将系统时间转换成时间戳
+(NSString *)getSystemTime{
   
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", time];//转为字符型
    return timeString;
    
}
//将来日期转换成时间戳
+(NSString *)vsdk_currentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}


#pragma mark -- 获取网络状态的方法
+(NSString *)networkState{
    
    NSString *strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability =SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    //没有网络
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return @"";
    }
    
    if ((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==0)
    {
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"wifi";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) !=0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) !=0
        )
    {
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags &kSCNetworkReachabilityFlagsInterventionRequired) ==0)
        {
            // ... and no [user] intervention is needed
            strNetworkType = @"wifi";
        }
    }
    
    if ((flags &kSCNetworkReachabilityFlagsIsWWAN) ==kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >=7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags &kSCNetworkReachabilityFlagsReachable) ==kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags &kSCNetworkReachabilityFlagsTransientConnection) ==kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    
    if ([strNetworkType isEqualToString:@""]) {
        strNetworkType = @"WWAN";
    }
    
    return strNetworkType;
    
}



// 正则匹配
+ (BOOL)RegexWithString:(NSString *)string pattern:(NSString *)pattern {
    
    NSRegularExpression *expresion = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    
    NSArray *results = [expresion matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (results.count == 0) {
        
        return NO;
        
    } else {
        
        return YES;
    }
    
}

+ (NSString *)vsdk_DeviceModel {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X (GSM)";
    
    if([deviceModel isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if([deviceModel isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if([deviceModel isEqualToString:@"iPhone11,4"]||[deviceModel isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if([deviceModel isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if([deviceModel isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if([deviceModel isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    
    if([deviceModel isEqualToString:@"iPhone12,8"])  return @"iPhone SE2";
    if([deviceModel isEqualToString:@"iPhone13,1"])  return @"iPhone 12 mini";
    if([deviceModel isEqualToString:@"iPhone13,2"])  return @"iPhone 12";
    if([deviceModel isEqualToString:@"iPhone13,3"])  return @"iPhone 12  Pro";
    if([deviceModel isEqualToString:@"iPhone13,4"])  return @"iPhone 12  Pro Max";
    if([deviceModel isEqualToString:@"iPhone14,4"])  return @"iPhone 13 mini";
    if([deviceModel isEqualToString:@"iPhone14,5"])  return @"iPhone 13";
    if([deviceModel isEqualToString:@"iPhone14,2"])  return @"iPhone 13  Pro";
    if([deviceModel isEqualToString:@"iPhone14,3"])  return @"iPhone 13  Pro Max";

    //iPod 系列
    if([deviceModel isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    if([deviceModel isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    if([deviceModel isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if([deviceModel isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if([deviceModel isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    if([deviceModel isEqualToString:@"iPod7,1"])  return @"iPod touch 6G";
    if([deviceModel isEqualToString:@"iPod9,1"])  return @"iPod touch 7G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])  return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])  return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])  return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])  return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])  return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])  return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])  return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])  return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])  return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(GSM)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    if([deviceModel isEqualToString:@"iPad5,1"] || [deviceModel isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    if([deviceModel isEqualToString:@"iPad6,7"] || [deviceModel isEqualToString:@"iPad6,8"])    return @"iPad Pro 12.9-inch";
    if([deviceModel isEqualToString:@"iPad6,3"] || [deviceModel isEqualToString:@"iPad6,4"])    return @"iPad Pro iPad 9.7-inch";
    if([deviceModel isEqualToString:@"iPad6,11"] || [deviceModel isEqualToString:@"iPad6,12"])    return @"iPad 5";
    if([deviceModel isEqualToString:@"iPad7,1"] || [deviceModel isEqualToString:@"iPad7,2"])    return @"iPad Pro 12.9-inch 2";
    if([deviceModel isEqualToString:@"iPad7,3"] || [deviceModel isEqualToString:@"iPad7,4"])    return @"iPad Pro 10.5-inch";
    if([deviceModel isEqualToString:@"iPad7,5"] || [deviceModel isEqualToString:@"iPad7,6"])    return @"iPad 6th Gen";

    if([deviceModel isEqualToString:@"iPad8,1"] || [deviceModel isEqualToString:@"iPad8,2"]||[deviceModel isEqualToString:@"iPad8,3"] || [deviceModel isEqualToString:@"iPad8,4"])  return @"iPad Pro 11 inch 3rd Gen";
    
    if([deviceModel isEqualToString:@"iPad8,5"] || [deviceModel isEqualToString:@"iPad8,6"]||[deviceModel isEqualToString:@"iPad8,7"] || [deviceModel isEqualToString:@"iPad8,8"])  return @"iPad Pro 12.9 inch 3rd Gen";

    if([deviceModel isEqualToString:@"iPad8,9"] || [deviceModel isEqualToString:@"iPad8,10"])  return @"iPad Pro 11 inch 4th Gen";
    
    if([deviceModel isEqualToString:@"iPad8,11"] || [deviceModel isEqualToString:@"iPad8,12"])    return @"iPad Pro 12.9 inch 4th Gen";
    
    if([deviceModel isEqualToString:@"iPad11,1"] || [deviceModel isEqualToString:@"iPad11,2"])    return @"iPad mini 5th Gen";
    
    if([deviceModel isEqualToString:@"iPad11,3"] || [deviceModel isEqualToString:@"iPad11,4"])    return @"iPad Air 3rd Gen";
    
    if([deviceModel isEqualToString:@"iPad11,6"] || [deviceModel isEqualToString:@"iPad11,7"])    return @"iPad 8th Gen";
    
    if([deviceModel isEqualToString:@"iPad12,2"])    return @"iPad 9th Gen";
    
    if([deviceModel isEqualToString:@"iPad14,2"])    return @"iPad mini 6th Gen";
    
    if([deviceModel isEqualToString:@"iPad13,1"] || [deviceModel isEqualToString:@"iPad13,2"])    return @"iPad Air 4th Gen";
    
    if([deviceModel isEqualToString:@"iPad13,4"] || [deviceModel isEqualToString:@"iPad13,5"]||[deviceModel isEqualToString:@"iPad13,6"] || [deviceModel isEqualToString:@"iPad13,7"])    return @"iPad Pro 11 inch 5th Gen";
    
    if([deviceModel isEqualToString:@"iPad13,8"] || [deviceModel isEqualToString:@"iPad13,9"]||[deviceModel isEqualToString:@"iPad13,10"] || [deviceModel isEqualToString:@"iPad13,11"])    return @"iPad Pro 12.9 inch 5th Gen";

    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}


//计算文本宽度的方法
+(CGFloat)sizeWithFontStr:(NSString *)str WithFontSize:(CGFloat)fontsize{

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:fontsize];
    CGSize maxSzie= CGSizeMake(CGFLOAT_MAX, fontsize);
    CGSize MaxSize = [str boundingRectWithSize:maxSzie options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
   return ceilf(MaxSize.width);
   
}


//根据文本和定宽求高度
 
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
 
                                     options:NSStringDrawingUsesLineFragmentOrigin
 
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];

    return rect.size.height;
 
}

/**
 根据高度求宽度
 @param text 计算的内容
 @param height 计算的高度
 @param font font字体大小
 @return 返回Label的宽度
 */
 
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
 
                                     options:NSStringDrawingUsesLineFragmentOrigin
 
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
 
                                     context:nil];
 
    return rect.size.width;
 
}




+ (BOOL)checkInputAccount:(NSString *)acount{
    
    NSString *pattern = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$";
    BOOL isEmail = [VSDeviceHelper RegexWithString:acount pattern:pattern];
    
    return isEmail;
}

+(CGFloat)getExpansionFactorWithphoneOrPad{

    if (SCREE_HEIGHT == 812||SCREE_HEIGHT == 896||SCREE_HEIGHT == 926||SCREE_HEIGHT == 844 ) {

        return 2;
        
    }else if(SCREE_HEIGHT == 1024||SCREE_HEIGHT == 1080||SCREE_HEIGHT == 1112||SCREE_HEIGHT == 1366) {
        
        return 1;
        
    }else if(SCREE_HEIGHT == 1194 || SCREE_HEIGHT == 1180){
        
        return 1.08;
        
    }else{
        
        return 1.6;
    }
}

+(NSDictionary *)getSanboxFilePathWithCompontment:(NSString *)compontmentName{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:compontmentName];
     NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:fileDicPath];
    
    return resultDic;

}

+(NSString *)getfilePathInDirectoryWithCompontment:(NSString *)compontmentName{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [docPath stringByAppendingPathComponent:compontmentName];
    
}


+(CGFloat)autoLoginPaltFormTypeTableHeight{

    NSUInteger availableCount = [self vsdk_supportablePlatform];
    
    CGFloat height = DEVICEPORTRAIT?777:886;
          
      if (availableCount == 1) {
          
          if (DEVICEPORTRAIT) {
              
              if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]) {
                 
                  height = 563;
                  
              }else{
                  
                  height = 544;
              }
              
          }else{
             
              if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]) {
                       
                        height = 624;
                        
                    }else{
                        
                       height = 600;
                    }

          }
          
      }
    
    if (availableCount == 2) {
           
           if (DEVICEPORTRAIT) {
               
               if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]) {
                  
                   height = 670;
                   
               }else{
                   
                   height = 646;
               }
               
           }else{
              
               if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]) {
                                
                     height = 755;
                     
                 }else{
                     
                    height = 743;
                 }
           }
           
       }
 
        return height;
}
    


+(NSUInteger)vsdk_supportablePlatform{
    
     NSUInteger count = 1;
    
    if (VSDK_LOCAL_DATA(VSDK_USABLE_PALTFORM_PATH, @"login_type_data")) {
        
        NSMutableDictionary * useDic = (NSMutableDictionary *)VSDK_LOCAL_DATA(VSDK_USABLE_PALTFORM_PATH, @"login_type_data");
               
               NSMutableArray * paltArr = [[NSMutableArray alloc]init];
               
               for (NSString * key in useDic.allKeys) {

                   if ([useDic objectForKey:key] != nil&&[[useDic objectForKey:key] isEqual: @1]) {

                       if ([key isEqualToString:VSDK_FACEBOOK]) {
                           
                           [paltArr insertObject:key atIndex:0];
                           
                       }else{
                           
                          [paltArr addObject:key];
                       }
                   }
               }
        
            count = paltArr.count;
        
    }else{
        
         NSString *path = [[NSBundle mainBundle] pathForResource:[kBundleName stringByAppendingPathComponent:@"supportablePlatform"] ofType:@"plist"];
        
        if (path) {
            
            NSMutableDictionary * uDic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
            
            for (NSString * key in uDic.allKeys) {
                
                if ([[uDic objectForKey:key] isEqual: @0]) {
                  
                    [uDic removeObjectForKey:key];
                }
            }
            
            count = uDic.count;
        }
        
    }
    
    return count;
    
}



+(void)showTermOrContactCustomerServiceWithUrl:(NSString *)url{
    
     SFSafariViewController * vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:url]];
    [VS_RootVC presentViewController:vc animated:YES completion:nil];
    
}

+(NSString *)vsdk_iapFailureOrderInfo{
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper iapReceiptPath] error:&error];
    
    NSString * receipt,*order,*createtime,*userId,*product_type;
    
    NSString *  failIapInfoStr = @"";
    
    if (error == nil) {
        
        for (NSString *name in cacheFileNameArray) {
            
            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                
                NSString *filePath = VS_UNFINISH_ORDER_PATH(name);
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                product_type = [dic objectForKey:VSDK_PARAM_PRODUCT_TYPE];
                createtime = [dic objectForKey:VSDK_PARAM_TIME];
                receipt = [dic objectForKey:VSDK_RECEIPT_KEY];
                order = [dic objectForKey:VSDK_PARAM_ORDER];
                userId = [dic objectForKey:VSDK_PARAM_USER_ID];
                failIapInfoStr = [NSString stringWithFormat:@"%@\nTime:%@\nproduct_type:%@\nUserId:%@\nOrder:%@\nReceipt:%@\n",failIapInfoStr,createtime,product_type,userId,order,receipt];
            }
        }
        
        if (failIapInfoStr.length == 0) {
            
            return @"";
            
        }else{
            
            return failIapInfoStr;
        }
        
    } else {
        
        return @"";
    }
}


+(NSString *)vsdk_iapSuccessOrderInfo{
  
    NSFileManager *fileManager = [NSFileManager defaultManager];
      NSError * error;
      NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper SuccessIapPath] error:&error];
      
      NSString * time,*product_type, * receipt,* order,* userId;
      NSString *  successInfoStr = @"";
      
      if (error == nil) {
          
          for (NSString * name in cacheFileNameArray) {
              
              if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                  NSString *filePath = VS_SUCCESS_ORDER_PATH(name);
                  
                  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                  time = [dic objectForKey:VSDK_PARAM_TIME];
                  product_type = [dic objectForKey:VSDK_PARAM_PRODUCT_TYPE];
                  receipt = [dic objectForKey:VSDK_RECEIPT_KEY];
                  order = [dic objectForKey:VSDK_PARAM_ORDER];
                  userId = [dic objectForKey:VSDK_PARAM_USER_ID];
                  successInfoStr = [NSString stringWithFormat:@"%@\nTime:%@\nproduct_type:%@\nUserId:%@\nOrder:%@\nReceipt:%@\n",successInfoStr,time,product_type,userId,order,receipt];
              }
          }
          
          if (successInfoStr.length == 0) {
              
              return @"";
              
          }else{
              
              return successInfoStr;
          }
          
      }else{
          
          return @"";
      }
}



+(NSString *)vsdk_subSuccessOrderInfo{
  
    NSFileManager *fileManager = [NSFileManager defaultManager];
      NSError * error;
      NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper SuccessSubPath] error:&error];
      
      NSString * time,*product_type, * receipt,* order,* userId;
      NSString *  successInfoStr = @"";
      
      if (error == nil) {
          
          for (NSString * name in cacheFileNameArray) {
              
              if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                  NSString *filePath = VS_SUB_SUCCESS_ORDER_PATH(name);
                  
                  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                  time = [dic objectForKey:VSDK_PARAM_TIME];
                  product_type = [dic objectForKey:VSDK_PARAM_PRODUCT_TYPE];
                  receipt = [dic objectForKey:VSDK_RECEIPT_KEY];
                  order = [dic objectForKey:VSDK_PARAM_ORDER];
                  userId = [dic objectForKey:VSDK_PARAM_USER_ID];
                  successInfoStr = [NSString stringWithFormat:@"%@\nTime:%@\nproduct_type:%@\nUserId:%@\nOrder:%@\nReceipt:%@\n",successInfoStr,time,product_type,userId,order,receipt];
              }
          }
          
          if (successInfoStr.length == 0) {
              
              return @"";
              
          }else{
              
              return successInfoStr;
          }
          
      }else{
          
          return @"";
      }
}


+(NSString *)vsdk_crashLog{
  
    NSFileManager *fileManager = [NSFileManager defaultManager];
       NSError * error;
       NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[VSSandBoxHelper crashLogInfo] error:&error];
       
       NSString * time,*crashLog,*crashLogInfoStr;
       
       if (error == nil) {
           
           for (NSString * name in cacheFileNameArray) {
               
               if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                   
                   NSString *filePath = [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper crashLogInfo], name];
                   NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                   crashLog = [dic objectForKey:@"crashLog"];
                   
                   crashLogInfoStr = [NSString stringWithFormat:@"%@\n崩溃日志:%@\n",crashLogInfoStr,crashLog];
               }
           }
           
           if (crashLogInfoStr.length == 0) {
               
               return @"";
               
           }else{
               
               return crashLogInfoStr;
           }
           
       }else{
           
           return @"";
       }
    
}



+(void)addAnimationInView:(UIView *)view Duration:(CGFloat)duration{
  
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = duration;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}


+(NSString *)vsdk_keychainOpenId{
    
    NSString * openid;
    
    if ([[VSKeychain load:VSDK_FOREVEVR_UUID]length]>0) {
        
        openid = [VSKeychain load:VSDK_FOREVEVR_UUID];
        
    }else{
        
        if ([[VS_USERDEFAULTS objectForKey:VSDK_FOREVEVR_UUID] length]>0) {
                
            openid = [VS_USERDEFAULTS objectForKey:VSDK_FOREVEVR_UUID];
            
        }else{
        
            if ([VSDK_IDFA isEqualToString:VSDK_INVALID_IDFA]) {
                
                openid = [VSOpenIDFA sameDayVSOpenIDFA];
                
            }else{
                
                openid = VSDK_IDFA;
                
            }
        }

        [VSKeychain save:VSDK_FOREVEVR_UUID data:openid];
    }
    
    return openid;
}


+(NSString *)getKeychainAdjustID{
    
    NSString * adujustId = [VSKeychain load:VSDK_KEYCHAIN_ADJUSTID];
    
    if([adujustId length]==0){
        
        if ([[Adjust adid]length]>0) {
            
            adujustId = [Adjust adid];
            
            [VSKeychain save:VSDK_KEYCHAIN_ADJUSTID data:adujustId];
            
        }else{
            
            adujustId = @"";
        }

    }
    
    return adujustId;

}



+(NSString *)vsdk_keychainIDFA{
    
    NSString * idfaKeychainSpUUID = [VSKeychain load:VSDK_SP_UUID];
    
    if ([idfaKeychainSpUUID length]>0){
        
        return idfaKeychainSpUUID;
    }
    NSString * idfaKeychain = [VSKeychain load:VSDK_KEYCHAIN_IDFA];
  
      if ([idfaKeychain length]==0) {
      
          if ([VSDK_IDFA isEqualToString:VSDK_INVALID_IDFA]) {
              
              idfaKeychain = [self vsdk_keychainOpenId];

          }else{
             
              idfaKeychain = VSDK_IDFA;
          }
          
          if ([idfaKeychain length]==0) {
              //获取本机SDK生成的OPEN_ID

              idfaKeychain = [self vsdk_keychainOpenId];
             
          }
          
          if ([idfaKeychain length]>0) {
            
             [VSKeychain save:VSDK_KEYCHAIN_IDFA data:idfaKeychain];
         
          }
          
      }
    
     return idfaKeychain;
}


+(NSString *)vsdk_realAdjustIdfa{
    
    NSString * adjustIdfa = VSDK_IDFA;
    
    if([VSDK_INVALID_IDFA isEqualToString:adjustIdfa]){
        
        return [VSDK_INVALID_IDFA isEqualToString:VSDK_IDFA]?@"":VSDK_IDFA;
    }else{
        
        return [adjustIdfa length]>0?adjustIdfa:@"";
    }
    
}


+ (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
 
}



+(void)addKeyframeAnimationWith:(UIButton *)button withDuration:(CGFloat)duration {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.4,@1.2,@1.0,@0.8,@1.0,@1.2,@1.4];
    animation.duration = duration;
    animation.calculationMode = kCAAnimationCubic;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [button.layer addAnimation:animation forKey:@"transform.scale"];
    
}


+(void)showSystemTipsAlertWithTitle:(NSString *)title message:(NSString *)message comfirmTitle:(NSString *)comfirmStr{
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:comfirmStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [VS_RootVC presentViewController:alert animated:YES completion:nil];
    
}



+(void)vsdk_firebaseEventWithEventName:(NSString *)eventName{
    

    if (VSDK_LOCAL_DATA(VSDK_ADJUST_EVEN_PATH, eventName)){
        
        NSDictionary * dic = VSDK_DIC_WITH_PATH(VSDK_ADJUST_EVEN_PATH);
        ADJEvent * event = [[ADJEvent alloc]initWithEventToken:[dic objectForKey:eventName]];
        [Adjust trackEvent:event];
        [FIRAnalytics logEventWithName:eventName parameters:nil];
        
    }else{
       
        [[VSDKAPI shareAPI]  vsdk_storedAdjustEventTokenSuccess:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                              
                NSString * token = [GETRESPONSEDATA:eventName];
                ADJEvent * event = [[ADJEvent alloc]initWithEventToken:token];
                [Adjust trackEvent:event];
                [FIRAnalytics logEventWithName:eventName parameters:nil];
            }
            
        } Failure:^(NSString *failure) {
            
        }];
    }
    
}

+(CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                      withFont:(CGFloat)font
{
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = lineSpacing;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:str
                                                                                       attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                context:nil];
    
    if ((rect.size.height - [UIFont systemFontOfSize:font].lineHeight)  <= lineSpacing){
    
    }
    return rect.size.height;
}


+(NSString *)analyzeIpAddressWithHostName:(NSString *)hostName{
    
    const char *hostN= [hostName UTF8String];
    
    // 记录主机的信息，包括主机名、别名、地址类型、地址长度和地址列表 结构体
    struct hostent *phot;
    
    @try {
        // 返回对应于给定主机名的包含主机名字和地址信息的hostent结构指针
        phot = gethostbyname(hostN);
        
        if (phot == NULL) return @"未能根据域名获取ip";
        
        struct in_addr ip_addr;
        
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        
        char ip[20] = {0};
        
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        
        NSString * strIPAddress = [NSString stringWithUTF8String:ip];
        
        return strIPAddress;
        
    }
    
    @catch (NSException *exception) {
        
        return @"未能根据域名获取ip";
    }
    
}



+(NSString *)getBasicRequestWithParams:(NSDictionary *)param{
    
       NSString * time =  [self getSystemTime];
       NSString * _gameId = VSDK_GAME_ID;
       NSString * _plamtform = VSDK_PALTFORM;
       NSString * Idfv = VSDK_IDFV;
       NSString * _Appid = VSDK_APP_ID;
       NSString * realAdjustId = [[Adjust adid] length]>0?[Adjust adid]:@"";
       NSString * realIdfa = [self vsdk_realAdjustIdfa];
       NSString * adujustId = [self getKeychainAdjustID];
       NSString * idfaKeychain = [self vsdk_keychainIDFA];
       NSString * _uuid = idfaKeychain;
       NSString * idfa = idfaKeychain;
       NSString * device = [self vsdk_DeviceModel];
       NSString * language = [self vsdk_systemLanguage];
       NSString * osVer = VSDK_OS_VER;
       NSString * sdkVer = VSDK_VER;
       NSString * netWork = [self networkState];
       NSString * simulateidfa = [self vsdk_keychainOpenId];
    
       NSMutableDictionary * Pdic = [VSDK_GAME_USERID length] >0?[NSMutableDictionary dictionaryWithDictionary:@{VSDK_PARAM_USER_ID:VSDK_GAME_USERID,VSDK_PARAM_ADJUST_ID:adujustId,VSDK_PARAM_IDFA:idfa,VSDK_PARAM_IDFV:Idfv,VSDK_PARAM_NEYWORK:netWork,VSDK_PARAM_DNAME:device,VSDK_PARAM_OS_VER:osVer,VSDK_PARAM_REAL_ADJUST_ID:realAdjustId,VSDK_PARAM_REAL_IDFA:realIdfa,VSDK_PARAM_SDK_VER:sdkVer,VSDK_PARAM_LANGUAGE:language,VSDK_PARAM_GAME_ID:_gameId,VSDK_PARAM_PLARFORM:_plamtform,VSDK_PARAM_UUID:_uuid,VSDK_PARAM_TIME:time,VSDK_PARAM_APP_ID:_Appid,VSDK_PARAM_APP_VERSION:VSDK_APP_VERSION,VSDK_PARAM_APP_BUILD:VSDK_APP_BUILD,VSDK_PARAM_DEVICE_ID:simulateidfa}]:[NSMutableDictionary dictionaryWithDictionary:@{VSDK_PARAM_ADJUST_ID:adujustId,VSDK_PARAM_IDFA:idfa,VSDK_PARAM_IDFV:Idfv,VSDK_PARAM_NEYWORK:netWork,VSDK_PARAM_DNAME:device,VSDK_PARAM_OS_VER:osVer,VSDK_PARAM_REAL_ADJUST_ID:realAdjustId,VSDK_PARAM_REAL_IDFA:realIdfa,VSDK_PARAM_SDK_VER:sdkVer,VSDK_PARAM_LANGUAGE:language,VSDK_PARAM_GAME_ID:_gameId,VSDK_PARAM_PLARFORM:_plamtform,VSDK_PARAM_UUID:_uuid,VSDK_PARAM_TIME:time,VSDK_PARAM_APP_ID:_Appid,VSDK_PARAM_APP_VERSION:VSDK_APP_VERSION,VSDK_PARAM_APP_BUILD:VSDK_APP_BUILD,VSDK_PARAM_DEVICE_ID:simulateidfa}];
    
    for (NSString * key in param.allKeys) {
        
        [Pdic setValue:[param objectForKey:key] forKey:key];
    }
    
    NSString * mD5str =   [[self MD5SignWithDic:Pdic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [Pdic setValue:sign forKey:VSDK_PARAM_SIGN];
    
    NSString * requestBasicStr = @"";
    for (NSString * key in Pdic.allKeys) {
      
        if ([[Pdic.allKeys lastObject]isEqualToString:key]) {
            requestBasicStr = [requestBasicStr stringByAppendingFormat:@"%@=%@",key,[Pdic objectForKey:key]];
        }else{
            requestBasicStr = [requestBasicStr stringByAppendingFormat:@"%@=%@&",key,[Pdic objectForKey:key]];
        }

    }
    return requestBasicStr;

}



+(NSMutableDictionary *)plarformAvailable{
    
    NSMutableDictionary * platDic;
    
    if (VSDK_LOCAL_DATA(VSDK_USABLE_PALTFORM_PATH, @"login_type_data")) {
        
        platDic = (NSMutableDictionary *)VSDK_LOCAL_DATA(VSDK_USABLE_PALTFORM_PATH, @"login_type_data");
        
        [platDic removeObjectForKey:VSDK_GUEST];
        
    }else{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[kBundleName stringByAppendingPathComponent:@"supportablePlatform"] ofType:@"plist"];
    
    if (path) {
        
        platDic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        
        [platDic removeObjectForKey:VSDK_GUEST];
        }else{
            
            platDic = nil;
        }
    }
      
    return platDic;;
}


+(NSMutableArray *)getCountryAreaCodes{
    
    NSMutableArray * dic =  [NSMutableArray arrayWithContentsOfFile:VS_COUNTRY_AREA_CODES_PATH(@"countryAreaCodes.plist")];
    
    return dic;
    
}


+ (NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


+(NSDictionary *)preSaveSocialData{
    
    NSDictionary * dic =  [NSDictionary dictionaryWithContentsOfFile:VS_SOCIAL_INFO_PATH(@"vsdkSocialData.plist")];
    
    return dic;
    
}



+(BOOL)vsdk_floatballtShowWithRolevel:(NSString *)rolelevel{
  
    id a = VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_show_state");
    id b = VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level");
    
    BOOL show = NO;

    if ([VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_show_state") isEqual:@1]&&([VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level") isEqual:@-1]||[VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level") isEqual:@0])) {
        
        show = YES;
    }
    
    if ([VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_show_state") isEqual:@2]&&([VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level") isEqual:@-1]||[VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level") isEqual:@0])) {
        
          show = YES;
    }
    
    if (rolelevel != nil) {
        
        NSNumber * roleLevelNum = @([rolelevel integerValue]);
        
        BOOL c = roleLevelNum>=VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level");
        
        BOOL d = [VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_show_state") isEqual:@3];
        
        if ([VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_show_state") isEqual:@3]&&roleLevelNum>=VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"floatball_restrict_level")) {
             show = YES;
        }
    }


    return show;
    
}

+(NSString *)vsdk_customServiceUrl{

     NSString * str =  [[NSString stringWithFormat:@"%@&%@",VSDK_CUSTOMER_SERVICE_API,[VSDeviceHelper getBasicRequestWithParams:@{VSDK_PARAM_SERVER_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID),VSDK_PARAM_SERVER_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME),VSDK_PARAM_ROLE_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID),VSDK_PARAM_ROLE_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME),VSDK_PARAM_ROLE_LEVEL:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL),VSDK_PARAM_UUID:[[VSDeviceHelper vsdk_realAdjustIdfa]length]>0?[VSDeviceHelper vsdk_realAdjustIdfa]:[VSDeviceHelper vsdk_keychainIDFA],VSDK_PARAM_TOKEN:VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY)}]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ;
    
    return str;
    
    
}


+(void)vsdk_saveCalitionCode{

     UIGraphicsBeginImageContextWithOptions(VS_RootVC.view.frame.size,NO, 0);

     [[UIColor clearColor] setFill];

     [[UIBezierPath bezierPathWithRect:VS_RootVC.view.bounds] fill];

     CGContextRef ctx = UIGraphicsGetCurrentContext();

     [VS_RootVC.view.layer renderInContext:ctx];

     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

     UIGraphicsEndImageContext();
    
    __block NSString * createdAssetID = nil;
      NSError *error =nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        createdAssetID = [PHAssetChangeRequest            creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
}


+(NSDictionary *)combineRequestParams{
    
        NSString * _gameId = VSDK_GAME_ID;
        NSString * _plamtform = VSDK_PALTFORM;
        NSString * Idfv = VSDK_IDFV;
        NSString * _Appid = VSDK_APP_ID;
        NSString * osVer = VSDK_OS_VER;
        NSString * sdkVer = VSDK_VER;
        NSString * time =  [self getSystemTime];
        NSString * adujustId = [self getKeychainAdjustID];
        NSString * idfaKeychain = [self vsdk_keychainIDFA];
        NSString * _uuid = idfaKeychain;
        NSString * idfa = idfaKeychain;
        NSString * device = [self vsdk_DeviceModel];
        NSString * language = [self vsdk_systemLanguage];
        NSString * netWork = [self networkState];
        NSString * realAdjustId = @"";
        NSString * realIdfa = [self vsdk_realAdjustIdfa];
        NSString * simulateidfa = [self vsdk_keychainOpenId];
        NSString * dispalyWidth = [NSString stringWithFormat:@"%f",SCREE_WIDTH];
        NSString * dispalyHeight = [NSString stringWithFormat:@"%f",SCREE_HEIGHT];
        NSDictionary * params;

    
    
        NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    
        if (_gameId == nil||_Appid == nil) {
        
            VS_SHOW_ERROR_STATUS(@"缺少参数配置,请检查Info.plist配置或请查看参数文档&对接文档");
        
        }else{
          
       if([VSDK_GAME_USERID length] >0) {
           
           params = @{VSDK_PARAM_USER_ID:VSDK_GAME_USERID,VSDK_PARAM_ROLE_LEVEL:roleLevel,VSDK_PARAM_ADJUST_ID:adujustId,VSDK_PARAM_IDFA:idfa,VSDK_PARAM_IDFV:Idfv,VSDK_PARAM_NEYWORK:netWork,VSDK_PARAM_DNAME:device,VSDK_PARAM_SDK_VER:sdkVer,VSDK_PARAM_OS_VER:osVer,VSDK_PARAM_REAL_ADJUST_ID:realAdjustId,VSDK_PARAM_REAL_IDFA:realIdfa,VSDK_PARAM_LANGUAGE:language,VSDK_PARAM_GAME_ID:_gameId,VSDK_PARAM_PLARFORM:_plamtform,VSDK_PARAM_UUID:_uuid,VSDK_PARAM_TIME:time,VSDK_PARAM_APP_ID:_Appid,VSDK_PARAM_APP_VERSION:VSDK_APP_VERSION,VSDK_PARAM_APP_BUILD:VSDK_APP_BUILD,VSDK_PARAM_DEVICE_ID:simulateidfa,VSDK_PARAM_DISPLAY_WIDTH:dispalyWidth,VSDK_PARAM_DISPLAY_HEIGHT:dispalyHeight,@"pro":@"game"};
           
       }else{
       
           params = @{VSDK_PARAM_ROLE_LEVEL:roleLevel,VSDK_PARAM_IDFA:idfa,VSDK_PARAM_ADJUST_ID:adujustId,VSDK_PARAM_IDFV:Idfv,VSDK_PARAM_NEYWORK:netWork,VSDK_PARAM_DNAME:device,VSDK_PARAM_SDK_VER:sdkVer,VSDK_PARAM_OS_VER:osVer,VSDK_PARAM_REAL_ADJUST_ID:realAdjustId,VSDK_PARAM_REAL_IDFA:realIdfa,VSDK_PARAM_LANGUAGE:language,VSDK_PARAM_GAME_ID:_gameId,VSDK_PARAM_PLARFORM:_plamtform,VSDK_PARAM_UUID:_uuid,VSDK_PARAM_TIME:time,VSDK_PARAM_APP_ID:_Appid,VSDK_PARAM_APP_VERSION:VSDK_APP_VERSION,VSDK_PARAM_APP_BUILD:VSDK_APP_BUILD,VSDK_PARAM_DEVICE_ID:simulateidfa,VSDK_PARAM_DISPLAY_WIDTH:dispalyWidth,VSDK_PARAM_DISPLAY_HEIGHT:dispalyHeight,@"pro":@"game"};
           
       }
        
    }
       return params;
}


+ (NSAttributedString *)vsdk_attrHtmlStringFrom:(NSString *)str {

    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}


+(void)POST:(NSString *)URLString parameters:(NSMutableDictionary *)parameters{
    
    [VSHttpHelper POST:URLString parameters:parameters success:^(id     responseObject){
        
    }failure:^(NSError *error) {}];
}


+(void)vsdk_closeLoginNoticeUI{
    
    VSGameExpired * view = [[VSGameExpired alloc]init];
    view.btnText = @"OK";
    view.ifLogin = YES;
    [view vsdk_gameStopOperation];
    
}

@end
