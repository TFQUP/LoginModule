//
//  VSDKTPInitHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSDKTPInitHelper.h"
#import "VSSDKDefine.h"


static VSDKTPInitHelper * xhepler;

@interface VSDKTPInitHelper ()
@property(nonatomic,copy)void(^completeBlock)(BOOL complete);
@end

@implementation VSDKTPInitHelper

+(VSDKTPInitHelper *)shareHelper{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        xhepler = [[VSDKTPInitHelper alloc]init];
        
    });
    
    return xhepler;
    
}

-(void)vsdk_initializeDependencyWithApplication:(UIApplication *)application Options:(NSDictionary *)options WithCompletionHandler:(void(^)(BOOL initlized)) completionHandler{
    
    self.completeBlock = [completionHandler copy];
    [FIRApp configure];
    [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:options];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        
    FBSDKSettings * settings = [FBSDKSettings sharedSettings];
    
    settings.appID = VSDK_FACEBOOK_APPID;
    settings.advertiserIDCollectionEnabled =  YES;
    settings.autoLogAppEventsEnabled = YES;
    
    [Bugly startWithAppId:VSDK_BUGLY_ID];
    [self  vsdk_initializeAdjustSdk];
    [[VSIPAPurchase manager]vsdk_startIapManager];
    
#if Helper
    [self vask_loadAssistantRemoteData];
#endif
    [self vsdk_calitionDataCleanedOrNot];
    
    //FBAudience库
//    [FBAdSettings setAdvertiserTrackingEnabled:YES];
    
    NSThread * pt = [[NSThread alloc]initWithTarget:self selector:@selector(vsdk_paramsContainAdjustId) object:nil];
    [pt start];

    
}


-(void)vsdk_paramsContainAdjustId{
    
    NSUInteger repeatMaxCount = 8;
    
    do{
        NSString * adid = [Adjust adid];
        
        sleep(1);
        
        if([adid length]>0){
            
            [self vsdk_saveSPUUID];
            VS_USERDEFAULTS_SETVALUE(@YES, @"AdjustExist");
            return;
        }
        
    }while (--repeatMaxCount > 0);
    
    [self vsdk_saveSPUUID];
    VS_USERDEFAULTS_SETVALUE(@YES, @"AdjustExist");
}


-(void)vsdk_saveSPUUID{
    
    [[VSDKAPI shareAPI] vsdk_storedAdjustEventTokenSuccess:^(id  _Nonnull responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            
            //获取网络的adjustid 是否存在
            
            if ([[Adjust adid]length]>0&&[[VSKeychain load:VSDK_SP_UUID]length]==0) {
                
                NSString * sp_uuid = [dic objectForKey:@"uuid"];
                
                if ([sp_uuid length]>0) {
                    
                    [VSKeychain save:VSDK_SP_UUID data:sp_uuid];
                }
                
                [self addAdjustSessionCallbackUUIDParams];
            }
            
            if (dic.allKeys.count >0) {
                
                NSString *fileDicPath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_ADJUST_EVEN_PATH];
                
                [dic writeToFile:fileDicPath atomically:YES];
            }
        }
        
    } Failure:^(NSString * _Nonnull failure) {
        
    }];
    
}

-(void)vsdk_initializeAdjustSdk{
    
    ADJConfig * adjustConfig = [ADJConfig configWithAppToken:VSDK_ADJUST_TOKEN environment:ADJEnvironmentProduction];
    NSArray * secretArr = [VSDK_ADJUST_APPSECRET componentsSeparatedByString:@"-"];
    [adjustConfig setAppSecret:[secretArr[0]integerValue] info1:[secretArr[1]integerValue] info2:[secretArr[2]integerValue] info3:[secretArr[3]integerValue] info4:[secretArr[4]integerValue]];
    NSString * realIdfa = [VSDeviceHelper vsdk_realAdjustIdfa];
    
    [Adjust addSessionCallbackParameter:@"sdk_game_id" value:VSDK_GAME_ID];
    [Adjust addSessionCallbackParameter:@"sdk_real_idfa" value:realIdfa];
    [Adjust addSessionCallbackParameter:@"sdk_platform" value:VSDK_PALTFORM];
    [self addAdjustSessionCallbackUUIDParams];
    [adjustConfig setLogLevel:ADJLogLevelVerbose];
    [Adjust appDidLaunch:adjustConfig];
}


