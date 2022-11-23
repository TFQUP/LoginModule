//
//  VSUserCenterView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSUserCenterView.h"
#import "VSSDKDefine.h"

@interface VSUserCenterView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIScrollView * accountBgScrollView;
@property(nonatomic,strong)VSCountryPickerView * countryPicker;
@property(nonatomic,strong)UIView * viewSocialBg;
@property(nonatomic,strong)UIButton * btnClose;
@property(nonatomic,strong)UITextField * tfPhoneNum;
@property(nonatomic,strong)UITextField * tfVertifyCode;
@property(nonatomic,strong)UIButton * btnSendPhoneCode;
@property(nonatomic,strong)UITextField * tfEmial;
@property(nonatomic,strong)UIButton * btnSendEmialCode;
@property(nonatomic,strong)UITextField * tfEmailCode;
@property(nonatomic,strong)UISegmentedControl * segment;
@property(nonatomic,strong)UISegmentedControl * allBindsegment;
@property(nonatomic,strong)UIScrollView * allBindscrollView;
@property(nonatomic,strong)UIButton * btnseletZone;
@property(nonatomic,strong)UIButton * btnComfirmBindEmial;
@property(nonatomic,strong)UIButton * btnComfirmBindPhone;
@property(nonatomic,strong)UILabel * labelAccountType;
@property(nonatomic,strong)UILabel * labelTipsBindPhone;
@property(nonatomic,strong)UILabel * labelTipsBindEmail;
@property(nonatomic,strong)NSString * rewardEvent;
@property(nonatomic,strong)VSEditPassWord * viewEditPwd;

@end

@implementation VSUserCenterView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        if (@available(iOS 13.0, *)) {
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        
        self.layer.masksToBounds = YES;
    }
    
    return self;
}



