//
//  VSSDKDefine.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#if Helper

#endif

#ifndef VSSDKDefine_h
#define VSSDKDefine_h

#if Helper
#import "IntergralModel.h"
#import "VSFeatures.h"
#import "VSAssistantHelper.h"
#import "VSAssistantView.h"
#import "VSAssitButton.h"
#import "VSTipsView.h"
#endif

#import "VSChainTool.h"
#import "VSTool.h"
//#import "VSDKAPI.h"
//钥匙串内购漏单标识
#define VSDK_IAPKEY @"IAPKEY"

//平台
#define VSDK_PALTFORM @"ios"

//设备uuid
#define VSDK_UUID  [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString

//设备idfv
#define VSDK_IDFV  [UIDevice currentDevice].identifierForVendor.UUIDString

//设备idfa
#define VSDK_IDFA  [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString

//iOS操作系统版本
#define VSDK_OS_VER [[UIDevice currentDevice] systemVersion]

//app显示在手机上的名称
#define VSDK_APP_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleDisplayName"]


//交易凭证存储路径
#define VSDK_RECEIPT_SIGN_PATH @"vsdk_receipt_sign.plist"
//订阅交易id
#define VSDK_SUBSCRIBTION_TRANSID @"vsdk_subscribtion_transid"

#define VSDK_FBINSTALLED [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]

#define VSDK_FB_LIKE_PAGE_URL  [[[NSBundle mainBundle] infoDictionary]objectForKey:@"VSDK_FB_LIKE_PAGE_URL"]

#define VSDK_ISSUED_AREA [[[NSBundle mainBundle] infoDictionary]objectForKey:@"VSDK_ISSUED_AREA"]

//SDK礼品发放方式

#define VSDK_PLATFORM_ACCOUNT @"platform"
#define VSDK_GUEST @"guest"//4
#define VSDK_FACEBOOK @"facebook"//2
#define VSDK_APPLE @"apple"//10
#define VSDK_GOOGLE @"google"//3
#define VSDK_TWITTER @"twitter"//5
#define VSDK_NAVER @"naver"//9

#define FB_TYPE_LIKEPAGE  @"likepage"
#define FB_TYPE_SHARELINK  @"sharelink"
#define FB_TYPE_SHAREPHOTO  @"sharephoto"
#define FB_TYPE_SHAREVIDEO  @"sharevideo"

#define SHARE_COMPLETE_SUCCESS @"1"
#define SHARE_CALL @"0"

#define TW_TYPE_SHARETEXT  @"sharetext"
#define TW_TYPE_SHAREPHOTO  @"sharephoto"
#define TW_TYPE_SHARELINK  @"sharelink"

#define MSG_TYPE_SHARELINK  @"sharelink"
#define MSG_TYPE_SHAREPHOTO  @"sharephoto"
#define MSG_TYPE_SHAREVIDEO  @"sharevideo"

#define VSDK_WHITE_COLOR [UIColor whiteColor]

#define VSDK_ORANGE_COLOR [UIColor orangeColor]

#define VSDK_HEADVIEW_COLOR [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1]

#define VSDK_RBG_COLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]


#define VSDK_WARN_COLOR [UIColor colorWithRed:240/255.0 green:131/255.0 blue:0/255.0 alpha:1]

#define VSDK_GRAY_COLOR [UIColor grayColor]

#define VSDK_LIGHT_GRAY_COLOR  [UIColor lightGrayColor]

#define VSDK_BLACK_COLOR [UIColor blackColor]

#define VSDK_HEAD_LABEL_COLOR [UIColor colorWithRed:248/255.0 green:60/255.0 blue:2/255.0 alpha:1]

#define VSDK_RAMDOM_COLOR  [UIColor colorWithRed:arc4random()%255/255.0  green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

#define VSDK_NEW_STYLE_COLOR VS_RGB(5, 51, 101)

//sdk版本
#define VSDK_VER @"1002"

//平台用户缓存userid
#define VSDK_GAME_USERID [[NSUserDefaults standardUserDefaults]valueForKey:@"vsdk_game_userid"]

/**************************************  以下平台参数配置   **************************************/

//自定义info文件路径
#define VSDK_INFOPATH [[NSBundle mainBundle] pathForResource:@"vsdk_cofig" ofType:@"plist"]
//自定义info文件字典
#define VSDK_INFODIC [[NSDictionary alloc] initWithContentsOfFile:VSDK_INFOPATH]

