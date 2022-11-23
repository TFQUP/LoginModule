//
//  VSDKTPInitHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VSDKTPInitHelper : NSObject


+(VSDKTPInitHelper *)shareHelper;

/// 初始化三方平台
/// @param application application
/// @param options options
-(void)vsdk_initializeDependencyWithApplication:(UIApplication *)application Options:(NSDictionary *)options WithCompletionHandler:(void(^)(BOOL initlized)) completionHandler;


/// 异步获取SDK启动相关模块配置
+(void)vsdk_asyncRequestSdkConfigData;

/// SDK激活埋点
+(void)vsdk_activedBreakPoint;


/// 存储用户中心礼品码状态
+(void)vsdk_saveUcGiftState;


/// 保存真爱大挑战数据
+(void)vsdk_cacheTrunLoveChallengeData;


+(void)vsdk_graphicButteinData;

/// 获取红包接口是否请求状态
+(void)vsdk_redPacketAlertRequestState;


/// 获取红包奖励是否可领取状态 
+(void)vsdk_redPacketAlertState;

@end

NS_ASSUME_NONNULL_END
