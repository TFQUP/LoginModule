//
//  VSDKEventHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSDKEventHelper : NSObject


/// 统计在线时长接口
/// @param date1 应用启动时间
/// @param date2 退出应用时间
/// @param userid uid
+(void)vsdk_onlineOver90MinutesInDayWithStartDate:(NSDate *)date1
                                       andEndDate:(NSDate *)date2 UserId:(NSString *)userid;


/// 平台定义时间记录&时间上报接口
/// @param uid uid
-(void)vsdk_platformBehaviorRecordWith:(NSString *)uid;




@end

NS_ASSUME_NONNULL_END