#define VSDK_APP_ID [VSDK_INFODIC objectForKey:@"VSDK_APP_ID"]

//游戏id
#define VSDK_GAME_ID [VSDK_INFODIC objectForKey:@"VSDK_GAME_ID"]
//游戏校验秘钥
#define VSDK_GAME_KEY [VSDK_INFODIC objectForKey:@"VSDK_GAME_KEY"]

#define VSDK_ADJUST_TOKEN [VSDK_INFODIC objectForKey:@"VSDK_ADJUST_TOKEN"]

#define VSDK_ADJUST_APPSECRET [VSDK_INFODIC objectForKey:@"VSDK_ADJUST_APPSECRET"]

#define VSDK_FACEBOOK_APPID  [VSDK_INFODIC objectForKey:@"VSDK_FACEBOOK_APPID"]

#define VSDK_BUGLY_ID [VSDK_INFODIC objectForKey:@"VSDK_BUGLY_ID"]

#define VSDK_GAM_REWARD_GIVEN_TYPE [VSDK_INFODIC objectForKey:@"VSDK_GAM_REWARD_GIVEN_TYPE"]

//是否开启自动登录配置
#define VSDK_GUEST_AUTO_LOGIN [[[NSBundle mainBundle] infoDictionary]objectForKey:@"VSDK_GUEST_AUTO_LOGIN"]

#define VSDK_APP_VERSION [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]

#define VSDK_APP_BUILD [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]

#define VSDK_SHOW_CALITION_RULE [VSDK_INFODIC objectForKey:@"VSDK_SHOW_CALITION_RULE"]

#define VSDK_GOOGLE_CLIENTID [VSDK_INFODIC objectForKey:@"VSDK_GOOGLE_CLIENTID"]

#define VSDK_TWITTER_KEY [VSDK_INFODIC objectForKey:@"VSDK_TWITTER_KEY"]

#define VSDK_TWITTER_SECRET  [VSDK_INFODIC objectForKey:@"VSDK_TWITTER_SECRET"]

/**************************** 以上是平台配置参数 *******************************/

//数据解析到data层
#define GETRESPONSEDATA  [responseObject objectForKey:@"data"]objectForKey

#define GETUSEABLEPLATFROMDATA  [useDic objectForKey:@"login_type_data"]objectForKey

//无效的IDFA(iOS设备开启限制广告追踪时获取到的IDFA 为这个值)
#define VSDK_INVALID_IDFA @"00000000-0000-0000-0000-000000000000"

#define VSDK_FOREVEVR_UUID @"vsdk_constant_uuid"

#define VSDK_CURRENT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion].doubleValue

//请求成功宏
#define REQUESTSUCCESS [[responseObject objectForKey:@"state"]  isEqual: @1]

#define RESPONSESTATE [[responseObject objectForKey:@"state"] stringValue]

#define VSDK_MISTAKE_MSG  [responseObject objectForKey:@"message"]

#define BANNEDACCOUNT [[responseObject objectForKey:@"state"] isEqual: @99]

#define VSDK_FACEBOOK_CACHE_SLOT 114829

//单例快速实例化
#define VSDKShareHelper [VSDKHelper sharedHelper]

#define VSDKLOGINOBJ @"LOGINOBJ"

//本地数据存储key
#define VSDK_INITIALIZE_KEY @"vsdk_first_init"
#define VSDK_ACTIVE_KEY @"vsdk_first_active"
#define VSDK_ACTIVE_DATE_KEY @"vsdk_active_date"
#define VSDK_APNS_TOKEN_KEY @"vsdk_apns_device_token"
#define VSDK_GAME_UID_KEY  @"vsdk_game_userid"
#define VSDK_GUEST_NICKNAME @"vsdk_guest_nick_name"


#define VSDK_TRANSID_KEY @"vsdk_transaction_id"
#define VSDK_RECEIPT_KEY @"vsdk_receipt_key"
#define VSDK_APPLE_TOKEN_KEY @"vsdk_appleid_token"
#define VSDK_APPLE_AUTH_CODE @"vsdk_appleauth_code"
#define VSDK_LEAST_TOKEN_KEY @"vsdk_token_least"
#define VSDK_UCENTER_GIFT_CODE_KEY @"vsdk_ucenter_gift_code"
#define VSDK_CDN_ERROR_KEY @"vsdk_cdn_report_error_open"
#define VSDK_CDN_SLOW_KEY  @"vsdk_cdn_report_slow_open"
#define VSDK_IF_FORM_UID @"link_security_email_from_uid"
#define VSDK_KEYCHAIN_IDFA [NSString stringWithFormat:@"kVsdkKeychainIDFA"]