-(void)vsdk_openUserCenterWithSelectIndex:(NSUInteger)index{
    
    self.selectIndex = index;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    self.viewSocialBg = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.viewSocialBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    
    CGFloat assW = ADJUSTPadAndPhonePortraitW(727);
    CGFloat assH = ADJUSTPadAndPhonePortraitH(614,[VSDeviceHelper getExpansionFactorWithphoneOrPad]);
    
    self.frame =isPad?DEVICEPORTRAIT?CGRectMake(0, 0, assW * 1.3,assH * 1.3):CGRectMake(0, 0, ADJUSTPadAndPhoneW(1187),ADJUSTPadAndPhoneH(991)):DEVICEPORTRAIT?CGRectMake(20, 30, SCREE_WIDTH - 40, (SCREE_WIDTH - 40)):CGRectMake(20, 30, (SCREE_HEIGHT - 50)*1.2, SCREE_HEIGHT - 50);
    
    self.layer.cornerRadius = 10;
    self.backgroundColor = VSDK_WHITE_COLOR;
    self.center = VS_RootVC.view.center;
    [self.viewSocialBg addSubview:self];
    [VS_RootVC.view addSubview:self.viewSocialBg];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnClose.frame = isPad? CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85)):DEVICEPORTRAIT?CGRectMake(self.frame.size.width/2 + self.center.x-30,self.frame.origin.y -30, ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitW(70)):CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85));
    
    [self.btnClose setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    [self.btnClose addTarget:self action:@selector(closeSocailView:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewSocialBg addSubview:self.btnClose];
    
    self.accountBgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
    self.accountBgScrollView.contentSize = isPad?CGSizeMake(self.frame.size.width, self.frame.size.height+40):CGSizeMake(self.frame.size.width, self.frame.size.height-20);
    self.accountBgScrollView.showsVerticalScrollIndicator =NO;
    self.accountBgScrollView.showsHorizontalScrollIndicator = NO;
    [self.accountBgScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewEndEditing:)]];
    [self addSubview:self.accountBgScrollView];
    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40 * (self.frame.size.height - 20)/280)];
    titleLabel.text = VSLocalString(@"Bind Phone/Email");
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = VS_RGB(245, 246, 247);
    titleLabel.textColor = VSDK_ORANGE_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UILabel * uidLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  23 * (self.frame.size.height - 20)/280, self.frame.size.width/2, 18 * (self.frame.size.height - 20)/280)];
    uidLabel.font = [UIFont boldSystemFontOfSize:13];
    uidLabel.textColor = VSDK_GRAY_COLOR;
    uidLabel.textAlignment = NSTextAlignmentCenter;
    uidLabel.text = [NSString stringWithFormat:@"UID:%@",VSDK_GAME_USERID];
    [self.accountBgScrollView addSubview:uidLabel];
    
    self.labelAccountType = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 23* (self.frame.size.height - 20)/280, self.frame.size.width/2, 18*(self.frame.size.height - 20)/280)];
    self.labelAccountType.font = [UIFont boldSystemFontOfSize:13];
    self.labelAccountType.textColor = [UIColor redColor];
    self.labelAccountType.textAlignment = NSTextAlignmentCenter;
    self.labelAccountType.text = [NSString stringWithFormat:@"%@:%@",VSLocalString(@"Account Type"),VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_USER_TYPE)];
    [self.accountBgScrollView addSubview:self.labelAccountType];
  
    
        NSArray * items = @[VSLocalString(@"Bind phone"),VSLocalString(@"Bind email")];
    
    [self SegmentAndScrollViewInitWithItems:items masObj:self.labelAccountType];
            
        for (int i = 0; i < 2; i++) {
                
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(i *self.scrollView.frame.size.width,0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            view.tag = 100+i;
            view.backgroundColor = VSDK_WHITE_COLOR;
            [self.scrollView addSubview:view];
                
            if (i == 0) {

                if([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) length]>0) {
                        
                        UILabel * bindTipsLabel = [[UILabel alloc]init];
                        
                        [view addSubview:bindTipsLabel];
                        
                        [bindTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(view.mas_left).with.offset(30);
                            make.top.equalTo(view.mas_top).with.offset(15);
                            make.right.equalTo(view.mas_right).with.offset(-10);
                            
                        }];
                        
                        bindTipsLabel.text = VSLocalString(@"You have bound this Phone");
                        [bindTipsLabel sizeToFit];
                        bindTipsLabel.textColor = VSDK_ORANGE_COLOR;
                        bindTipsLabel.numberOfLines = 0;
                        bindTipsLabel.textAlignment = NSTextAlignmentCenter;
                        bindTipsLabel.font = [UIFont boldSystemFontOfSize:16];
                        
                        
                        self.tfPhoneNum = [[UITextField alloc]init];
                        [view addSubview:self.tfPhoneNum];
                        
                        [self.tfPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(view.mas_left).with.offset(40);
                            make.top.equalTo(bindTipsLabel.mas_bottom).with.offset(15);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 80), 30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        self.tfPhoneNum.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
                        self.tfPhoneNum.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                        self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        
                        NSArray * phoneArr =     [VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) componentsSeparatedByString:@"#"];
                        self.tfPhoneNum.text = [NSString stringWithFormat:@"(+%@) %@",phoneArr[0],phoneArr[1]];
                        self.tfPhoneNum.userInteractionEnabled = NO;
                        self.tfPhoneNum.tintColor = VSDK_LIGHT_GRAY_COLOR;
                        self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
                        self.tfPhoneNum.delegate = self;
                        self.tfPhoneNum.font = [UIFont systemFontOfSize:15];
                        
                        UIButton * comfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                        [view addSubview:comfirmBtn];
                        
                        [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.tfPhoneNum.mas_left);
                            make.top.equalTo(self.tfPhoneNum.mas_bottom).with.offset(20);
                            make.right.equalTo(self.tfPhoneNum.mas_right);
                            make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60, 30 *(self.frame.size.height - 20)/280));
                        }];
                        
                        [comfirmBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        [comfirmBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_btn_bg")] forState:UIControlStateNormal];
                        comfirmBtn.layer.cornerRadius = 5;
                        
                        [comfirmBtn setTitle:VSLocalString(@"Back To User Center→") forState:UIControlStateNormal];
                        [comfirmBtn addTarget:self action:@selector(phoneBindcomfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];

                        UILabel * tipsLabel = [[UILabel alloc]init];
                        [view addSubview:tipsLabel];
                        
                        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(comfirmBtn.mas_left).with.offset(0);
                            make.top.equalTo(comfirmBtn.mas_bottom).with.offset(10);
                            make.right.equalTo(comfirmBtn.mas_right).with.offset(0);
                        }];
                        
                        tipsLabel.text = VSLocalString(@"You can claim rewards after binding.");
                        [tipsLabel sizeToFit];
                        tipsLabel.textColor =  VS_RGB(288, 73, 72);
                        tipsLabel.numberOfLines = 0;
                        tipsLabel.textAlignment = NSTextAlignmentCenter;
                        tipsLabel.font = [UIFont systemFontOfSize:14];
                        
                    }else{
                        
                        self.btnseletZone = [UIButton buttonWithType:UIButtonTypeSystem];
                        
                        [view addSubview:self.btnseletZone];
                        
                        [self.btnseletZone mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(view.mas_left).with.offset(30);
                            make.top.equalTo(view.mas_top).with.offset(10);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 60)/4, 30* (self.frame.size.height - 20)/280));
                        }];
                        
                        
                        if ([VSDeviceHelper getCountryAreaCodes].count >0) {
                            
                            NSString * str  = [NSString stringWithFormat:@"+%@",[VSDeviceHelper getCountryAreaCodes][0][@"data"][0][@"phone_code"]?[VSDeviceHelper getCountryAreaCodes][0][@"data"][0][@"phone_code"]:@"1"];
                            
                            [self.btnseletZone setTitle:VS_USERDEFAULTS_GETVALUE(@"vsdk_current_phoneCode")?VS_USERDEFAULTS_GETVALUE(@"vsdk_current_phoneCode"):str  forState:UIControlStateNormal];
                            
                        }else{
                            
                            NSArray * array = [VSDeviceHelper readLocalFileWithName:[kBundleName stringByAppendingPathComponent:[VSDK_ISSUED_AREA hasPrefix:@"Area-"]?VSDK_ISSUED_AREA:@"Area-Global"]];
                            NSString * str = [NSString stringWithFormat:@"+%@",array[0][@"data"][0][@"phone_code"]];
                            
                            [self.btnseletZone setTitle:VS_USERDEFAULTS_GETVALUE(@"vsdk_current_phoneCode")?VS_USERDEFAULTS_GETVALUE(@"vsdk_current_phoneCode"):str forState:UIControlStateNormal];
                            
                        }
                        [self.btnseletZone setTitleColor:VSDK_BLACK_COLOR forState:UIControlStateNormal];
                        self.btnseletZone.titleLabel.font = [UIFont systemFontOfSize:14];
                        self.btnseletZone.titleLabel.textAlignment = NSTextAlignmentCenter;
                        self.btnseletZone.layer.borderColor = VSDK_LIGHT_GRAY_COLOR.CGColor;
                        self.btnseletZone.layer.borderWidth = 0.4;
                        self.btnseletZone.layer.cornerRadius = 5;
                        [self.btnseletZone addTarget:self action:@selector(selectZonePhoneCode:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.tfPhoneNum = [[UITextField alloc]init];
                        [view addSubview:self.tfPhoneNum];
                        
                        [self.tfPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.btnseletZone.mas_right).with.offset(10);
                            make.top.equalTo(self.btnseletZone.mas_top);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 60)-(view.frame.size.width - 60)/4-10, 30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        self.tfPhoneNum.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
                        self.tfPhoneNum.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                        self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        self.tfPhoneNum.tintColor = VSDK_LIGHT_GRAY_COLOR;
                        self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
                        self.tfPhoneNum.placeholder =VSLocalString(@"Enter Phone Num");
                        self.tfPhoneNum.delegate = self;
                        self.tfPhoneNum.font = [UIFont systemFontOfSize:13];
                        
                        
                        self.tfVertifyCode = [[UITextField alloc]init];
                        [view addSubview:self.tfVertifyCode];
                        
                        [self.tfVertifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.btnseletZone.mas_left);
                            make.top.equalTo(self.btnseletZone.mas_bottom).with.offset(15);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 60)*4/7, 30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        
                        self.tfVertifyCode.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_vercode")]];
                        self.tfVertifyCode.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                        self.tfVertifyCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        self.tfVertifyCode.tintColor = VSDK_LIGHT_GRAY_COLOR;
                        self.tfVertifyCode.borderStyle = UITextBorderStyleRoundedRect;
                        self.tfVertifyCode.placeholder = VSLocalString(@"Enter Code");
                        self.tfVertifyCode.delegate = self;
                        self.tfVertifyCode.font = [UIFont systemFontOfSize:13];
                        
                        
                        self.btnSendPhoneCode = [UIButton buttonWithType:UIButtonTypeSystem];
                        [view addSubview:self.btnSendPhoneCode];
                        [self.btnSendPhoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.tfVertifyCode.mas_right).with.offset(15);
                            make.top.equalTo(self.tfVertifyCode.mas_top);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 60)*3/7-10, 30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        [self.btnSendPhoneCode setTitle:VSLocalString(@"Send Code") forState:UIControlStateNormal];
                        self.btnSendPhoneCode.titleLabel.font = [UIFont boldSystemFontOfSize:13];
                        [self.btnSendPhoneCode setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        [self.btnSendPhoneCode setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_captcha_btn_bg")] forState:UIControlStateNormal];
                        self.btnSendPhoneCode.layer.cornerRadius = 5;
                        [self.btnSendPhoneCode addTarget:self action:@selector(phoneNumVertifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        self.btnComfirmBindPhone = [UIButton buttonWithType:UIButtonTypeSystem];
                        [view addSubview:self.btnComfirmBindPhone];
                        
                        [self.btnComfirmBindPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.tfVertifyCode.mas_left);
                            make.top.equalTo(self.btnSendPhoneCode.mas_bottom).with.offset(15);
                            make.right.equalTo(self.btnSendPhoneCode.mas_right);
                            make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60, 30 *(self.frame.size.height - 20)/280));
                        }];
                        
                        [self.btnComfirmBindPhone setTitle:VSLocalString(@"Bind") forState:UIControlStateNormal];
                        [self.btnComfirmBindPhone setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        [self.btnComfirmBindPhone setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_btn_bg")] forState:UIControlStateNormal];
                        self.btnComfirmBindPhone.layer.cornerRadius = 5;
                        [self.btnComfirmBindPhone addTarget:self action:@selector(phoneBindcomfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        self.labelTipsBindPhone = [[UILabel alloc]init];
                        [view addSubview: self.labelTipsBindPhone];
                        
                        [ self.labelTipsBindPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.btnComfirmBindPhone.mas_left).with.offset(0);
                            make.top.equalTo(self.btnComfirmBindPhone.mas_bottom).with.offset(10);
                            make.right.equalTo(self.btnComfirmBindPhone.mas_right).with.offset(0);
                        }];
                        
                        self.labelTipsBindPhone.text = VSLocalString(@"You can claim rewards after binding.");
                        [ self.labelTipsBindPhone sizeToFit];
                        self.labelTipsBindPhone.textColor =  VS_RGB(288, 73, 72);
                        self.labelTipsBindPhone.numberOfLines = 0;
                        self.labelTipsBindPhone.textAlignment = NSTextAlignmentCenter;
                        self.labelTipsBindPhone.font = [UIFont systemFontOfSize:14];
                        
                    }
                    
                }else{
                    
                    if ([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL) length]>0) {
                        
                        UILabel * bindTipsLabel = [[UILabel alloc]init];
                        
                        [view addSubview:bindTipsLabel];
                        
                        [bindTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(view.mas_left).with.offset(30);
                            make.top.equalTo(view.mas_top).with.offset(15);
                            make.right.equalTo(view.mas_right).with.offset(-10);
                            
                        }];
                        
                        bindTipsLabel.text = VSLocalString(@"You have bound this Email");
                        [bindTipsLabel sizeToFit];
                        bindTipsLabel.textColor = VSDK_ORANGE_COLOR;
                        bindTipsLabel.numberOfLines = 0;
                        bindTipsLabel.textAlignment = NSTextAlignmentCenter;
                        bindTipsLabel.font = [UIFont boldSystemFontOfSize:16];
                        
                        
                        self.tfEmial = [[UITextField alloc]init];
                        [view addSubview:self.tfEmial];
                        
                        [self.tfEmial mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(view.mas_left).with.offset(40);
                            make.top.equalTo(bindTipsLabel.mas_bottom).with.offset(15);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 80), 30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        self.tfEmial.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
                        self.tfEmial.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                        self.tfEmial.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        
                        self.tfEmial.text = VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL);
                        self.tfEmial.userInteractionEnabled = NO;
                        self.tfEmial.tintColor = VSDK_LIGHT_GRAY_COLOR;
                        self.tfEmial.borderStyle = UITextBorderStyleRoundedRect;
                        self.tfEmial.delegate = self;
                        self.tfEmial.font = [UIFont systemFontOfSize:15];
                        
                        UIButton * comfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                        [view addSubview:comfirmBtn];
                        
                        [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.tfEmial.mas_left);
                            make.top.equalTo(self.tfEmial.mas_bottom).with.offset(20);
                            
                            make.right.equalTo(self.tfEmial.mas_right);
                            
                            make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60, 30 *(self.frame.size.height - 20)/280));
                        }];
                        
                        [comfirmBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        [comfirmBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_btn_bg")] forState:UIControlStateNormal];
                                               
                        [comfirmBtn setTitle:VSLocalString(@"Back To User Center→") forState:UIControlStateNormal];
                        [comfirmBtn addTarget:self action:@selector(phoneBindcomfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        UILabel * tipsLabel = [[UILabel alloc]init];
                        [view addSubview:tipsLabel];
                        
                        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(comfirmBtn.mas_left).with.offset(0);
                            make.top.equalTo(comfirmBtn.mas_bottom).with.offset(10);
                            make.right.equalTo(comfirmBtn.mas_right).with.offset(0);
                        }];
                        
                        tipsLabel.text = VSLocalString(@"You can claim rewards after binding.");
                        [tipsLabel sizeToFit];
                        tipsLabel.textColor =  VS_RGB(288, 73, 72);
                        tipsLabel.numberOfLines = 0;
                        tipsLabel.textAlignment = NSTextAlignmentCenter;
                        tipsLabel.font = [UIFont systemFontOfSize:14];

                    }else{
                        
                        self.tfEmial =   [[UITextField alloc]init];
                        [view addSubview:self.tfEmial];
                        
                        [self.tfEmial mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(view.mas_left).with.offset(30);
                            make.top.equalTo(view.mas_top).with.offset(8);
                            make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60,30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        self.tfEmial.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
                        self.tfEmial.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                        self.tfEmial.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        self.tfEmial.tintColor = VSDK_LIGHT_GRAY_COLOR;
                        self.tfEmial.borderStyle = UITextBorderStyleRoundedRect;
                        self.tfEmial.placeholder =VSLocalString(@"Enter Your Email");
                        self.tfEmial.delegate = self;
                        self.tfEmial.textAlignment = NSTextAlignmentCenter;
                        self.tfEmial.font = [UIFont systemFontOfSize:14];
                        
                        
                        self.tfEmailCode =   [[UITextField alloc]init];
                        [view addSubview:self.tfEmailCode];
                        
                        [self.tfEmailCode mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.tfEmial.mas_left);
                            make.top.equalTo(self.tfEmial.mas_bottom).with.offset(10);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 60)*4/7, 30 * (self.frame.size.height - 20)/280));
                        }];
                        
                        self.tfEmailCode.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_vercode")]];
                        self.tfEmailCode.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                        self.tfEmailCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        self.tfEmailCode.tintColor = VSDK_LIGHT_GRAY_COLOR;
                        self.tfEmailCode.borderStyle = UITextBorderStyleRoundedRect;
                        self.tfEmailCode.placeholder =VSLocalString(@"Enter Code");
                        self.tfEmailCode.delegate = self;
                        self.tfEmailCode.font = [UIFont systemFontOfSize:13];
                        
                        
                        self.btnSendEmialCode = [UIButton buttonWithType:UIButtonTypeSystem];
                        [view addSubview:self.btnSendEmialCode];
                        [self.btnSendEmialCode mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.tfEmailCode.mas_right).with.offset(10);
                            make.top.equalTo(self.tfEmailCode.mas_top);
                            make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 60)*3/7-10, 30 * (self.frame.size.height - 20)/280));
                        }];
                        [self.btnSendEmialCode setTitle:VSLocalString(@"Send Code") forState:UIControlStateNormal];
                        self.btnSendEmialCode.titleLabel.font = [UIFont boldSystemFontOfSize:13];
                        [self.btnSendEmialCode setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        [self.btnSendEmialCode setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_captcha_btn_bg")] forState:UIControlStateNormal];
                        self.btnSendEmialCode.layer.cornerRadius = 5;
                        [self.btnSendEmialCode addTarget:self action:@selector(emailVertifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.btnComfirmBindEmial = [UIButton buttonWithType:UIButtonTypeSystem];
                        [view addSubview:self.btnComfirmBindEmial];
                        
                        [self.btnComfirmBindEmial mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.equalTo(self.tfEmailCode.mas_left);
                            make.top.equalTo(self.btnSendEmialCode.mas_bottom).with.offset(15);
                            
                            make.right.equalTo(self.btnSendEmialCode.mas_right);
                            make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60, 30 *(self.frame.size.height - 20)/280));
                        }];
                        
                        [self.btnComfirmBindEmial setTitle:VSLocalString(@"Bind") forState:UIControlStateNormal];
                        [self.btnComfirmBindEmial setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        [self.btnComfirmBindEmial setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_btn_bg")] forState:UIControlStateNormal];
                        self.btnComfirmBindEmial.layer.cornerRadius = 5;
                        [self.btnComfirmBindEmial addTarget:self action:@selector(emailVertifycomfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        self.labelTipsBindEmail = [[UILabel alloc]init];
                        [view addSubview:self.labelTipsBindEmail];
                        
                        [self.labelTipsBindEmail mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.btnComfirmBindEmial.mas_left).with.offset(0);
                            make.top.equalTo(self.btnComfirmBindEmial.mas_bottom).with.offset(10);
                            make.right.equalTo(self.btnComfirmBindEmial.mas_right).with.offset(0);
                            
                        }];
                        
                        self.labelTipsBindEmail.text = VSLocalString(@"You can claim rewards after binding.");
                        
                        [self.labelTipsBindEmail sizeToFit];
                        self.labelTipsBindEmail.textColor =  VS_RGB(288, 73, 72);
                        self.labelTipsBindEmail.numberOfLines = 0;
                        self.labelTipsBindEmail.textAlignment = NSTextAlignmentCenter;
                        self.labelTipsBindEmail.font = [UIFont systemFontOfSize:14];
                }
            }
        }

    [VSDeviceHelper addAnimationInView:self Duration:0.5];
}



