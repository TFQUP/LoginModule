//
//  VSDKAPI.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VSSDKDefine.h"


@class VSDKAPI;


//登录成功
typedef void(^LoginSuccess)(VSDKAPI *api, id responseObject);
//登录失败
typedef void(^LoginFailure)(VSDKAPI *api, NSString *failure);


@interface VSDKAPI : NSObject

//登录回调成功
@property (nonatomic, copy)LoginSuccess loginsuccess;
@property (nonatomic, copy)LoginFailure loginfailure;

+(VSDKAPI * )shareAPI;

#pragma mark - 账号密码登录
-(void)loginWithEmail:(NSString *)email passWord:(NSString *)password success:(LoginSuccess)success failure:(LoginFailure)failure;


/**
 三方  登录的方法
 @param userType 类型
 @param success 成功
 @param failure 失败
 */

-(void)loginWithUserType:(NSString *)userType token:(NSString *)token success:(LoginSuccess)success failure:(LoginFailure)failure;


/**
 三方绑定接口

 @param userType 类型
 @param token 三方token
 @param gusetToken 三方token
 @param success 成功
 @param failure 失败
 */



-(void)vsdk_bindAccountWithUserType:(NSString *)userType token:(NSString *)token guestToken:(NSString *)gusetToken success:(void(^)(VSDKAPI * api,id responseObject))success
                       failure:(void(^)(VSDKAPI *api,NSString * failure))failure;
#pragma mark - 注册/免注册/Facebook注册

/**
 注册事件

 @param email 邮箱
 @param password 密码
 */
-(void)vsdk_registerWithEmial:(NSString * )email passWord:(NSString *)password success:(void(^)(VSDKAPI * api,id responseObject))success failure:(void(^)(VSDKAPI *api,NSString * failure))failure;

#pragma mark - 找回密码

/**
 找回密码
 @param email 邮箱
 @param success 成功回调
 @param failure 失败回调
 */
-(void)vsdk_retrievePwdWithEmail:(NSString *)email success:(void(^)(VSDKAPI * api,id responseObject))success
                  failure:(void(^)(VSDKAPI *api,NSString * failure))failure;


#pragma mark -  验证邮箱
-(void)vsdk_vertifyMailboxWithToken:(NSString *)token vertifyCode:(NSString *)vertifycode success:(void(^)(VSDKAPI * api,id responseObject))success
                       failure:(void(^)(VSDKAPI *api,NSString * failure))failure;


#pragma mark -- 平台账号注册绑定
-(void)vsdk_registerAndBindWithToken:(NSString *)touristToken Email:(NSString *)email  Password:(NSString *)passWord success:(void(^)(VSDKAPI * api,id responseObject))success failure:(void(^)(VSDKAPI *api,NSString * failure))failure;


#pragma mark -- 初始化 ,安装上报埋点

-(void)vsdk_initVsdSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString *errorDes))failure;

#pragma mark -- 首次拉起登录激活上报埋点

-(void)vsdk_activedVsdkSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString *errorDes))failure;

/**
 获取消耗型商品订单接口

 @param money 金额
 @param moneytype 货币类型
 @param extend 扩展参数
 @param ffType 支付类型
 @param serverId 服务器ID
 @param servername 游戏服务器名
 @param roleId 角色id
 @param rolename 角色名
 @param goodId 货物id
 @param goodName 货物名
 @param tradeSn 交易号
 @param extData 扩展数据
 @param thirdGoodId 内购ID
 @param thirdGoodName 内购名称
 @param subProduct 是否订阅商品
 @param success 成功回调
 @param failure 失败回调
 
 */
#pragma mark -- 获取CP订单号的方法
-(void)vsdk_cpOrderWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype Extend:(NSString *)extend FFType:(NSString *)ffType ServerId:(NSString *)serverId ServerName:(NSString *)servername RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ThirdGoodId:(NSString *)thirdGoodId ThirdGoodName:(NSString *)thirdGoodName ifSub:(BOOL)subProduct success:(void(^)(VSDKAPI *api,id responseObject))success failure:(void(^)(VSDKAPI *api,NSString * failure))failure;



/**
 通过订单号获取后台对应金额的方法
 
 @param order 订单号
 @param success 成功回调
 @param failure 失败回调
 */
