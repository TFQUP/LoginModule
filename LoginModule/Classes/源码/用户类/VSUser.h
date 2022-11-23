//
//  VSUser.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSUser : NSObject
@property (nonatomic,copy)NSString * account;// 用户账号
@property (nonatomic,copy)NSString * accountId;// 用户账号
@property (nonatomic,copy)NSString * password; // 用户密码
@property (nonatomic,copy)NSString * nickName;// 账号类型
@property (nonatomic,copy)NSString * token;//token
@property (nonatomic,copy)NSString * dateStr ;//入库时间

+ (id)userWithAccount:(NSString *)account passWord:(NSString *)password Date:(NSString *)date nickName:(NSString *)nickName Token:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