-(void)SegmentAndScrollViewInitWithItems:(NSArray *)items masObj:(UILabel *)label{
    
    
    self.segment  = [[UISegmentedControl alloc]initWithItems:items];
    self.segment .frame = CGRectMake(self.frame.size.width/5, VS_VIEW_BOTTOM(label) + 20, self.frame.size.width*3/5, 25 * (self.frame.size.height - 20)/280);
    [self.segment  setTitleTextAttributes:@{NSForegroundColorAttributeName: VSDK_WHITE_COLOR} forState:UIControlStateSelected];
    [self.segment  addTarget:self action:@selector(segmentControlSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    
    self.segment.selectedSegmentIndex = self.selectIndex;
    
    if (@available(iOS 13.0, *)) {
        self.segment .selectedSegmentTintColor = VSDK_ORANGE_COLOR;
    } else {
        self.segment .tintColor = VSDK_ORANGE_COLOR;
    }
    
    [self.accountBgScrollView addSubview:self.segment];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, VS_VIEW_BOTTOM(self.segment) + 5,self.accountBgScrollView.frame.size.width - 40 , 250)];
    self.scrollView.showsVerticalScrollIndicator =NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.accountBgScrollView addSubview:self.scrollView];
    
    if (self.selectIndex == 1) {
        
       self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        
    }
    
}



