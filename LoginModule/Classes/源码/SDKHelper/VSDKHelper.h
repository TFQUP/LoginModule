//
//  VSDKHelper.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//埋点类型 请在对应事件填入对应埋点类型
typedef NS_ENUM(NSInteger, kUrlEventType) {
    
    kEnterGameType = 0,//进入游戏
    kCreateRoleType = 1, //创建角色
    kLevelUpType = 2, //角色升级
    kQuitGameType = 3,  //退出游戏
    kCompleteNewbieType = 4, //完成新手指引
    kCompleteAllDailyTaskType = 5,//完成全部每日任务
    kJoinGameGuildType = 6,//加入公会
    
};



@interface VSDKHelper : NSObject

@property (nonatomic,copy)void(^Ablock)(void);
@property (nonatomic,copy)void(^Bblock)(void);
@property (nonatomic,copy)void(^PatfaceBlock)(NSString *actionStr);

///  SDK实例化方法
+ (VSDKHelper *)sharedHelper;



/// SDK初始化方法
/// @param application 程序入口方法 application
/// @param options 程序入口方法 launchOptions
-(void)vsdk_initializeWithApplication:(UIApplication *)application Options:(NSDictionary *)options;


/// 应用内回调
/// @param application application
/// @param url url
/// @param options options
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;



/// SDK事件激活接口
-(void)vsdk_activateAppEvents;



/// 移除内购队列监听
-(void)vsdk_stopTransManager;

/// 显示登录界面的方法
/// @param vc 弹出登录界面的控制器
/// @param callback 登录回调 isSuccess 是否登录成功,loginToken 登录token, errorMsg 返回错误信息
- (void)vsdk_popUpLoginPageInVc:(UIViewController *)vc loginCallback:(void(^)(BOOL isSuccess,NSString *loginToken,NSString *errorMsg))callback;




/// 上报选服埋点接口
/// @param gamename 游戏名 
/// @param serverid 游戏服id
/// @param servername 游戏服名
-(void)vsdk_reportSelectSeverBuriedPointWithGamename:(NSString *)gamename ServerId:(NSString *)serverid Servername:(NSString *)servername;

/**
 埋点事件上报接口
 
 @param urlType 埋点类型 {
 
 kEnterGameUrlType = 0,//进入游戏
 kCreateRoleUrlType = 1, //创建角色
 kLevelUpUrlType = 2, //角色升级
 kQuitGameUrlType = 3,  //退出游戏
 kCompleteNewbieUrlType = 4, //完成新手指引
 kCompleteAllDailyTaskUrlType = 5,//完成全部每日任务
 kJoinGameGuildUrlType = 6,//加入公会
 
 }
 @param serviceid 服务器ID
 @param servername 服务器名
 @param roleid 角色ID
 @param rolename 角色名
 @param rolelevel 角色等级
 @param openservertime 开服时间 10位数字时间戳,开服时间,北京时间(可选,有传则必传)
 
 */

-(void)vsdk_reportBuriedPointWithType:(kUrlEventType)urlType serviceId:(NSString *)serviceid serverName:(NSString *)servername roleId:(NSString *)roleid roleName:(NSString *)rolename roleLevel:(NSString *)rolelevel  openServertime:(NSString *)openservertime;



/// 拉起消耗型(即内购型)商品购买接口
/// @param userId 平台用户ID
/// @param money 金额
/// @param moneytype 货币类型 固定USD
/// @param serverId 游戏服务器ID
/// @param serverName 游戏服务器名
/// @param roleId 游戏角色id
/// @param rolename 游戏角色名
/// @param roleLevel 游戏角色等级
/// @param goodId cp商品id
/// @param goodName cp商品名字
/// @param tradeSn CP订单号
/// @param extData 充值回调的扩展参数
/// @param productId 内购商品id
/// @param productName 内购商品名称
/// @param Vc 控制器
/// @param iapResult iapResult
-(void)vsdk_purchaseWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName  Viewcontroller:(UIViewController *)Vc iapResult:(void(^)(BOOL isSuccess,NSString *certificate, NSString *errorMsg))iapResult;


/// 注册系统推送服务
/// @param application application
/// @param delegate 代理
-(void)vsdk_registerAPNSServiceWithApplication:(UIApplication *)application Delegate:(id)delegate;


/// 上传设备推送Token
/// @param deviceToken 推送token
-(void)vsdk_upLoadApnsDeviceToken:(NSData *)deviceToken;


/// 处理点击通知后的响应事件
/// @param response response
-(void)vsdk_handleNotificationWithResponse:(UNNotificationResponse *)response;


/// 响应前台通知
/// @param nofi nofi
-(void)vsdk_reponseToForegroundWithNotication:(UNNotification *)nofi;

/// 上报CDN资源加载出错接口 在cdn加载资源出错时候调用
/// @param cdnUrl cdn链接
/// @param errInfo 出错信息
-(void)vsdk_reportCdnResourcesErrorWithUrl:(NSString *)cdnUrl errorInfo:(NSString *)errInfo;


/// 打开游戏客服页面
-(void)vsdk_askForCustomerService; 


/// 获取是否有未读的客服信息,若有则打开客服链接的按钮加提醒红点
/// @param block block
-(void)vsdk_customerServiceIconShowBadgeWithBlock:(void(^)(BOOL ifShowBadge))block;


