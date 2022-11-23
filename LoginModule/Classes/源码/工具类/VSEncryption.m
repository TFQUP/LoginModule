//
//  VSEncryption.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSEncryption.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
@implementation VSEncryption

+ (NSString *)md5:(NSString *)string {
    
    if(string != nil){
    
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
        
    }else{
        
        return nil;
    }
    
}


+ (NSString *)getMd5_16Bit_String:(NSString *)srcString{
    
    //提取32位MD5散列的中间16位
    NSString *result_16Bit = [[[self md5:srcString] substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result_16Bit;
}


+ (NSString *)SHA1:(NSString *)string {
    
    const char *cStr = [string UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

+ (NSData *)dataEncryption:(NSData *)data Key:(NSString*)key {
    
    char keyPtr[kCCKeySizeAES256 + 1];  // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr));      // fill with zeroes (for padding)
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

+ (NSData *)dataDecryption:(NSData *)data Key:(NSString*)key {
    
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr));     // fill with zeroes (for padding)
    
    // 根据key获取数据
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSData *)stringEncryption:(NSString*)string withKey:(NSString*)key {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self dataEncryption:data Key:[self md5:key]];
}

+ (NSString *)stringDecryption:(NSData*)data withKey:(NSString*)key {
    
    NSData *decryptData = [self dataDecryption:data Key:[self md5:key]];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}


@end
