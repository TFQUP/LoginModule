//
//  VSUserHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
@class VSUser;
NS_ASSUME_NONNULL_BEGIN

@interface VSUserHelper : NSObject
/**
 *  是否有用户存在
 */
+ (BOOL)isUserExists;

/**
 *  获取当前用户信息
 */
+ (VSUser *)executeGetCurrentUserInfo;

/**
 *  保存用户信息
 */
+ (void)executeSaveUserInfo:(VSUser *)user;

/**
 *  将用户信息data转换成UserObject对象
 */
+ (VSUser *)executeUserInfoTransform:(NSData *)data;

/**
 *  删除用户
 */
+ (void)executeDeleteUser:(NSString *)account;

///**
// *  替换非平台帐号
// */
//+ (void)executeReplaceNonPlatformAccount:(VSUser *)user;
//

+ (NSArray *)executeLoadUserList;
@end

NS_ASSUME_NONNULL_END
