//
//  VSUserCenterEntrance.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSUserCenterEntrance.h"
#import "VSSDKDefine.h"

@interface VSUserCenterEntrance ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIScrollView * accountBgScrollView;
@property(nonatomic,strong)UILabel * labelAccountType;
@property(nonatomic,strong)UIView * viewSocialBg;
@property(nonatomic,strong)UIButton * btnClose;
@property(nonatomic,strong)UILabel * labelUndone;
@property(nonatomic,strong)NSString * emailToken;
@property(nonatomic,strong)NSString * changePwdToken;
@property(nonatomic,strong)NSArray * eventArr;
@property(nonatomic,strong)NSString * eventType;
@property(nonatomic,assign)CGFloat  btnWidthTitle;
@property(nonatomic,assign)CGFloat  btnWidthClaim;
@property(nonatomic,strong)VSUserCenterTF * tfPhoneNum;
@property(nonatomic,strong)VSUserCenterTF * tfEmail;
@property(nonatomic,strong)VSEditPassWord * viewWditPwd;
@property(nonatomic,strong)VSUserCenterTF * tfUid;
@property(nonatomic,strong)VSRetrieveView * viewRetrieve;
@property(nonatomic,strong)VSGiftCodeView * viewGiftCode;
@end

@implementation VSUserCenterEntrance

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 13.0, *)) {
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }else {
            
        }
    
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(void)vsdk_setUpCenterEntrance{
    
        self.btnWidthTitle =  [VSDeviceHelper sizeWithFontStr:VSLocalString(@"Change Password") WithFontSize:12] + 10;

        self.btnWidthClaim = [VSDeviceHelper sizeWithFontStr:VSLocalString(@"Claim") WithFontSize:12] + 8;

        self.viewSocialBg = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
        self.viewSocialBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];


        CGFloat assW = ADJUSTPadAndPhonePortraitW(727);
        CGFloat assH = ADJUSTPadAndPhonePortraitH(614,[VSDeviceHelper getExpansionFactorWithphoneOrPad]);

        self.frame =isPad?DEVICEPORTRAIT?CGRectMake(0, 0, assW * 1.3,assH * 1.3):CGRectMake(0, 0, ADJUSTPadAndPhoneW(1187),ADJUSTPadAndPhoneH(991)):DEVICEPORTRAIT?CGRectMake(20, 30, SCREE_WIDTH - 40, (SCREE_WIDTH - 40)):CGRectMake(20, 30, (SCREE_HEIGHT - 50)*1.2, SCREE_HEIGHT - 50);

    
        self.layer.cornerRadius = 10;
        self.backgroundColor = VSDK_WHITE_COLOR;
        self.center =VS_RootVC.view.center;
        [self.viewSocialBg addSubview:self];
        [VS_RootVC.view addSubview:self.viewSocialBg];

        self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];

        self.btnClose.frame = isPad? CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85)):DEVICEPORTRAIT?CGRectMake(self.frame.size.width/2 + self.center.x-30,self.frame.origin.y -30, ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitW(70)):CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85));

        [self.btnClose setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
        [self.btnClose addTarget:self action:@selector(closeCenterEntranceView:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewSocialBg addSubview:self.btnClose];

        self.accountBgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
        self.accountBgScrollView.contentSize = isPad?CGSizeMake(self.frame.size.width, self.frame.size.height+40):CGSizeMake(self.frame.size.width, self.frame.size.height-20);
        self.accountBgScrollView.showsVerticalScrollIndicator =NO;
        self.accountBgScrollView.showsHorizontalScrollIndicator = NO;
        self.accountBgScrollView.scrollEnabled = NO;
        [self.accountBgScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewEndEditing:)]];
        [self addSubview:self.accountBgScrollView];


        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40 * (self.frame.size.height - 20)/280)];
        titleLabel.text =VSLocalString(@"User Center");
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


        self.labelAccountType= [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 23* (self.frame.size.height - 20)/280, self.frame.size.width/2, 18*(self.frame.size.height - 20)/280)];
        self.labelAccountType.font = [UIFont boldSystemFontOfSize:13];
        self.labelAccountType.textColor = [UIColor redColor];
        self.labelAccountType.textAlignment = NSTextAlignmentCenter;
        self.labelAccountType.text = [NSString stringWithFormat:@"%@:%@",VSLocalString(@"Account Type"),VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_USER_TYPE)];
        [self.accountBgScrollView addSubview:self.labelAccountType];

        [self layOutTobeDoneLabelWithFinishBind];
    
        [VSDeviceHelper addAnimationInView:self Duration:0.5];
    
}


