//
//  VSKeychain.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