#define VSDK_SHOW_STATUTE @"vsdk_show_statute"
#define VSDK_CALOTION_FLAG @"vsdk_calition_import_flag"
#define VSDK_CALITION_CONNECT_TYPE @"vsdk_calition_connect_type"
#define VSDK_CALITION_IMPORT_FLAG @"vsdk_calition_import_flag"
#define VSDK_APPLE_CONNECT_STATE @"vsdk_apple_connect_state"
#define VSDK_TWITTER_CONNECT_STATE @"vsdk_twitter_connect_state"
#define VSDK_FACEBOOK_CONNECT_STATE @"vsdk_facebook_connect_state"
#define VSDK_NAVER_CONNECT_STATE @"vsdk_naver_connect_state"
#define VSDK_GOOGLE_CONNECT_STATE @"vsdk_google_connect_state"
#define VSDK_AUTO_LOGIN_KEY @"vsdk_last_login_type"


#define VSDK_TenTimesSuccessfulPayment @"AccumulatedTenTimesSuccessfulPayment"
#define VSDK_ThreeTimesSuccessfulPayment @"AccumulatedThreeTimesSuccessfulPayment"
#define VSDK_CompleteAllDailyTask @"CompleteAllDailyTask"
#define VSDK_CompleteNewbieTask @"CompleteNewbieTask"
#define VSDK_FiveLoginsInDay @"FiveLoginsInDay"
#define VSDK_JoinGameGuild @"JoinGameGuild"
#define VSDK_LoginAfter7DaysFromActivation @"LoginAfter7DaysFromActivation"
#define VSDK_LoginTwiceWithin5DaysFromActivation @"LoginTwiceWithin5DaysFromActivation"
#define VSDK_NumberOfSuccessfulPayment @"NumberOfSuccessfulPayment"
#define VSDK_OnlineOver90MinutesInDay @"OnlineOver90MinutesInDay"
#define VSDK_RegisterGameAccount @"RegisterGameAccount"


#define VSDK_CONNECT_STATE_PATH @"vsdkConnectState.plist"
#define VSDK_ADJUST_EVEN_PATH @"vsdkAjustEvenToken.plist"
#define VSDK_ASSISTANT_CONFIG_PATH @"vsdkAssistConfig.plist"
#define VSDK_NORMAL_BULLETIIN_PATH @"vsdkNormalBulletin.plist"
#define VSDK_TEMP_BULLETIIN_PATH @"vsdkTempBulletin.plist"

#define VSDK_KEYCHAIN_ADJUSTID [NSString stringWithFormat:@"kVsdkKeychainAdjustId_%@",VSDK_GAME_ID]
#define VSDK_SP_UUID  [NSString stringWithFormat:@"kVsdkKeychainSP_UUID"]
//引继码相关

#define VSDK_CALITION_UNIQUE_ID  @"vsdk_calition_unique_id"
#define VSDK_CALITION_TOKEN @"vsdk_clication_guest_token"
#define VSDK_CALITION_LAST_CLEAN_DATE @"vsdk_uniqueid_last_clean_date"
#define VSDK_CALITION_GUEST_TOKEN @"vsdk_calition_guest_token"
#define VSDK_CALITION_MD5_SIGN_KEY  @"vsdk_calition_token_md5_sign"



//真爱挑战相关

#define VSDK_BIG_CHALLENGE_PATH @"vsdk_big_challenge_data.plist"

//拍脸图
#define VSDK_GRAPHIC_BULLTEIN_PATH @"vsdk_graphic_bulltein_data.plist"

//好评引导
#define VSDK_UCENTER_FS_SHOW_KEY [NSString stringWithFormat:@"%@_%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"vsdk_game_userid"],@"fivestar_reviews_show"]


//账号绑定引导
#define VSDK_UCENTER_SHOW_KEY [NSString stringWithFormat:@"%@_%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"vsdk_game_userid"],@"user_account_center_show"]