-(void)layOutTobeDoneLabelWithFinishBind{
    
    
    if ([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL) length]>0&&[VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) length]>0) {

        if ([VS_CONVERT_TYPE(VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_UID)) length]>0) {
            
            self.tfPhoneNum = [[VSUserCenterTF alloc]init];
            [self.accountBgScrollView addSubview:self.tfPhoneNum];

            [self.tfPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
               
               make.left.equalTo(self.accountBgScrollView.mas_left).with.offset(40);
               make.top.equalTo(self.labelAccountType.mas_bottom).with.offset(20);
               make.right.equalTo(self.accountBgScrollView.mas_right).with.offset(-40);
               make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 35 * (self.frame.size.height - 20)/280));
            }];

            self.tfPhoneNum.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
            self.tfPhoneNum.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
            self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

            NSArray * phoneArr = [VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) componentsSeparatedByString:@"#"];
            self.tfPhoneNum.text =  [NSString stringWithFormat:@"(+%@) %@",phoneArr[0],phoneArr[1]];
            
            if ([VS_USERDEFAULTS_GETVALUE(VSDK_PHONE_GIFT_STATE)isEqual:@0]) {

                [self layClaimBtnWithSuperView:self.tfPhoneNum andTag:1001];
                
            }else{
                
                self.tfPhoneNum.rightView = [self userCentertextFieldRightView];
            }
        
            self.tfPhoneNum.tag = 101;
            
            self.tfPhoneNum.rightViewMode=UITextFieldViewModeAlways;
            UITapGestureRecognizer * TapPhone = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
            [self.tfPhoneNum addGestureRecognizer:TapPhone];
            self.tfPhoneNum.tintColor = VSDK_LIGHT_GRAY_COLOR;
            self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
            self.tfPhoneNum.delegate = self;
            self.tfPhoneNum.font = [UIFont systemFontOfSize:15];


            self.tfEmail = [[VSUserCenterTF alloc]init];
            [self.accountBgScrollView addSubview:self.tfEmail];

            [self.tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
               
               make.left.equalTo(self.tfPhoneNum.mas_left);
               make.top.equalTo(self.tfPhoneNum.mas_bottom).with.offset(20);
               make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80),35 *(self.frame.size.height - 20)/280));
            }];

            self.tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
            if ([VS_USERDEFAULTS_GETVALUE(VSDK_EMAIL_GIFT_STATE)isEqual:@0]) {
                
              [self layClaimBtnWithSuperView:self.tfEmail andTag:1002];
                
            }else{
                
               self.tfEmail.rightView = [self userCentertextFieldRightView];
                
            }
            
            self.tfEmail.rightViewMode=UITextFieldViewModeAlways;
            self.tfEmail.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
            self.tfEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.tfEmail.text = VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL);
            self.tfEmail.tag = 102;
            UITapGestureRecognizer * TapMail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
             [self.tfEmail addGestureRecognizer:TapMail];
            self.tfEmail.tintColor = VSDK_LIGHT_GRAY_COLOR;
            self.tfEmail.borderStyle = UITextBorderStyleRoundedRect;
            self.tfEmail.delegate = self;
            self.tfEmail.font = [UIFont systemFontOfSize:15];
            
            
            self.tfUid = [[VSUserCenterTF alloc]init];
            [self.accountBgScrollView addSubview:self.tfUid];

            [self.tfUid mas_makeConstraints:^(MASConstraintMaker *make) {
              
              make.left.equalTo(self.tfEmail.mas_left);
              make.top.equalTo(self.tfEmail.mas_bottom).with.offset(20);
              make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 35 * (self.frame.size.height - 20)/280));
            }];

            self.tfUid.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
            self.tfUid.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
            self.tfUid.rightViewMode=UITextFieldViewModeAlways;
            self.tfUid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.tfUid.text = [NSString stringWithFormat:@"UID:%@",VSDK_GAME_USERID];
            self.tfUid.tintColor = VSDK_LIGHT_GRAY_COLOR;
            self.tfUid.tag = 103;
            UITapGestureRecognizer * TapUid = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
            [self.tfUid addGestureRecognizer:TapUid];
            self.tfUid.borderStyle = UITextBorderStyleRoundedRect;
            self.tfUid.delegate = self;
            self.tfUid.font = [UIFont systemFontOfSize:15];
            
            
            if ([VS_USERDEFAULTS_GETVALUE(VSDK_UID_GIFT_STATE)isEqual:@0]) {
               
                [self layClaimBtnWithSuperView:self.tfUid andTag:1003];
                
                UIButton * editPswdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
               [self.accountBgScrollView addSubview:editPswdBtn];
               
               [editPswdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                  
                   make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                   make.right.equalTo(self.tfUid.mas_right).with.offset(-25-self.btnWidthClaim);
                  make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                   
               }];
               editPswdBtn.tag = 1004;
               editPswdBtn.layer.cornerRadius = 5.f;
               [editPswdBtn setBackgroundColor:[UIColor orangeColor]];
               [editPswdBtn setTitle:VSLocalString(@"Change Pwd") forState:UIControlStateNormal];
               editPswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
               [editPswdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               editPswdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
               [editPswdBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }else{
                
                self.tfUid.rightView = [self userCentertextFieldRightView];
                
                UIButton * editPswdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                
                [self.accountBgScrollView addSubview:editPswdBtn];
                
                [editPswdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                   make.right.equalTo(self.tfUid.mas_right).with.offset(-38);
                
                  make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                    
                }];
                editPswdBtn.tag = 1004;
                editPswdBtn.layer.cornerRadius = 5.f;
                [editPswdBtn setBackgroundColor:[UIColor orangeColor]];
                [editPswdBtn setTitle:VSLocalString(@"Change Pwd") forState:UIControlStateNormal];
                editPswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [editPswdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                editPswdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [editPswdBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            UILabel * rewardTipsLabel = [[UILabel alloc]init];

           [self.accountBgScrollView addSubview:rewardTipsLabel];

           [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {

              make.left.equalTo(self.mas_left);
              make.bottom.equalTo(self.mas_bottom).with.offset(-15);
              make.right.equalTo(self.mas_right);

            }];

           rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
           [rewardTipsLabel sizeToFit];
           rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
           rewardTipsLabel.numberOfLines = 0;
           rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
           rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];
                   
               
        }else{
        
        
         self.tfPhoneNum = [[VSUserCenterTF alloc]init];
        [self.accountBgScrollView addSubview:self.tfPhoneNum];

        [self.tfPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.left.equalTo(self.accountBgScrollView.mas_left).with.offset(40);
           make.top.equalTo(self.labelAccountType.mas_bottom).with.offset(20);
           make.right.equalTo(self.accountBgScrollView.mas_right).with.offset(-40);
           make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));
        }];

        self.tfPhoneNum.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
        self.tfPhoneNum.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        NSArray * phoneArr = [VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) componentsSeparatedByString:@"#"];
        self.tfPhoneNum.text =  [NSString stringWithFormat:@"(+%@) %@",phoneArr[0],phoneArr[1]];
        
       if ([VS_USERDEFAULTS_GETVALUE(VSDK_PHONE_GIFT_STATE)isEqual:@0]) {
        
           [self layClaimBtnWithSuperView:self.tfPhoneNum andTag:1001];
           
       }else{
           
           self.tfPhoneNum.rightView = [self userCentertextFieldRightView];
       }
            
        
        self.tfPhoneNum.rightViewMode=UITextFieldViewModeAlways;
        self.tfPhoneNum.tag = 101;
        UITapGestureRecognizer * TapPhone = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
        [self.tfPhoneNum addGestureRecognizer:TapPhone];
            
        self.tfPhoneNum.tintColor = VSDK_LIGHT_GRAY_COLOR;
        self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
        self.tfPhoneNum.delegate = self;
        self.tfPhoneNum.font = [UIFont systemFontOfSize:15];


        self.tfEmail = [[VSUserCenterTF alloc]init];
        [self.accountBgScrollView addSubview:self.tfEmail];

        [self.tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.left.equalTo(self.tfPhoneNum.mas_left);
           make.top.equalTo(self.tfPhoneNum.mas_bottom).with.offset(15);
           make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));
        }];

        self.tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
            
        if ([VS_USERDEFAULTS_GETVALUE(VSDK_EMAIL_GIFT_STATE)isEqual:@0]) {
           
           [self layClaimBtnWithSuperView:self.tfEmail andTag:1002];
        }else{
            
         self.tfEmail.rightView = [self userCentertextFieldRightView];
            
        }
      
        self.tfEmail.rightViewMode=UITextFieldViewModeAlways;
        self.tfEmail.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        self.tfEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.tfEmail.text = VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL);
        self.tfEmail.tag = 102;
        UITapGestureRecognizer * TapMail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
        [self.tfEmail addGestureRecognizer:TapMail];
        self.tfEmail.tintColor = VSDK_LIGHT_GRAY_COLOR;
        self.tfEmail.borderStyle = UITextBorderStyleRoundedRect;
        self.tfEmail.delegate = self;
        self.tfEmail.font = [UIFont systemFontOfSize:15];
        
        
        self.labelUndone = [[UILabel alloc]init];
               
       [self.accountBgScrollView addSubview:self.labelUndone];
       
       [self.labelUndone mas_makeConstraints:^(MASConstraintMaker *make) {

           make.left.equalTo(self.tfEmail);
           make.top.equalTo(self.tfEmail.mas_bottom).with.offset(5);
           make.right.equalTo(self.tfEmail);
           make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));

       }];
   
       self.labelUndone.text =VSLocalString(@"To-do quests");
            
            if ([self isKorean]) {
                self.labelUndone.text = @"임무";
            }
            
       self.labelUndone.textColor = VS_RGB(33, 186, 250);
       self.labelUndone.textAlignment = NSTextAlignmentCenter;
       self.labelUndone.font = [UIFont boldSystemFontOfSize:16];
       [self.accountBgScrollView addSubview:self.labelUndone];

       
       
        UILabel * rewardTipsLabel = [[UILabel alloc]init];

       [self.accountBgScrollView addSubview:rewardTipsLabel];

       [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {

           
           
          make.left.equalTo(self.mas_left);
          make.bottom.equalTo(self.mas_bottom).with.offset(-15);
          make.right.equalTo(self.mas_right);

        }];

       rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
       [rewardTipsLabel sizeToFit];
       rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
       rewardTipsLabel.numberOfLines = 0;
       rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
       rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];
       
       
       UIView * eventBgView = [[UIView alloc]init];

       [self.accountBgScrollView addSubview:eventBgView];

       [eventBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
          make.top.equalTo(self.labelUndone.mas_bottom).with.offset(10);
          make.left.equalTo(self.mas_left).with.offset(40);
          make.bottom.equalTo(rewardTipsLabel.mas_top).with.offset(-20);
          make.right.equalTo(self.mas_right).with.offset(-40);

       }];
       
       eventBgView.backgroundColor = [UIColor whiteColor];
       eventBgView.layer.cornerRadius = 8;
       eventBgView.layer.borderWidth = 2;
       eventBgView.layer.borderColor = [UIColor orangeColor].CGColor;
       [eventBgView layoutIfNeeded];

        self.eventArr = @[VSLocalString(@"Activate UID account")];

        self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:self.tableView];

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {

          make.top.equalTo(eventBgView.mas_top).with.offset(2);
          make.right.equalTo(eventBgView.mas_right).with.offset(-2);
          make.left.equalTo(eventBgView.mas_left).with.offset(2);
          make.bottom.equalTo(eventBgView.mas_bottom).with.offset(-2);

        }];


        [self.tableView layoutIfNeeded];
        self.tableView.rowHeight = eventBgView.frame.size.height/self.eventArr.count;
        self.tableView.layer.cornerRadius = 7.5;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;


        }
        
    }else if ([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL) length]>0) {
        
        
        if ([VS_CONVERT_TYPE(VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_UID)) length]>0) {
            
            self.tfEmail = [[VSUserCenterTF alloc]init];
                  [self.accountBgScrollView addSubview:self.tfEmail];

                  [self.tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                      make.left.equalTo(self.accountBgScrollView.mas_left).with.offset(40);
                      make.top.equalTo(self.labelAccountType.mas_bottom).with.offset(20);
                      make.right.equalTo(self.accountBgScrollView.mas_right).with.offset(-40);
                      make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));
                 }];

                  self.tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
                    if ([VS_USERDEFAULTS_GETVALUE(VSDK_EMAIL_GIFT_STATE)isEqual:@0]) {
                                
                      [self layClaimBtnWithSuperView:self.tfEmail andTag:1002];
                        
                    }else{
                        
                       self.tfEmail.rightView = [self userCentertextFieldRightView];
                        
                    }
                  self.tfEmail.rightViewMode=UITextFieldViewModeAlways;
                  self.tfEmail.text = VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL);
                  self.tfEmail.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                  self.tfEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                self.tfEmail.tag = 102;
                UITapGestureRecognizer * TapMail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
                [self.tfEmail addGestureRecognizer:TapMail];
                  self.tfEmail.tintColor = VSDK_LIGHT_GRAY_COLOR;
                  self.tfEmail.borderStyle = UITextBorderStyleRoundedRect;
                  self.tfEmail.delegate = self;
                  self.tfEmail.font = [UIFont systemFontOfSize:15];
                  
        
                 self.tfUid = [[VSUserCenterTF alloc]init];
                 [self.accountBgScrollView addSubview:self.tfUid];

                 [self.tfUid mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                   make.left.equalTo(self.tfEmail.mas_left);
                   make.top.equalTo(self.tfEmail.mas_bottom).with.offset(20);
                   make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 35 * (self.frame.size.height - 20)/280));
                 }];

                 self.tfUid.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
                 self.tfUid.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
                 self.tfUid.rightViewMode=UITextFieldViewModeAlways;
                 self.tfUid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                 self.tfUid.text = [NSString stringWithFormat:@"UID:%@",VSDK_GAME_USERID];
                 self.tfUid.tintColor = VSDK_LIGHT_GRAY_COLOR;
                self.tfUid.tag = 103;
                UITapGestureRecognizer * TapUid = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
                [self.tfUid addGestureRecognizer:TapUid];
                 self.tfUid.borderStyle = UITextBorderStyleRoundedRect;
                 self.tfUid.delegate = self;
                 self.tfUid.font = [UIFont systemFontOfSize:15];
            
            
            if ([VS_USERDEFAULTS_GETVALUE(VSDK_UID_GIFT_STATE)isEqual:@0]) {
                          
               [self layClaimBtnWithSuperView:self.tfUid andTag:1003];
               
               UIButton * editPswdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
              
              [self.accountBgScrollView addSubview:editPswdBtn];
              
              [editPswdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                 
                  make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                  make.right.equalTo(self.tfUid.mas_right).with.offset(-25-self.btnWidthClaim);
              
                make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                  
              }];
              editPswdBtn.tag = 1004;
              editPswdBtn.layer.cornerRadius = 5.f;
              [editPswdBtn setBackgroundColor:[UIColor orangeColor]];
              [editPswdBtn setTitle:VSLocalString(@"Change Pwd") forState:UIControlStateNormal];
              editPswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
              [editPswdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              editPswdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
              [editPswdBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
               
               
           }else{
               
               self.tfUid.rightView = [self userCentertextFieldRightView];
               
               UIButton * editPswdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
               
               [self.accountBgScrollView addSubview:editPswdBtn];
               
               [editPswdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                  
                   make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                  make.right.equalTo(self.tfUid.mas_right).with.offset(-38);
               
                 make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                   
               }];
               editPswdBtn.tag = 1004;
               editPswdBtn.layer.cornerRadius = 5.f;
               [editPswdBtn setBackgroundColor:[UIColor orangeColor]];
               [editPswdBtn setTitle:VSLocalString(@"Change Pwd") forState:UIControlStateNormal];
               editPswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
               [editPswdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               editPswdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
               [editPswdBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
               
           }

                

          self.labelUndone = [[UILabel alloc]init];
          
          [self.accountBgScrollView addSubview:self.labelUndone];
          
          [self.labelUndone mas_makeConstraints:^(MASConstraintMaker *make) {

              make.left.equalTo(self.tfUid);
              make.top.equalTo(self.tfUid.mas_bottom).with.offset(5);
              make.right.equalTo(self.tfUid);
              make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));

          }];
      
          self.labelUndone.text =VSLocalString(@"To-do quests");
            if ([self isKorean]) {
                self.labelUndone.text = @"임무";
            }
          self.labelUndone.textColor = VS_RGB(33, 186, 250);
          self.labelUndone.textAlignment = NSTextAlignmentCenter;
          self.labelUndone.font = [UIFont boldSystemFontOfSize:16];
          [self.accountBgScrollView addSubview:self.labelUndone];

          
          
           UILabel * rewardTipsLabel = [[UILabel alloc]init];

          [self.accountBgScrollView addSubview:rewardTipsLabel];

          [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {

             make.left.equalTo(self.mas_left);
             make.bottom.equalTo(self.mas_bottom).with.offset(-15);
             make.right.equalTo(self.mas_right);

           }];

          rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
          [rewardTipsLabel sizeToFit];
          rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
          rewardTipsLabel.numberOfLines = 0;
          rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
          rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];
          
          
          UIView * eventBgView = [[UIView alloc]init];

          [self.accountBgScrollView addSubview:eventBgView];

          [eventBgView mas_makeConstraints:^(MASConstraintMaker *make) {
              
             make.top.equalTo(self.labelUndone.mas_bottom).with.offset(10);
             make.left.equalTo(self.mas_left).with.offset(40);
             make.bottom.equalTo(rewardTipsLabel.mas_top).with.offset(-20);
             make.right.equalTo(self.mas_right).with.offset(-40);

          }];
          
          eventBgView.backgroundColor = [UIColor whiteColor];
          eventBgView.layer.cornerRadius = 8;
          eventBgView.layer.borderWidth = 2;
          eventBgView.layer.borderColor = [UIColor orangeColor].CGColor;
          [eventBgView layoutIfNeeded];

                    
          self.eventArr = @[VSLocalString(@"Bind phone number")];
            
            if ([self isKorean]) {
                self.eventArr = @[@"휴대폰 바인딩"];
            }

          self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
             [self addSubview:self.tableView];
             
             [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                 make.top.equalTo(eventBgView.mas_top).with.offset(2);
                 make.right.equalTo(eventBgView.mas_right).with.offset(-2);
                 make.left.equalTo(eventBgView.mas_left).with.offset(2);
                 make.bottom.equalTo(eventBgView.mas_bottom).with.offset(-2);

             }];

          
             [self.tableView layoutIfNeeded];
             self.tableView.rowHeight = eventBgView.frame.size.height/self.eventArr.count;
             self.tableView.layer.cornerRadius = 7.5;
             self.tableView.delegate = self;
             self.tableView.dataSource = self;
             self.tableView.scrollEnabled = NO;
            
        }else{
        
        
            self.tfEmail = [[VSUserCenterTF alloc]init];
            [self.accountBgScrollView addSubview:self.tfEmail];

            [self.tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
              
                make.left.equalTo(self.accountBgScrollView.mas_left).with.offset(40);
                make.top.equalTo(self.labelAccountType.mas_bottom).with.offset(20);
                make.right.equalTo(self.accountBgScrollView.mas_right).with.offset(-40);
                make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));
           }];

            self.tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_security_email")]];
            
            if ([VS_USERDEFAULTS_GETVALUE(VSDK_EMAIL_GIFT_STATE)isEqual:@0]) {
                
              [self layClaimBtnWithSuperView:self.tfEmail andTag:1002];
                
            }else{
                
               self.tfEmail.rightView = [self userCentertextFieldRightView];
                
            }
            self.tfEmail.rightViewMode=UITextFieldViewModeAlways;
            self.tfEmail.text = VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL);
            self.tfEmail.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
            self.tfEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.tfEmail.tag = 102;
            UITapGestureRecognizer * TapMail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
            [self.tfEmail addGestureRecognizer:TapMail];
            self.tfEmail.tintColor = VSDK_LIGHT_GRAY_COLOR;
            self.tfEmail.borderStyle = UITextBorderStyleRoundedRect;
            self.tfEmail.delegate = self;
            self.tfEmail.font = [UIFont systemFontOfSize:15];
            

            self.labelUndone = [[UILabel alloc]init];
            
            [self.accountBgScrollView addSubview:self.labelUndone];
            
            [self.labelUndone mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.equalTo(self.tfEmail);
                make.top.equalTo(self.tfEmail.mas_bottom).with.offset(5);
                make.right.equalTo(self.tfEmail);
                make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));

            }];

            self.labelUndone.text =VSLocalString(@"To-do quests");
            if ([self isKorean]) {
                self.labelUndone.text = @"임무";
            }
            self.labelUndone.textColor = VS_RGB(33, 186, 250);
            self.labelUndone.textAlignment = NSTextAlignmentCenter;
            self.labelUndone.font = [UIFont boldSystemFontOfSize:16];
            [self.accountBgScrollView addSubview:self.labelUndone];

            
            
             UILabel * rewardTipsLabel = [[UILabel alloc]init];

            [self.accountBgScrollView addSubview:rewardTipsLabel];

            [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {

               make.left.equalTo(self.mas_left);
               make.bottom.equalTo(self.mas_bottom).with.offset(-15);
               make.right.equalTo(self.mas_right);

             }];

            rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
            [rewardTipsLabel sizeToFit];
            rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
            rewardTipsLabel.numberOfLines = 0;
            rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
            rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];
            
            
            UIView * eventBgView = [[UIView alloc]init];

            [self.accountBgScrollView addSubview:eventBgView];

            [eventBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
               make.top.equalTo(self.labelUndone.mas_bottom).with.offset(10);
               make.left.equalTo(self.mas_left).with.offset(40);
               make.bottom.equalTo(rewardTipsLabel.mas_top).with.offset(-20);
               make.right.equalTo(self.mas_right).with.offset(-40);

            }];
            
            eventBgView.backgroundColor = [UIColor whiteColor];
            eventBgView.layer.cornerRadius = 8;
            eventBgView.layer.borderWidth = 2;
            eventBgView.layer.borderColor = [UIColor orangeColor].CGColor;
            [eventBgView layoutIfNeeded];

            
            
            self.eventArr = @[VSLocalString(@"Bind phone number"),VSLocalString(@"Activate UID account")];
            
            if ([self isKorean]) {
                self.eventArr = @[@"휴대폰 바인딩",@"UID 계정 활성화"];
            }
            
            self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
               [self addSubview:self.tableView];
               
               [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                 
                   make.top.equalTo(eventBgView.mas_top).with.offset(2);
                   make.right.equalTo(eventBgView.mas_right).with.offset(-2);
                   make.left.equalTo(eventBgView.mas_left).with.offset(2);
                   make.bottom.equalTo(eventBgView.mas_bottom).with.offset(-2);

               }];

            
               [self.tableView layoutIfNeeded];
               self.tableView.rowHeight = eventBgView.frame.size.height/self.eventArr.count;
               self.tableView.layer.cornerRadius = 7.5;
               self.tableView.delegate = self;
               self.tableView.dataSource = self;
               self.tableView.scrollEnabled = NO;
                
            }

        
    }else if ([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) length] >0) {
       
    
       if ([VS_CONVERT_TYPE(VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_UID)) length] >0) {
           
           
            self.tfPhoneNum = [[VSUserCenterTF alloc]init];
            [self.accountBgScrollView addSubview:self.tfPhoneNum];

            [self.tfPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
              
              make.left.equalTo(self.accountBgScrollView.mas_left).with.offset(40);
              make.top.equalTo(self.labelAccountType.mas_bottom).with.offset(20);
              make.right.equalTo(self.accountBgScrollView.mas_right).with.offset(-40);
              make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));
           }];

           self.tfPhoneNum.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
           self.tfPhoneNum.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
           self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
           self.tfPhoneNum.rightViewMode=UITextFieldViewModeAlways;
           NSArray * phoneArr = [VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) componentsSeparatedByString:@"#"];
           self.tfPhoneNum.text =  [NSString stringWithFormat:@"(+%@) %@",phoneArr[0],phoneArr[1]];
           
            if ([VS_USERDEFAULTS_GETVALUE(VSDK_PHONE_GIFT_STATE)isEqual:@0]) {
                     
                 [self layClaimBtnWithSuperView:self.tfPhoneNum andTag:1001];
                 
            }else{
              
                self.tfPhoneNum.rightView = [self userCentertextFieldRightView];
            }
         
           self.tfPhoneNum.tag = 101;
           UITapGestureRecognizer * TapPhone = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
           [self.tfPhoneNum addGestureRecognizer:TapPhone];
           self.tfPhoneNum.tintColor = VSDK_LIGHT_GRAY_COLOR;
           self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
           self.tfPhoneNum.delegate = self;
           self.tfPhoneNum.font = [UIFont systemFontOfSize:15];
           
           
           self.tfUid = [[VSUserCenterTF alloc]init];
           [self.accountBgScrollView addSubview:self.tfUid];

           [self.tfUid mas_makeConstraints:^(MASConstraintMaker *make) {
             
             make.left.equalTo(self.tfPhoneNum.mas_left);
             make.top.equalTo(self.tfPhoneNum.mas_bottom).with.offset(20);
             make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 35 * (self.frame.size.height - 20)/280));
           }];

           self.tfUid.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
           self.tfUid.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
           self.tfUid.rightViewMode=UITextFieldViewModeAlways;
           self.tfUid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
           self.tfUid.text = [NSString stringWithFormat:@"UID:%@",VSDK_GAME_USERID];
           self.tfUid.tintColor = VSDK_LIGHT_GRAY_COLOR;
           self.tfUid.tag = 103;
           UITapGestureRecognizer * TapUid = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
           [self.tfUid addGestureRecognizer:TapUid];
           self.tfUid.borderStyle = UITextBorderStyleRoundedRect;
           self.tfUid.delegate = self;
           self.tfUid.font = [UIFont systemFontOfSize:15];
           
           
             if ([VS_USERDEFAULTS_GETVALUE(VSDK_UID_GIFT_STATE)isEqual:@0]) {
                                   
                        [self layClaimBtnWithSuperView:self.tfUid andTag:1003];
                        
                        UIButton * editPswdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                 
                       [self.accountBgScrollView addSubview:editPswdBtn];
                       
                       [editPswdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                          
                          make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                          make.right.equalTo(self.tfUid.mas_right).with.offset(-25-self.btnWidthClaim);
                       
                          make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                           
                       }];
                       editPswdBtn.tag = 1004;
                       editPswdBtn.layer.cornerRadius = 5.f;
                       [editPswdBtn setBackgroundColor:[UIColor orangeColor]];
                       [editPswdBtn setTitle:VSLocalString(@"Change Pwd") forState:UIControlStateNormal];
                       editPswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                       [editPswdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                       editPswdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                       [editPswdBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                    }else{
                        
                        self.tfUid.rightView = [self userCentertextFieldRightView];
                        
                        UIButton * editPswdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                        
                        [self.accountBgScrollView addSubview:editPswdBtn];
                        
                        [editPswdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                           
                            make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                           make.right.equalTo(self.tfUid.mas_right).with.offset(-38);
                        
                          make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                            
                        }];
                        editPswdBtn.tag = 1004;
                        editPswdBtn.layer.cornerRadius = 5.f;
                        [editPswdBtn setBackgroundColor:[UIColor orangeColor]];
                        [editPswdBtn setTitle:VSLocalString(@"Change Pwd") forState:UIControlStateNormal];
                        editPswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                        [editPswdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        editPswdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                        [editPswdBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
      
                      
            
           self.labelUndone = [[UILabel alloc]init];
                
            [self.accountBgScrollView addSubview:self.labelUndone];
            
            [self.labelUndone mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.equalTo(self.tfUid);
                make.top.equalTo(self.tfUid.mas_bottom).with.offset(5);
                make.right.equalTo(self.tfUid);
                make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));

            }];


             self.labelUndone.text =VSLocalString(@"To-do quests");
           if ([self isKorean]) {
               self.labelUndone.text = @"임무";
           }
             self.labelUndone.textColor = VS_RGB(33, 186, 250);
             self.labelUndone.textAlignment = NSTextAlignmentCenter;
             self.labelUndone.font = [UIFont boldSystemFontOfSize:16];
             [self.accountBgScrollView addSubview:self.labelUndone];

                 
                 
             UILabel * rewardTipsLabel = [[UILabel alloc]init];

             [self.accountBgScrollView addSubview:rewardTipsLabel];

             [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.equalTo(self.mas_left);
                make.bottom.equalTo(self.mas_bottom).with.offset(-15);
                make.right.equalTo(self.mas_right);

              }];

             rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
             [rewardTipsLabel sizeToFit];
             rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
             rewardTipsLabel.numberOfLines = 0;
             rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
             rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];


             UIView * eventBgView = [[UIView alloc]init];

             [self.accountBgScrollView addSubview:eventBgView];

             [eventBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                 
                make.top.equalTo(self.labelUndone.mas_bottom).with.offset(10);
                make.left.equalTo(self.mas_left).with.offset(40);
                make.bottom.equalTo(rewardTipsLabel.mas_top).with.offset(-20);
                make.right.equalTo(self.mas_right).with.offset(-40);

             }];

              eventBgView.backgroundColor = [UIColor whiteColor];
              eventBgView.layer.cornerRadius = 8;
              eventBgView.layer.borderWidth = 2;
              eventBgView.layer.borderColor = [UIColor orangeColor].CGColor;
              [eventBgView layoutIfNeeded];

            self.eventArr = @[VSLocalString(@"Link security email")];

            self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            [self addSubview:self.tableView];
            
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
              
                make.top.equalTo(eventBgView.mas_top).with.offset(2);
                make.right.equalTo(eventBgView.mas_right).with.offset(-2);
                make.left.equalTo(eventBgView.mas_left).with.offset(2);
                make.bottom.equalTo(eventBgView.mas_bottom).with.offset(-2);

            }];

         
            [self.tableView layoutIfNeeded];
            self.tableView.rowHeight = eventBgView.frame.size.height/self.eventArr.count;
            self.tableView.layer.cornerRadius = 7.5;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.scrollEnabled = NO;
           
       }else{
       
       
       self.tfPhoneNum = [[VSUserCenterTF alloc]init];
       [self.accountBgScrollView addSubview:self.tfPhoneNum];

      [self.tfPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
         
         make.left.equalTo(self.accountBgScrollView.mas_left).with.offset(40);
         make.top.equalTo(self.labelAccountType.mas_bottom).with.offset(20);
         make.right.equalTo(self.accountBgScrollView.mas_right).with.offset(-40);
         make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));
      }];
       [self.tfPhoneNum layoutIfNeeded];

      self.tfPhoneNum.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_phone")]];
      self.tfPhoneNum.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
      self.tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      self.tfPhoneNum.rightViewMode=UITextFieldViewModeAlways;
      NSArray * phoneArr = [VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_PHOME) componentsSeparatedByString:@"#"];
      self.tfPhoneNum.text =  [NSString stringWithFormat:@"(+%@) %@",phoneArr[0],phoneArr[1]];
        if ([VS_USERDEFAULTS_GETVALUE(VSDK_PHONE_GIFT_STATE)isEqual:@0]) {
         
            [self layClaimBtnWithSuperView:self.tfPhoneNum andTag:1001];
            
        }else{
            
            self.tfPhoneNum.rightView = [self userCentertextFieldRightView];
        }
      
   self.tfPhoneNum.tag = 101;
   UITapGestureRecognizer * TapPhone = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeGiftCode:)];
   [self.tfUid addGestureRecognizer:TapPhone];
      self.tfPhoneNum.tintColor = VSDK_LIGHT_GRAY_COLOR;
      self.tfPhoneNum.borderStyle = UITextBorderStyleRoundedRect;
      self.tfPhoneNum.delegate = self;
      self.tfPhoneNum.font = [UIFont systemFontOfSize:15];
       
      self.labelUndone = [[UILabel alloc]init];
           
      [self.accountBgScrollView addSubview:self.labelUndone];
       
      [self.labelUndone mas_makeConstraints:^(MASConstraintMaker *make) {

           make.left.equalTo(self.tfPhoneNum);
           make.top.equalTo(self.tfPhoneNum.mas_bottom).with.offset(5);
           make.right.equalTo(self.tfPhoneNum);
           make.size.mas_equalTo(CGSizeMake((self.frame.size.width - 80), 33 * (self.frame.size.height - 20)/280));

       }];


        self.labelUndone.text =VSLocalString(@"To-do quests");
           if ([self isKorean]) {
               self.labelUndone.text = @"임무";
           }
        self.labelUndone.textColor = VS_RGB(33, 186, 250);
        self.labelUndone.textAlignment = NSTextAlignmentCenter;
        self.labelUndone.font = [UIFont boldSystemFontOfSize:16];
        [self.accountBgScrollView addSubview:self.labelUndone];

            
            
        UILabel * rewardTipsLabel = [[UILabel alloc]init];

        [self.accountBgScrollView addSubview:rewardTipsLabel];

        [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {

           make.left.equalTo(self.mas_left);
           make.bottom.equalTo(self.mas_bottom).with.offset(-15);
           make.right.equalTo(self.mas_right);

         }];

        rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
        [rewardTipsLabel sizeToFit];
        rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
        rewardTipsLabel.numberOfLines = 0;
        rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
        rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];


        UIView * eventBgView = [[UIView alloc]init];

        [self.accountBgScrollView addSubview:eventBgView];

        [eventBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
           make.top.equalTo(self.labelUndone.mas_bottom).with.offset(10);
           make.left.equalTo(self.mas_left).with.offset(40);
           make.bottom.equalTo(rewardTipsLabel.mas_top).with.offset(-20);
           make.right.equalTo(self.mas_right).with.offset(-40);

        }];

       eventBgView.backgroundColor = [UIColor whiteColor];
       eventBgView.layer.cornerRadius = 8;
       eventBgView.layer.borderWidth = 2;
       eventBgView.layer.borderColor = [UIColor orangeColor].CGColor;
       [eventBgView layoutIfNeeded];

       self.eventArr = @[VSLocalString(@"Link security email"),VSLocalString(@"Activate UID account")];
       
       self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
       [self addSubview:self.tableView];
       
       [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         
           make.top.equalTo(eventBgView.mas_top).with.offset(2);
           make.right.equalTo(eventBgView.mas_right).with.offset(-2);
           make.left.equalTo(eventBgView.mas_left).with.offset(2);
           make.bottom.equalTo(eventBgView.mas_bottom).with.offset(-2);

       }];

    
       [self.tableView layoutIfNeeded];
       self.tableView.rowHeight = eventBgView.frame.size.height/self.eventArr.count;
       self.tableView.layer.cornerRadius = 7.5;
       self.tableView.delegate = self;
       self.tableView.dataSource = self;
       self.tableView.scrollEnabled = NO;
           
       }

       
   }else{
       
       self.labelUndone = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/5, VS_VIEW_BOTTOM(self.labelAccountType) + 20, self.frame.size.width*3/5, 25 * (self.frame.size.height - 20)/280)];
       self.labelUndone.text = VSLocalString(@"To-do quests");
       if ([self isKorean]) {
           self.labelUndone.text = @"임무";
       }
       self.labelUndone.textColor = VS_RGB(33, 186, 250);
       self.labelUndone.textAlignment = NSTextAlignmentCenter;
       self.labelUndone.font = [UIFont boldSystemFontOfSize:16];
       [self.accountBgScrollView addSubview:self.labelUndone];
   
        UILabel * rewardTipsLabel = [[UILabel alloc]init];
   
       [self.accountBgScrollView addSubview:rewardTipsLabel];
   
       [rewardTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
   
           if ([[VSDeviceHelper vsdk_systemLanguage] hasPrefix:@"ja"]) {
               make.left.equalTo(self.mas_left).with.offset(15);
               make.bottom.equalTo(self.mas_bottom).with.offset(-15);
               make.right.equalTo(self.mas_right).with.offset(-15);;
               
           }else{
               
               make.left.equalTo(self.mas_left);
               make.bottom.equalTo(self.mas_bottom).with.offset(-15);
               make.right.equalTo(self.mas_right);
           }
        
   
        }];
   
       rewardTipsLabel.text =VSLocalString(@"You can claim rewards after binding.");
       [rewardTipsLabel sizeToFit];
       rewardTipsLabel.textColor = VSDK_ORANGE_COLOR;
       rewardTipsLabel.numberOfLines = 0;
       rewardTipsLabel.textAlignment = NSTextAlignmentCenter;
       rewardTipsLabel.font = [UIFont boldSystemFontOfSize:16];
   
   
       UIView * eventBgView = [[UIView alloc]init];
   
       [self.accountBgScrollView addSubview:eventBgView];
   
          [eventBgView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.equalTo(self.labelUndone.mas_bottom).with.offset(10);
              make.left.equalTo(self.mas_left).with.offset(40);
              make.bottom.equalTo(rewardTipsLabel.mas_top).with.offset(-20);
              make.right.equalTo(self.mas_right).with.offset(-40);
   
          }];
       eventBgView.backgroundColor = [UIColor whiteColor];
       eventBgView.layer.cornerRadius = 8;
       eventBgView.layer.borderWidth = 2;
       eventBgView.layer.borderColor = [UIColor orangeColor].CGColor;
       [eventBgView layoutIfNeeded];
   
       self.eventArr = @[VSLocalString(@"Bind phone number"),VSLocalString(@"Link security email"),VSLocalString(@"Activate UID account")];
       
       if ([self isKorean]) {
           self.eventArr = @[@"휴대폰 바인딩",@"보안 메일 바인딩",@"UID 계정 활성화"];
       }
   
       self.tableView =  [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
       [self addSubview:self.tableView];
       
       [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         
           make.top.equalTo(eventBgView.mas_top).with.offset(2);
           make.right.equalTo(eventBgView.mas_right).with.offset(-2);
           make.left.equalTo(eventBgView.mas_left).with.offset(2);
           make.bottom.equalTo(eventBgView.mas_bottom).with.offset(-2);

       }];

    
       [self.tableView layoutIfNeeded];
       self.tableView.rowHeight = eventBgView.frame.size.height/self.eventArr.count;
       self.tableView.layer.cornerRadius = 7.5;
       self.tableView.delegate = self;
       self.tableView.dataSource = self;
       self.tableView.scrollEnabled = NO;
    
   }
  
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.eventArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString * cellID = @"cell";

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];

        if (cell == nil) {

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
    
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
        cell.textLabel.text  = self.eventArr[indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = VSDK_ORANGE_COLOR;
        return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:VSLocalString(@"Bind phone number")]) {
       
            [self removeFromSuperview];
            [self.viewSocialBg removeFromSuperview];
            VSUserCenterView * uCenter = [[VSUserCenterView alloc]init];
            [uCenter  vsdk_openUserCenterWithSelectIndex:0];
        
    }else if ([cell.textLabel.text isEqualToString:VSLocalString(@"Link security email")]) {
        
            [self removeFromSuperview];
            [self.viewSocialBg removeFromSuperview];
            VSUserCenterView * uCenter = [[VSUserCenterView alloc]init];
            [uCenter  vsdk_openUserCenterWithSelectIndex:1];
        
    }else{
  
    if ([VS_USERDEFAULTS_GETVALUE(VSDK_ASSISTANT_BIND_MAIL)length]>0) {
               
        
               UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:VSLocalString(@"Activate UID account to login with UID and password") preferredStyle:UIAlertControllerStyleAlert];

                  [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                      [self removeFromSuperview]; [self.btnClose removeFromSuperview];
                      self.viewRetrieve = [[VSRetrieveView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
                      self.viewRetrieve.labelHead.text =VSLocalString(@"Verify security email");
                      
                      self.viewRetrieve.center = self.viewSocialBg.center;
                      [self.viewSocialBg addSubview:self.viewRetrieve];
                      
                      [VS_RootVC.view addSubview:self.viewSocialBg];
                      
                      [self.viewRetrieve retriveViewBlock:^(VSRetriveViewBlockType type) {
                          switch (type) {
                              case VSRetriveViewBlockBack:
                                  
                                  [self backToRetrive];
                                  
                                  break;
                                  
                              case VSRetriveViewBlockSend:
                                  //找回密码发送验证码
                                  [self sendVertifyCode];
                                  
                                  break;
                                  
                              case VSRetriveViewBlockComfirm:
                                  
                                  [self comfirmVertifyWithTokenStr:_emailToken];
                                  
                                  break;
                                  
                              default:
                                  
                                  break;
                          }
                      }];
                      

                  }]];

                      [VS_RootVC presentViewController:alert animated:YES completion:nil];

           }else{
             
              UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice")  message:VSLocalString(@"Link security email before activating UID account") preferredStyle:UIAlertControllerStyleAlert];


              [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"Cancel")  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                  VS_USERDEFAULTS_SETVALUE(@NO, VSDK_IF_FORM_UID);
                  
              }]];

              [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  

                      [self removeFromSuperview];
                      [self.viewSocialBg removeFromSuperview];
                  
                     VS_USERDEFAULTS_SETVALUE(@YES, VSDK_IF_FORM_UID);
                    VSUserCenterView * uCenter = [[VSUserCenterView alloc]init];
                    [uCenter  vsdk_openUserCenterWithSelectIndex:1];

              }]];

              [VS_RootVC presentViewController:alert animated:YES completion:nil];
               
           }
    }
    
}

