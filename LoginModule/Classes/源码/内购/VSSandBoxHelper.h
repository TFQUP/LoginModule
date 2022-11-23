//
//  VSSandBoxHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSandBoxHelper : NSObject

+ (NSString *)homePath;// 程序主目录，可见子目录(3个):Documents、Library、tmp

+ (NSString *)appPath;// 程序目录，不能存任何东西

+ (NSString *)docPath;// 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据

+ (NSString *)libPrefPath;// 配置目录，配置文件存这里

+ (NSString *)libCachePath;// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除

+ (NSString *)tmpPath;// 临时缓存目录，APP退出后，系统可能会删除这里的内容

+ (NSString *)iapReceiptPath;//用于存储iap内购返回的购买凭证

+ (NSString *)subReceiptPath;//用于存储订阅返回的购买凭证

+ (NSString *)SuccessIapPath;//存储成功订单的方法

+ (NSString *)SuccessSubPath;//存储订阅成功订单的方法

+ (NSString *)rectiptSignPath;//凭证MD5Sign

+ (NSString *)crashLogInfo;//存储崩溃日志的方法;

+ (NSString *)tempOrderPath;//保存临时订单

+ (NSString *)SubscriptionFlagPath;//保存订阅订单标识

+ (NSString *)promoPaymentPath;//保存促销订单

+ (NSString *)socialInfoPath;//社交数据存储路径

+ (NSString *)countryAreaCodePath;//国家码存储路径

+ (NSString *)DPBagInfoPath;//直购礼包数据路径

@end

NS_ASSUME_NONNULL_END
