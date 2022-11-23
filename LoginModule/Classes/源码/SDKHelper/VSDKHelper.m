//
//  VSDKHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.


#import "VSDKHelper.h"
#import "VSSDKDefine.h"
#import "PatFaceVC.h"
#import "SDKENTRANCE.h"
#import "Level_PatModel.h"
#import "VSTool.h"
#import "Pic_PatModel.h"
#import "IQKeyboardManager.h"
#define kThirdLoginType @"kLoginType"
#define kThirdBindType @"kBindType"

//判断玩家是否VIP
static BOOL ifVip = NO;
static BOOL ifWelcomeView = NO;
static BOOL ifBindApple = NO;
static BOOL isLaunchInfo = NO;
static BOOL hadShowBadge = NO;
static BOOL HadShowAst = NO;

static NSString * kAssistantBtnBadgeAlertNotification = @"kAssistantBtnBadgeAlertNotification";

@interface VSDKHelper ()<UITextFieldDelegate,ASAuthorizationControllerPresentationContextProviding,ASAuthorizationControllerDelegate,FBSDKSharingDelegate>


@property (nonatomic,strong) NSMutableArray *level_pic_listArr;
@property(nonatomic,copy)void(^loginCallback)(BOOL isSuccess,NSString *token,NSString *errorMsg);
@property(nonatomic,copy)void(^shareCallback)(BOOL isSuccess,id results ,NSError* error);
@property(nonatomic,copy)void(^inAppPurchaseCallback)(BOOL isSuccess,NSString *certificate, NSString *errorMsg);
@property(nonatomic,strong)VSSegmentView * viewSegment;//登录与注册切换view
@property(nonatomic,strong)VSLoginView * viewLogin; // 登录view
@property(nonatomic,strong)VSSignUpView * viewRegister; // 注册view
@property(nonatomic,strong)VSForgetPswView * viewForget; // 找回密码view
@property(nonatomic,strong)VSRetrieveView * viewRetrieve;//邮箱验证找回密码View;
@property(nonatomic,strong)VSEditPassWord * viewPwdedit;//重设密码View
@property(nonatomic,strong)VSBindSegmentView * viewBindSegment;//绑定切换View
@property(nonatomic,strong)VSAutoLoginView * viewAutoLogin;
@property(nonatomic,strong)VSBindThirdView * viewThirdBind;
@property(nonatomic,strong)VSBindSecurityView * viewBindSecuruty;
@property(nonatomic,strong)VSSeeLogView * viewSeeLog;//查看日志信息的View

@property(nonatomic,strong)VSSelectLoginView * viewSelect;
@property(nonatomic,strong)UIView * viewBgMask;//背景蒙版
@property(nonatomic,strong)UIView * viewAlpha;
@property(nonatomic,strong)VSToast * viewToast;
@property(nonatomic,strong)VSNotificationView * viewNotifi;
@property(strong,nonatomic)UIView * viewaskBindBg;
@property(strong,nonatomic)VSAskToBindView * viewAskToBind;

#if Helper
@property(nonatomic,strong)VSAssistantHelper * astHelper;
#endif


@property(nonatomic,strong)UIButton * btnBackToSelect;
@property(nonatomic,strong)UIView * viewLoginBg;
@property(nonatomic,strong)UIViewController * rootVc;
//应用启动信息字典
@property(nonatomic,strong)NSMutableDictionary * launchInfoDic;
@property(nonatomic,copy)NSString * vsdkGgEventType;
@property(nonatomic,copy)NSString * emailToken ;
@property(nonatomic,copy)NSString * changePwdToken;
@property(nonatomic,copy)NSString * guestToken;//游客登录token
//登录成功与否的标识
@property(nonatomic,assign)BOOL isLoginSuccess;
//临时存储全局变量
@property(nonatomic,copy)NSString * VSDK_UID;
//登录token
@property(nonatomic,copy)NSString * VSDK_LOGIN_TOKEN;
//登录返回的出错信息
@property(nonatomic,copy)NSString * errorMsg;
@property(nonatomic,strong)NSTimer * timerOnline;//在线计时定时器
@property(nonatomic,strong)NSTimer * timerBadge;//客服角标计时器
@property(nonatomic,strong)NSTimer * timerRefresh;//刷新token定时器

//进入应用开始时间
@property(nonatomic,strong)NSDate * launchDate;
//退出游戏的时间
@property(nonatomic,strong)NSDate * exitDate;

@end

static VSDKHelper *_helper;

@implementation VSDKHelper

-(VSSignUpView *)viewRegister{
    
    if (!_viewRegister) {

        _viewRegister = [[VSSignUpView alloc] initWithFrame:DEVICEPORTRAIT?CGRectMake(0, ADJUSTPadAndPhonePortraitH(144,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH, VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(0, ADJUSTPadAndPhoneH(154), VSDK_ADJUST_LANDSCAPE_WIDTH,  ADJUSTPadAndPhoneH(744))];
    }
    
    return _viewRegister;
}

-(VSLoginView *)viewLogin{
    
    if (!_viewLogin) {
        
        _viewLogin = [[VSLoginView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(0,ADJUSTPadAndPhonePortraitH(144,[VSDeviceHelper getExpansionFactorWithphoneOrPad]) , VSDK_ADJUST_PORTRIAT_WIDTH, VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(0,ADJUSTPadAndPhoneH(154) , VSDK_ADJUST_LANDSCAPE_WIDTH,  ADJUSTPadAndPhoneH(744))];
    }
    
    return _viewLogin;
}

-(VSSegmentView *)viewSegment{
    if (!_viewSegment) {
        
        _viewSegment = [[VSSegmentView alloc] initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
    }
    return _viewSegment;
}

-(VSSelectLoginView *)viewSelect{
    
    if (!_viewSelect) {
        
        _viewSelect = [[VSSelectLoginView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
    }
    
    return _viewSelect;
    
}

-(UIView *)viewAlpha{
    
    if (!_viewAlpha) {
        
        _viewAlpha = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _viewAlpha.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    
    return _viewAlpha;
}

+ (VSDKHelper *)sharedHelper{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _helper = [[VSDKHelper alloc] init];
    });
    return _helper;
}

#pragma mark -- 初始化SDK
-(void)vsdk_initializeWithApplication:(UIApplication *)application Options:(NSDictionary *)options{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"ENTERGAME"];
    [ud synchronize];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [self askOrderWithAppstore];
    [[VSDKTPInitHelper shareHelper] vsdk_initializeDependencyWithApplication:application Options:options WithCompletionHandler:^(BOOL initlized) {
        //初始化成功显示浮球
        [self vsdk_showAssistantBtnWithRolevel:nil];
        
    }];
    //网络检测
    [self netWorkingStatusChange];
 
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    if ([url.absoluteString rangeOfString:VSDK_FACEBOOK_APPID].location != NSNotFound) {
        
        return [[FBSDKApplicationDelegate sharedInstance]application:application openURL:url options:options];
        
    }else{
        
        return [[GIDSignIn sharedInstance] handleURL:url];
        
    }
}

-(void)netWorkingStatusChange{
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    [self realNetworkingStatus:status];
}

- (void)networkChanged:(NSNotification *)notification{
    
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    [self realNetworkingStatus:status];
}

-(void)realNetworkingStatus:(ReachabilityStatus)status{
    switch (status){
            
        case RealStatusUnknown:{
            VS_HUD_HIDE;break;
        }
            
        case RealStatusNotReachable:{
            VS_HUD_HIDE;break;
        }
            
        case RealStatusViaWWAN:{
            
            [VSDKTPInitHelper vsdk_asyncRequestSdkConfigData];break;
        }
        case RealStatusViaWiFi:{
            
            [VSDKTPInitHelper vsdk_asyncRequestSdkConfigData];break;
        }
        default:
            break;
    }
}



-(void)vsdk_activateAppEvents{
    
    [[FBSDKAppEvents shared]activateApp];
}


-(void)vsdk_stopTransManager{
    
    [[VSIPAPurchase manager]vsdk_stopIapManager];
}



#pragma mark -- 弹出SDK登录界面
- (void)vsdk_popUpLoginPageInVc:(UIViewController *)vc loginCallback:(void(^)(BOOL isSuccess,NSString *loginToken,NSString *errorMsg))callback{

   //
    if (VSDK_CLOSE_SERVER_DIC&&[[VSDK_CLOSE_SERVER_DIC objectForKey:@"login_status"]isEqual:@1]) {
        
        [VSDeviceHelper vsdk_closeLoginNoticeUI];
        
    }else{
        
        self.loginCallback = [callback copy];
        
#if Helper
        if (!self.astHelper) {HadShowAst = NO;}
#endif
       
        
        self.rootVc = vc;
        [self.rootVc.view addSubview:self.viewAlpha];
        [self.rootVc.view addSubview:self.viewSelect];
        
        __weak typeof(self) weakSelf = self;
        
        [self.viewSelect setSelectBlock:^(VSSelectLoginBlockType type) {
            
            switch (type) {
                    
                case VSSelectLoginTypeAccount:
                    
                    [weakSelf vs_showSegmentViewInVc:vc];
                    break;
                case VSSelectLoginTypeApple:
                    
                    [weakSelf vsdk_loginWithUserType:VSDK_APPLE];
                    break;
                case VSSelectLoginTypeGuest:
                    
                    [weakSelf vsdk_loginWithUserType:VSDK_GUEST];
                    break;
                    
                case VSSelectLoginTypeFacebook:
                    
                    [weakSelf vsdk_loginWithUserType:VSDK_FACEBOOK];
                    break;
                    
                case VSSelectLoginTypeGoogle:
                    
                    [weakSelf vsdk_loginWithUserType:VSDK_GOOGLE];
                    break;
                    
                case VSSelectLoginTypeTwitter:
                    
                    [weakSelf vsdk_loginWithUserType:VSDK_TWITTER];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        self.viewSelect.hidden = YES;self.viewAlpha.hidden = YES;
        
        if ([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY) length]>0) {
            
            [self vsdk_autoLogin];
            
        }else if([VSDK_GUEST_AUTO_LOGIN isEqual:@1]){
            
            [self vsdK_guestSignIn];
            
        }else{
            
            self.viewSelect.hidden = NO;self.viewAlpha.hidden = NO;
        }
        
        //SDK激活埋点
        [VSDKTPInitHelper vsdk_activedBreakPoint];
//        //监听键盘弹出
//        [[NSNotificationCenter defaultCenter]addObserver:self
//                                                selector:@selector(keyboardWillShow:)
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];
//
//        //监听键盘隐藏
//        [[NSNotificationCenter defaultCenter]addObserver:self
//                                                selector:@selector(keyboardWillHide:)
//                                                    name:UIKeyboardWillHideNotification object:nil];
        
        //FB登录token发生改变时的方法
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(vsdk_fbAccessTokenChanged:)
                                                    name:FBSDKAccessTokenDidChangeNotification
                                                  object:nil];
        }
}


-(void)vs_showSegmentViewInVc:(UIViewController *)vc{
    
    self.viewAlpha.hidden = YES;self.viewSelect.hidden = YES;
    self.rootVc = vc;
    _viewLoginBg = [[UIView alloc]initWithFrame:_rootVc.view.frame];
    _viewLoginBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_rootVc.view addSubview:_viewLoginBg];
  
    [self vsdk_layOutSegmentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vsdk_endEditingWithGes:)];
    [_viewLoginBg addGestureRecognizer:tap];
    
}


#pragma mark -- 注册系统推送服务
-(void)vsdk_registerAPNSServiceWithApplication:(UIApplication *)application Delegate:(id)delegate{
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
#if DEBUG
            NSLog(@"推送授权成功");
#endif
        }
        
    }];
    
    [application registerForRemoteNotifications];
}


-(void)vsdk_upLoadApnsDeviceToken:(NSData *)deviceToken{
    
    [Adjust setDeviceToken:deviceToken];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![deviceToken isKindOfClass:[NSData class]]) return;;
        
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        NSString *strToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
        VS_USERDEFAULTS_SETVALUE(strToken,VSDK_APNS_TOKEN_KEY);
        
    } else {
        
        NSString * tokenStr = [NSString stringWithFormat:@"%@",deviceToken];
        tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
        tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
        VS_USERDEFAULTS_SETVALUE(tokenStr,VSDK_APNS_TOKEN_KEY);
        
    }
    
}


-(void)vsdk_handleNotificationWithResponse:(UNNotificationResponse *)response{
    
    if (response) {
        
        if ([response.notification.request.content.userInfo objectForKey:@"event_type"] !=nil && [[response.notification.request.content.userInfo objectForKey:@"event_type"] isEqualToString:@"GameNews"] && [[response.notification.request.content.userInfo objectForKey:@"show_type"] isEqualToString:@"InAppToldShow"]) {
            
            if ([response.notification.request.content.userInfo objectForKey:@"ulsdk_equipment_uuid"]){
                
                [[VSDKAPI shareAPI] vsdk_reportDeviceToServiceWithEquipment_uuid:[response.notification.request.content.userInfo objectForKey:@"ulsdk_equipment_uuid"]];
            }
        }
        
        if ([response.notification.request.content.userInfo objectForKey:@"event_type"] !=nil && [[response.notification.request.content.userInfo objectForKey:@"event_type"] isEqualToString:@"JumpWindow"]) {
            
            self.launchInfoDic = [[NSMutableDictionary alloc]init];
            [response.notification.request.content.userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [self.launchInfoDic setValue:obj forKey:key];
                
            }];
            
            isLaunchInfo = YES;
        }
    }
}


