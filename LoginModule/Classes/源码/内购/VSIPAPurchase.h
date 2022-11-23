//
//  VSIPAPurchase.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 block

 @param isSuccess 是否支付成功
 @param certificate 支付成功得到的凭证（用于在自己服务器验证）
 @param errorMsg 错误信息
 */
typedef void(^purchaseResult)(BOOL isSuccess,NSString *certificate,NSString * errorMsg);

typedef void (^queryCallBack)(NSArray *);

@interface VSIPAPurchase : NSObject
@property (nonatomic, copy)purchaseResult iapResultBlock;

//内购注册相关
@property (nonatomic,copy)NSString * vsdk_order;//callback 返回的订单号
@property (nonatomic,copy)NSString * vsdk_orderSn ;//平台订单号
@property (nonatomic,copy)NSString * vsdk_userId;//游戏用户ID
@property (nonatomic,copy)NSString * vsdk_money;//充值金额
@property (nonatomic,copy)NSString * vsdk_moneyType;//货币类型
@property (nonatomic,copy)NSString * vsdk_Extend;//平台扩展参数
@property (nonatomic,copy)NSString * vsdk_Ftype;//支付类型
@property (nonatomic,copy)NSString * vsdk_serverId;//服务器ID
@property (nonatomic,copy)NSString * vsdk_serverName;//服务器名
@property (nonatomic,copy)NSString * vsdk_roleId;//角色ID
@property (nonatomic,copy)NSString * vsdk_roleName;//角色名
@property (nonatomic,copy)NSString * vsdk_roleLevel;//角色等级
@property (nonatomic,copy)NSString * vsdk_goodsId;//cp商品ID
@property (nonatomic,copy)NSString * vsdk_goodsName;//cp商品名称
@property (nonatomic,copy)NSString * third_goods_id;//我们苹果商品ID
@property (nonatomic,copy)NSString * third_goods_name;//苹果商品名称
@property (nonatomic,copy)NSString * cp_trade_sn;//cp订单号
@property (nonatomic,copy)NSString * vsdk_extData;//cp扩展参数
@property (nonatomic,copy)NSString * app_channel;//付费所属渠道
@property (nonatomic,copy)NSString * channel_trade_sn;//channel_trade_sn
@property(nonatomic,copy)NSString * vsdk_amountType; //货币类型
@property(nonatomic,copy)NSString * platformAmount; //货币金额
@property(nonatomic,assign)BOOL isSubProduct;//是否订阅类型商品;

//平台下单相关参数
@property (nonatomic,copy)NSString *extend;
@property (nonatomic,copy)NSString *fftype;
@property (nonatomic,copy)NSString *serverId;
@property (nonatomic,copy)NSString *serverName;
@property (nonatomic,copy)NSString *roleId;
@property (nonatomic,copy)NSString *rolename;
@property (nonatomic,copy)NSString *roleLevel;
@property (nonatomic,copy)NSString *goodId;
@property (nonatomic,copy)NSString *goodName;
@property (nonatomic,copy)NSString *tradeSn;
@property (nonatomic,copy)NSString *extData;
@property (nonatomic,copy)NSString *productId;
@property (nonatomic,copy)NSString *productName;
@property (nonatomic,assign)BOOL subProduct;


//查询标记
@property(nonatomic,assign) BOOL chekTag;
//本地化查询回调
@property (nonatomic,copy) queryCallBack qCllback;


/// 工具单例实例化方法
+ (instancetype)manager;

/// 开启内购观察者
-(void)vsdk_startIapManager;


/// 停止内购观察者
-(void)vsdk_stopIapManager;

/**
 内购支付
 @param productID 内购商品ID
 @param iapResult 结果
 */
-(void)vsdk_purchaseWithProductID:(NSString *)productID iapResult:(purchaseResult)iapResult;


/// 内购id查询接口
/// @param productIDArr 要查询的内购id数组
-(void)requestProductLocalInfo:(NSArray *)productIDArr;

@end

NS_ASSUME_NONNULL_END