-(void)vsdk_calitionDataCleanedOrNot{
    
    if ([VS_USERDEFAULTS valueForKey:VSDK_CALITION_UNIQUE_ID]) {
        
        [[VSDKAPI shareAPI] vsdk_citationCleanLocalCacheSuccess:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                if ([[VS_USERDEFAULTS valueForKey:VSDK_CALITION_MD5_SIGN_KEY] isEqualToString:[GETRESPONSEDATA:VSDK_PARAM_SIGN]]){
                    
                    [VS_USERDEFAULTS removeObjectForKey:VSDK_CALITION_UNIQUE_ID];
                }
            }
            
        } Failure:^(NSString *failure) {}];
    }
}


#pragma mark -- adjust 加入新的会话参数
-(void)addAdjustSessionCallbackUUIDParams{
    
    NSString * idfa =  [VSDeviceHelper vsdk_keychainIDFA];
    
    if([idfa length] > 0){
        
        [Adjust addSessionCallbackParameter:@"sdk_unique" value:idfa];

    }
    
}


+(void)vsdk_asyncRequestSdkConfigData{
    
    dispatch_group_t groud = dispatch_group_create();
    
    dispatch_queue_t asyncQueue = dispatch_queue_create("vsdkAsyncQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_initlizationBreakPoint];
    });
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_storedAdjustEventToken];
    });
    
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_usablePlatformtype];
    });
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_closeServerNotice];
    });
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_normalBullteinData];
    });
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_tempBullteinData];
    });
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_cdnReportStatus];
    });
    
    dispatch_group_async(groud, asyncQueue, ^{
        
        [self vsdk_graphicButteinData];
    });

    dispatch_group_notify(groud, dispatch_get_main_queue(), ^{
        
        
    });
    
}


+(void)vsdk_closeServerNotice{
    
    [[VSDKAPI shareAPI] vsdk_loginAndPurchaseStateWithSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = (NSDictionary *)[responseObject objectForKey:@"data"];
            NSString * filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_CLOSE_SERVER_INFO_PATH];

            [dic writeToFile:filePath atomically:YES];

        }
        
    } Failure:^(NSString *failure) {
        
    }];
    
}

+(void)vsdk_initlizationBreakPoint{
    
    if (![VS_USERDEFAULTS valueForKey:VSDK_INITIALIZE_KEY]){
        
        [[VSDKAPI shareAPI]  vsdk_initVsdSuccess:^(id responseObject) {
            
            if (REQUESTSUCCESS){
                
                VS_USERDEFAULTS_SETVALUE(@"YES",VSDK_INITIALIZE_KEY);
            }
            
        } Failure:^(NSString *errorDes) {}];
    }
}


+(void)vsdk_activedBreakPoint{
    
    if (![VS_USERDEFAULTS valueForKey:VSDK_ACTIVE_KEY]) {
        
        VS_USERDEFAULTS_SETVALUE([NSDate date],VSDK_ACTIVE_DATE_KEY);
        
        [[VSDKAPI shareAPI] vsdk_activedVsdkSuccess:^(id responseObject) {
            
            if (REQUESTSUCCESS){
                
                VS_USERDEFAULTS_SETVALUE(@"YES" ,VSDK_ACTIVE_KEY);
                
            }
            
        } Failure:^(NSString *errorDes) {}];
    }
}

+(void)vsdk_storedAdjustEventToken{
    
    [[VSDKAPI shareAPI]  vsdk_storedAdjustEventTokenSuccess:^(id responseObject) {
    
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            if (dic.allKeys.count >0) {
                
                NSString *fileDicPath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_ADJUST_EVEN_PATH];
                
               [dic writeToFile:fileDicPath atomically:YES];
    
            }
        }
        
    } Failure:^(NSString *failure) {
        
    }];
    
}