-(void)vsdk_reponseToForegroundWithNotication:(UNNotification *)nofi{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if ([nofi.request.content.userInfo objectForKey:@"event_type"] !=nil && [[nofi.request.content.userInfo objectForKey:@"event_type"] isEqualToString:@"GameNews"]&&[[nofi.request.content.userInfo objectForKey:@"show_type"] isEqualToString:@"InAppImportantShow"]) {
        
        CGFloat textHeight = [VSDeviceHelper getTextHeightWithStr:[[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"alert"] withWidth:SCREE_WIDTH*2/3-100 withLineSpacing:0 withFont:16];
        
        VS_USERDEFAULTS_SETVALUE(@"YES" ,@"importShow");
        
        if (40 + textHeight > 120) {
            
            self.viewNotifi = [[VSNotificationView alloc]initWithFrame:CGRectMake((SCREE_WIDTH - SCREE_WIDTH*0.8)/2 , -140, SCREE_WIDTH*0.8, 121)];
            self.viewNotifi.showTextHeight = 40 + textHeight;
            
        }else{
            
            self.viewNotifi = [[VSNotificationView alloc]initWithFrame:CGRectMake((SCREE_WIDTH - SCREE_WIDTH*0.8)/2 , -(40 + textHeight), SCREE_WIDTH*0.8, 40 + textHeight)];
        }
        
        self.viewNotifi.labelTitleDes.text = [[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"title"]?[[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"title"]:@"notice";
        
        self.viewNotifi.labelContent.text = [[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"alert"]?[[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"alert"]:@"";
        
        [VS_RootVC.view addSubview:self.viewNotifi];
        [self.viewNotifi showUlImportantAlertViewWithNofi:nofi];
        
    }
    
    if ([nofi.request.content.userInfo objectForKey:@"event_type"] !=nil && [[nofi.request.content.userInfo objectForKey:@"event_type"] isEqualToString:@"GameNews"]&&[[nofi.request.content.userInfo objectForKey:@"show_type"] isEqualToString:@"InAppToldShow"]) {
        
        CGFloat textHeight = [VSDeviceHelper getTextHeightWithStr:[[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"alert"] withWidth:SCREE_WIDTH*2/3-100 withLineSpacing:0 withFont:16];
        
        [VS_USERDEFAULTS setObject:@"NO" forKey:@"importShow"];
        
        if (40 + textHeight > 120) {
            
            self.viewNotifi = [[VSNotificationView alloc]initWithFrame:CGRectMake((SCREE_WIDTH - SCREE_WIDTH*0.8)/2 , -140, SCREE_WIDTH*0.8, 121)];
            self.viewNotifi.showTextHeight = 40 + textHeight;
            
        }else{
            
            self.viewNotifi = [[VSNotificationView alloc]initWithFrame:CGRectMake((SCREE_WIDTH - SCREE_WIDTH*0.8)/2 , -(40 + textHeight), SCREE_WIDTH*0.8, 40 + textHeight)];
            self.viewNotifi.importantShow = NO;
        }
        
        self.viewNotifi.labelTitleDes.text = [[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"title"]?[[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"title"]:@"notice";
        
        self.viewNotifi.labelContent.text = [[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"alert"]?[[nofi.request.content.userInfo objectForKey:@"aps"]objectForKey:@"alert"]:@"";
        
        [VS_RootVC.view addSubview:self.viewNotifi];
        [self.viewNotifi showUlImportantAlertViewWithNofi:nofi];
        
    }
    
    if ([nofi.request.content.userInfo objectForKey:@"event_type"] !=nil && [[nofi.request.content.userInfo objectForKey:@"event_type"] isEqualToString:@"CustomerRedPoint"]) {
        
        if ([[nofi.request.content.userInfo objectForKey:@"red_point_state"]isEqual:@1]) {
            VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_show_red_point");
        }
    }
    
}


-(void)vsdk_customerServiceIconShowBadgeWithBlock:(void(^)(BOOL ifShowBadge))block{
    
    if (!hadShowBadge) {
        
        self.timerBadge = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            if ([VS_USERDEFAULTS_GETVALUE(@"vsdk_show_red_point")isEqual:@1]) {
                block(YES);hadShowBadge = YES;
            }
        }];
        
        [self.timerBadge fire];
    }
    
}


-(void)vsdk_shareToFacebookWithQuote:(NSString *)quote contentURL:(NSString *)url HashTag:(NSString *)tag FromViewControlle:(UIViewController *)Vc shareResults:(void(^)(BOOL isSuccess,id results ,NSError* error))shareBlock{
    
    self.shareCallback = [shareBlock copy];
    
    if ([[[VSDeviceHelper plarformAvailable]objectForKey:VSDK_FACEBOOK] isEqual:@1]){
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        content.quote = VS_CONVERT_TYPE(quote);//引文分享 用户可删除
        content.hashtag = [[FBSDKHashtag alloc]initWithString:VS_CONVERT_TYPE(tag)];
        [FBSDKShareDialog showFromViewController:Vc withContent:content delegate:self];
        
    }else{
        
        VS_SHOW_INFO_MSG(@"Features are not yet open, so stay tuned");
    }
}


-(void)vsdk_sharePhotoToFacebookWithImage:(UIImage *)image FromViewControler:(UIViewController *)Vc shareResults:(void(^)(BOOL isSuccess,id results ,NSError* error))shareBlock{
    
    
    if ([[[VSDeviceHelper plarformAvailable]objectForKey:VSDK_FACEBOOK] isEqual:@1]) {
        
        if (VSDK_FBINSTALLED) {
            
            self.shareCallback = [shareBlock copy];
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] initWithImage:image isUserGenerated:YES];
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            content.photos = @[photo];
            [FBSDKShareDialog showFromViewController:Vc withContent:content delegate:self];
            
        }else{
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:@"To use this feature, please install Facebook first!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [VS_RootVC presentViewController:alert animated:YES completion:nil];
        }
        
    }else{
        
        VS_SHOW_INFO_MSG(@"Features are not yet open, so stay tuned");
    }
    
    
}


#pragma mark -- FBSDKSharingDelegate
//FB分享失败回调
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    self.shareCallback(NO, nil, error);
    
}

//FB分享成功回调
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    self.shareCallback(YES , results, nil);
    
}

//FB取消分享回调
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    self.shareCallback(NO , nil, nil);
    
}

-(NSString *)vsdk_createFacebookShareLinkWithServiceId:(NSString *)serverid RoleId:(NSString *)roleid RoleName:(NSString *)rolename RoleLevel:(NSString *)rolelevel InviteCode:(NSString *)invitecode{
    
    return [NSString stringWithFormat:@"%@&game_id=%@&user_id=%@&server_id=%@&role_id=%@&role_name=%@&role_level=%@&invite_code=%@&share_type=facebook",VSDK_GAME_DOWNLOAD_API,VSDK_GAME_ID,VSDK_GAME_USERID,VS_CONVERT_TYPE(serverid),VS_CONVERT_TYPE(roleid),VS_CONVERT_TYPE(rolename),VS_CONVERT_TYPE(rolelevel),VS_CONVERT_TYPE(invitecode)];
}



-(NSString *)vsdk_gameInviteShareLinkWithServiceId:(NSString *)serverid RoleId:(NSString *)roleid RoleName:(NSString *)rolename RoleLevel:(NSString *)rolelevel InviteCode:(NSString *)invitecode{
    
    return [NSString stringWithFormat:@"%@&game_id=%@&user_id=%@&server_id=%@&role_id=%@&role_name=%@&role_level=%@&invite_code=%@",VSDK_GAME_DOWNLOAD_API,VSDK_GAME_ID,VSDK_GAME_USERID,VS_CONVERT_TYPE(serverid),VS_CONVERT_TYPE(roleid),VS_CONVERT_TYPE(rolename),VS_CONVERT_TYPE(rolelevel),VS_CONVERT_TYPE(invitecode)];
}


-(BOOL)vsdk_handleContinueUserActivityWithActivity:(NSUserActivity *)activity{
    
    self.launchInfoDic = [[NSMutableDictionary alloc]init];
    BOOL handle = [[FIRDynamicLinks dynamicLinks]handleUniversalLink:activity.webpageURL completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:dynamicLink.url.absoluteString];
        
        [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableString *responseString = [NSMutableString stringWithString:(NSString *)obj.value];
            NSString *character = nil;
            
            for (int i = 0; i < responseString.length; i ++) {
                character = [responseString substringWithRange:NSMakeRange(i, 1)];
                if ([character isEqualToString:@"\\"])
                    [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
            }
            
            NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            if (dic.count > 0) {
                
                NSData *detailData = [[NSData alloc]initWithBase64EncodedString:[[dic objectForKey:@"extras"]objectForKey:@"vsdk_data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSDictionary * detailDic = [NSJSONSerialization JSONObjectWithData:detailData options:NSJSONReadingMutableLeaves error:nil];
                
                NSMutableDictionary * backDic = [[NSMutableDictionary alloc]init];
                
                [detailDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    [backDic setValue:obj forKey:key];
                    
                }];
                
                if ([VS_CONVERT_TYPE([backDic valueForKey:@"even_type"]) length] > 0) {
                    
                    [backDic removeObjectForKey:@"even_type"];
                }
                
                if ([detailDic valueForKey:@"jump_loading_desc"]) {
                    [self.launchInfoDic setValue:[detailDic valueForKey:@"jump_loading_desc"] forKey:@"jumpLoadingDesc"];
                }
                
                if ([detailDic valueForKey:@"jump_value"]) {
                    [self.launchInfoDic setValue:[detailDic valueForKey:@"jump_value"] forKey:@"jumpValue"];
                }
                if ([detailDic valueForKey:@"jump_type"]) {
                    [self.launchInfoDic setValue:[detailDic valueForKey:@"jump_type"] forKey:@"jumpType"];
                }
                if ([detailDic valueForKey:@"jump_details"]) {
                    [self.launchInfoDic setValue:[detailDic valueForKey:@"jump_details"] forKey:@"jumpDetails"];
                }
                
                isLaunchInfo  = YES;
            }
            
        }];
    }];
    
    return handle;
}


-(void)vsdk_appLaunchDataBlock:(void(^)(NSDictionary * dic))infoBlock{
    
    __weak typeof(self) weakSelf  = self;
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (isLaunchInfo) {
            
            infoBlock(weakSelf.launchInfoDic);
            [timer invalidate];
            timer = nil;
        }
    }];
    
    [timer fire];
    
}


-(void)vsdk_callbackAppStartupData:(void(^)(NSDictionary * dic))infoBlock{
    
    __weak typeof(self) weakSelf  = self;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (isLaunchInfo) {
            
            infoBlock(weakSelf.launchInfoDic);
            [timer invalidate];
            timer = nil;
        }
        
    }];
    
    [timer fire];
    
}

-(void)vsdk_reportCdnResourcesErrorWithUrl:(NSString *)cdnUrl errorInfo:(NSString *)errInfo{
    
    if([VS_CONVERT_TYPE(cdnUrl) hasPrefix:@"http://"]||[VS_CONVERT_TYPE(cdnUrl) hasPrefix:@"https://"]){
        
        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        NSMutableDictionary * mDic = [[NSMutableDictionary alloc]init];
        NSString * homename = [NSURL URLWithString:cdnUrl].host;
        //根据域名获取ip地址
        NSString * ipAdress = [VSDeviceHelper analyzeIpAddressWithHostName:homename];
        
        [mDic setValue:homename forKey:@"cdn_url"];
        [mDic setValue:ipAdress forKey:@"host_ip"];
        [mDic setValue:errInfo forKey:VSDK_PARAM_EXT_DATA];
        [dataArr addObject:mDic];
        
        if ([VS_USERDEFAULTS valueForKey:VSDK_CDN_ERROR_KEY]) {
            [[VSDKAPI shareAPI] vsdk_reportFialedCdnResourceWithDataList:dataArr];
        }
    }
}


-(NSString *)vsdk_latestRefreshedLoginToken{
    
    return VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY);
}


-(void)vsdk_openManageSubscriptionsPage{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}


-(void)vsdk_showSubsribtionsTermOfService{
    
    [VSDeviceHelper showTermOrContactCustomerServiceWithUrl:[NSString stringWithFormat:@"%@&language=%@",VS_USERDEFAULTS_GETVALUE(@"vsdk_subs_term_url")?VS_USERDEFAULTS_GETVALUE(@"vsdk_subs_term_url"):VSDK_SUBS_TERM_OF_SERVICE,[VSDeviceHelper vsdk_systemLanguage]]];
}



//-(void)keyboardWillShow:(NSNotification *)noti{
//
//    self.viewSegment.frame = DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 130,self.viewSegment.frame.size.width,self.viewSegment.frame.size.height):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,self.viewSegment.frame.size.width,self.viewSegment.frame.size.height);
//
//
//    self.btnBackToSelect.frame =DEVICEPORTRAIT? CGRectMake(VS_VIEW_LEFT(self.btnBackToSelect), 130, self.btnBackToSelect.frame.size.width, self.btnBackToSelect.frame.size.height):CGRectMake(VS_VIEW_RIGHT(self.viewSegment) + 5 , VS_VIEW_TOP(self.viewSegment)  + 2, ADJUSTPadAndPhoneW(64), ADJUSTPadAndPhoneW(64));
//
//
//    self.viewRetrieve.frame = DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 20,self.viewRetrieve.frame.size.width,self.viewRetrieve.frame.size.height):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,self.viewRetrieve.frame.size.width,self.viewRetrieve.frame.size.height);
//
//    self.viewPwdedit.frame = DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 20,VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT);
//
//    self.viewBindSegment.frame =  DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewBindSegment.frame.size.width/2, 20,VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(_rootVc.view.center.x - self.viewBindSegment.frame.size.width/2, 5,VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT);
//
//    self.viewBgMask.frame = DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 20,VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT);
//
//    self.viewBindSecuruty.frame = DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 20,VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT);
//
//    self.viewAutoLogin.frame = DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 20,VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT);
//
//}
//
////键盘隐藏调用方法
//-(void)keyboardWillHide:(NSNotification *)noti{
//
//    self.viewSegment.center = _rootVc.view.center;
//    self.viewRetrieve.center = _rootVc.view.center;
//    self.viewPwdedit.center = _rootVc.view.center;
//    self.viewBindSegment.center =_rootVc.view.center;
//    self.viewBgMask.center = _rootVc.view.center;
//    self.viewBindSecuruty.center = _rootVc.view.center;
//    self.viewAutoLogin.center = _rootVc.view.center;
//
//    self.btnBackToSelect.frame = DEVICEPORTRAIT? CGRectMake(VS_VIEW_RIGHT(self.viewSegment) + 5 , self.viewSegment.frame.origin.y  + 2, self.btnBackToSelect.frame.size.width, self.btnBackToSelect.frame.size.height):CGRectMake(VS_VIEW_RIGHT(self.viewSegment) + 5 , self.viewSegment.frame.origin.y  + 2, self.btnBackToSelect.frame.size.width, self.btnBackToSelect.frame.size.height);
//
//
//
//}

//点击背景空白回收键盘
-(void)vsdk_endEditingWithGes:(UITapGestureRecognizer *)tapGes{
    
    [VS_RootVC.view endEditing:YES];

}

