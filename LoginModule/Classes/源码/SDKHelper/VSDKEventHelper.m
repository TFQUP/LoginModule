
//
//  VSDKEventHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSDKEventHelper.h"
#import "VSSDKDefine.h"
@implementation VSDKEventHelper

-(void)vsdk_platformBehaviorRecordWith:(NSString *)uid{
    
    if (![VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_fiveDaysLoginCount_%@",uid]]) {
        
        [VS_USERDEFAULTS setValue:@"1" forKey:[NSString stringWithFormat:@"vsdk_fiveDaysLoginCount_%@",uid]];
        
    }else{
        
        int loginCount = [[VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_fiveDaysLoginCount_%@",uid]]intValue];
        loginCount += 1;
        [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%ld",(long)loginCount] forKey:[NSString stringWithFormat:@"vsdk_fiveDaysLoginCount_%@",uid]];
    }
    
    [self RegisterGameAccount];
    [self LoginTwiceWithin5DaysFromActivation:[VS_USERDEFAULTS valueForKey:VSDK_ACTIVE_DATE_KEY] LoginDate:[NSDate date] UserId:uid];
    [self LoginAfter7DaysFromActivation:[VS_USERDEFAULTS valueForKey:VSDK_ACTIVE_DATE_KEY] LoginDate:[NSDate date]];
    [self FiveLoginsInDayWithUserid:uid];
    
    [[VSDKAPI shareAPI]  vsdk_upLoadApnsDeviceTokenWithToken:VS_USERDEFAULTS_GETVALUE(VSDK_APNS_TOKEN_KEY)];
    
}

+(void)vsdk_onlineOver90MinutesInDayWithStartDate:(NSDate *)date1 andEndDate:(NSDate *)date2 UserId:(NSString *)userid{
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    
    if ((cmps.hour * 60 + cmps.minute) * 60 + cmps.second > 5400) {
        
        [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_OnlineOver90MinutesInDay];
        
    }else{
        
        NSDateFormatter * formater = [[NSDateFormatter alloc]init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate *currentDate = [NSDate date];
        NSString *currentDateString = [formater stringFromDate:currentDate];
        
        if(![VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_online_time_%@_%@",userid,currentDateString]]) {
            
            [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%ld",(long)(cmps.hour * 60 + cmps.minute) * 60 + cmps.second] forKey:[NSString stringWithFormat:@"vsdk_online_time_%@_%@",userid,currentDateString]];
            
        }else{
            
            int onlineTimeAmount = [[VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_online_time_%@_%@",userid,currentDateString]]intValue];
            onlineTimeAmount += (cmps.hour * 60 + cmps.minute) * 60 + cmps.second;
            
            if (onlineTimeAmount >=  5400) {
                
                [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_OnlineOver90MinutesInDay];
                
            }else{
                
                [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%d",onlineTimeAmount] forKey:[NSString stringWithFormat:@"vsdk_online_time_%@_%@",userid,currentDateString]];
            }
        }
    }
    
}


-(void)RegisterGameAccount{
    
    [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_RegisterGameAccount];
}

-(void)LoginTwiceWithin5DaysFromActivation:(NSDate *)activeDate LoginDate:(NSDate *)loginDate UserId:(NSString *)userid{
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:activeDate toDate:loginDate options:0];
    
    if (((cmps.day * 24 * 60) + cmps.hour * 60 + cmps.minute) * 60 <= 432000) {
        
        if ([[VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_fiveDaysLoginCount_%@",userid]]intValue] >= 2) {
            
            [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_LoginTwiceWithin5DaysFromActivation];
        }
    }
}


-(void)LoginAfter7DaysFromActivation:(NSDate *)activeDate LoginDate:(NSDate *)loginDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:activeDate toDate:loginDate options:0];
    if (((cmps.day * 24 * 60) + cmps.hour * 60 + cmps.minute) * 60 >= 604800) {
        
        [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_LoginAfter7DaysFromActivation];
    }
}


-(void)FiveLoginsInDayWithUserid:(NSString *)userId{
    
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formater stringFromDate:currentDate];
    
    if (![VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_fivelogin_indays_%@",userId]]) {
        
        [VS_USERDEFAULTS setValue:currentDateString forKey:[NSString stringWithFormat:@"vsdk_fivelogin_indays_%@",userId]];
        [VS_USERDEFAULTS setValue:@"1" forKey:[NSString stringWithFormat:@"vsdk_onedaylogincount_%@",userId]];
        
    }else{
        
        if ([currentDateString isEqualToString:[VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_fivelogin_indays_%@",userId]]]) {
            
            int  oneDayLoginCount = [[VS_USERDEFAULTS valueForKey:[NSString stringWithFormat:@"vsdk_onedaylogincount_%@",userId]]intValue];
            
            if (oneDayLoginCount >= 5) {
                
                [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_FiveLoginsInDay];
                
            }else{
                
                oneDayLoginCount += 1;
                [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%d",oneDayLoginCount] forKey:[NSString stringWithFormat:@"vsdk_onedaylogincount_%@",userId]];
            }
            
        }else{
            
            [VS_USERDEFAULTS setValue:currentDateString forKey:[NSString stringWithFormat:@"vsdk_fivelogin_indays_%@",userId]];
            [VS_USERDEFAULTS setValue:@"1" forKey:[NSString stringWithFormat:@"vsdk_onedaylogincount_%@",userId]];
        }
    }
}



@end