#define VSDK_U_LOGIN_COUNT @"vsdk_user_login_count"


//邮箱绑定引导相关

#define kSdkNextTimeCount(uid)  [NSString stringWithFormat:@"vsdk_next_time_count_%@",uid]
#define kSdkNextTimeBind(uid)  [NSString stringWithFormat:@"vsdk_next_time_bind_%@",uid]

/*
 平台公共参数宏
 */

#define VSDK_PARAM_ROLE_LEVEL @"role_level"
#define VSDK_PARAM_USER_TYPE @"user_type"
#define VSDK_PARAM_ROLE_ID @"role_id"
#define VSDK_PARAM_ROLE_NAME @"role_name"
#define VSDK_PARAM_ADJUST_ID @"adjust_id"
#define VSDK_PARAM_IDFV @"idfv"
#define VSDK_PARAM_NEYWORK @"net_type"
#define VSDK_PARAM_DNAME  @"dname"
#define VSDK_PARAM_OS_VER @"os_ver"
#define VSDK_PARAM_SDK_VER @"sdk_ver"
#define VSDK_PARAM_LANGUAGE @"language"
#define VSDK_PARAM_GAME_ID @"game_id"
#define VSDK_PARAM_PLARFORM @"platform"
#define VSDK_PARAM_UUID @"uuid"
#define VSDK_PARAM_WIFI_NAME @"wifi_name"
#define VSDK_PARAM_IDFA @"idfa"
#define VSDK_PARAM_TIME @"time"
#define VSDK_PARAM_APP_ID @"app_id"
#define VSDK_PARAM_SERVER_ID @"server_id"
#define VSDK_PARAM_SERVER_NAME @"server_name"
#define VSDK_PARAM_GAME_NAME @"game_name"
#define VSDK_PARAM_SIGN @"sign"
#define VSDK_PARAM_OPEN_ID @"open_id"
#define VSDK_PARAM_OPEN_TYPE @"open_type"
#define VSDK_PARAM_USER_ID @"user_id"
#define VSDK_PARAM_DEVICE_ID @"sdk_device_id"
#define VSDK_PARAM_REAL_ADJUST_ID @"real_adjust_id"
#define VSDK_PARAM_REAL_IDFA @"real_idfa"
#define VSDK_PARAM_USERNAME @"user_name"
#define VSDK_PARAM_UID @"user_id"
#define VSDK_PARAM_PASSWORD @"password"
#define VSDK_PARAM_TOKEN @"token"
#define VSDK_PARAM_GUEST_TOKEN @"guest_token"
#define VSDK_PARAM_BIND_MAIL @"bind_mail"
#define VSDK_PARAM_CODE @"code"
#define VSDK_PARAM_SWITCH_TYPE @"switch_type"
#define VSDK_PARAM_GUEST_TYPE @"guest"
#define VSDK_PARAM_MONEY @"money"
#define VSDK_PARAM_MONEY_TYPE @"money_type"
#define VSDK_PARAM_EXTEND @"extend"
#define VSDK_PARAM_ORDER  @"order"
#define VSDK_PARAM_PID @"product_id"
#define VSDK_PARAM_PAY_TYPE  @"pay_type"
#define VSDK_PARAM_GOODS_ID  @"goods_id"
#define VSDK_PARAM_GOODS_NAME @"goods_name"
#define VSDK_PARAM_CP_TRADE_SN @"cp_trade_sn"
#define VSDK_PARAM_EXT_DATA @"ext_data"
#define VSDK_PARAM_THIRD_GOODS_ID @"third_goods_id"
#define VSDK_PARAM_THIRD_GOODS_NAME @"third_goods_name"
#define VSDK_PARAM_RECEIPT_DATA @"receipt_data"
#define VSDK_PARAM_PURCHASE_DATE @"purchase_date"
#define VSDK_PARAM_TRANSACTION_ID @"transaction_id"
#define VSDK_PARAM_ORIGINAL_TRANSACTION_ID @"original_transaction_id"
#define VSDK_PARAM_ORDER_PROOF_MD5 @"order_proof_md5"
#define VSDK_PARAM_PUSH_TOKEN @"push_token"
#define VSDK_PARAM_FF_TYPE @"apple"
#define VSDK_PARAM_BIND_EMAIL @"bind_email"
#define VSDK_PARAM_ADS_TYPE @"ads_type"
#define VSDK_PARAM_ADS_POSITION @"ads_position"
#define VSDK_PARAM_ADS_EVENT @"ads_event"
#define VSDK_PARAM_ADS_STATE @"ads_state"
#define VSDK_PARAM_PRODUCT_TYPE @"product_type"
#define VSDK_PARAM_REPORT_TYPE @"type"
#define VSDK_PARAM_REPORT_STATE @"state"
#define VSDK_PARAM_APP_VERSION @"app_version"
#define VSDK_PARAM_GAM_VER_TYPE @"gam_version_type"
#define VSDK_PARAM_BIND_VER_TYPE @"bind_version_type"
#define VSDK_PARAM_ERROR_CODE @"error_code"
#define VSDK_PARAM_ERROR_MSG @"error_msg"
#define VSDK_PARAM_APP_BUILD @"app_build"
#define VSDK_PARAM_EVENT @"event"
#define VSDK_PARAM_EVENT_ID @"event_id"
#define VSDK_PARAM_EVENT_CERT @"event_cert"
#define VSDK_PARAM_INVITE_CODE @"invite_code"
#define VSDK_PARAM_NICK_NAME @"nick_name"
#define VSDK_PARAM_DISPLAY_WIDTH @"display_width"
#define VSDK_PARAM_DISPLAY_HEIGHT @"display_height"