//输入完毕回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -- 初始化登录界面
-(void)vsdk_layOutSegmentView{
    
    self.viewSegment.center = _rootVc.view.center;
    [_rootVc.view addSubview:self.viewSegment];
    [self.viewSegment layoutIfNeeded];

    __weak typeof(self) weakSelf = self;
    
    self.btnBackToSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rootVc.view addSubview:self.btnBackToSelect];
    
    self.btnBackToSelect.frame = DEVICEPORTRAIT? CGRectMake(VS_VIEW_RIGHT(self.viewSegment) + 5 , self.viewSegment.frame.origin.y  + 2, ADJUSTPadAndPhonePortraitW(64), ADJUSTPadAndPhonePortraitH(64,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(VS_VIEW_RIGHT(self.viewSegment) + 5 , self.viewSegment.frame.origin.y  + 2, ADJUSTPadAndPhoneW(64), ADJUSTPadAndPhoneW(64));
    
    [self.btnBackToSelect addTarget:self action:@selector(backToSelectView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnBackToSelect setImage:[UIImage imageNamed:kSrcName(@"vsdk_close_white")] forState:UIControlStateNormal];
    
    [self.viewSegment setSegmentViewBlock:^(VSSegmentViewBlockType type) {
        
        switch (type) {
            case VSSegmentViewBlockLogin:
                [weakSelf layoutLoginView]; // 登录界面布局
                break;
            case VSSegmentViewBlockSignUp:
                [weakSelf layoutSignUpView]; // 注册界面布局
                break;
                
            default:
                break;
        }
    }];
    
    //默认登录界面
    [self.viewSegment login];
    
}

-(void)backToSelectView{
    
    [self.viewSegment removeFromSuperview];self.viewSegment = nil;
    [self.viewLoginBg removeFromSuperview];self.viewLoginBg  = nil;
    [self.btnBackToSelect removeFromSuperview];self.btnBackToSelect = nil;
    self.viewSelect.hidden = NO;self.viewAlpha.hidden = NO;
    
}

#pragma mark -- 点击三次以查看相关日志的方法
-(void)vsdk_showReceiptAndCrashLog{
    
    self.viewSegment.hidden =YES;self.btnBackToSelect.hidden = YES;
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"View Successful Order (Consumption)") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.viewSeeLog = [[VSSeeLogView alloc]initWithFrame:self.viewSegment.frame];
        self.viewSeeLog.labelHead.text =VSLocalString(@"Successful Order Info");
        self.viewSeeLog.textView.text = [VSDeviceHelper vsdk_iapSuccessOrderInfo];
        
        [_rootVc.view addSubview:self.viewSeeLog];
        
        [self.viewSeeLog SeeLogViewBlock:^(VSSeeLogViewBlockType type) {
            
            switch (type) {
                case VSSeeLogBlockTypeBack:
                    
                    [self seeLogBackToSegment];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"View Successful Order (Subscription)") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.viewSeeLog = [[VSSeeLogView alloc]initWithFrame:self.viewSegment.frame];
        self.viewSeeLog.labelHead.text =VSLocalString(@"Successful Order Info");
        self.viewSeeLog.textView.text = [VSDeviceHelper vsdk_subSuccessOrderInfo];
        
        [_rootVc.view addSubview:self.viewSeeLog];
        
        [self.viewSeeLog SeeLogViewBlock:^(VSSeeLogViewBlockType type) {
            
            switch (type) {
                case VSSeeLogBlockTypeBack:
                    
                    [self seeLogBackToSegment];
                    break;
                    
                default:
                    break;
            }
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"View Unsuccessful Order") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.viewSeeLog = [[VSSeeLogView alloc]initWithFrame:self.viewSegment.frame];
        self.viewSeeLog.labelHead.text =VSLocalString(@"Unsuccessful Order Info");
        self.viewSeeLog.textView.text = [VSDeviceHelper vsdk_iapFailureOrderInfo];
        
        [_rootVc.view addSubview:self.viewSeeLog];
        
        [self.viewSeeLog SeeLogViewBlock:^(VSSeeLogViewBlockType type) {
            
            switch (type) {
                case VSSeeLogBlockTypeBack:
                    
                    [self seeLogBackToSegment];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"View Crash Log") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.viewSeeLog = [[VSSeeLogView alloc]initWithFrame:self.viewSegment.frame];
        self.viewSeeLog.labelHead.text = VSLocalString(@"Crash Log");
        self.viewSeeLog.textView.text = [VSDeviceHelper vsdk_crashLog];
        
        [_rootVc.view addSubview:self.viewSeeLog];
        
        [self.viewSeeLog SeeLogViewBlock:^(VSSeeLogViewBlockType type) {
            
            switch (type) {
                case VSSeeLogBlockTypeBack:
                    
                    [self seeLogBackToSegment];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"View NetWork Log" ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.viewSeeLog = [[VSSeeLogView alloc]initWithFrame:self.viewSegment.frame];
        self.viewSeeLog.labelHead.text =VSLocalString(@"Network Log");
        self.viewSeeLog.textView.text = [VSDeviceHelper vsdk_iapFailureOrderInfo];
        [_rootVc.view addSubview:self.viewSeeLog];
        
        [self.viewSeeLog SeeLogViewBlock:^(VSSeeLogViewBlockType type) {
            
            switch (type) {
                case VSSeeLogBlockTypeBack:
                    
                    [self seeLogBackToSegment];
                    break;
                    
                default:
                    break;
            }
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        self.viewSegment.hidden =NO;self.btnBackToSelect.hidden = NO;
        
    }]];
    
#pragma mark -- 添加查看当前SDK版本信息
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"Restore For Free") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
        
        if (transactions.count >= 1) {
            
            for (NSInteger count = transactions.count; count > 0; count--) {
                
                SKPaymentTransaction* transaction = [transactions objectAtIndex:count-1];
                
                if (transaction.transactionState == SKPaymentTransactionStatePurchased||transaction.transactionState == SKPaymentTransactionStateRestored) {
                    
                    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                }
            }
        }
        
        self.viewSegment.hidden =NO;
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"View SDK Version") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [VSHUD showInfoWithContainerView:VS_RootVC.view status:[NSString stringWithFormat:@"%@:%@ GAME_ID = %@",VSLocalString(@"Current SDK Version is"),VSDK_VER,VSDK_GAME_ID]];
        self.viewSegment.hidden =NO;
        
    }]];
    
#pragma mark -- 解决ipad上弹出崩溃的情况
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = self.viewLogin;
        popPresenter.sourceRect = self.viewLogin.bounds;
        [VS_RootVC presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [VS_RootVC presentViewController:alert animated:YES completion:nil];
    }
    
}


-(void)seeLogBackToSegment{
    
    self.viewSegment.hidden =NO;self.btnBackToSelect.hidden = NO;
    [self.viewSeeLog removeFromSuperview];
    self.viewSeeLog = nil;
    
}


#pragma mark -- 布局登陆界面
-(void)layoutLoginView{
    
    if (self.viewRegister) {
        [self.viewRegister removeFromSuperview];
        self.viewRegister = nil;
    }
    
    [self.viewSegment addSubview:self.viewLogin];
    
    __weak typeof(self) weakSelf = self;
    
    [self.viewLogin loginViewBlock:^(VSLoginViewBlockType type) {
        
        switch (type) {
                
            case VSLoginViewBlockLogin:
                
                [weakSelf vsdk_loginWithEmailAndPwd];
                break;
                
            case VSLoginViewBlockShowTerm:
                
                [weakSelf vsdk_showTerm];
                break;
                
            case VSLoginViewBlockSeeLog:
                
                [self vsdk_showReceiptAndCrashLog];
                break;
                
            default:
                break;
        }
    }];
}



#pragma mark -- 布局登录界面
-(void)layoutSignUpView{
    
    // 登录view存在则移除
    if (self.viewLogin) {
        [self.viewLogin removeFromSuperview];
        self.viewLogin = nil;
    }
    
    [self.viewSegment addSubview:self.viewRegister];
    
    [self.viewRegister signUpViewBlock:^(VSSignUpViewBlockType type) {
        
        switch (type) {
            case VSSignUpViewBlockShowTerm:
                
                [self vsdk_showTerm];
                
                break;
                
            case VSSignUpViewBlockSignUp:
                
                [self vsdk_registerAccount];
                
                break;
                
            default:
                break;
        }
    }];
    
}


#pragma mark -- 已经登录过的用户下次登录调用的方法
-(void)vsdk_plarformAccountAutoLogin{
    
    VS_SHOW_TIPS_MSG(@"Logging in");
    VS_USERDEFAULTS_REOMVEVALUE(@"vsdk_nick_name");
  
    VSUser * user = [VSUserHelper executeGetCurrentUserInfo];
    
    if (!user) {

        self.viewSegment.hidden = NO; self.btnBackToSelect.hidden = NO;return;
    }
    
    [[VSDKAPI shareAPI]  loginWithEmail:user.account passWord:user.password success:^(VSDKAPI *api, id responseObject) {
        
        if (REQUESTSUCCESS){
            
            VS_HUD_HIDE;
            _isLoginSuccess = YES;_VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];_errorMsg = nil;VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
            _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
            VS_USERDEFAULTS_SETVALUE(VSDK_PLATFORM_ACCOUNT, VSDK_AUTO_LOGIN_KEY);
            [self showThirdLoginWelComeView:responseObject];
            
        }else{
            
            [self vsdk_pLogiViewHide];
            VS_HUD_HIDE;
            VS_SHOW_ERROR_STATUS(@"Login Failed");
            [[VSDKAPI shareAPI]  vsdk_sendLoginErrorLogWithErrorCode:RESPONSESTATE errorMsg:VSDK_MISTAKE_MSG];
            _isLoginSuccess = NO;
            _VSDK_LOGIN_TOKEN = nil;
            _errorMsg = VSDK_MISTAKE_MSG;
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        
        [self vsdk_pLogiViewHide];
        _isLoginSuccess = NO;_VSDK_LOGIN_TOKEN = nil;_errorMsg = @"请求错误";
        
    }];
}

/**
 在登录界面使用账号密码登录
 */
-(void)vsdk_loginWithEmailAndPwd{
    
    [self.viewLoginBg removeFromSuperview];
    
    VS_SHOW_TIPS_MSG(@"Logging in");
    VS_USERDEFAULTS_REOMVEVALUE(@"vsdk_nick_name");
    
    [[VSDKAPI shareAPI]  loginWithEmail:self.viewLogin.tfEmial.text passWord:self.viewLogin.tfPwd.text success:^(VSDKAPI *api, id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_HUD_HIDE;[self vsdk_pLogiViewShow];
            NSString  * date = [VSDeviceHelper vsdk_currentDate];
            NSString * nickName = [GETRESPONSEDATA:VSDK_PARAM_NICK_NAME];
            
            _isLoginSuccess = YES;_VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];_errorMsg = nil;VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
            _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
            
            //保存客户信息
            [self vsdk_saveUserDataWithAccount:self.viewLogin.tfEmial.text passWord:self.viewLogin.tfPwd.text loginDate:date nickName:nickName Token:_VSDK_LOGIN_TOKEN];
            
            VS_USERDEFAULTS_SETVALUE(VSDK_PLATFORM_ACCOUNT, VSDK_AUTO_LOGIN_KEY);
            [self showThirdLoginWelComeView:responseObject];
            
        }else if(BANNEDACCOUNT){
            
            VS_HUD_HIDE;VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            
        }else{
            
            VS_HUD_HIDE;
            _viewBgMask = [[UIView alloc]initWithFrame:self.viewSegment.frame];
            _viewBgMask.layer.cornerRadius = 5;
            _viewBgMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            _viewForget = [[VSForgetPswView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(ADJUSTPadAndPhonePortraitW(58), ADJUSTPadAndPhonePortraitH(146,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(526,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(ADJUSTPadAndPhoneW((1026-894)/2), ADJUSTPadAndPhoneH(146), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(600))];
            
            [_viewForget ForgetViewBlock:^(VSForgetViewBlockType type) {
                
                switch (type) {
                    case VSForgetViewBlockRetrive:
                        [self vsdk_restrivePassword];
                        break;
                        
                    case VSForgetViewBlockRetry:
                        [self vsdk_retry];
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [_viewBgMask addSubview:_viewForget];
            [_rootVc.view addSubview:_viewBgMask];
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        
    }];
    
}

#pragma mark --  保存用户信息的方法
-(void)vsdk_saveUserDataWithAccount:(NSString *)accout passWord:(NSString *)password loginDate:(NSString *)date nickName:(NSString *)nickname Token:(NSString *)token{
    
    VSUser * user = [VSUser userWithAccount:accout passWord:password Date:date nickName:nickname Token:token];
    [VSUserHelper executeSaveUserInfo:user];
    
}

#pragma mark -- 返回切换账号
-(void)vsdk_switchAccountWithObj:(id)responseObject{
    
    if (!ifWelcomeView){[_viewToast hideToast];}
    
    if ([[GETRESPONSEDATA:VSDK_PARAM_USER_TYPE]isEqualToString:@"4"]) {
        
        _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
        
        if ([VSDeviceHelper vsdk_supportablePlatform] < 3){
            
            CGFloat height = [VSDeviceHelper autoLoginPaltFormTypeTableHeight];
            _viewAutoLogin = [[VSAutoLoginView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,ADJUSTPadAndPhonePortraitH(height,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneH(height))];
            
        }else{
            
            _viewAutoLogin = [[VSAutoLoginView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
            
        }
        
        _viewAutoLogin.lbPlayerName.text = [NSString stringWithFormat:@"Guest_%@",[GETRESPONSEDATA:VSDK_PARAM_UID]];
        [_rootVc.view addSubview:_viewAutoLogin];
        _viewAutoLogin.center = _rootVc.view.center;
        _guestToken = _VSDK_LOGIN_TOKEN;
        
        [_viewAutoLogin BindViewBlock:^(VSBindAccountBlockType type) {
            
            switch (type) {
                    
                case VSBindAccountBlockPlatform:
                    //本平台绑定
                    [self vsdk_bindPlarformAccount];
                    break;
                    
                case VSBindAccountBlockApple:
                    
                    [self vsdk_bindApple];
                    break;
                    
                case VSBindAccountBlockFacebook:
                    
                    [self vsdk_bindFacebook];
                    break;
                    
                case VSBindAccountBlockGoogle:
                    
                    [self vsdk_bindGoogle];
                    break;
                    
                case VSBindAccountBlockSwitch:
                    
                    [self vsdk_backToSelectLoginView];
                    break;
                    
                case VSBindAccountBlockContinue:
                    
                    [self vsdk_loginSucceedAndContinue];
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }else{
        
        VS_USERDEFAULTS_REOMVEVALUE(VSDK_AUTO_LOGIN_KEY);
        
        if (!HadShowAst) {
#if Helper
            [self.astHelper.assitantBtn removeFromSuperview];HadShowAst = NO;
#endif
            
        }
        
        [self.viewSegment removeFromSuperview];self.viewSegment = nil;
        [self.viewLoginBg removeFromSuperview];
        self.viewAlpha.hidden = NO;
        self.viewSelect.hidden = NO;
    }
    
}

-(void)showMainLoginView{
    VS_USERDEFAULTS_REOMVEVALUE(VSDK_AUTO_LOGIN_KEY);
    
    if (!HadShowAst) {
        
#if Helper
        [self.astHelper.assitantBtn removeFromSuperview];HadShowAst = NO;
#endif
        
       
    }
    
    [self.viewSegment removeFromSuperview];
    self.viewSegment = nil;
    [self.viewLoginBg removeFromSuperview];
    self.viewAlpha.hidden = NO;
    self.viewSelect.hidden = NO;
    [self.btnBackToSelect setImage:[UIImage imageNamed:kSrcName(@"")] forState:UIControlStateNormal];
}

#pragma mark -- 找回密码点击发送时间倒数
-(void)vsdk_countdownWithSeconds:(NSInteger)seconds{
    
    __block NSInteger time = seconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewRetrieve.btnSend setTitle:VSLocalString(@"Send") forState:UIControlStateNormal];
                [self.viewRetrieve.btnSend setBackgroundColor:VSDK_WARN_COLOR];
                self.viewRetrieve.btnSend.enabled = YES;
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewRetrieve.btnSend setBackgroundColor:VSDK_LIGHT_GRAY_COLOR];
                self.viewRetrieve.btnSend.enabled = NO;
                [self.viewRetrieve.btnSend setTitle:[NSString stringWithFormat:@"%.1lds", (long)time] forState:UIControlStateNormal];
            });
            
            time--;
        }
    });
    
    dispatch_resume(_timer);
}


#pragma mark --  找回密码事件
-(void)vsdk_restrivePassword{
    
    VS_USERDEFAULTS_SETVALUE(self.viewLogin.tfEmial.text, @"vsdk_reset_password_email");
    self.viewSegment.hidden = YES;
    
    UIView * view = [_viewForget superview];
    [view removeFromSuperview];
    
    _viewRetrieve = [[VSRetrieveView alloc]initWithFrame:self.viewSegment.frame];
    [_rootVc.view addSubview:_viewRetrieve];
    
    [_viewRetrieve retriveViewBlock:^(VSRetriveViewBlockType type) {
        switch (type) {
            case VSRetriveViewBlockBack:
                
                [self vsdk_backToRetrive];
                break;
                
            case VSRetriveViewBlockSend:
            
                [self vsdk_sendEmailCapthaCode];
                break;
                
            case VSRetriveViewBlockComfirm:
                
                [self comfirmVertifyWithTokenStr:_emailToken];
                break;
                
            default:
                
                break;
        }
    }];
}

#pragma mark -- 取消验证返回找回密码
-(void)vsdk_backToRetrive{
    
    self.viewSegment.hidden = NO;
    [_viewRetrieve removeFromSuperview];
    _viewRetrieve = nil;
}

#pragma maek -- 找回密码事件发送验证码
-(void)vsdk_sendEmailCapthaCode{
    
    NSString * email = self.viewRetrieve.tfEmail.text;
    //邮箱判断正则
    BOOL success = [VSDeviceHelper RegexWithString:email pattern:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$"];
    
    if (success == NO) {
        
        VS_SHOW_INFO_MSG(@"Invalid mailbox");
        
    }else{
        
        VS_SHOW_TIPS_MSG(@"Send...");
        [[VSDKAPI shareAPI]  vsdk_retrievePwdWithEmail:email success:^(VSDKAPI *api, id responseObject) {
            
            VS_HUD_HIDE;
            
            if (REQUESTSUCCESS) {
                
                VS_SHOW_SUCCESS_STATUS(@"Sent");
                [self vsdk_countdownWithSeconds:120];
                _emailToken = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
                
            }else{
                
                VS_SHOW_ERROR_STATUS(@"Error");
                [self vsdk_countdownWithSeconds:10];
                
            }
            
        } failure:^(VSDKAPI *api, NSString *failure) {
            VS_HUD_HIDE;
        }];
        
    }
}

#pragma mark -- 提交验证
-(void)comfirmVertifyWithTokenStr:(NSString *)emailToken{
    
    NSString * vertifyCode = self.viewRetrieve.tfVertify.text;
    
    if (vertifyCode.length == 0) {
        
        VS_SHOW_INFO_MSG(@"Please Enter Verification Code");return;
    }
    
    VS_SHOW_TIPS_MSG(@"Verifying...");
    [[VSDKAPI shareAPI]  vsdk_vertifyMailboxWithToken:_emailToken vertifyCode:vertifyCode success:^(VSDKAPI *api, id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_HUD_HIDE;
            VS_SHOW_SUCCESS_STATUS(@"Verified");
            _changePwdToken = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
            _viewPwdedit = [[VSEditPassWord alloc]initWithFrame:self.viewSegment.frame];
            _viewPwdedit.labelAccount.text  = self.viewRetrieve.tfEmail.text;
            
            [_viewPwdedit passwordViewBlock:^(VSEditPswViewBlockType type) {
                switch (type) {
                    case VSEditPswViewBlockBack:
                        
                        [self.viewPwdedit removeFromSuperview];
                        
                        break;
                        
                    case VSEditPswViewBlockComfirm:
                        
                        [self vsdk_comfirmNewPwdWithToken:_changePwdToken];
                        
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            [_rootVc.view addSubview:_viewPwdedit];
            
        }else{
            
            VS_HUD_HIDE;
            VS_SHOW_SUCCESS_STATUS(@"Vertify failed");
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        
        VS_HUD_HIDE;
        
    }];
}


#pragma mark -- 找回密码事件
//找回密码View 提交新密码事件
-(void)vsdk_comfirmNewPwdWithToken:(NSString *)tokenStr{
    
    VS_SHOW_TIPS_MSG(@"Changing...");
    
    [[VSDKAPI shareAPI] updateNewPwd:self.viewPwdedit.tfNewPwd.text tokenStr:tokenStr success:^(id responseObject) {
        
        VS_HUD_HIDE;
        
        if (REQUESTSUCCESS) {
            
            VS_SHOW_SUCCESS_STATUS(@"Change Succeed!");
            [self jumpToLoginView];
            
        }else{
            
            VS_SHOW_ERROR_STATUS(@"Change failed,please retry!");
        }
        
    } failure:^(NSString *failure) {
        
    }];
}


#pragma mark -- 修改密码成功返回登录界面的方法
-(void)jumpToLoginView{
    
    self.viewSegment.hidden = NO;
    [_viewRetrieve removeFromSuperview];
    _viewRetrieve = nil;
    [_viewPwdedit removeFromSuperview];
    _viewPwdedit = nil;
}


/**
 重试登陆事件
 */
#pragma mark --  取消找回密码重新尝试登录的方法
-(void)vsdk_retry{
    
    UIView * view = [_viewForget superview];
    [view removeFromSuperview];
}


-(void)vsdk_autoLogin{
    
    if ([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY) isEqualToString:VSDK_APPLE]) {
        
        if (@available(iOS 13.0, *)) {
            
            // 基于用户的Apple ID 生成授权用户请求的机制
            ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
            // 注意 存储用户标识信息需要使用钥匙串来存储 这里使用NSUserDefaults 做的简单示例
            NSString *userIdentifier = [VSKeychain load:@"kVsdkAppleUserIdentifier"];
            
            if (userIdentifier) {
                
                [appleIDProvider getCredentialStateForUserID:userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
                    
                    switch (credentialState) {
                        case ASAuthorizationAppleIDProviderCredentialRevoked:
                            [self vsdk_loginWithUserType:VSDK_APPLE];
                            
                            break;
                            
                        case ASAuthorizationAppleIDProviderCredentialAuthorized:

                            [self vsdk_appleAutoLogin];
                            
                            break;
                        case ASAuthorizationAppleIDProviderCredentialNotFound:
                            
                            break;
                            
                        default:
                            break;
                    }
                    
                }];
                
            }else{
                
                [self vsdk_loginWithUserType:VSDK_APPLE];
            }
        }
        
    }else if ([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY) isEqualToString:VSDK_PLATFORM_ACCOUNT]){
        
        [self vsdk_plarformAccountAutoLogin];
        
    }else if([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY) isEqualToString:VSDK_FACEBOOK]){
        
        [self vsdk_signInWithThirdType:VSDK_FACEBOOK];
        
    }else if([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY) isEqualToString:VSDK_GOOGLE]){
        
        [self vsdk_signInWithThirdType:VSDK_GOOGLE];
        
    }else if([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY) isEqualToString:VSDK_TWITTER]){
        
        [self vsdk_signInWithThirdType:VSDK_TWITTER];
        
    }else{
        
        if ([[VS_USERDEFAULTS objectForKey:@"vsdk_guest_login_count"] intValue] >= 1) {
            
            [self vsdK_guestSignIn];
            
        }else{
            
            self.viewSelect.hidden = NO;self.viewAlpha.hidden = NO;
        }
    }
}


-(void)vsdK_guestSignIn{
    
    VS_SHOW_TIPS_MSG(@"Logging in");
    
    [[VSDKAPI shareAPI]  loginWithUserType:VSDK_PARAM_GUEST_TYPE token:nil success:^(VSDKAPI *api, id responseObject) {
        
        VS_HUD_HIDE;
        
        if (REQUESTSUCCESS) {
            
            if ([[GETRESPONSEDATA:VSDK_PARAM_USER_TYPE] isEqualToString:@"4"]) {
                
                _guestToken = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_PARAM_NICK_NAME],@"vsdk_nick_name");
                
            }
            
            _isLoginSuccess = YES;_VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];_errorMsg = nil;VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);_VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
            
            VS_USERDEFAULTS_SETVALUE(_VSDK_LOGIN_TOKEN,VSDK_PARAM_GUEST_TOKEN);
            VS_USERDEFAULTS_SETVALUE(VSDK_GUEST, VSDK_AUTO_LOGIN_KEY);
            
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_PARAM_NICK_NAME],VSDK_GUEST_NICKNAME);
            
            [self showThirdLoginWelComeView:responseObject];
            
        }else if (BANNEDACCOUNT){
            
            [self vsdk_pLogiViewHide];
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            
        }else{
            
            [self vsdk_pLogiViewHide];
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            self.loginCallback(NO, nil, VSDK_MISTAKE_MSG);
            
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        
        [self vsdk_pLogiViewHide];
        VS_HUD_HIDE;
        
    }];
    
}

#pragma mark -- 判断游客是否初次登录

-(void)vsdk_guestFirstLogin{
    
    if (![VS_USERDEFAULTS valueForKey:@"vsdk_guest_login_count"]) {
        
        VS_USERDEFAULTS_SETVALUE(@"1" ,@"vsdk_guest_login_count");
        
    }else{
        
        int guestLoginCount = [[VS_USERDEFAULTS valueForKey:@"vsdk_guest_login_count"]intValue];
        guestLoginCount += 1;
        [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%d",guestLoginCount] forKey:@"vsdk_guest_login_count"];
    }
    
}

#pragma mark -- 第三方登录的方法
-(void)vsdk_loginWithUserType:(NSString *)userType {
    //每次登录苹果授权码置为空
    VS_USERDEFAULTS_SETVALUE(@"", VSDK_APPLE_AUTH_CODE);
    self.viewAlpha.hidden = YES;self.viewSelect.hidden = YES;
    
    VS_USERDEFAULTS_REOMVEVALUE(@"vsdk_nick_name");
    
    self.viewSegment.hidden = YES;
    
    if ([userType isEqualToString:VSDK_APPLE]) {
        
        if (@available(iOS 13.0, *)) {
            
            ASAuthorizationAppleIDRequest *authAppleIDRequest = [[ASAuthorizationAppleIDProvider new] createRequest];
            authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
            ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[authAppleIDRequest]];
            authorizationController.delegate = self;
            authorizationController.presentationContextProvider = self;
            [authorizationController performRequests];
            
        }
        
    }else if ([userType isEqualToString:VSDK_FACEBOOK]){
        
        [self vsdk_signInWithThirdType:VSDK_FACEBOOK];
        
    }else if([userType isEqualToString:VSDK_GOOGLE]){
        
        [self vsdk_signInWithThirdType:VSDK_GOOGLE];
        
    }else if([userType isEqualToString:VSDK_TWITTER]){
        
        [self vsdk_signInWithThirdType:VSDK_TWITTER];
        
    }else{
        
        VS_SHOW_TIPS_MSG(@"Logging in");
        
        [[VSDKAPI shareAPI] loginWithUserType:userType token:nil success:^(VSDKAPI *api, id responseObject) {
            
            
            
            VS_HUD_HIDE;
            //游客登录成功
            if (REQUESTSUCCESS) {
                
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_PARAM_NICK_NAME],@"vsdk_nick_name");
                _guestToken = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
       
                _isLoginSuccess = YES;
                _VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
                _errorMsg = nil;
                _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
                
                //存储绑定奖励凭证
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
                
                VS_USERDEFAULTS_SETVALUE(_VSDK_LOGIN_TOKEN,VSDK_PARAM_GUEST_TOKEN);
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_PARAM_NICK_NAME],VSDK_GUEST_NICKNAME);
                VS_USERDEFAULTS_SETVALUE(VSDK_GUEST, VSDK_AUTO_LOGIN_KEY);
                
                [self showThirdLoginWelComeView:responseObject];
                
            }else if (BANNEDACCOUNT){
                [self vsdk_pLogiViewHide];
                VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
                
            }else{
                
                [self vsdk_pLogiViewHide];
                VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
                self.loginCallback(NO, nil, VSDK_MISTAKE_MSG);
            }
            
        } failure:^(VSDKAPI *api, NSString *failure) {
            
            [self vsdk_pLogiViewHide];
            
        }];
    }
}