-(void)vsdk_platformAmountWithOrder:(NSString *)order success:(void(^)(id responseObject))success failure:(void(^)(NSString *failure))failure;

/**
 发送验证的方法
 @param VerfityStr 验证串
 @param ordersn 交易号
 @param success 成功回调
 @param failure 失败回调
 */

#pragma mark -- 发送验证信息到后台判断是都成功购买的方法
-(void)vsdk_sendVertifyWithReceipt:(NSString *)VerfityStr order:(NSString *)ordersn userId:(NSString *)userid  productId:(NSString *)pid success:(void(^)(VSDKAPI *api,id responseObject))vertifySuccess failure:(void(^)( VSDKAPI *api,NSString * msg))vertifyFailure;


-(void)sendSubscriptionVertifyWithReceipt:(NSString *)VerfityStr order:(NSString *)ordersn userId:(NSString *)userid transcation:(SKPaymentTransaction *)trans success:(void(^)(VSDKAPI *api,id responseObject))vertifySuccess failure:(void(^)( VSDKAPI *api,NSString * msg))vertifyFailure;


/**
 上报崩溃日志api

 @param crashInfo 崩溃信息
 @param success 成功回调
 @param failure 失败回调
 */
-(void)vsdk_reportBugWithCrashInfo:(NSString *)crashInfo success:(void(^)(VSDKAPI *api, id responseObject))success failure:(void(^)(VSDKAPI *api, NSString * failure))failure;



/**
 上报登录错误信息api

 @param errCode 错误码
 @param errMsg 错误描述
 */
-(void)vsdk_sendLoginErrorLogWithErrorCode:(NSString *)errCode errorMsg:(NSString *)errMsg;


/**
 充值错误上报接口

 @param userid 用户id
 @param roleid 角色id
 @param serverId 服务器id
 @param servername 服务器名
 @param rolename 角色名
 @param roleLevel 角色等级
 @param errCode 错误码
 @param errMsg 错误信息
 */
-(void)vsdk_sendPayErrorLogWithUser:(NSString *)userid roleId:(NSString *)roleid ServerId:(NSString *)serverId ServerName:(NSString *)servername RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel ErrorCode:(NSString *)errCode errorMsg:(NSString *)errMsg;



/// 请求adjustEvenToken
/// @param evenSuccess 成功回调
/// @param evenFailure 失败回调
-(void)vsdk_storedAdjustEventTokenSuccess:(void(^)(id responseObject))evenSuccess Failure:(void(^)(NSString * failure))evenFailure;


/// 上传推送设备token
/// @param apnsToken 设备token
-(void)vsdk_upLoadApnsDeviceTokenWithToken:(NSString *)apnsToken;




/// 回传消息通知自定义唯一识别id
/// @param uuid 识别id
-(void)vsdk_reportDeviceToServiceWithEquipment_uuid:(NSString *)uuid;




/// 上报错误的cdn链接url
/// @param datalist 链接数组
-(void)vsdk_reportFialedCdnResourceWithDataList:(NSMutableArray *)datalist;



/// 根据旧的token刷新token
/// @param token 旧token
/// @param success 成功
/// @param failure 失败
-(void)vsdk_refreshTokenWitholdToken:(NSString *)token Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 判断当前角色是否vip
/// @param serviceid 服务器id
/// @param servername 服务器名
/// @param roleid 角色id
/// @param roleName 角色名
/// @param rolelevel 角色等级
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_playerIsVipWithServiceId:(NSString *)serviceid ServerName:(NSString *)servername RoleId:(NSString *)roleid RoleName:(NSString *)roleName RoleLevel:(NSString *)rolelevel vipSuccess:(void(^)(id responseObject))success vipFailure:(void(^)(NSString * failureMsg))failure;




/// 类型打点
/// @param type 类型
/// @param state 定义的事件类型
-(void)vsdk_beatPointWithType:(NSString *)type state:(NSString *)state;



-(void)avliablePingtaiSuccess:(void(^)(id responseObject))openSuccess Failure:(void(^)(NSString * failure))openFailure;




