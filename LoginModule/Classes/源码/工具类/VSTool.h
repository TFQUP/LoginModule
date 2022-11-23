//
//  VSTool.h
//  VVSDK
//
//  Created by admin on 6/23/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSTool : NSObject
+ (BOOL)isBlankString:(NSString *)string;
+ (BOOL)nowisToday:(NSString *)string;
+(BOOL)isKorean;
@end

NS_ASSUME_NONNULL_END