-(void)vsdk_bindAppleIdToken:(NSString *)idToken{
    
    [[VSDKAPI shareAPI] vsdk_bindAccountWithUserType:VSDK_APPLE token:idToken guestToken:_guestToken success:^(VSDKAPI *api, id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_SHOW_SUCCESS_STATUS(@"Bound");
            ifBindApple = NO;
            _isLoginSuccess = YES;_VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];_errorMsg = nil;
            _VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
            
            [self vsdk_loginSucceedAndContinue];
            
        }else{
            
            ifBindApple = NO;
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) { ifBindApple = NO;}];
}




-(void)vsdk_guestBindIfShowSelectView{
    
    if ([VS_USERDEFAULTS_GETVALUE(VSDK_AUTO_LOGIN_KEY)isEqualToString:VSDK_GUEST]) {
        
        [self.viewSegment removeFromSuperview];self.viewSegment = nil;
        
    }else{
        
        self.viewSelect.hidden = NO;self.viewAlpha.hidden = NO;
        [self.viewSegment removeFromSuperview];self.viewSegment = nil;
    }
    
}

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    
    return _rootVc.view.window;
}



#pragma mark -- ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])       {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        NSString *authCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *userID = credential.user;
        
        VS_USERDEFAULTS_SETVALUE(identityToken,VSDK_APPLE_TOKEN_KEY);
        VS_USERDEFAULTS_SETVALUE(authCode, VSDK_APPLE_AUTH_CODE);
        
        if (ifBindApple) {
            
            [self vsdk_bindAppleIdToken:[VS_USERDEFAULTS valueForKey:VSDK_APPLE_TOKEN_KEY]];
            
        }else{
            
            [VSKeychain save:@"kVsdkAppleUserIdentifier" data:userID];
            [self vsdk_appleAutoLogin];
            
        }
        
    }else if([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        
    }else{
        
    }
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    
    [self vsdk_guestBindIfShowSelectView];
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            
            VS_SHOW_INFO_MSG(@"Authorization Canceled");
            break;
            
        case ASAuthorizationErrorFailed:
            
            VS_SHOW_INFO_MSG(@"Authorization Failed");
            break;
        case ASAuthorizationErrorInvalidResponse:
            
            
            VS_SHOW_INFO_MSG(@"No Authorization Response");
            break;
        case ASAuthorizationErrorNotHandled:
            
            VS_SHOW_INFO_MSG(@"Authorization Not Handled");
            break;
        case ASAuthorizationErrorUnknown:
            
            VS_SHOW_INFO_MSG(@"Unknown Authorization Error");
            break;
            
        default:
            break;
    }
}



-(void)vsdk_appleAutoLogin{
    
    [[VSDKAPI shareAPI] loginWithUserType:VSDK_APPLE token:[VS_USERDEFAULTS valueForKey:VSDK_APPLE_TOKEN_KEY] success:^(VSDKAPI *api, id responseObject) {
        
        VS_HUD_HIDE;
        
        if (REQUESTSUCCESS) {
            
            _isLoginSuccess = YES; _VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];_errorMsg = nil;VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
            _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
            _errorMsg = nil;
            
            VS_USERDEFAULTS_SETVALUE(VSDK_APPLE, VSDK_AUTO_LOGIN_KEY);
            [self showThirdLoginWelComeView:responseObject];
          
            
        }else  if(BANNEDACCOUNT){
            
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            
        }else{
            self.viewAlpha.hidden = YES;self.viewSelect.hidden = YES;
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            [VSKeychain delete:@"kVsdkAppleUserIdentifier"];
            self.loginCallback(NO, nil, VSDK_MISTAKE_MSG);
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        VS_HUD_HIDE;
    }];
    
}