-(void)phoneAndEmialBindedThenSegmentAndScrollViewInitWithItems:(NSArray *)items masObj:(UILabel *)label{
   
    self.allBindsegment  = [[UISegmentedControl alloc]initWithItems:items];
    self.allBindsegment .frame = CGRectMake(self.frame.size.width/5,  VS_VIEW_BOTTOM(label) + 20, self.frame.size.width*3/5, 28 * (self.frame.size.height - 20)/280);
    [self.allBindsegment  setTitleTextAttributes:@{NSForegroundColorAttributeName: VSDK_WHITE_COLOR} forState:UIControlStateSelected];
    [self.allBindsegment  addTarget:self action:@selector(segmentControlSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    
    self.allBindsegment .selectedSegmentIndex = 0;
    if (@available(iOS 13.0, *)) {
        self.allBindsegment .selectedSegmentTintColor = VSDK_ORANGE_COLOR;
    } else {
        self.allBindsegment .tintColor = VSDK_ORANGE_COLOR;
    }
    
    [self.accountBgScrollView addSubview:self.allBindsegment];
    
    self.allBindscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, self.segment .frame.size.height + VS_VIEW_TOP(self.allBindsegment) + 5,self.accountBgScrollView.frame.size.width - 40 , 250)];
    self.allBindscrollView.showsVerticalScrollIndicator =NO;
    self.allBindscrollView.showsHorizontalScrollIndicator = NO;
    self.allBindscrollView.pagingEnabled = YES;
    self.allBindscrollView.bounces = NO;
    self.allBindscrollView.scrollEnabled = NO;
    self.allBindscrollView.backgroundColor = [UIColor redColor];
    [self.accountBgScrollView addSubview:self.allBindscrollView];
    
}