#define VSDK_BIND_PHONE_EVENT @"bind_phone"
#define VSDK_BIND_MAIL_EVENT @"bind_mail"
#define VSDK_BIND_UID_EVENT @"bind_uid"


#define VSDK_ASSISTANT_BIND_MAIL @"vsdk_assistant_bind_mail"
#define VSDK_ASSISTANT_BIND_PHOME @"vsdk_assistant_bind_phone"
#define VSDK_ASSISTANT_BIND_UID @"vsdk_assistant_bind_uid"
#define VSDK_ASSISTANT_USER_TYPE @"vsdk_assistant_user_type"


#define VSDK_EMAIL_GIFT_STATE @"vsdk_email_gift_state"
#define VSDK_PHONE_GIFT_STATE @"vsdk_phone_gift_state"
#define VSDK_UID_GIFT_STATE @"vsdk_uid_gift_state"
#define VSDK_BIND_GIFT_CRET @"bind_gift_cert"

#define VSDK_SOCIAL_SERVER_ID @"social_server_id"
#define VSDK_SOCIAL_SERVER_NAME @"social_server_name"
#define VSDK_SOCIAL_ROLE_ID @"social_role_id"
#define VSDK_SOCIAL_ROLE_NAME @"social_role_name"
#define VSDK_SOCIAL_ROLE_LEVEL @"social_role_level"
#define VSDK_SOCIAL_GAME_NAME @"social_game_name"

/*
 平台公共参数宏
 */

#import "VSAPIConfig.h"
#import "VSIPAPurchase.h"
#import "VSDKAPI.h"
#import "VSDKHelper.h"
#import "VSDeviceHelper.h"
#import "VSUserHelper.h"
#import "VSUser.h"
#import "VSHUD.h"
#import "VSSwitchBtn.h"
#import "Masonry.h"
#import "VSSandBoxHelper.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "VSOpenIDFA.h"
#import "VSSeeLogView.h"
#import "PDKeyChain.h"
#import "VSHttpHelper.h"
#import "VSWidget.h"
#import "VSToast.h"
#import "RSA.h"
#import "VSKeychain.h"
#import "RealReachability.h"
#import "VSEncryption.h"

#import "VSLoginView.h"
#import "VSSignUpView.h"
#import "VSForgetPswView.h"
#import "VSRetrieveView.h"
#import "VSChangePswView.h"
#import "VSAutoLoginView.h"
#import "VSSegmentView.h"
#import "VSEditPassWord.h"
#import "VSBindThirdView.h"
#import "VSBindSegmentView.h"
#import "VSBindSecurityView.h"
#import "VSIrregularBtn.h"
#import "VSSelectLoginView.h"
#import "VSNotificationView.h"
#import "VSCountryPickerView.h"
#import "VSUserCenterView.h"
#import "VSUserCenterEntrance.h"
#import "VSUserCenterTF.h"
#import "VSGiftCodeView.h"
//#import "VSFeatures.h"
//#import "VSAssistantHelper.h"
//#import "VSAssistantView.h"
//#import "VSAssitButton.h"
//#import "VSTipsView.h"
#import "VSFiveStarView.h"
#import "VSBadgeBtn.h"
#import "VSNormalBulltein.h"
#import "VSTempBulltein.h"
#import "VSTextBackView.h"
#import "VSAskToBindView.h"
#import "VSGameExpired.h"
#import "VSDelAccontView.h"
#import "VSActivicityPageView.h"