/// 更新密码
/// @param newPwd 新密码
/// @param tokenStr 登录token
/// @param success 成功回调
/// @param failure 失败回调
- (void)updateNewPwd:(NSString *)newPwd tokenStr:(NSString *)tokenStr
                success:(void(^)(id responseObject))success
             failure:(void(^)(NSString * failure))failure;


/// 用户中心绑定手机号码
/// @param code 验证码
/// @param phoneNum 手机号码
/// @param success 成功回调
/// @param failure 失败回调
-(void)ucComfirmBindPhoneNumWithCode:(NSString * )code PhoneFormatNum:(NSString *)phoneNum Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 发送安全邮箱验证码
/// @param token 登录token
/// @param bindEmail 绑定的安全邮箱
/// @param success 成功回调
/// @param failure 失败回调
-(void)postSecurityCodeWithToken:(NSString *)token BindMail:(NSString *)bindEmail success:(void(^)(id responseObject))success failure:(void(^)(NSString * failure))failure;


/// 获取绑定安全邮箱的验证码
/// @param phoneNum 手机号码
/// @param success 成功回调
/// @param failure 失败回调
-(void)ucGetVertifyCodeWithPhoneNum:(NSString *)phoneNum Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 绑定安全邮箱
/// @param token 登录token
/// @param bindEmail 安全邮箱
/// @param code 验证码
/// @param success 成功回调
/// @param failure 失败回调
-(void)ucBindSecurityEmainWithToken:(NSString *)token BindMail:(NSString *)bindEmail VertifyCode:(NSString *)code success:(void(^)(id responseObject))success failure:(void(^)(NSString * failure))failure;



/// 获取相关绑定方式的礼品码状态
/// @param success 成功回调
/// @param failure 失败回调
-(void)ucGetGiftStateSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 上报用户中心领取礼品时间
/// @param eventType 事件类型
/// @param success 成功回调
/// @param failure 失败回调
-(void)ucReportReceiveBindGiftWithEvent:(NSString *)eventType Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;


/// 社交模块请求社交数据
/// @param success 成功回调
/// @param failure 失败回调
-(void)ssRequestSocialDataSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 社交分享点赞奖励兑换就饿口
/// @param type 类型
/// @param eventId 事件id
/// @param eventCert 事件凭证
/// @param success 成功回调
/// @param failure 失败回调
-(void)ssLikeRewardWithEventType:(NSString *)type EventId:(NSString *)eventId EventCert:(NSString *)eventCert Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 社交事件行为上报接口
/// @param event 事件
/// @param type 类型
-(void)ssSocialEventReportWithEvent:(NSString *)event Type:(NSString *)type;



/// 社交邀请页绑定邀请着邀请码
/// @param code 邀请码
/// @param success 成功回调
/// @param failure 失败回调
-(void)ssBindInviteCodeWithInviteCode:(NSString *)code Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 获取小助手模块数据
/// @param success 成功回调
/// @param failure 失败回调
-(void)requestAssistantReomteDataSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 获取普通游戏公告
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_normalBullteinDataSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 获取临时游戏公告数据
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_tempBullteinDataSuccess:(void (^)(id))success Failure:(void (^)(NSString *))failure;



/// 获取cdn上报开启状态
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_cdnReportInitWithSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 引继码游客登录接口
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_calitionLoginSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



///  引继码账号密码登录
/// @param username 账号
/// @param password 密码
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_calitionLoginWithAccount:(NSString *)username Password:(NSString *)password Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 通过token和密码生成引继码账号
/// @param token 登录token
/// @param pwd 密码
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_getCalitionAccountWithToken:(NSString *)token Password:(NSString *)pwd Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 导入三方已引继账号
/// @param type 类型
/// @param token 登录token
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_calitionImportWithType:(NSString *)type Token:(NSString *)token Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 获取三方平台关联状态
/// @param token 登录token
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_platformConnectStateWithToken:(NSString *)token Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 引继关联三方平台账号
/// @param type 类型
/// @param token token
/// @param guestToken 游客token
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_connectPlatformWithType:(NSString *)type Token:(NSString *)token GuestToken:(NSString *)guestToken  Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 引继解除三方关联
/// @param type 账号类型
/// @param guestToken 登录token
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_disconnectPlatformWithType:(NSString*)type GuestToken:(NSString *)guestToken Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 清楚本地引继码信息
/// @param uniqueid 唯一标识
-(void)vsdk_clearCitationDataWithUniqueId:(NSString *)uniqueid;


