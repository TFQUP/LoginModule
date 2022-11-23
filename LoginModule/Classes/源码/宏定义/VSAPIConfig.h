//
//  VSAPIConfig.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#ifndef VSAPIConfig_h
#define VSAPIConfig_h


#define HOSTNAME @"https://api.unlockgame.org/"

#define GAMHOSTNAME @"http://tyfly.cn:8801/"

#define BIG_CHALLENGE_HOSTNAME @"http://tyfly.cn:8801/"

#define SERVICE_HOSTNAME @"http://tyfly.cn:8889/"

#define ONLINELOG_HOSTNAME @"https://apilog.unlockgame.com/"

#define INTEGRATING_HOSTNAME @"https://point.unlockgame.org/"

#define ONLINELOG_HOSTNAME_TEST @"https://apilog.unlockgame.org/"
//域名随时更换 根据发布地区

// 正式域名

//#define HOSTNAME @"https://api.unlock.game/"
//
//#define GAMHOSTNAME @"https://assistant.unlock.game/"
//
//#define GAMHOSTNAME2 @"https://assistant.gametransf.com/"
//
//#define BIG_CHALLENGE_HOSTNAME @"https://activitylib.unlock.game/"
//
//#define SERVICE_HOSTNAME @"https://feedback.unlock.game/"
//
//#define ONLINELOG_HOSTNAME @"https://apilog.unlockgame.com/"
//
//#define INTEGRATING_HOSTNAME @"https://point.unlockgame.org/"
//
//#define ONLINELOG_HOSTNAME_TEST @"https://apilog.unlockgame.org/"

//服务条款URL
#define VSDK_TERM_URL [HOSTNAME stringByAppendingString:@"?ct=index&ac=terms"]


//平台注册API
#define VSDK_REGISTER_API [HOSTNAME stringByAppendingString:@"?method=user.register"]

//平台登录API
#define VSDK_LOGIN_API [HOSTNAME stringByAppendingString:@"?method=user.login"]

//UID登录接口
#define VSDK_UID_LOGIN_API [HOSTNAME stringByAppendingString:@"?method=user.loginUID"]

//三方登录接口
#define VSDK_THIRD_LOGIN_API [HOSTNAME stringByAppendingString:@"?method=user.thirdLogin"]

//发送邮件验证API
#define VSDK_SEND_EMAIL_API [HOSTNAME stringByAppendingString:@"?method=user.sendMail"]

//验证邮件验证码接口
#define VSDK_CHECK_MAIL_CODE_API [HOSTNAME stringByAppendingString:@"?method=user.checkMailCode"]

//修改密码接口
#define VSDK_EDIT_PASSWORD_API [HOSTNAME stringByAppendingString:@"?method=user.editPassword"]

//UL账号绑定接口
#define VSDK_BIND_LOGIN_API [HOSTNAME stringByAppendingString:@"?method=user.bindLogin"]

//UL账号注册绑定接口
#define VSDK_BIND_REGISTER_API [HOSTNAME stringByAppendingString:@"?method=user.bindRegister"]

//游客绑定第三方接口
#define VSDK_THIRD_BIND_GUEST_API [HOSTNAME stringByAppendingString:@"?method=user.thirdBindGuest"]


//初始化上报埋点API
#define VSDK_INIT_API [HOSTNAME stringByAppendingString:@"?method=user.init"]

//首次拉起的登录 激活上报埋点
#define VSDK_ACTIVE_API [HOSTNAME stringByAppendingString:@"?method=user.active"]

//玩家(角色登录)进入游戏上报埋点接口
#define VSDK_ENTER_GAME_API [HOSTNAME stringByAppendingString:@"?method=user.enter"]

//玩家创建角色上报埋点接口
#define VSDK_CREATE_ROLE_API [HOSTNAME stringByAppendingString:@"?method=user.create"]

//选服接口
#define VSDK_SELECT_SERVER_API [HOSTNAME stringByAppendingString:@"?method=user.select"]

//玩家升级上报埋点接口
#define VSDK_LEVELUP_API [HOSTNAME stringByAppendingString:@"?method=user.levelup"]

#define VSDK_QUIT_GAME_API [HOSTNAME stringByAppendingString:@"?method=user.quit"]

#define VSDK_COMPLETENEWBIE_API [HOSTNAME stringByAppendingString:@"?method=user.completenewbie"]

//玩家加入公会
#define VSDK_JOIN_GUILD_API [HOSTNAME stringByAppendingString:@"?method=user.joingameguild"]

//玩家完成每日任务
#define VSDK_COMPLETEALLDAILY_API [HOSTNAME stringByAppendingString:@"?method=user.completealldaily"]

//获取订单号接口
#define VSDK_PAY_ORDER_API [HOSTNAME stringByAppendingString:@"?method=pay.order"]

