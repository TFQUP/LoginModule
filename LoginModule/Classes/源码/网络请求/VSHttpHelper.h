//
//  VSHttpHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN
@interface VSHttpHelper : NSObject

/**
 * 网络GET请求方法
 *
 * @prama url 请求路径
 * @prama params 请求参数 字典
 * @prama success 请求成功回调
 * @prama failure 请求失败回调
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 * 网络POST请求方法
 *
 * @prama url 请求路径
 * @prama params 请求参数
 * @prama success 请求成功回调
 * @prama failure 请求失败回调
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 * 网络POST请求方法
 *
 * @prama URLString 请求路径
 * @prama body      请求体
 * @prama success   请求成功回调
 * @prama failure   请求失败回调
 */
+ (void)POST:(NSString *)URLString HTTPBody:(id)body success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