-(UIView *)textFieldLeftView:(UIImage*)image{
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 18, 20)];
    UIView  * lineView = [[UIView alloc]initWithFrame:CGRectMake(VS_VIEW_RIGHT(imageView) + 15, 8, 0.5, 25)];
    lineView.backgroundColor = VSDK_LIGHT_GRAY_COLOR;
    [leftView addSubview:lineView];
    imageView.image = image;
    [leftView addSubview:imageView];
    return leftView;
    
    
}



-(void)keyboardWillShow:(NSNotification *)noti{
    
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.frame = DEVICEPORTRAIT? CGRectMake(VS_VIEW_LEFT(self), 55, self.frame.size.width, self.frame.size.height): CGRectMake(VS_VIEW_LEFT(self), -self.frame.size.height*1/3, self.frame.size.width, self.frame.size.height);
        
        DEVICEPORTRAIT?CGRectMake(self.frame.size.width/2 + self.center.x-30,self.frame.origin.y -30, ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitW(70)):CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85));
        
        self.btnClose.frame = DEVICEPORTRAIT?CGRectMake(self.frame.size.width/2 + self.center.x-30,self.frame.origin.y -30, ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitW(70)):CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85));
        
    }];
    
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    self.center  = VS_RootVC.view.center;
    [UIView animateWithDuration:0.15 animations:^{
        self.btnClose.frame = DEVICEPORTRAIT?CGRectMake(self.frame.size.width/2 + self.center.x-30,self.frame.origin.y -30, ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitW(70)):CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85));
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [self endEditing:YES];
    
    return YES;
}

-(void)closeSocailView:(UIButton *)sender{

    [self.viewSocialBg removeFromSuperview];
    [self removeFromSuperview];
    VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
    [view vsdk_setUpCenterEntrance];
}


-(void)ViewEndEditing:(UITapGestureRecognizer *)tap{
    
    [self endEditing:YES];
}


-(void)segmentControlSelectedIndex:(UISegmentedControl *)segment{
    
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self bindPhoneNumMethod];
            break;
        case 1:
            [self bindEmialMethod];
            
            break;
        default:
            break;
    }
}


-(void)bindEmialMethod{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        
    }];
}


-(void)bindPhoneNumMethod{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
    }];
}