#define VSDK_PRODUCT_INFO_API [HOSTNAME stringByAppendingString:@"?method=pay.product.getProductInfo"]

#define VSDK_PAY_CALLBACK_API [HOSTNAME stringByAppendingString:@"?method=pay.callback"]

#define VSDK_PAY_SUB_ORDER_API [HOSTNAME stringByAppendingString:@"?method=pay.subOrder"]

#define VSDK_PAY_SUB_CALLBACK_API [HOSTNAME stringByAppendingString:@"?method=pay.subCallback"]

//遍历内购接口
#define VSDK_ORDER_INFO_API [HOSTNAME stringByAppendingString:@"?method=pay.getOrderInfo"]

#define VSDK_SUB_ORDER_INFO_API [HOSTNAME stringByAppendingString:@"?method=pay.getSubOrderInfo"]

//校验不成功返回服务器API
#define VSDK_PAY_LOG_API [HOSTNAME stringByAppendingString:@"?ct=paylog&ac=apple"]

//内购失败上报接口
#define VSDK_PAY_LOG_ORDER_API [HOSTNAME stringByAppendingString:@"?ct=paylog&ac=apple_order"]

//上爆bug 出错信息接口
#define VSDK_APPLE_ERROR_LOG_API [HOSTNAME stringByAppendingString:@"?ct=paylog&ac=apple_error_log"]

#define VSDK_SEND_EMAIL_CODE_API [HOSTNAME stringByAppendingString:@"?method=user.send_code_mail"]

#define VSDK_BIND_SAFE_EMAIL_API [HOSTNAME stringByAppendingString:@"?method=user.send_bind_safemail"]

//采集玩家在线API
#define VSDK_USER_ONLINE_API [ONLINELOG_HOSTNAME stringByAppendingString:@"?ct=UserOnline&ac=apple_online"]

//SDK登录界面点击上报API
#define VSDk_LoginClick_API [ONLINELOG_HOSTNAME_TEST stringByAppendingString:@"?ct=user&ac=click_login"]

#define VSDK_FEEKBACK_API [HOSTNAME stringByAppendingString:@"?ct=problem&ac=feedback"]


#define VSDK_LOGIN_ERROR_LOG_API   [HOSTNAME stringByAppendingString:@"index.php?ct=app&ac=login_error_log"]

#define VSDK_PAY_ERROR_LOG_API  [HOSTNAME stringByAppendingString:@"index.php?ct=app&ac=pay_error_log"]

#define VSDK_EVEN_TOKEN_API [HOSTNAME stringByAppendingString:@"index.php?ct=AdjustConfig&ac=event_token"]


#define VSDK_APNS_TOKEN_API [HOSTNAME stringByAppendingString:@"?ct=push&ac=apple_token"]


#define VSDK_UNIQUETAG_API [HOSTNAME stringByAppendingString:@"?ct=push&ac=callback_apple_token"]


#define VSDK_CDN_SLOW_API [HOSTNAME stringByAppendingString:@"?ct=cdn&ac=slow_load_log"]

#define VSDK_REFRESH_TOKEN_API  [HOSTNAME stringByAppendingString:@"?ct=index&ac=refreshToken"]


#define VSDK_CUSTOMER_SERVICE_API [SERVICE_HOSTNAME stringByAppendingString:@"?ct=index&ac=customerService"]


#define VSDK_VIP_USER_API [HOSTNAME stringByAppendingString:@"?ct=Config&ac=guibin"]


#define VSDK_REPORT_API(type) [NSString stringWithFormat:@"%@%@%@",HOSTNAME,@"?ct=advert&ac=advert&advert_type=",type]


#define VSDK_OPEN_LOGIN_TYPE_API [HOSTNAME stringByAppendingString:@"?ct=config&ac=loginType"]


#define VSDK_BIND_PHONE_NUM_API [HOSTNAME stringByAppendingString:@"?method=user.bindPhone"]


#define VSDK_GET_BING_PHONE_CODE_API [HOSTNAME stringByAppendingString:@"?method=user.sendCodeBindPhone"]


#define VSDK_BIND_GIFT_STATE_API [GAMHOSTNAME stringByAppendingString:@"?method=bindGift.bindGiftState"]


#define VSDK_BIND_REWARD_RECEIVED_API [GAMHOSTNAME stringByAppendingString:@"?method=bindGift.bindRewardReceive"]


//小助手相关功能&配置接口
#define VSDK_SOCIAL_DATA_API [GAMHOSTNAME stringByAppendingString:@"?method=gamActivity.getInfo"]

//社交分享也简历兑换上报接口
#define VSDK_LIKE_REWARD_API [GAMHOSTNAME stringByAppendingString:@"?method=gamActivity.prizeExchange"]


#define VSDK_SOCAIL_EVENT_REPORT_API [GAMHOSTNAME stringByAppendingString:@"?method=gamActivity.report"]