//社交相关
#import "VSSocailCodeView.h"
#import "VSSocialView.h"
#import "VSShareView.h"
#import "VSShareModel.h"
#import "VSShareButton.h"
#import "VSPageMenu.h"


//游戏事件
#import "VSEventView.h"

//SDK工具类
#import "VSDKTPInitHelper.h"
#import "VSDKEventHelper.h"


//系统库
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SafariServices/SafariServices.h>
#import <StoreKit/StoreKit.h>
#import <UserNotifications/UserNotifications.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>


//三方库
#import "Firebase.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bugly/Bugly.h>
#import <AdjustSdk/Adjust.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "SDWebImagePrefetcher.h"
#import "SDImageCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SUCache.h"
#import "SUCacheItem.h"

/************************  适配相关宏定义  ******************************/
// 输入框的高度
#define kTFHeight 4

#define mianScreenW   [UIScreen mainScreen].bounds.size.width

#define mianScreenH   [UIScreen mainScreen].bounds.size.height

#define  distanceW(px) (mianScreenW>736)? px/3 * mianScreenW/iPHONEXWidth:px/3 * mianScreenW/i7PlusWidth

#define distanceH(px)  (mianScreenW>736)? px/3 * mianScreenH/iPHONEXHeight:px/3 * mianScreenH/i7PlusHeight

#define distancePadW(px) px/3 * mianScreenW/IPADMAXWidth

#define distancePadH(px) px/3 * mianScreenH/IPADMAXHeight

//设配IPAD 和 iphone 高度

#define ADJUSTPadAndPhoneW(px) UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?distancePadW(px):distanceW(px)

#define ADJUSTPadAndPhoneH(px) UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?distancePadH(px):distanceH(px)

// 竖屏适配宏
#define ADJUSTPadAndPhonePortraitW(px) UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?distancePadW(px*1.8):distanceW(px*2)

//Portrait

#define ADJUSTPadAndPhonePortraitH(px,pt) UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?distancePadH(px/pt):distanceH(px/pt)

#define screenAdjudtPortraitW  [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait?mianScreenW * 2/i7PlusWidth: mianScreenW/i7PlusWidth

#define screenAdjudtPortraitH  [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait?mianScreenH/1.6/i7PlusHeight:mianScreenH/i7PlusHeight

#define padScreenAdjudtPortraitW  [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait?mianScreenW * 2/IPADMAXWidth:mianScreenW/IPADMAXWidth

#define padScreenAdjudtPortraitH  [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait?mianScreenH/IPADMAXHeight:mianScreenH/IPADMAXHeight

// 竖屏适配宏

#define screenAdjudtW mianScreenW/i7PlusWidth

#define screenAdjudtH mianScreenH/i7PlusHeight

#define padScreenAdjudtW mianScreenW/IPADMAXWidth

#define padScreenAdjudtH mianScreenH/IPADMAXHeight

#define i7PlusWidth   736
#define i7PlusHeight  414

#define iPHONEXWidth  812
#define iPHONEXHeight  375

#define IPADMAXWidth 1024
#define IPADMAXHeight  768

// 屏幕的宽和高
#define SCREE_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREE_HEIGHT [[UIScreen mainScreen] bounds].size.height

//位置计算

#define VS_VIEW_BOTTOM(view)  view.frame.origin.y + view.frame.size.height

#define VS_VIEW_TOP(view)  view.frame.origin.y

#define VS_VIEW_LEFT(view) view.frame.origin.x

#define VS_VIEW_RIGHT(view) view.frame.origin.x + view.frame.size.width


#define IPAD_SCREEN_MAX_HEGHT 1366
#define IPHONE_SCREEN_MAX_HEGHT 896
#define IPHONE_SCREEN_MAX_WIDTH 414


