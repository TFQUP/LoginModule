//
//  VSKeychain.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSKeychain.h"
#import <Security/Security.h>
#import "VSSDKDefine.h"

//MAKE LIUJIA
#define getServiceKey(key) [NSString stringWithFormat:@"vsdk_%@",key]

@implementation VSKeychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword, (id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible, nil];
    
  
}

#pragma mark - 写入
+ (void)save:(NSString *)service data:(id)data{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    
    NSError * error;
    if (VSDK_CURRENT_SYSTEM_VERSION <=12.0) {

    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
        
    }else{
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:&error] forKey:(id)kSecValueData];
    
    }
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
    [[NSUserDefaults standardUserDefaults]setValue:data forKey:getServiceKey(service)];
  
}

#pragma mark - 读取
+ (id)load:(NSString *)service{
    id result = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    NSError * error;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            
            if (VSDK_CURRENT_SYSTEM_VERSION <=12.0) {
              
                  result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
                
            }else{
               
                 result = [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:(__bridge NSData * _Nonnull)(keyData) error:&error];
            }
          
        
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", service, exception);
        } @finally {
            
        }
    }

    if (result == nil) {

        result = [[NSUserDefaults standardUserDefaults]valueForKey:getServiceKey(service)];
    } else {

        [[NSUserDefaults standardUserDefaults]setValue:result forKey:getServiceKey(service)];
    }

    if (keyData) {
        CFRelease(keyData);
    }

    return result;
}

#pragma mark - 删除
+ (void)delete:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:getServiceKey(service)];
}

@end