/// 判断本地引继信息是否已经删除
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_citationCleanLocalCacheSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * failure))failure;



/// 获取真爱大挑战活动数据
/// @param serverId 服务器id
/// @param roleId 角色id
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_trueLoveChallengeDataWithServerId:(NSString *)serverId RoleId:(NSString *)roleId Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 真爱大挑战埋点上报
/// @param serverId 服务器id
/// @param roleId 角色id
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_bigChanllengeEventSubmitShareWithServerId:(NSString *)serverId RoleId:(NSString *)roleId  Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 领取真爱挑战分享奖励埋点上报接口
/// @param serverId 服务器id
/// @param roleId 角色id
/// @param event_cert 事件凭证
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_bigChallengeShareRewardClaimWithServerId:(NSString *)serverId RoleId:(NSString *)roleId  Cert:(NSString *)event_cert Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 真爱大挑战领取目标奖励接口
/// @param serverId 服务器id
/// @param roleId 角色id
/// @param event_cert 事件凭证
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_bigChallengeRewardClaimWithServerId:(NSString *)serverId RoleId:(NSString *)roleId  Cert:(NSString *)event_cert Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 真爱挑战数据获取接口
-(void)vsdk_dpBagDataWithServerId:(NSString *)serverId RoleId:(NSString *)roleId RoleLevel:(NSString *)roleLevel Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 真爱大挑战活跃点上报接口
-(void)vsdk_bigChanllengeEventSubmitActivePointWithServerId:(NSString *)serverId RoleId:(NSString *)roleId activeNum:(NSNumber *)num Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 检测直购礼包是否已购买
-(void)vsdk_dpBagCheckOrderBuyExistWithServerId:(NSString *)serverId RoleId:(NSString *)roleId RoleLevel:(NSString *)roleLevel ProductId:(NSString *)pid Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;




/// 直购礼包订单上传接口
/// @param userId userId 
/// @param money money
/// @param moneytype moneytype
/// @param serverId serverId
/// @param serverName serverName
/// @param roleId roleId
/// @param rolename rolename
/// @param roleLevel roleLevel
/// @param goodId goodId
/// @param goodName goodName
/// @param tradeSn tradeSn
/// @param extData extData
/// @param productId productId
/// @param productName productName
/// @param orderSn orderSn
-(void)vsdk_dpBagUploadOrderWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName OrderSn:(NSString *)orderSn;




/// 游戏停服登录和充值提示获取接口
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_loginAndPurchaseStateWithSuccess:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 下单前获取商品信息
/// @param pid 商品ID
/// @param success 成功回调
/// @param failure 失败回调
-(void)vsdk_getproductInfoBeforeOrderWithPid:(NSString *)pid Success:(void(^)(id responseObject))success  Failure:(void(^)(NSString * failure))failure;



/// 获取红包条目是否有可领取项目
/// @param success 成功回调
/// @param failure 失败回调 
-(void)vsdk_getRedpacketAlertStateSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;




/// 账号删除/恢复使用
-(void)vsdk_delOrRecoverUserAccountWithType:(NSNumber *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;



/// 获取拍脸图数据
-(void)vsdk_activityPageDataSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;

// 获取新拍脸图数据
-(void)vsdk_acquirePatFaceDateSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;

// 拍脸图数据上报
-(void)vsdk_reportPatFaceDateWithImgID:(NSString *)img_id WithImgtitle:(NSString *)img_title WithImgUrl:(NSString *)imgurl WithType:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;

// 平台积分
//type: 0初始化 1积分签到 2积分明细 3积分查询 4积分商城
-(void)vsdk_initPlatformIntegralWithType:(int)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;

// 平台积分发货接口
//type: 1自动发货 2手动发货
-(void)vsdk_PlatformDeliveryWithType:(int)type AndGoodid:(NSString *)goodid Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;

// 登录页面点击上报
-(void)vsdk_loginClickWithType:(NSString *)type Success:(void(^)(id responseObject))success Failure:(void(^)(NSString * errorMsg))failure;
@end