#define  VSDK_ADJUST_PORTRIAT_WIDTH  ADJUSTPadAndPhonePortraitW(900)
#define  VSDK_ADJUST_PORTRIAT_HEIGHT  ADJUSTPadAndPhonePortraitH(777,[VSDeviceHelper getExpansionFactorWithphoneOrPad])

#define  VSDK_ADJUST_LANDSCAPE_WIDTH   ADJUSTPadAndPhoneW(1026)
#define  VSDK_ADJUST_LANDSCAPE_HEIGHT  ADJUSTPadAndPhoneH(886)

/************************  适配相关宏定义  ******************************/

/*********************  苹果系列机型判断宏  *********************/
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhoneX，Xs（iPhoneX，iPhoneXs） 11pro
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhoneXr 11
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhoneXsMax | 11 pro max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)

//判断iPhone12_Mini | 13 mini
#define IS_IPHONE12_Mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhone12 | 12Pro | 13 | 13Pro
#define IS_IPHONE12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//判断iPhone12 Pro Max iPhone13 Pro Max
#define IS_IPHONE12_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)


//iPhone X全系列
#define IS_IPhoneX_All  IS_IPHONE_X||IS_IPHONE_Xr||IS_IPHONE_Xs_Max||IS_IPHONE12_Mini||IS_IPHONE12||IS_IPHONE12_ProMax


#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kMaxScreenLength (MAX(kScreenWidth, kScreenHeight))
#define kMinScreenLength (MIN(kScreenWidth, kScreenHeight))

/**
 *  屏幕是否是iPhone4
 *          iPhone4S
 */
#define iPhone4 (iPhone && kMaxScreenLength == 480)

/**
 *  屏幕是否是iPhone 5
 *          iPhone 5S
 *          iPhone SE 1
 */
#define iPhone5 (iPhone && kMaxScreenLength == 568)


/**
 *  屏幕是否是iPhone 6
 *          iPhone 6S
 *          iPhone 7
 *          iPhone 8
 *          iPhone SE 2
 */
#define iPhone6 (iPhone && kMaxScreenLength == 667)

/**
 *  屏幕是否是iPhone 6 Plus
 *          iPhone 6S Plus
 *          iPhone 7 Plus
 *          iPhone 8 Plus
 *
 */
#define iPhone6Plus (iPhone && kMaxScreenLength == 736)

/**
 *  屏幕是否是iPhone X
 *          iPhone XS
 *          iPhone 11 Pro
 *          iPhone 12 mini
 */
#define iPhoneX (iPhone && kMaxScreenLength == 812)

/**
 *  屏幕是否是iPhone XR
 *          iPhone XS Max
 *          iPhone 11
 *          iPhone 11 Pro Max
 */
#define iPhoneXSMax (iPhone && kMaxScreenLength == 896)

/**
 *  屏幕是否是iPhone 12
 */
#define iPhone12 (iPhone && kMaxScreenLength == 844)

/**
 *  屏幕是否是iPhone 12 Pro Max
 */
#define iPhone12ProMax  (iPhone && kMaxScreenLength == 926)


//以6s为基准。
#define kLJWidthScale DEVICEPORTRAIT?[UIScreen mainScreen].bounds.size.width/375.0:[UIScreen mainScreen].bounds.size.width/667

#define kLJHeightScale  DEVICEPORTRAIT?[UIScreen mainScreen].bounds.size.height/667.0:[UIScreen mainScreen].bounds.size.height/375


/*********************  苹果系列机型判断宏  *********************/

//RGB
#define VS_RGB(r, g, b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

// bundle包名目录
#define kBundleName  @"VSDKResources.bundle"
// 目录下的资源路径
#define kSrcName(file)   [kBundleName stringByAppendingPathComponent:file]

#define VS_RootVC [[UIApplication  sharedApplication] keyWindow].rootViewController


//日志输出相关
#define DEBUGString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DEBUGLog(...) printf("%s 第%d行: %s\n\n", [DEBUGString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

//判断设备横竖屏
#define DEVICEPORTRAIT  [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown


/********************    本地存储路径宏    *********************/
//创建存储平台订单号的路径
#define VS_TEMP_ORDER_PATH_PLIST(transId)  [NSString stringWithFormat:@"%@/%@.plist", [VSSandBoxHelper tempOrderPath], transId]

#define VS_SUBSCRIPTION_FLAG_PATH_PLIST(transId)  [NSString stringWithFormat:@"%@/%@.plist", [VSSandBoxHelper SubscriptionFlagPath], transId]