#pragma mark -- 显示登录成功选择切换界面
-(void)showThirdLoginWelComeView:(id)responseObject{

    NSDictionary * dic = @{@"1":@"Email",@"2":@"Facebook",@"3":@"Google",@"4":@"Guest",@"5":@"Twitter",@"9":@"Naver",@"10":@"Apple"};
    
    VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
    
    if ([[VS_USERDEFAULTS valueForKey:@"vsdk_guest_login_count"] intValue] >= 1 &&[[VS_USERDEFAULTS valueForKey:VSDK_AUTO_LOGIN_KEY] isEqualToString:VSDK_GUEST]) {
        
        ifWelcomeView = YES;
        [self vsdk_switchAccountWithObj:responseObject];
        
    }else{
        
        NSString * context;
        
        if (kiPhone5 || kiPhone4) {
           
            context = [NSString stringWithFormat:@"%@_%@",[dic objectForKey:[GETRESPONSEDATA:VSDK_PARAM_USER_TYPE]],[GETRESPONSEDATA:VSDK_PARAM_UID]];
        }else{
            
            context = [NSString stringWithFormat:@"%@%@_%@",VSLocalString(@"Welcome,"),[dic objectForKey:[GETRESPONSEDATA:VSDK_PARAM_USER_TYPE]],[GETRESPONSEDATA:VSDK_PARAM_UID]];
        }
   
        self.viewToast = [[VSToast alloc] initWithImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_account")] content: context];
        
        __strong typeof(self)StrongSelf = self;
        
        [self.viewToast setToastBlock:^(VSToastViewBlockType type) {
            switch (type) {
                case VSToastViewBlockSwitch:
                    HadShowAst = NO;
                    [StrongSelf vsdk_switchAccountWithObj:responseObject];
                    break;
                    
                case VSToastViewBlockEnterGame:
                    
                    [StrongSelf vsdk_loginSucceedAndContinue];
                    [StrongSelf vsdk_guideToBindSecurityEmailWithObj:responseObject];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self.viewToast showToast];
    }
}



//引导平台账号登录的玩家去绑定安全邮箱
-(void)vsdk_guideToBindSecurityEmailWithObj:(id)responseObject{
    
    NSString * uLoginCount = [NSString stringWithFormat:@"%@_%@",VSDK_U_LOGIN_COUNT,_VSDK_UID];
    
    if (!VS_USERDEFAULTS_GETVALUE(uLoginCount)) {
        
        VS_USERDEFAULTS_SETVALUE(@"1", uLoginCount);
        
    }else{
        
        int cou = [VS_USERDEFAULTS_GETVALUE(uLoginCount) intValue];
        cou += 1;
        NSString * couStr =  [NSString stringWithFormat:@"%d",cou];
        VS_USERDEFAULTS_SETVALUE(couStr, uLoginCount);
    }
    
    if ([VS_USERDEFAULTS_GETVALUE(uLoginCount) intValue] >= 10) {
        
        if ([[GETRESPONSEDATA:VSDK_PARAM_USER_TYPE] isEqualToString:@"1"]||[[GETRESPONSEDATA:VSDK_PARAM_USER_TYPE] isEqual:@1]) {
            
            [self vsdk_bindSecurityLogicWithObj:responseObject];
        }
    }
}

#pragma mark -- 绑定安全邮箱逻辑
-(void)vsdk_bindSecurityLogicWithObj:(id)responseObject{
    
    if ([[GETRESPONSEDATA:VSDK_PARAM_BIND_MAIL] length] == 0) {
        
        if (!VS_USERDEFAULTS_GETVALUE(kSdkNextTimeCount(_VSDK_UID))) {
            
            VS_USERDEFAULTS_SETVALUE(@"1",kSdkNextTimeCount(_VSDK_UID));
            
        }else{
            
            int nextTimeCount = [[VS_USERDEFAULTS valueForKey:kSdkNextTimeCount(_VSDK_UID)] intValue];
            nextTimeCount += 1;
            [VS_USERDEFAULTS setValue:[NSString stringWithFormat:@"%d",nextTimeCount] forKey:kSdkNextTimeCount(_VSDK_UID)];
        }
        
        if (!VS_USERDEFAULTS_GETVALUE(kSdkNextTimeBind(_VSDK_UID))||[VS_USERDEFAULTS_GETVALUE(kSdkNextTimeBind(_VSDK_UID)) isEqual:@0]) {
            
            _viewaskBindBg = [[UIView alloc]initWithFrame:_rootVc.view.frame];
            _viewaskBindBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
            [_rootVc.view addSubview:_viewaskBindBg];
            
            _viewAskToBind  = [[VSAskToBindView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(ADJUSTPadAndPhonePortraitW(58), ADJUSTPadAndPhonePortraitH(146,[VSDeviceHelper  getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(526,[VSDeviceHelper  getExpansionFactorWithphoneOrPad])):CGRectMake(ADJUSTPadAndPhoneW((1026-894)/2), ADJUSTPadAndPhoneH(146), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(600))];
            _viewAskToBind.center = _rootVc.view.center;
            
            [_viewAskToBind askToBindViewBlock:^(VSAskToBindBlockType type) {
                
                switch (type) {
                    case VSAskToBindBlockTypeOK:
                        
                        [self vsdk_comfirmBindEmail];
                        
                        break;
                        
                    case VSAskToBindBlockTypeNextTime:
                        
                        [self vsdk_bindEmialNextTime];
                        
                        break;
                    default:
                        break;
                }
                
            }];
            
            [_viewaskBindBg addSubview:_viewAskToBind];
            
        }else{
            
            int nextTimeCount = [[VS_USERDEFAULTS valueForKey:kSdkNextTimeCount(_VSDK_UID)] intValue];
            
            if (nextTimeCount % 30 == 0) {
                
                _viewaskBindBg = [[UIView alloc]initWithFrame:_rootVc.view.frame];
                _viewaskBindBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
                [_rootVc.view addSubview:_viewaskBindBg];
                
                _viewAskToBind  = [[VSAskToBindView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(ADJUSTPadAndPhonePortraitW(58), ADJUSTPadAndPhonePortraitH(146,[VSDeviceHelper  getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(526,[VSDeviceHelper  getExpansionFactorWithphoneOrPad])):CGRectMake(ADJUSTPadAndPhoneW((1026-894)/2), ADJUSTPadAndPhoneH(146), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(600))];
                _viewAskToBind.center = _rootVc.view.center;
                
                [_viewAskToBind askToBindViewBlock:^(VSAskToBindBlockType type) {
                    
                    switch (type) {
                        case VSAskToBindBlockTypeOK:
                            
                            [self vsdk_comfirmBindEmail];
                            
                            break;
                            
                        case VSAskToBindBlockTypeNextTime:
                            
                            [self vsdk_bindEmialNextTime];
                            
                            break;
                        default:
                            break;
                    }
                    
                }];
                
                [_viewaskBindBg addSubview:_viewAskToBind];
                
            }
        }
    }
}


/// 确认绑定安全邮箱
-(void)vsdk_comfirmBindEmail{
    
    self.viewaskBindBg.hidden = YES;
    
    if (!_viewBindSecuruty) {
        
        _viewBindSecuruty = [[VSBindSecurityView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper  getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,ADJUSTPadAndPhonePortraitH(777,[VSDeviceHelper  getExpansionFactorWithphoneOrPad])):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
        
    }else{
        
        if (_viewBindSecuruty.hidden == YES) {
            
            _viewBindSecuruty.hidden = NO;
        }
        
    }
    _viewBindSecuruty.center = _rootVc.view.center;
    
    [_rootVc.view addSubview:_viewBindSecuruty];
    
    [_viewBindSecuruty bindSecurityViewBlock:^(VSBindSecurityViewBlockType type) {
        
        switch (type) {
                
            case VSBindSecurityViewBlockBack:
                
                [self vsdk_backToWelcomePage];
                
                break;
                
            case VSBindSecurityViewBlockComfirm:
                
                [self vsdk_comfirmBindSecurityMainBox];
                
                break;
                
            case VSBindSecurityViewBlockSend:
                
                [self vsdk_sendSecurityVertifyCode];
                
                break;
                
            default:
                break;
        }
    }];
    
}

-(void)vsdk_backToWelcomePage{
    
    [self vsdk_bindEmialNextTime];
    self.viewAskToBind.hidden = NO;
    self.viewBindSecuruty.hidden = YES;
    
}


-(void)vsdk_comfirmBindSecurityMainBox{
    
    VS_SHOW_SUCCESS_STATUS(@"Binding...");
    
    NSString * bindMail = self.viewBindSecuruty.tfEmail.text;
    NSString * code = self.viewBindSecuruty.tfVertify.text;
    
    if (code.length<6) {
        
        VS_SHOW_INFO_MSG(@"Incorrect Verification Code");
        
    }else{
        
        [[VSDKAPI shareAPI] ucBindSecurityEmainWithToken:_VSDK_LOGIN_TOKEN BindMail:bindMail VertifyCode:code success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                VS_HUD_HIDE;
                VS_SHOW_SUCCESS_STATUS(@"Bound");
                
                [self.viewBindSecuruty removeFromSuperview];
                [self vsdk_bindEmialNextTime];
            }else{
                
                VS_SHOW_INFO_MSG(@"Binding failed,please retry" );
            }
            
        } failure:^(NSString *failure) {
            VS_HUD_HIDE;
        }];
    }
    
}

-(void)vsdk_sendSecurityVertifyCode{
    
    NSString * bindMail = self.viewBindSecuruty.tfEmail.text;
    
    VS_SHOW_TIPS_MSG(@"Send...");
    
    [[VSDKAPI shareAPI] postSecurityCodeWithToken:_VSDK_LOGIN_TOKEN BindMail:bindMail success:^(id responseObject) {
        VS_HUD_HIDE;
        if (REQUESTSUCCESS) {
            
            VS_SHOW_SUCCESS_STATUS(@"Sent");
            [self vsdk_countdownWithSeconds:180];
            
        }else{
            VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            [self vsdk_countdownWithSeconds:10];
            
        }
        
    } failure:^(NSString *failure) {VS_HUD_HIDE;}];
}


/// 取消绑定安全邮箱
-(void)vsdk_bindEmialNextTime{
    
    VS_USERDEFAULTS_SETVALUE(@YES,kSdkNextTimeBind(_VSDK_UID));
    [self.viewaskBindBg removeFromSuperview];
    self.viewaskBindBg = nil;
    [self.viewAskToBind removeFromSuperview];
    self.viewAskToBind = nil;
}


#pragma mark -- 返回登录界面
-(void)vsdk_backToSelectLoginView{
#if Helper
    [self.astHelper.assitantBtn removeFromSuperview];
#endif
    
    HadShowAst = NO;
    self.viewSegment.hidden = NO;
    self.btnBackToSelect.hidden = NO;
    self.viewAlpha.hidden = NO;
    self.viewSelect.hidden = NO;
    [self.viewAutoLogin removeFromSuperview];
}


#pragma mark --  本平台绑定
-(void)vsdk_bindPlarformAccount{
    
    //隐藏游客登录绑定界面
    _viewAutoLogin.hidden = YES;
    _viewBindSegment = [[VSBindSegmentView alloc]initWithFrame:  DEVICEPORTRAIT?CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 20,VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(_rootVc.view.center.x - self.viewSegment.frame.size.width/2, 5,VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
    
    [self layoutThirdView];
    
    _viewBindSegment.center = _rootVc.view.center;
    [_rootVc.view addSubview:self.viewBindSegment];
    
    __weak typeof(self) weakself = self;
    
    [self.viewBindSegment setSegmentViewBlock:^(VSBindSegmentViewBlockType type) {
        
        switch (type) {
                
            case VSBindSegmentViewBlockBack:
                
                [weakself vsdk_backToBind];
                
                break;
                
            default:
                break;
        }
    }];
}


-(void)vsdk_bindApple{
    
    if (@available(iOS 13.0, *)) {
        
        ifBindApple = YES;
        
        ASAuthorizationAppleIDRequest *authAppleIDRequest = [[ASAuthorizationAppleIDProvider new] createRequest];
        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[authAppleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
        
    }
}

-(void)vsdk_bindFacebook{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithPermissions:@[@"public_profile", @"email"]  fromViewController:_rootVc handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            
            VS_SHOW_ERROR_STATUS(@"Binding Failed");
            
        }else if (result.isCancelled){
            
            VS_SHOW_INFO_MSG(@"Canceled");
            
        } else{
            
            [self vsdk_bindThirdtWithType:VSDK_FACEBOOK Token:[FBSDKAccessToken currentAccessToken].tokenString GuestToken:_guestToken];
            
        }
    }];
    
}

#pragma mark-- 绑定谷歌账号
-(void)vsdk_bindGoogle{
    
    self.vsdkGgEventType = kThirdBindType;

    GIDConfiguration * config = [[GIDConfiguration alloc]initWithClientID:VSDK_GOOGLE_CLIENTID];
    [[GIDSignIn sharedInstance] signInWithConfiguration:config presentingViewController:VS_RootVC callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
       
            
#warning -- 在这里进行google 授权相关操作
        if (error) {
            
            VS_HUD_HIDE;[self vsdk_pLogiViewHide];return;
        }
        
        if ([self.vsdkGgEventType isEqualToString:kThirdLoginType]) {
            
            [self vsdk_loginThirdWithType:VSDK_GOOGLE Token:user.authentication.idToken];
            
        }else{
            
            [self vsdk_bindThirdtWithType:VSDK_GOOGLE Token:user.authentication.idToken GuestToken:_guestToken];
            
        }

        
    }];
    
}


#pragma Mark -- 谷歌代理方法登录错误
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error{
    
    VS_HUD_HIDE
    
}

#pragma mark  -- GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    if (error) {
        
        VS_HUD_HIDE;[self vsdk_pLogiViewHide];return;
    }
    
    if ([self.vsdkGgEventType isEqualToString:kThirdLoginType]) {
        
        [self vsdk_loginThirdWithType:VSDK_GOOGLE Token:user.authentication.idToken];
        
    }else{
        
        [self vsdk_bindThirdtWithType:VSDK_GOOGLE Token:user.authentication.idToken GuestToken:_guestToken];
        
    }
    
}


-(void)vsdk_loginThirdWithType:(NSString *)type Token:(NSString *)token{
    
    VS_SHOW_TIPS_MSG(@"Logging in");
    
    [[VSDKAPI shareAPI] loginWithUserType:type token:token success:^(VSDKAPI *api, id responseObject) {
        
        VS_HUD_HIDE;
        
        if (REQUESTSUCCESS) {
            
            //存储自动登录标识
            VS_USERDEFAULTS_SETVALUE(type, VSDK_AUTO_LOGIN_KEY);
            _isLoginSuccess = YES; _VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];_errorMsg = nil;
            _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
            
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
            
            [self showThirdLoginWelComeView:responseObject];
            
        }else  if(BANNEDACCOUNT){
            
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
        }else{
            
            [self vsdk_pLogiViewHide];
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            if ([type isEqualToString:VSDK_APPLE]) {
                
                [VSKeychain delete:@"kVsdkAppleUserIdentifier"];
            }
            [[VSDKAPI shareAPI] vsdk_sendLoginErrorLogWithErrorCode:RESPONSESTATE errorMsg:VSDK_MISTAKE_MSG];
            self.loginCallback(NO, nil, VSDK_MISTAKE_MSG);
            
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        [self vsdk_pLogiViewHide];
        
    }];
    
}



/// 绑定三方平台
/// @param type 平台类型
/// @param token 登录token
/// @param guestToken 游客token
-(void)vsdk_bindThirdtWithType:(NSString *)type Token:(NSString*)token GuestToken:(NSString *)guestToken{
    
    VS_SHOW_TIPS_MSG(@"Binding...")
    
    [[VSDKAPI shareAPI] vsdk_bindAccountWithUserType:type token:token guestToken:guestToken success:^(VSDKAPI *api, id responseObject) {
        
        VS_HUD_HIDE
        
        if (REQUESTSUCCESS) {
            
            _isLoginSuccess = YES;_VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];_errorMsg = nil;
            _VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
            
            VS_SHOW_SUCCESS_STATUS(@"Bound");
            
            [self vsdk_loginSucceedAndContinue];
            
            VS_USERDEFAULTS_SETVALUE(type, VSDK_AUTO_LOGIN_KEY);
    
        }else{
            
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {VS_HUD_HIDE}];
    
}

#pragma mark -- GIDSignDelegate
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    VS_HUD_HIDE;[self vsdk_pLogiViewHide];
}


//返回绑定
-(void)vsdk_backToBind{
    
    self.viewAutoLogin.hidden = NO;
    [self.viewBindSegment removeFromSuperview];
    self.viewBindSegment = nil;
}


#pragma mark -- 停止绑定继续游戏的方法
-(void)vsdk_loginSucceedAndContinue{
    
    [self.viewAlpha removeFromSuperview];self.viewAlpha = nil;[self.viewSelect removeFromSuperview];self.viewSelect = nil;
    //回调登录信息
    self.loginCallback(_isLoginSuccess, _VSDK_LOGIN_TOKEN, _errorMsg);
    //存储用户登录的user_id
    VS_USERDEFAULTS_SETVALUE(_VSDK_UID, VSDK_GAME_UID_KEY);
    VS_USERDEFAULTS_SETVALUE(_VSDK_LOGIN_TOKEN, VSDK_LEAST_TOKEN_KEY);
    VS_USERDEFAULTS_SETVALUE(self.viewLogin.tfEmial.text, @"vsdk_reset_password_email");
    
    ifWelcomeView = NO;
    
    [self vsdk_guestFirstLogin];
    self.viewSegment.clickCount = 0;
    [self.viewSegment removeFromSuperview];
    self.viewSegment = nil;
    [self.btnBackToSelect removeFromSuperview];
    self.btnBackToSelect = nil;
    [self.viewLogin removeFromSuperview];
    self.viewLogin = nil;
    [self.viewRegister removeFromSuperview];
    self.viewRegister = nil;
    [self.viewLoginBg removeFromSuperview];
    self.viewLoginBg = nil;
    [self .viewLoginBg removeFromSuperview];
    self.viewLoginBg = nil;
    [self.viewBindSegment removeFromSuperview];
    [self.viewBindSecuruty removeFromSuperview];
    self.viewBindSecuruty = nil;
    [self.viewAutoLogin removeFromSuperview];
    self.viewAutoLogin = nil;
    [self.viewThirdBind removeFromSuperview];
    self.viewThirdBind = nil;
    
    [[[VSDKEventHelper alloc]init] vsdk_platformBehaviorRecordWith:_VSDK_UID];
    [VSDKTPInitHelper vsdk_saveUcGiftState];
    
    self.timerRefresh = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(vsdk_latestRefreshedToken) userInfo:nil repeats:YES];
    //登录成功显示浮球
    [self vsdk_showAssistantBtnWithRolevel:nil];
    
    //显示普通公告。
    [self vsdk_popUpGameBulletinPage];

    [self vsdk_requestTrackingAuthorizedWithBlock:^(BOOL isAuthorized) {
            
      [[FBSDKSettings sharedSettings]setAdvertiserTrackingEnabled:YES];
        
            
    }];

    
    
    
}

-(void)vsdk_showAssistantBtnWithRolevel:(NSString *)level{
    
    if (!HadShowAst) {
        
        if ([VSDeviceHelper vsdk_floatballtShowWithRolevel:level]) {
#if Helper
        [self vsdk_assistantToolshow];
        HadShowAst = YES;
    
#endif
          
        }
    }
}


/// 刷新登录token
-(void)vsdk_latestRefreshedToken{
    
    NSString *currentToken = VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY);
    
    [[VSDKAPI shareAPI] vsdk_refreshTokenWitholdToken:currentToken Success:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_PARAM_TOKEN],VSDK_LEAST_TOKEN_KEY);
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


-(void)vsdk_askForCustomerService{
    
    VS_USERDEFAULTS_SETVALUE(@NO, @"vsdk_show_red_point");hadShowBadge = NO;
    [VSDeviceHelper showTermOrContactCustomerServiceWithUrl:[VSDeviceHelper vsdk_customServiceUrl]];
    
}


#pragma mark -- 平台账号注册绑定
-(void)vsdk_registerAndBind{
    
    VS_SHOW_TIPS_MSG(@"Register and Binding..." );
    [[VSDKAPI shareAPI]  vsdk_registerAndBindWithToken:_guestToken Email:self.viewThirdBind.tfEmail.text Password:self.viewThirdBind.tfPwd.text success:^(VSDKAPI *api, id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_HUD_HIDE;
            VS_SHOW_SUCCESS_STATUS(@"Register and Bind Succeed");
            
            _isLoginSuccess = YES;_VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];_errorMsg = nil;VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
            _VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];
            
            //获取当前时间
            NSString * date = [VSDeviceHelper vsdk_currentDate];
            [self vsdk_saveUserDataWithAccount:self.viewThirdBind.tfEmail.text passWord:self.viewThirdBind.tfPwd.text loginDate:date nickName:[GETRESPONSEDATA:VSDK_PARAM_NICK_NAME] Token:[GETRESPONSEDATA:VSDK_PARAM_TOKEN]];
            
            VS_USERDEFAULTS_SETVALUE(VSDK_PLATFORM_ACCOUNT, VSDK_AUTO_LOGIN_KEY);
            
            [self vsdk_loginSucceedAndContinue];
            
        }else{
            
            VS_HUD_HIDE;
            VS_SHOW_ERROR_STATUS(@"Bind and Register Failed");
            self.loginCallback(NO, nil, nil);
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        
        VS_HUD_HIDE;
        VS_SHOW_ERROR_STATUS(@"Request failed,please retry");
        
    }];
    
}

#pragma mark -- 布局三方平台绑定界面
-(void)layoutThirdView{
    
    self.viewThirdBind =  [[VSBindThirdView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(0,ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad]) , VSDK_ADJUST_PORTRIAT_WIDTH, ADJUSTPadAndPhonePortraitW(774)):CGRectMake(0,ADJUSTPadAndPhoneH(77 * 2) , VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneW(744))];
    
    [self.viewBindSegment addSubview:self.viewThirdBind];
    
    [self.viewThirdBind loginViewBlock:^(VSBindThirdViewBlockType type) {
        
        switch (type) {
            case VSBindThirdViewBlockBind:
                
                [self vsdk_registerAndBind];
                
                break;
            case VSBindThirdViewBlockContinue:
                
                [self vsdk_loginSucceedAndContinue];
                
                break;
                
            case VSBindThirdViewBlockShowTerm:
                
                [self vsdk_showTerm];
                
                break;
            default:
                break;
        }
    }];
    
}