-(void)backToRetrive{
    [self.viewSocialBg removeFromSuperview];
    [_viewRetrieve removeFromSuperview];
    _viewRetrieve = nil;
    VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
    [view vsdk_setUpCenterEntrance];
    
}

#pragma maek -- 找回密码事件发送验证码
-(void)sendVertifyCode{
    
    NSString * email = self.viewRetrieve.tfEmail.text;
    //首先判断邮箱是否合法
    BOOL success = [VSDeviceHelper RegexWithString:email pattern:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$"];
    
    if (success == NO) {
        
        VS_SHOW_INFO_MSG(@"Invalid mailbox");
        
    }else{
        
        VS_SHOW_TIPS_MSG(@"Send...");
        
        [[VSDKAPI shareAPI]  vsdk_retrievePwdWithEmail:email success:^(VSDKAPI *api, id responseObject) {
            
            VS_HUD_HIDE;
            
            if (REQUESTSUCCESS) {
                
                VS_SHOW_SUCCESS_STATUS(@"Sent");
                //发送成功倒数120秒
                [self RetrieveViewopenCountdownWithSeconds:120];
                //获取验证返回Token
                _emailToken = [GETRESPONSEDATA:VSDK_PARAM_TOKEN];
                
            }else{
                
                VS_SHOW_ERROR_STATUS(@"Error");
                [self RetrieveViewopenCountdownWithSeconds:10];
            }
            
        } failure:^(VSDKAPI *api, NSString *failure) {
            
            VS_HUD_HIDE;
            
        }];
        
    }
}



#pragma mark -- 提交验证
-(void)comfirmVertifyWithTokenStr:(NSString *)str{
    
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
            _viewWditPwd = [[VSEditPassWord alloc]initWithFrame:self.viewRetrieve.frame];
            _viewWditPwd.labelAccount.text  = self.viewRetrieve.tfEmail.text;
            
            [_viewWditPwd passwordViewBlock:^(VSEditPswViewBlockType type) {
                switch (type) {
                    case VSEditPswViewBlockBack:
                        
                        [self removePassWordView];
                        
                        break;
                        
                    case VSEditPswViewBlockComfirm:
                        
                        [self comfirmNewPswWithToken:_changePwdToken];
                        
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            [VS_RootVC.view addSubview:_viewWditPwd];
            
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
-(void)comfirmNewPswWithToken:(NSString *)tokenStr{
    
    
    if ([self.viewWditPwd.btnComfirm.titleLabel.text isEqualToString:VSLocalString(@"Back To User Center→")]) {
        
        [self backToUserCenter];
        
    }else{
    
    VS_SHOW_TIPS_MSG(@"Changing...");
    
    [[VSDKAPI shareAPI]  updateNewPwd:self.viewWditPwd.tfNewPwd.text  tokenStr:tokenStr success:^(id responseObject) {
        
         VS_HUD_HIDE;
        
        if (REQUESTSUCCESS) {
            
            VS_SHOW_SUCCESS_STATUS(@"Change Succeed!");
            
            [self.viewRetrieve removeFromSuperview];

            [self.viewWditPwd.btnComfirm setTitle:VSLocalString(@"Back To User Center→") forState:UIControlStateNormal];
       
            VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:VSDK_BIND_UID_EVENT], VSDK_ASSISTANT_BIND_UID);
            
        }else{
            
            VS_SHOW_ERROR_STATUS(@"Change failed,please retry!");
        }
        
    } failure:^(NSString *failure) {
        
    }];
        
    }
}

-(void)backToUserCenter{
    
    [self.viewRetrieve removeFromSuperview];
    self.viewRetrieve = nil;
    
    [self.viewWditPwd removeFromSuperview];
    self.viewWditPwd = nil;
    
    VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
    [view vsdk_setUpCenterEntrance];
}

#pragma mark -- 找回密码点击发送之后的倒数
-(void)RetrieveViewopenCountdownWithSeconds:(NSInteger)seconds{
    
    __block NSInteger time = seconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
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


-(void)removePassWordView{
    
    [_viewWditPwd removeFromSuperview];
    
}


-(void)resetPassword:(UIButton *)sender{
    
       [self removeFromSuperview]; [self.btnClose removeFromSuperview];
       self.viewRetrieve = [[VSRetrieveView alloc]initWithFrame:DEVICEPORTRAIT? CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT)];
       self.viewRetrieve.labelHead.text =VSLocalString(@"Verify security email");
       
       self.viewRetrieve.center = self.viewSocialBg.center;
       [self.viewSocialBg addSubview:self.viewRetrieve];
    
      [VSDeviceHelper addAnimationInView:self.viewRetrieve Duration:0.5];
    
       [VS_RootVC.view addSubview:self.viewSocialBg];
       
       [self.viewRetrieve retriveViewBlock:^(VSRetriveViewBlockType type) {
           switch (type) {
               case VSRetriveViewBlockBack:
                   
                   [self backToRetrive];
                   
                   break;
                   
               case VSRetriveViewBlockSend:
                   //找回密码发送验证码
                   [self sendVertifyCode];
                   
                   break;
                   
               case VSRetriveViewBlockComfirm:
                   
                   [self comfirmVertifyWithTokenStr:_emailToken];
                   
                   break;
                   
               default:
                   
                   break;
           }
       }];
    }


-(UIButton *)userCentertextFieldRightView{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 23.7)];
    [rightBtn setImage:[UIImage imageNamed: kSrcName(@"vsdk_success")] forState:UIControlStateNormal];
    return rightBtn;
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return  NO;
}


-(void)ViewEndEditing:(UITapGestureRecognizer *)tap{
    
    [self endEditing:YES];
}

-(void)closeCenterEntranceView:(UIButton * )sender{
    
    [self.viewSocialBg removeFromSuperview];
    [self removeFromSuperview];
}


-(void)layClaimBtnWithSuperView:(UITextField *)textField andTag:(NSInteger)tag{
    
    UIButton * cliamBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cliamBtn.frame= CGRectMake(0, 0, 100, 50);
     [self.accountBgScrollView addSubview:cliamBtn];

     [cliamBtn mas_makeConstraints:^(MASConstraintMaker *make) {

         make.top.equalTo(textField.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
         make.right.equalTo(textField.mas_right).with.offset(-10);
         make.size.mas_equalTo(CGSizeMake(self.btnWidthClaim, 35 * (self.frame.size.height - 20)/280/2));

     }];
     
     cliamBtn.tag = tag;
     cliamBtn.layer.cornerRadius = 5.f;
     [cliamBtn setBackgroundColor:[UIColor orangeColor]];
     [cliamBtn setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
     cliamBtn.titleLabel.font = [UIFont systemFontOfSize:12];
     [cliamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     cliamBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
     [cliamBtn addTarget:self action:@selector(claimReward:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)seeGiftCode:(UITapGestureRecognizer *)tap{
    
    VSUserCenterTF * tf = (VSUserCenterTF *)tap.view;
    [self removeFromSuperview];
    [self.viewSocialBg removeFromSuperview];
     
     NSString * eventType;

     if (tf.tag == 101) {
        
         eventType = VSDK_BIND_PHONE_EVENT;
         
     }else if (tf.tag == 102){
         
         eventType = VSDK_BIND_MAIL_EVENT;
         
     }else{
         
         eventType = VSDK_BIND_UID_EVENT;
     }
     
     [[VSDKAPI shareAPI]  ucReportReceiveBindGiftWithEvent:eventType Success:^(id responseObject) {
         
         if (REQUESTSUCCESS) {
             
             if (tf.tag == 101) {
                 
                     VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_phone_gift_code"], VSDK_UCENTER_GIFT_CODE_KEY);
             
                 }else if (tf.tag == 102) {
                 
                      VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_mail_gift_code"], VSDK_UCENTER_GIFT_CODE_KEY);
                     
                 }else{
                     
                     VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_uid_gift_code"], VSDK_UCENTER_GIFT_CODE_KEY);
                     
                     UIButton * pswBtn = (UIButton *)[self viewWithTag:1004];
                                 
                     [pswBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                       
                         make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                         make.right.equalTo(self.tfUid.mas_right).with.offset(-38);
                         make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                         
                     }];
     
                 }
            }

            self.viewGiftCode = [[VSGiftCodeView alloc]init];
                 
            __strong typeof(self)  strongSelf = self;
         
              [self.viewGiftCode setCodeViewBlock:^(VSGiftBlockType type) {
                  
                  switch (type) {
                          
                          case VSGiftBlockClose:
                          
                          [strongSelf viewGiftCodeClose];
                          
                          break;
                          
                      case VSGiftBlockCopy:

                          [strongSelf copyGiftCodeToPastordWithEventType:eventType];
                          
                          break;
                          
                      default:
                          break;
                  }
                  
              }];
      
         
     } Failure:^(NSString *failure) {
         
     }];
         
}


-(void)claimReward:(UIButton *)sender{
    
    [self removeFromSuperview];
    [self.viewSocialBg removeFromSuperview];
    
    NSString * eventType;

    if (sender.tag == 1001) {
       
        eventType = VSDK_BIND_PHONE_EVENT;
        
    }else if (sender.tag == 1002){
        
        eventType = VSDK_BIND_MAIL_EVENT;
        
    }else{
        
        eventType = VSDK_BIND_UID_EVENT;
    }
     
    [[VSDKAPI shareAPI]  ucReportReceiveBindGiftWithEvent:eventType Success:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            [sender removeFromSuperview];
            
            if (sender.tag == 1001) {
                
                    VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_phone_gift_code"], VSDK_UCENTER_GIFT_CODE_KEY);
            
                }else if (sender.tag == 1002) {
                
                     VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_mail_gift_code"], VSDK_UCENTER_GIFT_CODE_KEY);
                }else{
                    
                    VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"bind_uid_gift_code"], VSDK_UCENTER_GIFT_CODE_KEY);
                    
                    UIButton * pswBtn = (UIButton *)[self viewWithTag:1004];
                                
                    [pswBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                      
                        make.top.equalTo(self.tfUid.mas_top).with.offset(35 * (self.frame.size.height - 20)/280/4);
                        make.right.equalTo(self.tfUid.mas_right).with.offset(-38);
                        make.size.mas_equalTo(CGSizeMake(self.btnWidthTitle, 35 * (self.frame.size.height - 20)/280/2));
                        
                    }];
    
                }

                self.viewGiftCode = [[VSGiftCodeView alloc]init];
                __strong typeof(self)  strongSelf = self;
                [self.viewGiftCode setCodeViewBlock:^(VSGiftBlockType type) {
                    
                    switch (type) {
                            
                            case VSGiftBlockClose:
                            
                            [strongSelf viewGiftCodeClose];
                            
                            break;
                            
                        case VSGiftBlockCopy:

                            [strongSelf copyGiftCodeToPastordWithEventType:eventType];
                            
                            break;
                            
                        default:
                            break;
                    }
                    
                }];
                
        }else{
            
            VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
        }
        
    } Failure:^(NSString *failure) {
        
    }];
}


