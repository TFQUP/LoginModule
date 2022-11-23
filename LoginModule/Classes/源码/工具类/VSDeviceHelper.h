//
//  VSDeviceHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>
NS_ASSUME_NONNULL_BEGIN

@interface VSDeviceHelper : NSObject


/// 获取系统语言
+(NSString *)vsdk_systemLanguage;


/// 获取存储在keyChain的自生成idfa
+(NSString *)vsdk_keychainIDFA;


/// 获取自生成的openId
+(NSString *)vsdk_keychainOpenId;


/**
 正则匹配
 
 @param string 需匹配的字符串
 @param pattern 匹配规则
 @return 匹配结果 成功返回YES 失败返回NO
 */
+ (BOOL)RegexWithString:(NSString *)string pattern:(NSString *)pattern;

/**
 设备型号
 
 @return 设备型号
 */
+ (NSString *)vsdk_DeviceModel;


/**
 *  获取当前日期 yyyy-MM-dd
 */
+ (NSString *)vsdk_currentDate;

/**
 计算字体宽度和高度

 @param str 文本
 @param fontsize 字体代销
 @return 返回宽高度
 */
+(CGFloat)sizeWithFontStr:(NSString *)str WithFontSize:(CGFloat)fontsize;

/**
 根据宽度求高度
 @param text 计算的内容
 @param width 计算的宽度
 @param font font字体大小
 @return 放回label的高度
 */
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;

/**
 检测邮箱密码规则

 @param acount 账号
 @return 返回判定结果
 */
+ (BOOL)checkInputAccount:(NSString *)acount;

/**
 获取屏幕比例拓展

 @return 返回比例
 */
+(CGFloat)getExpansionFactorWithphoneOrPad;

/**
 获取沙盒路径目录

 @param compontmentName 目录名
 @return 目录path
 */
+(NSDictionary *)getSanboxFilePathWithCompontment:(NSString *)compontmentName;

/**
 获取沙盒路径目录

 @param compontmentName 目录名
 @return 目录描述
 */
+(NSString *)getfilePathInDirectoryWithCompontment:(NSString *)compontmentName;


/// 游客自动登录页面tableView高度动态计算
+(CGFloat)autoLoginPaltFormTypeTableHeight;


/// 根据链接打来safari浏览器
/// @param url url
+(void)showTermOrContactCustomerServiceWithUrl:(NSString *)url;

//日志相关
+(NSString *)vsdk_iapFailureOrderInfo;

+(NSString *)vsdk_iapSuccessOrderInfo;

+(NSString *)vsdk_subSuccessOrderInfo;

+(NSString *)vsdk_crashLog;


#pragma mark -- 添加view动画

+(void)addAnimationInView:(UIView *)view Duration:(CGFloat)duration;


+(NSUInteger)vsdk_supportablePlatform;


+(NSString *)vsdk_realAdjustIdfa;


+ (BOOL)isPureInt:(NSString *)string;


+(void)addKeyframeAnimationWith:(UIButton *)button withDuration:(CGFloat)duration;


+(void)showSystemTipsAlertWithTitle:(NSString *)title message:(NSString *)message comfirmTitle:(NSString *)comfirmStr;


+(void)vsdk_firebaseEventWithEventName:(NSString *)eventName;


/// 计算文字高度
/// @param str 字符串
/// @param width 宽度
/// @param lineSpacing 空格
/// @param font 字体
+(CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                      withFont:(CGFloat)font;



/// 解析并获取域名对应的ip地址
/// @param hostName 域名
+(NSString *)analyzeIpAddressWithHostName:(NSString *)hostName;



/// 获取功能请求连接
/// @param param 参数数组
+(NSString *)getBasicRequestWithParams:(NSDictionary *)param;



+(NSMutableDictionary *)plarformAvailable;


/// 获取国家码
+(NSMutableArray *)getCountryAreaCodes;

//获取本地bunlde 资源文件
+ (NSArray *)readLocalFileWithName:(NSString *)name;


/// 获取预先存储的本地社交数据
+(NSDictionary *)preSaveSocialData;

//对字典数据进行md5加密
+(NSString *)MD5SignWithDic:(NSDictionary *)dic;


/// 获取系统时间戳
+(NSString *)getSystemTime;


+(NSInteger)getDifferenceByDate:(NSString *)date;


/// 获取网络类型
+(NSString *)networkState;

/// 根据等级判断小助手是否显示
/// @param rolelevel 角色等级
+(BOOL)vsdk_floatballtShowWithRolevel:(NSString *)rolelevel;


+(NSString *)vsdk_customServiceUrl;


/// 存储引继码账号截图到相册
+(void)vsdk_saveCalitionCode;


/// 组装接口请求参数
+(NSDictionary *)combineRequestParams;


/// 解析富文本
/// @param str 富文本html字符串
+ (NSAttributedString *)vsdk_attrHtmlStringFrom:(NSString *)str;


#pragma mark -- 发送post请求
+(void)POST:(NSString *)URLString parameters:(NSMutableDictionary *)parameters;


+(void)vsdk_closeLoginNoticeUI;


@end

NS_ASSUME_NONNULL_END