#pragma mark -- 注册按钮事件
-(void)vsdk_registerAccount{
    
    NSString * email = self.viewRegister.tfEmail.text;
    NSString * psw = self.viewRegister.tfPwd.text;
    [self registerWithAccountEmail:email password:psw];
}

#pragma mark -- 服务条款 跳转H5页面
-(void)vsdk_showTerm{
    
    [VSDeviceHelper showTermOrContactCustomerServiceWithUrl:[NSString stringWithFormat:@"%@&language=%@",VS_USERDEFAULTS_GETVALUE(@"vsdk_user_term_link")?VS_USERDEFAULTS_GETVALUE(@"vsdk_user_term_link"):VSDK_TERM_URL,[VSDeviceHelper vsdk_systemLanguage]]];
}


#pragma mark -- 注册界面 注册按钮事件
-(void)registerWithAccountEmail:(NSString *)email password:(NSString *)password{
    
    VS_SHOW_TIPS_MSG(@"Registering...");
    [[VSDKAPI shareAPI] vsdk_registerWithEmial:email passWord:password success:^(VSDKAPI *api, id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_HUD_HIDE;
            VS_SHOW_SUCCESS_STATUS(@"Registered");
            VS_USERDEFAULTS_REOMVEVALUE(VSDK_PARAM_GUEST_TOKEN);
            VS_USERDEFAULTS_SETVALUE(VSDK_PLATFORM_ACCOUNT, VSDK_AUTO_LOGIN_KEY);
            
            _isLoginSuccess = YES;_VSDK_UID = [GETRESPONSEDATA:VSDK_PARAM_USER_ID];_errorMsg = nil;VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
            _VSDK_LOGIN_TOKEN = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
            
            NSString  * date = [VSDeviceHelper vsdk_currentDate];
            
            [self vsdk_saveUserDataWithAccount:email passWord:password loginDate:date nickName:[GETRESPONSEDATA:VSDK_PARAM_NICK_NAME] Token:[GETRESPONSEDATA:VSDK_PARAM_TOKEN]];
            
            [self vsdk_loginSucceedAndContinue];
            
        }else{
            
            VS_HUD_HIDE;
            VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            self.loginCallback(NO, nil,VSDK_MISTAKE_MSG);
            
        }
        
    } failure:^(VSDKAPI *api, NSString *failure) {
        
        VS_HUD_HIDE;
        VS_SHOW_ERROR_STATUS(@"Request failed,please retry");
        
    }];
}


#pragma mark -- 获取支付渠道决定苹果支付和三方支付的方法
-(void)vsdk_purchaseWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName Viewcontroller:(UIViewController *)Vc iapResult:(void(^)(BOOL isSuccess,NSString *certificate, NSString *errorMsg))iapResult{
    
    self.inAppPurchaseCallback = [iapResult copy];
    
    if (VSDK_CLOSE_SERVER_DIC&&[[VSDK_CLOSE_SERVER_DIC objectForKey:@"pay_status"]isEqual:@1]) {
        
        VSGameExpired * view = [[VSGameExpired alloc]init];
        view.btnText = @"Close";
        view.ifLogin = NO;
        [view vsdk_gameStopOperation];
        
    }else{
        
        if ([VS_CONVERT_TYPE(roleLevel) integerValue] > 0) {
            
            NSString * extend = @"";
            VSIPAPurchase * purchase = [VSIPAPurchase manager];
            purchase.vsdk_userId = VSDK_GAME_USERID;
            purchase.vsdk_money = money;
            purchase.vsdk_roleLevel = roleLevel;
            purchase.vsdk_moneyType = moneytype;
            purchase.vsdk_Extend = extend;
            purchase.vsdk_Ftype = VSDK_PARAM_FF_TYPE;
            purchase.vsdk_serverId = serverId;
            purchase.vsdk_serverName = serverName;
            purchase.vsdk_roleId = roleId;
            purchase.vsdk_roleName = rolename;
            purchase.vsdk_goodsId = goodId;
            purchase.vsdk_goodsName = goodName;
            purchase.cp_trade_sn = tradeSn;
            purchase.vsdk_extData = extData;
            purchase.third_goods_id = productId;
            purchase.third_goods_name = productName;
            purchase.app_channel = @"";
            purchase.isSubProduct = NO;
            
            [[VSDKAPI shareAPI]vsdk_getproductInfoBeforeOrderWithPid:productId Success:^(id responseObject) {
                
                if(REQUESTSUCCESS){
                    
                    NSString * base64Str = [GETRESPONSEDATA:@"authorize"];
                    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    VS_USERDEFAULTS_SETVALUE(base64Str, @"vsdk_authorize");
                    
                    if ([[dic objectForKey:@"key"] isEqualToString:@"default"]||[[dic objectForKey:@"key"] isEqualToString:@"md5"]) {
                        
                        [self vsdk_inAppPurchaseWithUserId:VSDK_GAME_USERID Money:money MoneyType:moneytype Extend:extend FFType:VSDK_PARAM_FF_TYPE ServerId:serverId ServerName:serverName RoleId:roleId RoleName:rolename RoleLevel:roleLevel GoodId:goodId GoodsName:goodName CPTradeSn:tradeSn ExtData:extData ThirdGoodId:productId ThirdGoodName:productName ifSub:NO];
                        
                    }else if([[dic objectForKey:@"key"] isEqualToString:@"rsa"]){
                  
                        [self vsdk_openWebPageInSafariWithUrl:[self vsdk_socialShareLinkUrlWithDic:dic UserId:userId Money:money MoneyType:moneytype ServerId:serverId ServerName:serverName RoleId:roleId RoleName:rolename RoleLevel:roleLevel GoodId:goodId GoodsName:goodName CPTradeSn:tradeSn ExtData:extData ProductId:productId ProductName:productName]];
                        
                    }else if([[dic objectForKey:@"key"] isEqualToString:@"all"]){
                        
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:VSLocalString(@"Please choose a purchase channel") preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"App Store" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [self vsdk_inAppPurchaseWithUserId:VSDK_GAME_USERID Money:money MoneyType:moneytype Extend:extend FFType:VSDK_PARAM_FF_TYPE ServerId:serverId ServerName:serverName RoleId:roleId RoleName:rolename RoleLevel:roleLevel GoodId:goodId GoodsName:goodName CPTradeSn:tradeSn ExtData:extData ThirdGoodId:productId ThirdGoodName:productName ifSub:NO];
                            
                        }]];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [self vsdk_openWebPageInSafariWithUrl:[self vsdk_socialShareLinkUrlWithDic:dic UserId:userId Money:money MoneyType:moneytype ServerId:serverId ServerName:serverName RoleId:roleId RoleName:rolename RoleLevel:roleLevel GoodId:goodId GoodsName:goodName CPTradeSn:tradeSn ExtData:extData ProductId:productId ProductName:productName]];
                            
                        }]];

                        [VS_RootVC presentViewController:alert animated:YES completion:nil];
   
                    }else{VS_SHOW_ERROR_STATUS(@"Request failed,please retry");}
                    
                }else{
                    
                    [self vsdk_inAppPurchaseWithUserId:VSDK_GAME_USERID Money:money MoneyType:moneytype Extend:extend FFType:VSDK_PARAM_FF_TYPE ServerId:serverId ServerName:serverName RoleId:roleId RoleName:rolename RoleLevel:roleLevel GoodId:goodId GoodsName:goodName CPTradeSn:tradeSn ExtData:extData ThirdGoodId:productId ThirdGoodName:productName ifSub:NO];
                    
                }
                
            } Failure:^(NSString *failure) {
                
                VS_SHOW_ERROR_STATUS(@"Request failed,please retry")
            }];
            
        }else{
            
            VS_SHOW_INFO_MSG(@"传入角色等级参数非法(即无法转换为对应整型,不是数字型字符串)");
        }
    }
}



-(void)vsdk_inAppPurchaseWithUserId:(NSString *)uid Money:(NSString *)money MoneyType:(NSString *)moneytype Extend:(NSString *)extend FFType:(NSString *)fftype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ThirdGoodId:(NSString *)productId ThirdGoodName:(NSString *)productName ifSub:(BOOL)subProduct{
        
    VSIPAPurchase *ipamanager = [VSIPAPurchase manager];
    ipamanager.extend = extend;
    ipamanager.fftype = fftype;
    ipamanager.serverId = serverId;
    ipamanager.serverName = serverName;
    ipamanager.roleId = roleId;
    ipamanager.rolename = rolename;
    ipamanager.roleLevel = roleLevel;
    ipamanager.goodId = goodId;
    ipamanager.goodName = goodName;
    ipamanager.tradeSn = tradeSn;
    ipamanager.extData = extData;
    ipamanager.productId = productId;
    ipamanager.productName = productName;
    ipamanager.subProduct = subProduct;
    
    [[VSIPAPurchase manager] vsdk_purchaseWithProductID:productId iapResult:^(BOOL isSuccess, NSString *certificate, NSString *errorMsg) { self.inAppPurchaseCallback(isSuccess, certificate, errorMsg); }];
    
}


-(NSString *)vsdk_socialShareLinkUrlWithDic:(NSDictionary*)dic UserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName{
    
    
    NSData *data1 = [[NSData alloc]initWithBase64EncodedString:[dic objectForKey:@"encrypt"] options:0];
    NSString * https = [[NSString alloc]initWithData:data1 encoding: NSUTF8StringEncoding];
    
    if ([https hasPrefix:@"https"]||[https hasPrefix:@"http"]){
    
        return @"404";
    }
        
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]] ;
    
    [params setValue:VSDK_APP_DISPLAY_NAME forKey:VSDK_PARAM_GAME_NAME];
    [params setValue:userId forKey:VSDK_PARAM_USER_ID];
    [params setValue:money forKey:VSDK_PARAM_MONEY];
    [params setValue:moneytype forKey:VSDK_PARAM_MONEY_TYPE];
    [params setValue:@"" forKey:VSDK_PARAM_EXTEND];
    [params setValue:VSDK_PARAM_FF_TYPE forKey:VSDK_PARAM_PAY_TYPE];
    [params setValue:serverId forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:roleId forKey:VSDK_PARAM_ROLE_ID];
    [params setValue:rolename forKey:VSDK_PARAM_ROLE_NAME];
    [params setValue:serverName forKey:VSDK_PARAM_SERVER_NAME];
    [params setValue:roleLevel forKey:VSDK_PARAM_ROLE_LEVEL];
    [params setValue:goodId forKey:VSDK_PARAM_GOODS_ID];
    [params setValue:goodName forKey:VSDK_PARAM_GOODS_NAME];
    [params setValue:tradeSn forKey:VSDK_PARAM_CP_TRADE_SN];
    [params setValue:extData forKey:VSDK_PARAM_EXT_DATA];
    [params setValue:productId forKey:VSDK_PARAM_THIRD_GOODS_ID];
    [params setValue:productName forKey:VSDK_PARAM_THIRD_GOODS_NAME];
    [params setValue:VS_USERDEFAULTS_GETVALUE(@"vsdk_authorize") forKey:@"authorize"];
    [params setValue:VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY) forKey:VSDK_PARAM_TOKEN];
    NSString * md5str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    NSString * paramStr = @"";
    
    for (NSString * key in params) {
        
        paramStr = [paramStr stringByAppendingFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    
    NSString * paramStrSub = [paramStr substringToIndex:paramStr.length - 1];
    
    return [[NSString stringWithFormat:@"%@?%@",https,paramStrSub]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
}



-(void)vsdk_subscriptionPurchaseWithUserId:(NSString *)userId Money:(NSString *)money MoneyType:(NSString *)moneytype ServerId:(NSString *)serverId ServerName:(NSString *)serverName RoleId:(NSString *)roleId RoleName:(NSString *)rolename RoleLevel:(NSString *)roleLevel GoodId:(NSString *)goodId GoodsName:(NSString *)goodName CPTradeSn:(NSString *)tradeSn ExtData:(NSString *)extData ProductId:(NSString *)productId ProductName:(NSString *)productName Viewcontroller:(UIViewController *)Vc iapResult:(void(^)(BOOL isSuccess,NSString *certificate, NSString *errorMsg))iapResult{
    
    if(![productId hasPrefix:@"sub"]){
        
        VS_SHOW_INFO_MSG(@"商品id不是订阅型id,请检查商品id对应的类型是否订阅型~");
        return;
    }
    
    if ([VS_CONVERT_TYPE(roleLevel) integerValue] > 0) {
        
        NSString * extend = @"";
        VSIPAPurchase * purchase = [VSIPAPurchase manager];
        purchase.vsdk_userId = VSDK_GAME_USERID;
        purchase.vsdk_money = money;
        purchase.vsdk_roleLevel = roleLevel;
        purchase.vsdk_moneyType = moneytype;
        purchase.vsdk_Extend = extend;
        purchase.vsdk_Ftype = VSDK_PARAM_FF_TYPE;
        purchase.vsdk_serverId = serverId;
        purchase.vsdk_serverName = serverName;
        purchase.vsdk_roleId = roleId;
        purchase.vsdk_roleName = rolename;
        purchase.vsdk_goodsId = goodId;
        purchase.vsdk_goodsName = goodName;
        purchase.cp_trade_sn = tradeSn;
        purchase.vsdk_extData = extData;
        purchase.third_goods_id = productId;
        purchase.third_goods_name = productName;
        purchase.app_channel = @"";
        purchase.isSubProduct = YES;

        [[VSDKAPI shareAPI]  vsdk_cpOrderWithUserId:VSDK_GAME_USERID Money:money MoneyType:moneytype Extend:extend FFType:VSDK_PARAM_FF_TYPE ServerId:serverId ServerName:serverName RoleId:VS_CONVERT_TYPE(roleId) RoleName:rolename RoleLevel:VS_CONVERT_TYPE(roleLevel) GoodId:goodId GoodsName:goodName CPTradeSn:tradeSn ExtData:extData ThirdGoodId:productId ThirdGoodName:productName ifSub:YES success:^(VSDKAPI *api, id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    [VSIPAPurchase manager].vsdk_order = [GETRESPONSEDATA:VSDK_PARAM_ORDER];
                    
                    if ([[VSIPAPurchase manager].vsdk_order length] != 0) {
                        
                        [[VSIPAPurchase manager] vsdk_purchaseWithProductID:productId iapResult:^(BOOL isSuccess, NSString *certificate, NSString *errorMsg) {iapResult(isSuccess, certificate, errorMsg); }];
                        
                    }else{VS_SHOW_ERROR_STATUS(@"Parameter Error!");}
                    
                }else{VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);}
                
            }else{VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);}
            
        } failure:^(VSDKAPI *api, NSString *failure) {VS_SHOW_ERROR_STATUS(@"Request failed,please retry");}];
    }
}