-(void)viewGiftCodeClose{
    
    [self.viewGiftCode.bgView  removeFromSuperview];
    [self.viewGiftCode removeFromSuperview];
    
        VSUserCenterEntrance * view = [[VSUserCenterEntrance alloc]init];
     [view vsdk_setUpCenterEntrance];

}


-(void)copyGiftCodeToPastordWithEventType:(NSString *)eventType{
    
    if ([VS_USERDEFAULTS_GETVALUE(VSDK_UCENTER_GIFT_CODE_KEY) length]>0) {

    if ([eventType isEqualToString:VSDK_BIND_PHONE_EVENT]) {
        
      self.tfPhoneNum.rightView = [self userCentertextFieldRightView];
      VS_USERDEFAULTS_SETVALUE(@2, VSDK_PHONE_GIFT_STATE);
        
    }else if ([eventType isEqualToString:VSDK_BIND_MAIL_EVENT]){
        
      self.tfEmail.rightView = [self userCentertextFieldRightView];
      VS_USERDEFAULTS_SETVALUE(@2, VSDK_EMAIL_GIFT_STATE);
        
    }else{
        
       self.tfUid.rightView = [self userCentertextFieldRightView];
       VS_USERDEFAULTS_SETVALUE(@2, VSDK_UID_GIFT_STATE);
    }

    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = VS_USERDEFAULTS_GETVALUE(VSDK_UCENTER_GIFT_CODE_KEY);
    VS_SHOW_SUCCESS_STATUS(@"Copied");
        
    }else{
        
        VS_SHOW_INFO_MSG(@"Gift Code Not Found,Please Retry");
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return NO;
}

-(BOOL)isKorean{
    NSArray *languages = [NSLocale preferredLanguages];
    if (languages.count>0) {
       NSString *currentLocaleLanguageCode = languages.firstObject;
        if ([currentLocaleLanguageCode hasPrefix:@"ko"]) {
            return YES;
        }
    }
    return NO;
}

@end