+(void)vsdk_usablePlatformtype{
    
    [[VSDKAPI shareAPI]  avliablePingtaiSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = [responseObject objectForKey:@"data"];
            
            if (dic.allKeys.count > 0) {
                
                NSString *filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_USABLE_PALTFORM_PATH];
                
               [dic writeToFile:filePath atomically:YES];
             
            }
        }else if([[responseObject objectForKey:@"state"]  isEqual: @0]){
            
            NSString * filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_USABLE_PALTFORM_PATH];
            
            if (filePath) {
                
                NSDictionary * dic = VSDK_DIC_WITH_PATH(VSDK_USABLE_PALTFORM_PATH);
                
                if (dic) {
                    
                    NSFileManager *fileManger = [NSFileManager defaultManager];
                    [fileManger removeItemAtPath:filePath error:nil];
                    
                }
            }
        }
        
    } Failure:^(id responseObject) {}];
    
}

+(void)vsdk_saveUcGiftState{
    
    [[VSDKAPI shareAPI]  ucGetGiftStateSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_mail_gift_state"], VSDK_EMAIL_GIFT_STATE);
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_phone_gift_state"], VSDK_PHONE_GIFT_STATE);
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_uid_gift_state"], VSDK_UID_GIFT_STATE);
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


-(void)vask_loadAssistantRemoteData{
    
    [[VSDKAPI shareAPI]  requestAssistantReomteDataSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = (NSDictionary *)[responseObject objectForKey:@"data"];
            
            if (dic.count > 0) {
#if Helper
                [IntergralModel sharModel].point_state = [dic[@"point_state"] boolValue];
#endif
                
                
            }
            
            NSString * filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_ASSISTANT_CONFIG_PATH];
            
            BOOL ifWriteSuccess = [dic writeToFile:filePath atomically:YES];
            
            if (ifWriteSuccess) {
                
                self.completeBlock(YES);
            }
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


+(void)vsdk_normalBullteinData{
    
    [[VSDKAPI shareAPI] vsdk_normalBullteinDataSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = (NSDictionary *)[responseObject objectForKey:@"data"];
            NSString * filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_NORMAL_BULLETIIN_PATH];
            
            [dic writeToFile:filePath atomically:YES];
  
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


+(void)vsdk_tempBullteinData{
    
    [[VSDKAPI shareAPI] vsdk_tempBullteinDataSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = (NSDictionary *)[responseObject objectForKey:@"data"];
            NSString * filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_TEMP_BULLETIIN_PATH];
            
            BOOL ifWriteSuccess = [dic writeToFile:filePath atomically:YES];
       
            if (ifWriteSuccess) {

                if ([VSDK_LOCAL_DATA(VSDK_TEMP_BULLETIIN_PATH, @"bulletin_url") length] > 0 || [VSDK_LOCAL_DATA(VSDK_TEMP_BULLETIIN_PATH, @"bulletin_desc") length]) {
                    
                    VSTempBulltein * tempView = [[VSTempBulltein alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, SCREE_WIDTH - 60, SCREE_HEIGHT /2): CGRectMake(0, 0, SCREE_WIDTH *2/3, SCREE_HEIGHT - 60)];
                    tempView.center = VS_RootVC.view.center;
                    [VS_RootVC.view addSubview:tempView];
                    
                }
            }
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


+(void)vsdk_cdnReportStatus{
    
    [[VSDKAPI shareAPI] vsdk_cdnReportInitWithSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            if ([[GETRESPONSEDATA:@"cdn_resources_slow_request"] integerValue] >= 1 ) {
                
                VS_USERDEFAULTS_SETVALUE(@YES,VSDK_CDN_SLOW_KEY);
            }
            
            if ([[GETRESPONSEDATA:@"cdn_resources_request"] integerValue] >= 1 ) {
                
                VS_USERDEFAULTS_SETVALUE(@YES,VSDK_CDN_ERROR_KEY);
            }
            
            if ([[GETRESPONSEDATA:@"subs_term_url"] length] > 0 ) {
                
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"subs_term_url"],@"vsdk_subs_term_url");
            }
            
            if ([[GETRESPONSEDATA:@"user_term_url"] length] > 0 ) {
                
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"user_term_url"],@"vsdk_user_term_link");
            }
            
            if ([[GETRESPONSEDATA:@"country_area_code_state"]  isEqual: @1]) {
                
                NSArray * codeArea = @[@{@"data":[GETRESPONSEDATA:@"country_area_codes"]}];
                
                [codeArea writeToFile:[NSString stringWithFormat:@"%@/countryAreaCodes.plist",[VSSandBoxHelper countryAreaCodePath]] atomically:YES];
                
            }else if ([[GETRESPONSEDATA:@"country_area_code_state"] isEqual: @2]){
                
                
            }else if([[GETRESPONSEDATA:@"country_area_code_state"] isEqual: @0]){
                
                if ([VSDeviceHelper getCountryAreaCodes].count >0) {
                    
                    NSFileManager * fileM = [NSFileManager defaultManager];
                    
                    [fileM removeItemAtPath:VS_COUNTRY_AREA_CODES_PATH(@"countryAreaCodes.plist") error:nil];
                }
            }
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


+(void)vsdk_graphicButteinData{
    
    [[VSDKAPI shareAPI]vsdk_activityPageDataSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = (NSDictionary *)[responseObject objectForKey:@"data"];
            
            NSString * fileDicPath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_GRAPHIC_BULLTEIN_PATH];
            
            [dic writeToFile:fileDicPath atomically:YES];
       
            NSArray * imageList  = [dic objectForKey:@"list"];
            
            for ( int i = 0 ; i < imageList.count; i++) {
                
                NSURL * url = [NSURL URLWithString:[imageList[i] objectForKey:@"img"]];
                //预缓存网络图片
                [[SDWebImagePrefetcher sharedImagePrefetcher]prefetchURLs:@[url]];
                
                }
            }
        
    } Failure:^(NSString *errorMsg) {
        
    }];
    
}