#pragma mark -- 选择服务器接口
-(void)vsdk_reportSelectSeverBuriedPointWithGamename:(NSString *)gamename ServerId:(NSString *)serverid Servername:(NSString *)servername{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [params setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [params setValue:gamename forKey:VSDK_PARAM_GAME_NAME];
    [params setValue:VS_CONVERT_TYPE(serverid) forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:VS_CONVERT_TYPE(servername) forKey:VSDK_PARAM_SERVER_NAME];
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    [VSDeviceHelper POST:VSDK_SELECT_SERVER_API parameters:params];
    
}

#pragma mark -- 进入游戏、 创建角色 、升级、退出游戏埋点接口
-(void)vsdk_reportBuriedPointWithType:(kUrlEventType)urlType serviceId:(NSString *)serviceid serverName:(NSString *)servername roleId:(NSString *)roleid roleName:(NSString *)rolename roleLevel:(NSString *)rolelevel  openServertime:(NSString *) openservertime{
    //保存开服时间，新拍脸图上报需要用到
    if ([VSTool isBlankString:openservertime]) {
        openservertime = @"";
    }
    [Pic_PatModel shareInstance].open_server_time = openservertime;
    
    NSString * url;
    
    switch (urlType) {
            
        case kEnterGameType:
            
            url = VSDK_ENTER_GAME_API;
            break;
            
        case kCreateRoleType:
            
            url = VSDK_CREATE_ROLE_API;
            
            break;
            
        case kLevelUpType:
            
            url = VSDK_LEVELUP_API;
            
            break;
            
        case kQuitGameType:
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setBool:NO forKey:@"ENTERGAME"];
            [ud synchronize];
            url = VSDK_QUIT_GAME_API;
        }
            break;
            
        case kCompleteNewbieType:
            
            url = VSDK_COMPLETENEWBIE_API;
            
            break;
            
        case kJoinGameGuildType:
            
            url = VSDK_JOIN_GUILD_API;
            
            break;
            
        case kCompleteAllDailyTaskType:
            
            url = VSDK_COMPLETEALLDAILY_API;
            
            break;
            
        default:
            break;
    }
    
    VS_USERDEFAULTS_SETVALUE([VS_CONVERT_TYPE(rolelevel) length]>0?VS_CONVERT_TYPE(rolelevel):@"", @"vsdk_role_level");
    //保存参数，后续可能需要
    VS_USERDEFAULTS_SETVALUE([VS_CONVERT_TYPE(serviceid) length]>0?VS_CONVERT_TYPE(serviceid):@"", @"vsdk_role_serviceid");
    VS_USERDEFAULTS_SETVALUE([VS_CONVERT_TYPE(servername) length]>0?VS_CONVERT_TYPE(servername):@"", @"vsdk_role_servername");
    VS_USERDEFAULTS_SETVALUE([VS_CONVERT_TYPE(roleid) length]>0?VS_CONVERT_TYPE(roleid):@"", @"vsdk_role_roleid");
    VS_USERDEFAULTS_SETVALUE([VS_CONVERT_TYPE(rolename) length]>0?VS_CONVERT_TYPE(rolename):@"", @"vsdk_role_rolename");
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [params setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [params setValue:VS_CONVERT_TYPE(servername) forKey:VSDK_PARAM_SERVER_NAME];
    [params setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [params setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [params setValue:VS_CONVERT_TYPE(rolename) forKey:VSDK_PARAM_ROLE_NAME];
    [params setValue:VS_CONVERT_TYPE(rolelevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    NSString * md5Str = [[VSDeviceHelper MD5SignWithDic:params]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:md5Str];
    [params setValue:sign forKey:VSDK_PARAM_SIGN];
    
    
    [VSDeviceHelper POST:url parameters:params];
    
    if (url == VSDK_CREATE_ROLE_API) {
        
        if (![VS_USERDEFAULTS_GETVALUE(@"vsdk_red_packet_request_state") isEqual:@1]) {
            [VSDKTPInitHelper vsdk_redPacketAlertState];
        }

    }

    if ([url isEqualToString:VSDK_ENTER_GAME_API]) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:YES forKey:@"ENTERGAME"];
        [ud synchronize];
        
        Pic_PatModel *pm = [Pic_PatModel shareInstance];
        pm.up = NO;
        pm.down = NO;
        pm.range = NO;
        
        [VSDKTPInitHelper vsdk_redPacketAlertRequestState];
        
        _launchDate = [NSDate date];
        //计算在线累积时长
        [self vsdk_sumOnlineTimeWithIntervalWithServerid:VS_CONVERT_TYPE(serviceid) ServerName:VS_CONVERT_TYPE(servername) RoleId:VS_CONVERT_TYPE(roleid) RoleName:VS_CONVERT_TYPE(rolename) RoleLevel:VS_CONVERT_TYPE(rolelevel)];
        
        [_timerOnline invalidate]; _timerOnline = nil;
        _timerOnline = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(vsdk_onlineSelector:) userInfo:params repeats:YES];
        [_timerOnline fire];
    
        //浮球根据等级显示--进入游戏根据进入游戏的时候的等级显示浮球
        [self vsdk_showAssistantBtnWithRolevel:rolelevel];
        
        //加载新拍脸图数据
        [[VSDKAPI shareAPI] vsdk_acquirePatFaceDateSuccess:^(id responseObject) {
            
            NSDictionary *dic = responseObject;
            NSNumber *nub = [dic objectForKey:@"state"];
            NSString *state = [nub stringValue];
            NSDictionary *dateDic = [dic objectForKey:@"data"];
            if (dateDic.count > 0) {
                NSArray *pic_lict = [dateDic objectForKey:@"pic_list"];
                NSArray *level_pic_list = [dateDic objectForKey:@"level_pic_list"];
                //本地缓存拍脸图数据
                NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                [df setValue:dic forKey:@"NEWPAT"];
                [df synchronize];

                //根据是否有数据先做图片缓存
                if (pic_lict.count > 0) {
                    for (NSDictionary *dic in pic_lict) {
                        NSString *imgStr = [dic objectForKey:@"img"];
                        NSURL *imgUrl = [NSURL URLWithString:imgStr];
                        NSString *btnImgStr = [dic objectForKey:@"btn_img"];
                        NSURL *btnImgUrl = [NSURL URLWithString:btnImgStr];
                        
                        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[imgUrl,btnImgUrl]];
                    }
                }
                
                if (level_pic_list.count > 0) {
                    for (NSDictionary *dic in level_pic_list) {
                        NSString *imgStr = [dic objectForKey:@"img"];
                        NSURL *imgUrl = [NSURL URLWithString:imgStr];
                        NSString *btnImgStr = [dic objectForKey:@"btn_img"];
                        NSURL *btnImgUrl = [NSURL URLWithString:btnImgStr];
                        
                        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[imgUrl,btnImgUrl]];
                    }
                }
                
                //显示
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *time = [ud objectForKey:@"STIME"];
                BOOL isS = [ud boolForKey:@"isS"];
                //如果已经选择了今天不显示，并且选择的日期是今天
                if ([VSTool nowisToday:time] && isS) {
                    //不显示
                }else{
                    //新的一天初始化选择
                    [ud setBool:NO forKey:@"isS"];
                    [ud synchronize];
                    //显示
                    if ([state isEqualToString:@"1"]) {
                        PatFaceVC *faceVC = [[PatFaceVC alloc] init];
                        if (pic_lict.count >0) {
                            faceVC.showType = @"pic_list";
                            
                            
                        }
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            [SDKENTRANCE showViewController:faceVC];
                        });
                        
                        
                    }
                }
            }
                
        } Failure:^(NSString *errorMsg) {
            
            
        }];
        
        //平台积分初始化
        
#if Helper
        if ([IntergralModel sharModel].point_state) {
            [[VSDKAPI shareAPI] vsdk_initPlatformIntegralWithType:0 Success:^(id responseObject) {
                
                if (REQUESTSUCCESS) {
                    NSLog(@"%@",responseObject);
                    NSDictionary * dic = [responseObject objectForKey:@"data"];
                    if (dic.count > 0) {
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        [ud setValue:dic forKey:@"PLT_INIT"];
                        [ud synchronize];
                    
                        IntergralModel *model = [IntergralModel sharModel];
                        model.curtime = dic[@"cur_time"];
                        model.idescription = dic[@"description"];
                        model.hot_dot = [dic[@"hot_dot"] stringValue];
                        model.point_clear_time = dic[@"point_clear_time"];
                        model.pay_time = dic[@"pay_time"];
                        
    //                    model.pay_time = @"16630386181";
                        
                        model.sign_time = dic[@"sign_time"];
                        model.user_point = dic[@"user_point"];
                        
    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEUI" object:nil];
                    }
                    
                }
                
                    } Failure:^(NSString *errorMsg) {
                        
                    }];
        }
#endif
        
        
        
        
        
    }else if ([url isEqualToString:VSDK_COMPLETENEWBIE_API]) {
        
        [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_CompleteNewbieTask];
        
    }else if ([url isEqualToString:VSDK_JOIN_GUILD_API]) {
        
        [VSDeviceHelper vsdk_firebaseEventWithEventName:VSDK_JoinGameGuild];
        
    }else if([url isEqualToString:VSDK_LEVELUP_API]){
        
        //达到预设等级则显示小助手
        [self vsdk_showAssistantBtnWithRolevel:rolelevel];
        //评分界面根据预设等级展示
        [self vsdk_skRequestViewShowWithRoleLevel:rolelevel];
        //浮球根据预设等级展示
        [self vsdk_uCenterViewShowWithRoleLevel:rolelevel];
        //新拍脸图根据等级展示
        [self vsdk_accordingRoleLevelToshowPatFace:rolelevel];
        
        if (![VS_USERDEFAULTS_GETVALUE(@"vsdk_red_packet_request_state") isEqual:@1]) {
            [VSDKTPInitHelper vsdk_redPacketAlertState];
        }
        
    }else if ([url isEqualToString:VSDK_QUIT_GAME_API]){
        
        _exitDate = [NSDate date];
        [_timerOnline invalidate];_timerBadge = nil;
        VS_USERDEFAULTS_REOMVEVALUE(VSDK_AUTO_LOGIN_KEY);
        [VSDKEventHelper vsdk_onlineOver90MinutesInDayWithStartDate:_launchDate andEndDate:_exitDate UserId:VSDK_GAME_USERID];
    }
}


#pragma mark -- 根据等级展示游戏引导评分界面
-(void)vsdk_skRequestViewShowWithRoleLevel:(NSString *)rolelevel{
    
    //是否开启展示五星好评 1为开 0 为关闭
    if (![VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"fivestar_praise_state") isEqual:@1]) return;

    //是否已经领取过五星好评奖励
    if ([[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_state"] isEqual:@2]) return;
    
    NSNumber * restrictLevel = VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"fivestar_reviews_restrict_level")? VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"fivestar_reviews_restrict_level"):nil;
    
    if (!VS_USERDEFAULTS_GETVALUE(VSDK_UCENTER_FS_SHOW_KEY)) {
        
        if (restrictLevel != nil) {
            
            if ([rolelevel integerValue] >= [restrictLevel integerValue]) {
                
                VS_USERDEFAULTS_SETVALUE(@YES, VSDK_UCENTER_FS_SHOW_KEY);
                VSFiveStarView * fs = [[VSFiveStarView alloc]init];
                [fs vsdk_requeustMarkReview];
            }
        }
        
    }else{
        
        if (restrictLevel != nil) {
            
            if ([rolelevel integerValue] >= [restrictLevel integerValue]&&[rolelevel integerValue]%10 == 0) {
                
                VSFiveStarView * fs = [[VSFiveStarView alloc]init];
                [fs vsdk_requeustMarkReview];
            }
        }
    }
}

-(void)vsdk_accordingRoleLevelToshowPatFace:(NSString *)rolelevel{
    
    NSInteger lev = [rolelevel integerValue];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud objectForKey:@"NEWPAT"];
    NSNumber *nub = [dic objectForKey:@"state"];
    NSString *state = [nub stringValue];
    NSDictionary *dateDic = [dic objectForKey:@"data"];
    NSArray *pic_lict = [dateDic objectForKey:@"pic_list"];
    NSArray *level_pic_list = [dateDic objectForKey:@"level_pic_list"];
    
    self.level_pic_listArr = [NSMutableArray array];
    
    if (level_pic_list.count > 0) {
        for (NSDictionary *dic in level_pic_list) {
            NSString *imgStr = [dic objectForKey:@"img"];
            NSString *btnImgStr = [dic objectForKey:@"btn_img"];
            
            UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgStr];
            UIImage *btnImg = [[SDImageCache sharedImageCache] imageFromCacheForKey:btnImgStr];
            
            Level_PatModel *pmodel = [[Level_PatModel alloc] init];
            pmodel.img_id = [dic objectForKey:@"img_id"];
            pmodel.img = [dic objectForKey:@"img"];
            pmodel.link = [dic objectForKey:@"link"];
            pmodel.btn_img = [dic objectForKey:@"btn_img"];
            pmodel.jump_type = [dic objectForKey:@"jump_type"];
            pmodel.jump_page = [dic objectForKey:@"jump_page"];
            pmodel.level_type = [dic objectForKey:@"level_type"];
            NSNumber *starLevelNub = [dic objectForKey:@"start_level"];
            NSInteger starlevel = [starLevelNub integerValue];
            pmodel.start_level = starlevel;
            NSNumber *endLevelNub = [dic objectForKey:@"end_level"];
            NSInteger endlevel = [endLevelNub integerValue];
            pmodel.end_level = endlevel;
            
            pmodel.mainImg = img;
            pmodel.btnImg = btnImg;
            [self.level_pic_listArr addObject:pmodel];
            
        }
        
        if ([state isEqualToString:@"1"]) {
            Pic_PatModel *pm = [Pic_PatModel shareInstance];
            for (Level_PatModel *model in self.level_pic_listArr) {
                if ([model.level_type isEqualToString:@"appoint"]) {
                    if (lev == model.start_level) {
                        [self showPatV];
                    }
                }
                if ([model.level_type isEqualToString:@"up"]) {
                    if (lev >= model.start_level) {
                        if (!pm.up) {
                            pm.up = YES;
                            [self showPatV];
                        }
                        
                    }
                }
                if ([model.level_type isEqualToString:@"down"]) {
                    if (lev <= model.start_level) {
                        if (!pm.down) {
                            pm.down = YES;
                            [self showPatV];
                        }
                    }
                }
                if ([model.level_type isEqualToString:@"range"]) {
                    if (lev >= model.start_level && lev <= model.end_level) {
                        if (!pm.range) {
                            pm.range = YES;
                            [self showPatV];
                        }
                    }
                }
            }
        }
    }
}

-(void)showPatV{
    PatFaceVC *faceVC = [[PatFaceVC alloc] init];
    faceVC.showType = @"level_pic_list";
    //防止图片没加载好
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [SDKENTRANCE showViewController:faceVC];
    });
}
    
-(void)vsdk_uCenterViewShowWithRoleLevel:(NSString *)rolelevel{
    
    if (!VSDK_UCENTER_SHOW_KEY) {
        
        NSNumber *  restrictLevel = VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"user_account_center_popup_level")?VSDK_LOCAL_DATA(VSDK_ASSISTANT_CONFIG_PATH, @"user_account_center_popup_level"):nil;
        
        if (restrictLevel != nil) {
            
            if ([rolelevel integerValue] >= [restrictLevel integerValue]) {
                
                VS_USERDEFAULTS_SETVALUE(@YES, VSDK_UCENTER_SHOW_KEY);
                VSUserCenterEntrance * entrance = [[VSUserCenterEntrance alloc]init];
                [entrance vsdk_setUpCenterEntrance];
            }
        }
    }
}