#define VS_SUBSCRIPTION_FLAG_PATH(name)  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper SubscriptionFlagPath], name]

//根据路径名取出取出路径
#define VS_TEMP_ORDER_PATH(name)  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper tempOrderPath], name]

#define VS_SUCCESS_ORDER_PATH_PLIST(transId) [NSString stringWithFormat:@"%@/%@.plist", [VSSandBoxHelper SuccessIapPath], transId]

#define VS_SUCCESS_ORDER_PATH(name)  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper SuccessIapPath], name]

#define VS_SUB_SUCCESS_ORDER_PATH_PLIST(transId) [NSString stringWithFormat:@"%@/%@.plist", [VSSandBoxHelper SuccessSubPath], transId]

#define VS_SUB_SUCCESS_ORDER_PATH(name)  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper SuccessSubPath], name]

#define VS_UNFINISH_ORDER_PATH_PLIST(transId)  [NSString stringWithFormat:@"%@/%@.plist", [VSSandBoxHelper iapReceiptPath], transId]

#define VS_UNFINISH_ORDER_PATH(name)  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper iapReceiptPath], name]

#define VS_SOCIAL_INFO_PATH(name)  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper socialInfoPath], name]

#define VS_COUNTRY_AREA_CODES_PATH(name) [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper countryAreaCodePath], name]

#define VS_RECEIPT_SIGN_PATH_PLIST(name)  [NSString stringWithFormat:@"%@/%@.plist", [VSSandBoxHelper rectiptSignPath], name]

#define VS_RECEIPT_SIGN_PATH  [NSString stringWithFormat:@"%@/%@", [VSSandBoxHelper rectiptSignPath], name]

#define VS_SOCIALINFO_PLIST_PATH  [NSString stringWithFormat:@"%@/vsdkSocialData.plist",[VSSandBoxHelper socialInfoPath]]

#define VS_USERDEFAULTS  [NSUserDefaults standardUserDefaults]

#define VS_USERDEFAULTS_SETVALUE(value,key) [[NSUserDefaults standardUserDefaults]setValue:value forKey:key]

#define VS_USERDEFAULTS_REOMVEVALUE(key)  [[NSUserDefaults standardUserDefaults]removeObjectForKey:key]

#define VS_USERDEFAULTS_GETVALUE(key) [[NSUserDefaults standardUserDefaults]valueForKey:key]

/********************    以上为本地存储路径宏    *********************/
//隐藏hud
#define VS_HUD_HIDE [VSHUD hide];

//显示hud成功提示弹窗
#define VS_SHOW_SUCCESS_STATUS(message)   [VSHUD showSuccessWithContainerView:VS_RootVC.view status:VSLocalString(message)];

//显示hud出错提示弹窗
#define VS_SHOW_ERROR_STATUS(message)  [VSHUD showErrorWithContainerView:VS_RootVC.view status:VSLocalString(message)];

//显示hud信息提示弹窗
#define VS_SHOW_TIPS_MSG(message) [VSHUD showWithContainerView:VS_RootVC.view status:VSLocalString(message)];

#define VS_SHOW_INFO_MSG(message) [VSHUD showInfoWithContainerView:VS_RootVC.view status:VSLocalString(message)];

//类型转换
#define VS_CONVERT_TYPE(param) [NSString stringWithFormat:@"%@",param]

#define VSLocalString(str) NSLocalizedString(str, @"")

#define VSDK_LOCAL_DATA(path,key) [[VSDeviceHelper getSanboxFilePathWithCompontment:path]objectForKey:key]

#define VSDK_DIC_WITH_PATH(path) [VSDeviceHelper getSanboxFilePathWithCompontment:path]

#define VSDK_USABLE_PALTFORM_PATH @"vsdkUsablePlatform.plist"

#define VSDK_BIG_CHALLENGE_VALUE_MIN  100

#define VSDKGetDicData(dic,arrayKey,index,valueKey) [[dic objectForKey:arrayKey][index] objectForKey:valueKey]

#define VSDK_CLOSE_SERVER_INFO_PATH @"vsdkCloseServerInfo.plist"

#define VSDK_CLOSE_SERVER_DIC [VSDeviceHelper getSanboxFilePathWithCompontment:VSDK_CLOSE_SERVER_INFO_PATH]

#endif /* VSSDKDefine_h */