-(void)selectZonePhoneCode:(UIButton *)sender{
    
    self.countryPicker = [[VSCountryPickerView alloc] init];
    self.countryPicker.confirmClickBlock = ^(NSString * _Nonnull countryName, NSString * _Nonnull countryCode) {
        
        [sender setTitle:[NSString stringWithFormat:@"+%@",countryCode] forState:UIControlStateNormal] ;
        
        NSString * currentCode = [NSString stringWithFormat:@"+%@",countryCode];
        VS_USERDEFAULTS_SETVALUE(currentCode, @"vsdk_current_phoneCode");
        
    };
    [VS_RootVC.view addSubview:self.countryPicker];
    
    [self.countryPicker showCountryPickerView];
    
    
}

-(void)phoneNumVertifyBtnClick:(UIButton *)sender{
    
    NSString * MOBILE = @"^[0-9]{5,}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (![regextestmobile evaluateWithObject:self.tfPhoneNum.text]){
        
        VS_SHOW_INFO_MSG(@"Invalid phone number");return;
        
    }else{
        
        [self openCountdownWithSeconds:120];
        
        NSString * formatPhoneNum = [NSString stringWithFormat:@"%@#%@",[self.btnseletZone.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""],self.tfPhoneNum.text];
        
        [[VSDKAPI shareAPI]  ucGetVertifyCodeWithPhoneNum:formatPhoneNum Success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                VS_SHOW_SUCCESS_STATUS(@"Verification code has been sent");
                
            }else{
                
                VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            }
            
        } Failure:^(NSString *failure) {
            
        }];
        
    }
    
}


-(void)openCountdownWithSeconds:(NSInteger)seconds{
    
    __block NSInteger time = seconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.btnSendPhoneCode setTitle:VSLocalString(@"Send Code") forState:UIControlStateNormal];
                
                [self.btnSendPhoneCode setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_captcha_btn_bg")] forState:UIControlStateNormal];
                self.btnSendPhoneCode.enabled = YES;
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.btnSendPhoneCode setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_captcha_send_btn_bg")] forState:UIControlStateNormal];
                
                self.btnSendPhoneCode.enabled = NO;
                //设置按钮显示读秒效果
                [self.btnSendPhoneCode setTitle:[NSString stringWithFormat:@"%.1lds", (long)time] forState:UIControlStateNormal];
            });
            
            time--;
        }
    });
    
    dispatch_resume(_timer);
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
   if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

#pragma mark -- 手机+验证码绑定
-(void)phoneBindcomfirmBtnClick:(UIButton *)sender{
    
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"Back To User Center→")]) {
        
        [self backToUserCenterToGetReward:sender];
        
    }else{
    
//        NSString * MOBILE = @"[1-9][0-9]{10}";
//        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//
//        if (![regextestmobile evaluateWithObject:self.tfPhoneNum.text]||[self.tfVertifyCode.text length] == 0) {
//
//            VS_SHOW_INFO_MSG(@"Invalid phone number or verification code");return;
//        }
        
        if (![self deptNumInputShouldNumber:self.tfPhoneNum.text]||[self.tfVertifyCode.text length] == 0) {

            VS_SHOW_INFO_MSG(@"Invalid phone number or verification code");
            return;
        }
        
        NSString * formatPhoneNum = [NSString stringWithFormat:@"%@#%@",[self.btnseletZone.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""],self.tfPhoneNum.text];
        
        [[VSDKAPI shareAPI]  ucComfirmBindPhoneNumWithCode:self.tfVertifyCode.text PhoneFormatNum:formatPhoneNum Success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
                VS_USERDEFAULTS_SETVALUE(formatPhoneNum, VSDK_ASSISTANT_BIND_PHOME);
                
                self.tfPhoneNum.hidden = YES ;
                self.tfVertifyCode.hidden = YES ;
                self.btnseletZone .hidden = YES ;
                self.btnSendPhoneCode .hidden = YES ;
                self.btnComfirmBindPhone .hidden = YES ;
                self.labelTipsBindPhone .hidden = YES ;
                
        
                UIView * view = [self viewWithTag:100];
                
                UILabel * bindTipsLabel = [[UILabel alloc]init];
                
                [view addSubview:bindTipsLabel];
                
                [bindTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(view.mas_left).with.offset(30);
                    make.top.equalTo(view.mas_top).with.offset(15);
                    make.right.equalTo(view.mas_right).with.offset(-10);
                    
                }];
                    
                bindTipsLabel.text = VSLocalString(@"You have bound this Phone");
                [bindTipsLabel sizeToFit];
                bindTipsLabel.textColor = VSDK_ORANGE_COLOR;
                bindTipsLabel.numberOfLines = 0;
                bindTipsLabel.textAlignment = NSTextAlignmentCenter;
                bindTipsLabel.font = [UIFont boldSystemFontOfSize:16];
                
                
                UITextField * bindPhoneTF= [[UITextField alloc]init];
                [view addSubview:bindPhoneTF];
                    
                [bindPhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(view.mas_left).with.offset(40);
                    make.top.equalTo(bindTipsLabel.mas_bottom).with.offset(15);
                    make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 80), 30 * (self.frame.size.height - 20)/280));
                }];
                
                bindPhoneTF.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
                bindPhoneTF.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                bindPhoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                bindPhoneTF.text = [NSString stringWithFormat:@"(+%@) %@",[self.btnseletZone.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""],self.tfPhoneNum.text];
                bindPhoneTF.userInteractionEnabled = NO;
                bindPhoneTF.tintColor = VSDK_LIGHT_GRAY_COLOR;
                bindPhoneTF.borderStyle = UITextBorderStyleRoundedRect;
                bindPhoneTF.delegate = self;
                bindPhoneTF.font = [UIFont systemFontOfSize:15];
                
                UIButton * comfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                [view addSubview:comfirmBtn];
                
                [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(bindPhoneTF.mas_left);
                    make.top.equalTo(bindPhoneTF.mas_bottom).with.offset(20);
                    make.right.equalTo(bindPhoneTF.mas_right);
                    make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60, 30 *(self.frame.size.height - 20)/280));
                }];
            
                    
                 self.rewardEvent = VSDK_BIND_PHONE_EVENT;
                
                [comfirmBtn setTitle:VSLocalString(@"Back To User Center→") forState:UIControlStateNormal];
                [comfirmBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_btn_bg")] forState:UIControlStateNormal];
                [comfirmBtn addTarget:self action:@selector(backToUserCenterToGetReward:) forControlEvents:UIControlEventTouchUpInside];
    
                
                comfirmBtn.layer.cornerRadius = 5;
                [comfirmBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                
                
                UILabel * tipsLabel = [[UILabel alloc]init];
                [view addSubview:tipsLabel];
                
                [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(comfirmBtn.mas_left).with.offset(0);
                    make.top.equalTo(comfirmBtn.mas_bottom).with.offset(10);
                    make.right.equalTo(comfirmBtn.mas_right).with.offset(0);
                }];
                
                tipsLabel.text = VSLocalString(@"You can claim rewards after binding.");
                [tipsLabel sizeToFit];
                tipsLabel.textColor =  VS_RGB(288, 73, 72);
                tipsLabel.numberOfLines = 0;
                tipsLabel.textAlignment = NSTextAlignmentCenter;
                tipsLabel.font = [UIFont systemFontOfSize:14];
     
            }else{
                
                VS_SHOW_INFO_MSG(@"Failed to bind Phone. Please try again later.")
                
            }
            
        } Failure:^(NSString *failure) {
            
        }];
        
    }
  
}

