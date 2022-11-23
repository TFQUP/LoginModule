//
//  VSTool.m
//  VVSDK
//
//  Created by admin on 6/23/22.
//

#import "VSTool.h"

@implementation VSTool
+(BOOL) isBlankString:(NSString *)string {

   if (string == nil || string == NULL) {

   return YES;

   }

   if ([string isKindOfClass:[NSNull class]]) {

   return YES;

   }

   if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {

   return YES;

   }

   return NO;

}

//判断当前日期是否是同一天
+ (BOOL)nowisToday:(NSString *)string{

    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    return isToday;
}

+(BOOL)isKorean{
    NSArray *languages = [NSLocale preferredLanguages];
    if (languages.count>0) {
       NSString *currentLocaleLanguageCode = languages.firstObject;
        if ([currentLocaleLanguageCode hasPrefix:@"ko"]) {
            return YES;
        }
    }
    return NO;
}
@end
