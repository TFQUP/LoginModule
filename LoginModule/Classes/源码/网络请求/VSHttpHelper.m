//
//  VSHttpHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSHttpHelper.h"
#import "VSSDKDefine.h"

#define kTimeOutInterval 15.0 // 请求超时的时间

NSString *const kVsdkReachabilityChangedNotification = @"kVsdkReachabilityChangedNotification";

static VSHttpHelper *_helper;
static AFHTTPSessionManager *_AFNManager;

@implementation VSHttpHelper

+ (AFHTTPSessionManager *)HTTPManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        _AFNManager = [AFHTTPSessionManager manager];
        _AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        // 设置超时时间
        [_AFNManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _AFNManager.requestSerializer.timeoutInterval = kTimeOutInterval;
        [_AFNManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    });
    
    return _AFNManager;
}

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [self HTTPManager];
    
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [self HTTPManager];
        
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)POST:(NSString *)URLString HTTPBody:(id)body success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self HTTPManager];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= kTimeOutInterval;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:body];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if (success) {
                success(responseObject);
            }
            
        } else {
    
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];

 
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