#pragma mark -- 发送邮箱验证码接口
-(void)emailVertifyBtnClick:(UIButton *)sender{
    
    if (![VSDeviceHelper RegexWithString:self.tfEmial.text pattern:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$"]) {
        
        VS_SHOW_INFO_MSG(@"Please Enter a Valid Email Address!");return;
    }else{
        
        VS_SHOW_TIPS_MSG(@"Send...");
        
        [self openEmailCountdownWithSeconds:120];
        
        [[VSDKAPI shareAPI]  postSecurityCodeWithToken:[VSDKShareHelper vsdk_latestRefreshedLoginToken] BindMail:self.tfEmial.text success:^( id responseObject) {
            
            VS_HUD_HIDE;
            
            if (REQUESTSUCCESS) {
                VS_SHOW_SUCCESS_STATUS(@"Sent");
            }else{
                VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            }
            
        } failure:^( NSString *failure) {
            
        }];
    }
}


-(void)openEmailCountdownWithSeconds:(NSInteger)seconds{
    
    __block NSInteger time = seconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.btnSendEmialCode setTitle:VSLocalString(@"Send Code") forState:UIControlStateNormal];
                
                [self.btnSendEmialCode setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_captcha_btn_bg")] forState:UIControlStateNormal];
                self.btnSendEmialCode.enabled = YES;
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.btnSendEmialCode setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_captcha_send_btn_bg")] forState:UIControlStateNormal];
                
                self.btnSendEmialCode.enabled = NO;
                //设置按钮显示读秒效果
                [self.btnSendEmialCode setTitle:[NSString stringWithFormat:@"%.1lds", (long)time] forState:UIControlStateNormal];
            });
            
            time--;
        }
    });
    
    dispatch_resume(_timer);
    
}