-(void)vsdk_sumOnlineTimeWithIntervalWithServerid:(NSString *)serverid ServerName:(NSString *)servername RoleId:(NSString *)roleid RoleName:(NSString *)roleName RoleLevel:(NSString *)rolelevel{
    
    VS_USERDEFAULTS_SETVALUE(serverid, VSDK_SOCIAL_SERVER_ID);
    VS_USERDEFAULTS_SETVALUE(servername, VSDK_SOCIAL_SERVER_NAME);
    VS_USERDEFAULTS_SETVALUE(roleid, VSDK_SOCIAL_ROLE_ID);
    VS_USERDEFAULTS_SETVALUE(roleName, VSDK_SOCIAL_ROLE_NAME);
    VS_USERDEFAULTS_SETVALUE(rolelevel, VSDK_SOCIAL_ROLE_LEVEL);
    VS_USERDEFAULTS_SETVALUE(VSDK_APP_DISPLAY_NAME, VSDK_SOCIAL_GAME_NAME);
    
    dispatch_semaphore_t semap = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[VSDKAPI shareAPI]  ssRequestSocialDataSuccess:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                NSDictionary * dic = [responseObject objectForKey:@"data"];
                
                if ([[[[[dic objectForKey:@"fivestar_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_state"] isEqual:@0]||([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL) length]==0&&[VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) length]==0)) {
                    
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:kAssistantBtnBadgeAlertNotification object:nil];
                        
                    });
                    
                }
                
                NSString * fsImageUrl = [[[[dic objectForKey:@"fivestar_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_image"];
                
                if ([fsImageUrl length]>0) {
                    
                    VS_USERDEFAULTS_SETVALUE(fsImageUrl, @"fiveStarImageData");
                    NSURL * url = [NSURL URLWithString:fsImageUrl];
                    [[SDWebImagePrefetcher sharedImagePrefetcher]prefetchURLs:@[url]];
                    
                }
                
                [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];
   
            }
            
        } Failure:^(NSString *failure) {}];
        
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (dispatch_semaphore_wait(semap, dispatch_time(DISPATCH_TIME_NOW,
                                                         DISPATCH_TIME_FOREVER * NSEC_PER_SEC))){
            
            [[VSDKAPI shareAPI]  vsdk_playerIsVipWithServiceId:VS_CONVERT_TYPE(serverid) ServerName:VS_CONVERT_TYPE(servername) RoleId:VS_CONVERT_TYPE(roleid) RoleName:VS_CONVERT_TYPE(roleName) RoleLevel:VS_CONVERT_TYPE(rolelevel) vipSuccess:^(id responseObject) {
                
                if (REQUESTSUCCESS) {
                    
                    ifVip = YES;
                }
                
            } vipFailure:^(NSString *failureMsg) {}];
            
        }
        
    });
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(vsdk_updateEndDate) userInfo:nil repeats:YES];
    [timer fire];
    
}

-(void)vsdk_updateEndDate{
    
    _exitDate = [NSDate date];
    [VSDKEventHelper vsdk_onlineOver90MinutesInDayWithStartDate:_launchDate andEndDate:_exitDate UserId:_VSDK_UID];
}


#pragma mark -- 发送在线日志的方法
-(void)vsdk_onlineSelector:(NSTimer*)timer{
    
    [VSDeviceHelper POST:VSDK_USER_ONLINE_API parameters:timer.userInfo];
}



-(void)vsdk_requestTrackingAuthorizedWithBlock:(void(^)(BOOL isAuthorized))block{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
    
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    
                    block(YES);
                    
                } else {
                    
                    block(NO);
                }
            }];
        } else {
            
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                
                block(YES);
                
            } else {
                block(NO);
            }
        }
        
    });

}

/// 在当前控制器上打开网页
/// @param url 网址
/// @param vc 当前控制器
-(void)vsdk_openWebsiteWithUrl:(NSString *)url inCurrentVc:(UIViewController *)vc{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
        
    }];
}


-(void)vsdk_openWebPageInSafariWithUrl:(NSString *)url{
    
    
    if ([url hasPrefix:@"http"]||[url hasPrefix:@"https"]) {

        SFSafariViewController * vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:url]];
        [VS_RootVC presentViewController:vc animated:YES completion:nil];
        
    }else{
    
        VS_SHOW_ERROR_STATUS(@"Configuration Error! Please try again later");

    }
    
}


-(BOOL)vsdk_currentRoleisVip{
    
    return ifVip;
}


/// 打开苹果官方评分UI
-(void)vsdk_popUpSKRequestView{
    
    [SKStoreReviewController requestReview];
}


/// 社交分享接口
-(void)vsdk_showSocialSharePage{
    
    if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {
        
        VSSocailCodeView * view = [[VSSocailCodeView alloc]init];
        [view vsdk_openSocialShareCodePage];
    }else{
        VSSocialView  * view = [[VSSocialView alloc]init];
        [view vsdk_openSocialShareUrlPage];
    }
    
}


-(void)vsdk_popUpGameBulletinPage{
    
    if ([VSDK_LOCAL_DATA(VSDK_NORMAL_BULLETIIN_PATH, @"bulletin_list") count] != 0) {
        VSNormalBulltein * view = [[VSNormalBulltein alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, SCREE_WIDTH - 60, SCREE_HEIGHT /2): CGRectMake(0, 0, SCREE_WIDTH *2/3, SCREE_HEIGHT - 60)];
        view.center = VS_RootVC.view.center;
        [VS_RootVC.view addSubview:view];
    }
}


/// 显示游戏助手
-(void)vsdk_assistantToolshow{
#if Helper
    self.astHelper = [[VSAssistantHelper alloc]initWithFrame:CGRectZero];
    [VS_RootVC.view addSubview:self.astHelper];
    [self.astHelper vsdk_assistantToolShowInVc:VS_RootVC];
#endif
   
}


#pragma mark -- 三方平台登录
-(void)vsdk_signInWithThirdType:(NSString *)type{
    
     VS_SHOW_TIPS_MSG(@"Logging in");
    
    if ([type isEqualToString:VSDK_FACEBOOK]) {
        
        FBSDKAccessToken * token = [SUCache itemForSlot:VSDK_FACEBOOK_CACHE_SLOT].token;
        
        if (token) {
            
            [self vsdk_AutoLoginFBWithToken:token];

        }else{
           
            [self vsdk_loginFacebook];
        }
    }else if ([type isEqualToString:VSDK_GOOGLE]){
        
        self.vsdkGgEventType = kThirdLoginType;
        
        
        GIDConfiguration * config = [[GIDConfiguration alloc]initWithClientID:VSDK_GOOGLE_CLIENTID];
        [[GIDSignIn sharedInstance] signInWithConfiguration:config presentingViewController:VS_RootVC callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
           
#warning -- 在这里进行google 授权相关操作
            if (error) {
                
                VS_HUD_HIDE;[self vsdk_pLogiViewHide];return;
            }
            
            if ([self.vsdkGgEventType isEqualToString:kThirdLoginType]) {
                
                [self vsdk_loginThirdWithType:VSDK_GOOGLE Token:user.authentication.idToken];
                
            }else{
                
                [self vsdk_bindThirdtWithType:VSDK_GOOGLE Token:user.authentication.idToken GuestToken:_guestToken];
                
            }
            
        }];
        
    }
}


/// Facebook自动登录
/// @param token token
-(void)vsdk_AutoLoginFBWithToken:(FBSDKAccessToken *)token{
    
    [FBSDKAccessToken setCurrentAccessToken:token];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name"}];
    
    [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
        //token过期，删除存储的token和profile
        if (error) {
            
            VS_HUD_HIDE
            [SUCache deleteItemInSlot:VSDK_FACEBOOK_CACHE_SLOT];
            [[VSDKAPI shareAPI] vsdk_sendLoginErrorLogWithErrorCode:[NSString stringWithFormat:@"%ld",(long)error.code] errorMsg:@"facebooks授权失败"];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
            [self vsdk_pLogiViewHide];
            
        }else{ //做登录完成的操作
            
            [self vsdk_loginThirdWithType:VSDK_FACEBOOK Token:token.tokenString];
        }
    }];
    
}


/// Facebook登录
-(void)vsdk_loginFacebook{
    
    FBSDKLoginManager * manager = [[FBSDKLoginManager alloc] init];
    [manager logOut];
    [manager
     logInWithPermissions: @[@"public_profile", @"email"]
     fromViewController:_rootVc
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error || result.isCancelled) {
            
            if (error) {
                
                VS_HUD_HIDE;VS_SHOW_ERROR_STATUS(@"Facebook Login Error!");
            }
            
            if (result.isCancelled) {
                
                VS_HUD_HIDE;VS_SHOW_INFO_MSG(@"Authorization Canceled");
            }
            _isLoginSuccess = NO;_VSDK_LOGIN_TOKEN = nil;_errorMsg = nil;
            [self vsdk_pLogiViewHide];
            
        }else{
            
            SUCacheItem * item  = [SUCache itemForSlot:VSDK_FACEBOOK_CACHE_SLOT];
            [self vsdk_loginThirdWithType:VSDK_FACEBOOK Token:item.token.tokenString];
        }
    }];
}


#pragma mark -- token 改变的方法
- (void)vsdk_fbAccessTokenChanged:(NSNotification *)notification{
    
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    if (!token) {
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
        
    }else{
        
        SUCacheItem *item = [SUCache itemForSlot:VSDK_FACEBOOK_CACHE_SLOT]?[SUCache itemForSlot:VSDK_FACEBOOK_CACHE_SLOT]:[[SUCacheItem alloc] init];
        if (![item.token isEqualToAccessToken:token]) {
            item.token = token;
            [SUCache saveItem:item slot:VSDK_FACEBOOK_CACHE_SLOT];
        }
    }
}



#pragma mark -- 红包浮窗

-(void)vsdk_showRedBagFloatBtn{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = DEVICEPORTRAIT?CGRectMake(SCREE_WIDTH-45, VS_RootVC.view.center.y , 60, 60): CGRectMake(SCREE_WIDTH-45, VS_RootVC.view.center.y, 60, 60);
    [button setBackgroundImage:[UIImage imageNamed:@"hongbao"] forState:UIControlStateNormal];
    button.alpha = 0.8;
    [button addTarget:self action:@selector(redBagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [VS_RootVC.view addSubview:button];
    
 
}

-(void)redBagBtnClick:(UIButton*)sender{

    sender.selected = !sender.selected;
    
    if (sender.selected) {
      
        sender.alpha = 1;
        sender.selected = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
          
            sender.frame = DEVICEPORTRAIT?CGRectMake(SCREE_WIDTH-65, sender.frame.origin.y, 1.2* sender.frame.size.width, 1.2* sender.frame.size.height):CGRectMake(SCREE_WIDTH-65, sender.frame.origin.y,1.1*  sender.frame.size.width, 1.1 * sender.frame.size.height);
            
        }completion:^(BOOL finished) {

        }];
        
        [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sender.alpha = 0.8;
            sender.frame = CGRectMake(SCREE_WIDTH-45,VS_RootVC.view.center.y, 60, 60);
        } completion:^(BOOL finished) {
            
            sender.selected = NO;
        }];

    }
    
}


-(void)vsdk_showRedPacketWebPage{
    
    VSEventView * redPacket = [[VSEventView alloc]init] ;
    redPacket.webUrl = [[NSString stringWithFormat:@"%@?%@",[VSDK_DIC_WITH_PATH(VSDK_ASSISTANT_CONFIG_PATH) objectForKey:@"red_bag_url"],[VSDeviceHelper getBasicRequestWithParams:@{VSDK_PARAM_SERVER_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID),VSDK_PARAM_SERVER_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME),VSDK_PARAM_ROLE_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID),VSDK_PARAM_ROLE_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME),VSDK_PARAM_ROLE_LEVEL:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL),VSDK_PARAM_UUID:[[VSDeviceHelper vsdk_realAdjustIdfa]length]>0?[VSDeviceHelper vsdk_realAdjustIdfa]:[VSDeviceHelper vsdk_keychainIDFA],VSDK_PARAM_TOKEN:VS_USERDEFAULTS_GETVALUE(VSDK_LEAST_TOKEN_KEY)}]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ;

    [redPacket vsdk_eventViewShow];
 
}


/// 账号删除功能
-(void)vsdk_delectUserAccount{

    VSDelAccontView * delCount = [[VSDelAccontView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    delCount.center = VS_RootVC.view.center;
    [VS_RootVC.view addSubview:delCount];

}


/// 初始化广告加载
/// @param readyBlock 准备回调
/// @param errorBlock 错误回调
/// @param startBlock 开始回调
/// @param completeBlock 完成回调
-(void)vsdk_adsPlayReady:(void(^)(BOOL isReady))readyBlock ifError:(void(^) (NSString *error))errorBlock ifStart:(void(^)(NSString * placement))startBlock ifComplete:(void(^)(BOOL ifComplete))completeBlock{
    
    
}



/// 播放广告
/// @param vc 播放广告vc
-(void)vsdk_adsPlayInVc:(UIViewController *)vc{
    
    
}


-(void)vsdk_showGameActivityPage{
    
    NSDictionary * ppDic = VSDK_DIC_WITH_PATH(VSDK_GRAPHIC_BULLTEIN_PATH);
//    NSString * currentCount = VS_USERDEFAULTS_GETVALUE(@"vsdk_activity_show_count");
    id status = [ppDic objectForKey:@"status"];
    if ([status isEqualToString:@"1"]){
       
        VSActivicityPageView * view = [[VSActivicityPageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [VS_RootVC.view addSubview:view];
    }
   
}

-(void)vsdk_pLogiViewHide{
    
    self.viewSegment.hidden = NO;self.btnBackToSelect.hidden = NO;self.viewAlpha.hidden = NO;self.viewSelect.hidden = NO;
}

-(void)vsdk_pLogiViewShow{
    
    self.viewSegment.hidden = YES;self.btnBackToSelect.hidden = YES;
}


-(void)vsdk_queryLocalMsgWithInpurchaseId:(NSArray *)productIdArr andCallBack:(void(^)(NSArray *))callback{
    [VSIPAPurchase manager].qCllback = ^(NSArray * _Nonnull skarr) {
        callback(skarr);
    };
    [[VSIPAPurchase manager] requestProductLocalInfo:productIdArr];
    
}

//移除监听
-(void)dealloc{
    
    [self.timerOnline invalidate];
    self.timerOnline = nil;
    [self.timerBadge invalidate];
    self.timerBadge = nil;
    [self.timerRefresh invalidate];
    self.timerRefresh = nil;
    [[VSIPAPurchase manager]vsdk_stopIapManager];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)vsdk_buglyAddMessageWithGmaeEngine:(NSString *)gameEngine AndEngineVersion:(NSString *)engineVersion AndGameName:(NSString *)gameName{
    [Bugly setUserValue:@"游戏引擎" forKey:gameEngine];
    [Bugly setUserValue:@"游戏引擎版本" forKey:engineVersion];
    [Bugly setUserValue:@"游戏名称" forKey:gameName];
}

#pragma mark 请求掉单接口
-(void)askOrderWithAppstore{
//    [VSChainTool delegateValueForKey:@"receipt"];
//    [VSChainTool delegateValueForKey:@"userId"];
//    [VSChainTool delegateValueForKey:@"order"];
//    [VSChainTool delegateValueForKey:@"productId"];
//    [JKRKeyChainTool delegateValueForKey:VSDK_IAPKEY];
    //获取之前的掉单
    NSArray *arr = [VSChainTool objectForKey:VSDK_IAPKEY];
    NSMutableArray *mutableArr = [NSMutableArray array];
    [mutableArr setArray:arr];
    NSMutableArray *copyArr = [mutableArr mutableCopy];
    dispatch_group_t group = dispatch_group_create();
    if (mutableArr.count > 0) {
        for (NSDictionary *iapDic in copyArr) {
            NSString *receipt = [iapDic objectForKey:@"receipt"];
            NSString *userId = [iapDic objectForKey:@"userId"];
            NSString *order = [iapDic objectForKey:@"order"];
            NSString *productId = [iapDic objectForKey:@"productId"];
            dispatch_group_enter(group);
            [[VSDKAPI shareAPI]  vsdk_sendVertifyWithReceipt:receipt order:order userId:userId  productId:productId success:^(VSDKAPI *api, id responseObject) {
                NSString *c = [responseObject objectForKey:@"message"];
                    if (REQUESTSUCCESS) {
                        //删除钥匙串里面请求成功的掉单
                        [mutableArr removeObject:iapDic];
                        [VSChainTool setObject:mutableArr forKey:VSDK_IAPKEY];
                        dispatch_group_leave(group);
                        
                    }else{
                        //删除钥匙串里面请求成功的掉单
                        [mutableArr removeObject:iapDic];
                        [VSChainTool setObject:mutableArr forKey:VSDK_IAPKEY];
                        dispatch_group_leave(group);
                    }
                
                } failure:^(VSDKAPI *api, NSString *failure) {
                    dispatch_group_leave(group);
                    
               }];
        }
    }
}

-(void)vsdk_loginClickWithType:(NSString *)type{
    [[VSDKAPI shareAPI] vsdk_loginClickWithType:type Success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } Failure:^(NSString *errorMsg) {
            
        }];
}

-(void)showAssistant{
#if Helper
    [self.astHelper assistantShow];
#endif
   
}

-(void)hideAssistant{
#if Helper
    [self.astHelper assitantHide];
#endif
    
}

-(void)showBackV{
#if Helper
    self.astHelper.backV.hidden = NO;
#endif
    
}

-(void)hideBackV{
#if Helper
    self.astHelper.backV.hidden = YES;
#endif
   
}

-(void)assistantBtnClick{
#if Helper
    [self.astHelper assitantClick];
#endif
   
}

-(void)patfaceCilickBlock:(void(^)(NSString *))patfaceBlock{
    self.PatfaceBlock = patfaceBlock;
}
@end