/// 跳转应用外部safari浏览器并打开网页
/// @param url 网址
/// @param vc 当前控制器
-(void)vsdk_openWebsiteWithUrl:(NSString *)url inCurrentVc:(UIViewController *)vc;


/// 打开苹果官方评分UI
-(void)vsdk_popUpSKRequestView;



/// 弹出社交分享页
-(void)vsdk_showSocialSharePage;


/// 账号删除功能(2022年6月30日后提交的app都要求有账号删除功能，重点审核)
-(void)vsdk_delectUserAccount;


/***********************以下为选择性/辅助性接口(在有运营的具体需求时接入)***************/

/// 分享链接到faceBook接口
/// @param quote 引文分享标识 用户可删除
/// @param url 链接地址
/// @param tag 话题标签
/// @param Vc 控制器
/// @param shareBlock 分享结果回调 YES 成功  NO 失败
-(void)vsdk_shareToFacebookWithQuote:(NSString *)quote contentURL:(NSString *)url HashTag:(NSString *)tag FromViewControlle:(UIViewController *)Vc shareResults:(void(^)(BOOL isSuccess,id results ,NSError* error))shareBlock;


///  分享图片到facebook接口
/// @param image 图片
/// @param Vc 控制器
/// @param shareBlock 分享结果的回调 YES 成功  NO 失败
-(void)vsdk_sharePhotoToFacebookWithImage:(UIImage *)image FromViewControler:(UIViewController *)Vc shareResults:(void(^)(BOOL isSuccess,id results ,NSError* error))shareBlock;


/// 生成分享到facebook链接接口
/// @param serverid 服务器id
/// @param roleid 角色id
/// @param rolename 角色名
/// @param rolelevel 角色等级
/// @param invitecode 邀请码
///@return 返回拼接好的邀请链接
-(NSString *)vsdk_createFacebookShareLinkWithServiceId:(NSString *)serverid RoleId:(NSString *)roleid RoleName:(NSString *)rolename RoleLevel:(NSString *)rolelevel InviteCode:(NSString *)invitecode;



/// 生成三方平台邀请链接接口
/// @param serverid 服务器id
/// @param roleid 角色id
/// @param rolename 角色名
/// @param rolelevel 角色等级
/// @param invitecode 邀请码
/// @return 返回拼接好的邀请链接
-(NSString *)vsdk_gameInviteShareLinkWithServiceId:(NSString *)serverid RoleId:(NSString *)roleid RoleName:(NSString *)rolename RoleLevel:(NSString *)rolelevel InviteCode:(NSString *)invitecode;



/// 判断当前登录角色是否VIP
-(BOOL)vsdk_currentRoleisVip;


/// 处理deepLinks信息回调接口
/// @param activity activity
-(BOOL)vsdk_handleContinueUserActivityWithActivity:(NSUserActivity *)activity;



/// 获取应用启动数据
/// @param infoBlock infoBlock
-(void)vsdk_callbackAppStartupData:(void(^)(NSDictionary * dic))infoBlock;


/// 获取最新刷新的登录token
-(NSString *)vsdk_latestRefreshedLoginToken;


/// 打开appStore管理订阅界面
-(void)vsdk_openManageSubscriptionsPage;


/// 展示订阅条款界面
-(void)vsdk_showSubsribtionsTermOfService;


/// 拉起订阅型商品购买接口
/// @param userId 平台用户ID
/// @param money 金额
/// @param moneytype 货币类型 固定USD
/// @param serverId 游戏服务器ID
/// @param serverName 游戏服务器名
/// @param roleId 游戏角色id
/// @param rolename 游戏角色名
/// @param roleLevel 游戏角色等级
/// @param goodId cp商品id
/// @param goodName cp商品名字
/// @param tradeSn CP订单号
/// @param extData 充值回调的扩展参数
/// @param productId 订阅商品id
/// @param productName 订阅商品名称
/// @param Vc 控制器
/// @param iapResult iapResul sub_
-(void)vsdk_subscriptionPurchaseWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName Viewcontroller:(UIViewController *)Vc iapResult:(void(^)(BOOL isSuccess,NSString *certificate, NSString *errorMsg))iapResult;


/// 在应用内部打开一个网页
/// @param url 网页URL
-(void)vsdk_openWebPageInSafariWithUrl:(NSString *)url;

/// 展示红包浮窗
-(void)vsdk_showRedBagFloatBtn;

/// 展示红包活动界面
-(void)vsdk_showRedPacketWebPage;

/// 显示活动介绍页
-(void)vsdk_showGameActivityPage;

// 内购本地化查询
/// @param productIdArr 内购id数组
-(void)vsdk_queryLocalMsgWithInpurchaseId:(NSArray *)productIdArr andCallBack:(void(^)(NSArray *))callback;


/// bugly添加日志参数
/// @param gameEngine 游戏引擎
/// @param engineVersion 游戏引擎版本
/// @param gameName 游戏名称
-(void)vsdk_buglyAddMessageWithGmaeEngine:(NSString *)gameEngine AndEngineVersion:(NSString *)engineVersion AndGameName:(NSString *)gameName;


-(void)vsdk_loginClickWithType:(NSString *)type;

-(void)showAssistant;

-(void)hideAssistant;

-(void)showBackV;

-(void)hideBackV;

-(void)assistantBtnClick;

-(void)patfaceCilickBlock:(void(^)(NSString *))patfaceBlock;
@end

NS_ASSUME_NONNULL_END