#define VSDK_BIND_INVITE_API [GAMHOSTNAME stringByAppendingString:@"?method=gamActivity.invite"]


#define  VSDK_ASSISTANT_CONFIG_INFO [GAMHOSTNAME stringByAppendingString:@"?method=floatball.getInfo"]


#define VSDK_NORMAL_BULLTEIN_API [GAMHOSTNAME stringByAppendingString:@"?method=notice.normal"]


#define VSDK_TEMP_BULLTEIN_API [GAMHOSTNAME stringByAppendingString:@"?method=notice.temporary"]


#define VSDK_CDN_INIR_API  [HOSTNAME stringByAppendingString:@"index.php?ct=config&ac=init"]


#define VSDK_CITATION_LOGIN_API  [HOSTNAME stringByAppendingString:@"?method=user.citationLogin"]


#define VSDK_CITATION_REGISTER_API [HOSTNAME stringByAppendingString:@"?method=user.citationRegister"]


#define VSDK_THIRD_CONNECT_GUEST_LOGIN_API [HOSTNAME stringByAppendingString:@"?method=user.thirdConnectGuestLoign"]


#define VSDK_THIRD_CONNECT_STATE_API [HOSTNAME stringByAppendingString:@"?method=user.thirdConnectGuestState"]


#define VSDK_THIRD_CONNECT_BUND_API [HOSTNAME stringByAppendingString:@"?method=user.thirdConnectGuestBund"]


#define VSDK_THIRD_CONNECT_UNBUND_API [HOSTNAME stringByAppendingString:@"?method=user.thirdConnectGuestUnbund"]

#define VSDK_CLEAN_CALITION_DATA_API [HOSTNAME stringByAppendingString:@"?ct=Sdklog&ac=cleanLogData"]

#define VSDK_APP_GUEST_API [HOSTNAME stringByAppendingString:@"?method=user.appGuest"]


#define VSDK_BIG_CHALLENGE_DATA_API [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=bigChallenge.getInfo"]


#define VSDK_SUBS_TERM_OF_SERVICE [HOSTNAME stringByAppendingString:@"?ct=index&ac=subterms"]


#define VSDK_GAME_DOWNLOAD_API [HOSTNAME stringByAppendingString:@"index.php?ct=game&ac=download"]


#define VSDK_GET_PRODUCT_INFO_API [HOSTNAME stringByAppendingString:@"?ct=config&ac=getProductInfo"]


//大挑战相关api
#define VSDK_SHARE_BREAK_POINT_API [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=bigChallenge.shareUpload"]

#define VSDK_BC_SHARE_REWARD_CLAIM_API  [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=bigChallenge.sharePrizeExchange"]

#define VSDK_BIG_CHALLENGE_PRIZE_API  [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=bigChallenge.prizeExchange"]

#define VSDK_ACTIVE_BREAK_POINT_API  [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=bigChallenge.activeUpload"]


//直购礼包相关
#define VSDK_DPB_INFO_API [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=directPurchaseBilling.getInfo"]

#define VSDK_ORDER_EXIST_BUY_API  [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=directPurchaseBilling.checkOrderBuyExist"]

#define VSDK_ORDERSN_UPLOAD_API  [BIG_CHALLENGE_HOSTNAME stringByAppendingString:@"?method=directPurchaseBilling.uploadOrder"]

#define VSDK_CLOSE_SERVER_API [HOSTNAME stringByAppendingString:@"?ct=config&ac=notice"]

//账号删除接口
#define VSDK_DELETE_ACCOUNT_API [HOSTNAME stringByAppendingString:@"?method=user.delAccount"]

#define VSDK_GRAPHIC_BULLETIN_API [GAMHOSTNAME stringByAppendingString:@"?method=notice.graphicBulletin"]

//新拍脸图接口
#define VSDK_PATFACE_API [GAMHOSTNAME stringByAppendingString:@"?method=facePainting.getList"]

//新拍脸图数据上报接口
#define VSDK_PATFACEREPORT_API [GAMHOSTNAME stringByAppendingString:@"?method=facePainting.uploadReport"]

//平台积分初始化接口
#define VSDK_PlatformIntegral_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=PPoint.init"]

//平台积分签到
#define VSDK_PlatformIntegralSignin_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=PPoint.getDaySign"]

//平台积分明细
#define VSDK_PlatformIntegralDetail_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=PPoint.getPointOrderList"]

//平台积分查询
#define VSDK_PlatformIntegralQuery_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=PPoint.getPPointRewardList"]

//平台积分商城
#define VSDK_PlatformIntegralMall_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=PPoint.giftList"]

//平台积分自动发货接口
#define VSDK_Autodelive_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=point.giftExchangeCode"]

//平台积分手动发货接口
#define VSDK_Manualdelive_API [INTEGRATING_HOSTNAME stringByAppendingString:@"?method=point.giftExchangeGame"]
#endif /* VSAPIConfig_h */