+(void)vsdk_cacheTrunLoveChallengeData{
    
    [[VSDKAPI shareAPI] vsdk_trueLoveChallengeDataWithServerId:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID) RoleId:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID) Success:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            NSDictionary * dic = (NSDictionary *)[responseObject objectForKey:@"data"];
            
            NSString *fileDicPath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_BIG_CHALLENGE_PATH];
            
            BOOL ifWriteSuccess = [dic writeToFile:fileDicPath atomically:YES];
            
            if (ifWriteSuccess) {
                
                VS_USERDEFAULTS_SETVALUE([NSDate date], @"vsdk_bc_info_fresh_date");
                
            }
            
        }else{
            
            NSString * filePath = [VSDeviceHelper getfilePathInDirectoryWithCompontment:VSDK_BIG_CHALLENGE_PATH];
            
            if (filePath) {
                NSFileManager *fileManger = [NSFileManager defaultManager];
               [fileManger removeItemAtPath:filePath error:nil];
            }
            
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


+(void)vsdk_redPacketAlertRequestState{

    [[VSDKAPI shareAPI] vsdk_getRedpacketAlertStateSuccess:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"state"]  isEqual: @2]) {
            
            VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_red_packet_request_state");
            
        }else{
            
            VS_USERDEFAULTS_SETVALUE(@NO, @"vsdk_red_packet_request_state");
        }
        
    } Failure:^(NSString *errorMsg) {
        
    }];
    
}

+(void)vsdk_redPacketAlertState{

    
    if ([VS_USERDEFAULTS_GETVALUE(@"vsdk_red_packet_state") isEqual:@1]) return;
    
    [[VSDKAPI shareAPI] vsdk_getRedpacketAlertStateSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_red_packet_state");
            
        }else{
            
            VS_USERDEFAULTS_SETVALUE(@NO, @"vsdk_red_packet_state");
        }
        
    } Failure:^(NSString *errorMsg) {
        
    }];
    
}

@end