-(void)emailVertifycomfirmBtnClick:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"Back To User Center→")]) {
        
        [self removeFromSuperview];
        [self.viewSocialBg removeFromSuperview];
        
        VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
         [view vsdk_setUpCenterEntrance];
        
    }else{
        
        if (![VSDeviceHelper RegexWithString:self.tfEmial.text pattern:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$"]||[self.tfEmailCode.text length] == 0) {
            
            VS_SHOW_INFO_MSG(@"Invalid email adress or verification code");return;
        }
        
        [[VSDKAPI shareAPI]  ucBindSecurityEmainWithToken:[VSDKShareHelper vsdk_latestRefreshedLoginToken] BindMail:self.tfEmial.text VertifyCode:self.tfEmailCode.text success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
#pragma mark -- 在这里判断是否弹出修改密码的弹窗逻辑
                
                VS_USERDEFAULTS_SETVALUE(self.tfEmial.text, VSDK_ASSISTANT_BIND_MAIL);
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_GIFT_CRET], VSDK_BIND_GIFT_CRET);
                
                if ([VS_USERDEFAULTS_GETVALUE(VSDK_IF_FORM_UID) isEqual:@1]) {
                    
                    [self.viewSocialBg removeFromSuperview];
                    [self removeFromSuperview];
                    
                    VS_SHOW_SUCCESS_STATUS(@"Security email bound. You can change your password now!");
                                               
                    VS_USERDEFAULTS_SETVALUE(@NO, VSDK_IF_FORM_UID);
                    
                    self.viewEditPwd = [[VSEditPassWord alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
                   self.viewEditPwd.labelAccount.text  = self.self.tfEmial.text;
                 self.viewEditPwd.center =VS_RootVC.view.center;
                 [VSDeviceHelper addAnimationInView:_viewEditPwd Duration:0.4];
                  [self.viewEditPwd passwordViewBlock:^(VSEditPswViewBlockType type) {
                             switch (type) {
                                 case VSEditPswViewBlockBack:
                                     
                                     [self removePassWordView];
                                     
                                     break;
                                     
                                 case VSEditPswViewBlockComfirm:
                                     
                                     [self comfirmNewPswWithToken:[GETRESPONSEDATA:VSDK_PARAM_TOKEN]];
                                     
                                     break;
                                     
                                 default:
                                     break;
                             }
                             
                         }];
                         
                    [VS_RootVC.view addSubview:self.viewEditPwd];
                    
                    
                }else{
                
                    self.tfEmial.hidden = YES;
                   self.tfEmailCode.hidden = YES;
                   self.btnSendEmialCode.hidden = YES;
                   self.labelTipsBindEmail.hidden = YES;
                   self.btnComfirmBindEmial.hidden = YES;
                    
                    
                           
                    UIView * view = [self viewWithTag:101];
                    UILabel * bindTipsLabel = [[UILabel alloc]init];
                    
                    [view addSubview:bindTipsLabel];
                    
                    [bindTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(view.mas_left).with.offset(30);
                        make.top.equalTo(view.mas_top).with.offset(15);
                        make.right.equalTo(view.mas_right).with.offset(-10);
                        
                    }];
                    
                    bindTipsLabel.text = VSLocalString(@"You have bound this Email");
                    [bindTipsLabel sizeToFit];
                    bindTipsLabel.textColor = VSDK_ORANGE_COLOR;
                    bindTipsLabel.numberOfLines = 0;
                    bindTipsLabel.textAlignment = NSTextAlignmentCenter;
                    bindTipsLabel.font = [UIFont boldSystemFontOfSize:16];
                    
                    
                    UITextField * bindEmialTF = [[UITextField alloc]init];
                    [view addSubview:bindEmialTF];
                    
                    [bindEmialTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(view.mas_left).with.offset(40);
                        make.top.equalTo(bindTipsLabel.mas_bottom).with.offset(15);
                        make.size.mas_equalTo(CGSizeMake((view.frame.size.width - 80), 30 * (self.frame.size.height - 20)/280));
                    }];
                    
                    bindEmialTF.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
                    bindEmialTF.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                    bindEmialTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    bindEmialTF.text = self.tfEmial.text;
                    bindEmialTF.userInteractionEnabled = NO;
                    bindEmialTF.tintColor = VSDK_LIGHT_GRAY_COLOR;
                    bindEmialTF.borderStyle = UITextBorderStyleRoundedRect;
                    bindEmialTF.delegate = self;
                    bindEmialTF.font = [UIFont systemFontOfSize:15];
                    
                    UIButton * comfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                    [view addSubview:comfirmBtn];
                    
                    [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(bindEmialTF.mas_left);
                        make.top.equalTo(bindEmialTF.mas_bottom).with.offset(20);
                        
                        make.right.equalTo(bindEmialTF.mas_right);
                        
                        make.size.mas_equalTo(CGSizeMake(view.frame.size.width - 60, 30 *(self.frame.size.height - 20)/280));
                    }];
                
                    self.rewardEvent = VSDK_BIND_MAIL_EVENT;
                    [comfirmBtn setTitle:VSLocalString(@"Back To User Center→") forState:UIControlStateNormal];
                    [comfirmBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                    [comfirmBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_binding_btn_bg")] forState:UIControlStateNormal];
                    comfirmBtn.layer.cornerRadius = 5;
                    [comfirmBtn addTarget:self action:@selector(backToUserCenterToGetReward:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    UILabel * tipsLabel = [[UILabel alloc]init];
                    [view addSubview:tipsLabel];
                    
                    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.equalTo(comfirmBtn.mas_left).with.offset(0);
                        make.top.equalTo(comfirmBtn.mas_bottom).with.offset(10);
                        make.right.equalTo(comfirmBtn.mas_right).with.offset(0);
                    }];
                    
                    tipsLabel.text = VSLocalString(@"You can claim rewards after binding.");
                    [tipsLabel sizeToFit];
                    tipsLabel.textColor =  VS_RGB(288, 73, 72);
                    tipsLabel.numberOfLines = 0;
                    tipsLabel.textAlignment = NSTextAlignmentCenter;
                    tipsLabel.font = [UIFont systemFontOfSize:14];
                    
                }
            
                
            }else{
                
                VS_SHOW_INFO_MSG(@"Failed to bind Email. Please try again later.")
            }
            
        } failure:^(NSString *failure) {
            
        }];
        
    }
}


-(void)removePassWordView{
    
    [_viewEditPwd removeFromSuperview];
    
}



#pragma mark -- 找回密码事件
//找回密码View 提交新密码事件
-(void)comfirmNewPswWithToken:(NSString *)tokenStr{
    
    
    if ([self.viewEditPwd.btnComfirm.titleLabel.text isEqualToString:VSLocalString(@"Back To User Center→")]) {
        
         [self.viewEditPwd removeFromSuperview];self.viewEditPwd = nil;
          
         VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
         [view vsdk_setUpCenterEntrance];
        
    }else{
       
    VS_SHOW_TIPS_MSG(@"Changing...");
    
    [[VSDKAPI shareAPI]  updateNewPwd:self.viewEditPwd.tfNewPwd.text  tokenStr:tokenStr success:^(id responseObject) {
        
         VS_HUD_HIDE;
        
        if (REQUESTSUCCESS) {
            
            VS_SHOW_SUCCESS_STATUS(@"Change Succeed!");
            
#pragma mark -- 返回领取奖励
            [self.viewEditPwd.btnComfirm setTitle:VSLocalString(@"Back To User Center→") forState:UIControlStateNormal];
       
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_UID_EVENT], VSDK_ASSISTANT_BIND_UID);
            
        }else{
            
            VS_SHOW_ERROR_STATUS(@"Change failed,please retry!");
        }
        
    } failure:^(NSString *failure) {
        
    }];
        
    }
}




-(void)backToUserCenterToGetReward:(UIButton *)sender{
 
    [self removeFromSuperview];
    [self.viewSocialBg removeFromSuperview];
    VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
    [view vsdk_setUpCenterEntrance];
    
}

@end
