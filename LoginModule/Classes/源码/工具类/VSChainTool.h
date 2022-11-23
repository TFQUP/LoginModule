//
//  VSChainTool.h
//  VSChainTool
//
//  Created by admin on 7/2/21.


#import <Foundation/Foundation.h>

@interface VSChainTool : NSObject

+ (void)setObject:(nullable id)value forKey:(nonnull NSString *)key;

+ (void)setBool:(BOOL)value forKey:(nonnull NSString *)key;

+ (nullable id)objectForKey:(nonnull NSString *)key;

+ (BOOL)boolForKey:(nonnull NSString *)key;

+ (void)delegateValueForKey:(nonnull NSString *)key;

+ (nonnull NSString *)getUUID;

@end
