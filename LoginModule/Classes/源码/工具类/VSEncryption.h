//
//  VSEncryption.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSEncryption : NSObject
/**
 *  32位MD5加密
 *
 *  @return 32位MD5加密结果
 */
+ (NSString *)md5:(NSString *)string;

/**
 *  16位MD5加密
 *
 *  @return 16位MD5加密结果
 */
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString;

/**
 *  SHA1加密
 *
 *  @return SHA1加密结果
 */
+ (NSString *)SHA1:(NSString *)string;

/**
 对NSData加密
 
 @param data 未加密的data数据
 @param key key
 @return 加密后的data数据
 */
+ (NSData *)dataEncryption:(NSData *)data Key:(NSString*)key;

/**
 对NSData解密
 
 @param data 加密的data数据
 @param key key
 @return 解密后的data数据
 */
+ (NSData *)dataDecryption:(NSData *)data Key:(NSString*)key;

/**
 对NSString加密
 
 @param string 未加密的NSString数据
 @param key key
 @return 加密后的data数据
 */
+ (NSData *)stringEncryption:(NSString*)string withKey:(NSString*)key;

/**
 对NSString解密
 
 @param data 加密后的data数据
 @param key key
 @return 解密后的NSString数据
 */
+ (NSString *)stringDecryption:(NSData*)data withKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
