//
//  VSUserHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSUserHelper.h"
#import "VSUser.h"
#import "VSSDKDefine.h"

#define Array_Creator(arr)  [NSArray arrayWithArray:arr]
#define MArray_Creator(arr) [NSMutableArray arrayWithArray:arr]
#define NSArchiver(obj)     [NSKeyedArchiver archivedDataWithRootObject:obj]
#define NSUnarchiver(data)  [NSKeyedUnarchiver unarchiveObjectWithData:data]
#define ArithmeticUserInfoKey   @"3" // 加密key
#define UserInfoKey             @"4" // NSUserDefaults key
@implementation VSUserHelper

/**
 *  是否有用户存在
 */
+ (BOOL)isUserExists {
    
    NSArray *userArray = Array_Creator([VS_USERDEFAULTS objectForKey:UserInfoKey]);
    if (userArray.count > 0) {
        return YES;
    }
    return NO;
}

/**
 *  读取当前登录的用户信息
 */
+ (VSUser *)executeGetCurrentUserInfo {
    
    NSArray *userArray = Array_Creator([VS_USERDEFAULTS objectForKey:UserInfoKey]);
    if (userArray.count > 0) {
        // 取出加密的用户信息
        NSData *userData = [userArray objectAtIndex:0];
        // 解密
        NSData *decryData = [VSEncryption dataDecryption:userData Key:ArithmeticUserInfoKey];
        return NSUnarchiver(decryData);
    }
    return nil;
    
}

/**
 *  保存用户信息
 */
+ (void)executeSaveUserInfo:(VSUser *)user {
    
    NSMutableArray *userArray = MArray_Creator([VS_USERDEFAULTS objectForKey:UserInfoKey]);
    
    for (NSUInteger i = 0; i < userArray.count; i++) {
        // 取出加密的用户信息
        NSData *userData = [userArray objectAtIndex:i];
        // 解密 保存的是user信息
        NSData *decryData = [VSEncryption dataDecryption:userData Key:ArithmeticUserInfoKey];
        VSUser *obj = [self executeUserInfoTransform:decryData];
        // 首先把存在相同的用戶移除
        if ([obj.account.lowercaseString hash] == [user.account.lowercaseString hash]) {
            [userArray removeObjectAtIndex:i];
        }
    }
    // 數據持久化
    NSData *encodedObject = NSArchiver(user);
    // 加密
    NSData *encryData = [VSEncryption dataEncryption:encodedObject Key:ArithmeticUserInfoKey];
    // 将用户信息插入数组中
    [userArray insertObject:encryData atIndex:0];
    // 存儲
    [VS_USERDEFAULTS setObject:userArray forKey:UserInfoKey];
    [VS_USERDEFAULTS synchronize];
}

/**
 *  将用户信息data转换成UserObject对象
 */
+ (VSUser *)executeUserInfoTransform:(NSData *)data {
    
    VSUser *userObj = (VSUser *)NSUnarchiver(data);
    return userObj;
}

/**
 *  删除用户
 */
+ (void)executeDeleteUser:(NSString *)account {
    
    NSArray *listArray = [self executeLoadUserList];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (VSUser *obj in listArray) {
        //遍历用户数组 如果用户名和删除的用户名不相同 则添加到数组 重新保存
        if (![obj.account isEqualToString:account]) {
            NSData *data = NSArchiver(obj);
            NSData *encryData = [VSEncryption dataEncryption:data Key:ArithmeticUserInfoKey]; // 加密
            [tempArray addObject:encryData];
        }
    }
    
    [VS_USERDEFAULTS setObject:tempArray forKey:UserInfoKey];
    [VS_USERDEFAULTS synchronize];
}

/**
 *  替换(当前)第三方账号用户
 */
//+ (void)executeReplaceNonPlatformAccount:(VSUser *)user {
//    // 获取当前账号
//    VSUser *userObj = [self executeGetCurrentUserInfo];
//    NSString *account  = userObj.account;
//    
//    NSMutableArray *tempArray = MArray_Creator([VS_USERDEFAULTS objectForKey:UserInfoKey]);
//    // 遍历当前所有账号 找出账号与当前账号相同的账号
//    for (NSUInteger i = 0; i < tempArray.count; i++) {
//        NSData *userData = [tempArray objectAtIndex:i];
//        // 解密
//        NSData *decryData = [VSEncryption dataDecryption:userData Key:ArithmeticUserInfoKey];
//        VSUser *obj =  [self executeUserInfoTransform:decryData];
//        
//        if ([obj.account isEqualToString:account]) {
//            [tempArray removeObjectAtIndex:i];
//        }
//    }
//    
//    NSData *encodedObject = NSArchiver(user);
//    // 加密
//    NSData *encryData = [VSEncryption dataEncryption:encodedObject Key:ArithmeticUserInfoKey];
//    [tempArray insertObject:encryData atIndex:0];
//    
//    [VS_USERDEFAULTS setObject:tempArray forKey:UserInfoKey];
//    [VS_USERDEFAULTS synchronize];
//}

// 读取账号列表(已解密)
+ (NSArray *)executeLoadUserList {
    
    NSArray *userArray = Array_Creator([VS_USERDEFAULTS objectForKey:UserInfoKey]);
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSData *userData in userArray) {
        // 解密
        NSData *decryData = [VSEncryption dataDecryption:userData Key:ArithmeticUserInfoKey];
        VSUser *obj = [self executeUserInfoTransform:decryData];
        
        [tempArray addObject:obj];
    }
    
    NSArray *userListArray = [tempArray copy];
    return userListArray;
}

@end
