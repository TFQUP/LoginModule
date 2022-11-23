//
//  VSEditPassWord.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSEditPassWord.h"
#import "VSSDKDefine.h"
#import "VSTextBackView.h"

@interface VSEditPassWord()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton * btnBack;
@property (nonatomic,strong)UIImageView * imageIcon;
@property (nonatomic,strong)UILabel * labelHead;
@property (nonatomic,strong)UITextField * tfOldPwd;

@end
@implementation VSEditPassWord

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.layer.cornerRadius = 10;
        [self layEidtPswViews];
        
    }
    
    return self;
}

-(void)layEidtPswViews{
    
    UIView * headView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, VSDK_ADJUST_PORTRIAT_WIDTH, ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneH(120))];
    headView.layer.cornerRadius = 5;
    
    
    if (@available(iOS 13.0, *)) {
        
        headView.backgroundColor = [UIColor systemBackgroundColor];
        
    }else{
        
        headView.backgroundColor = VSDK_WHITE_COLOR;
    }
    
    [self addSubview:headView];
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBack setImage:[UIImage imageNamed:kSrcName(@"vsdk_back")] forState:UIControlStateNormal];
    
    _btnBack.frame = DEVICEPORTRAIT?CGRectMake(15, ADJUSTPadAndPhonePortraitH(16.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhoneW(80), ADJUSTPadAndPhonePortraitH(68,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(15, 10, ADJUSTPadAndPhoneW(42), ADJUSTPadAndPhoneH(60));
    
    [_btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _labelHead = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(700), ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(100, 0, 243, ADJUSTPadAndPhoneH(120)) Text:VSLocalString(@"Change Password") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54) TextColor:VSDK_NEW_STYLE_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
    _labelHead.center = headView.center;
    [headView addSubview:_labelHead];
    [headView addSubview:_btnBack];
    
    [self addSubview:headView];
    
    _imageIcon = [VSWidget imageViewWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(73), ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(headView) + 50,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitH(70,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(73), ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(headView) + 50), ADJUSTPadAndPhoneW(70), ADJUSTPadAndPhoneH(70)) imageName:@"vsdk_user"];
    
    _labelAccount = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(VS_VIEW_RIGHT(_imageIcon) + 30, ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(headView) + 50,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitH(728,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitH(70,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(VS_VIEW_RIGHT(_imageIcon) + 10, ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(headView) + 50), ADJUSTPadAndPhoneH(728), ADJUSTPadAndPhoneH(70)) Text:@"13800138000@163.com" Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(48): ADJUSTPadAndPhoneW(46) TextColor:nil NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
    [_labelAccount sizeToFit];
    [self addSubview:_labelAccount];
    [self addSubview:_imageIcon];
    
    self.btnComfirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.btnComfirm];
    [self.btnComfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
            make.left.equalTo(self.mas_left).with.offset(ADJUSTPadAndPhonePortraitW(38.5));
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(824.5), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
            make.left.equalTo(self.mas_left).with.offset(ADJUSTPadAndPhoneW(43));
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(940),ADJUSTPadAndPhoneH(120)));
        }
        
    }];
    self.btnComfirm.layer.cornerRadius = 5;
    [self.btnComfirm setTitle:VSLocalString(@"Confirm") forState:UIControlStateNormal];
    [self.btnComfirm setBackgroundColor:VSDK_NEW_STYLE_COLOR];
    [self.btnComfirm setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    self.btnComfirm.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnComfirm.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(43):ADJUSTPadAndPhoneW(56)];
    [self.btnComfirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    VSTextBackView  * emainBackView  = [[VSTextBackView alloc]init];
    [self addSubview:emainBackView];
    [emainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            make.left.equalTo(self.btnComfirm);
            make.top.equalTo(_labelAccount.mas_bottom).with.offset(25);
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
            make.left.equalTo(self.btnComfirm);
            make.top.equalTo(_labelAccount.mas_bottom).with.offset(25);
            make.size.mas_equalTo(CGSizeMake( ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(120)));
        }
        
    }];
    
    self.tfOldPwd  = [[UITextField alloc]init];
    [emainBackView addSubview:self.tfOldPwd];
    [self.tfOldPwd  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.top.equalTo(emainBackView);
        
        if (DEVICEPORTRAIT) {
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(120)));
        }
        
    }];
    
    self.tfOldPwd .leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];
    self.tfOldPwd .placeholder =VSLocalString(@"Enter New Password");
    self.tfOldPwd .leftViewMode = UITextFieldViewModeAlways;
    self.tfOldPwd.rightViewMode =UITextFieldViewModeAlways;
    if (@available(iOS 13.0, *)) {
        
        self.tfOldPwd.backgroundColor = [UIColor systemBackgroundColor];
        
    }else{
        
        self.tfOldPwd.backgroundColor = VSDK_WHITE_COLOR;
    }
    
    self.tfOldPwd .textAlignment = NSTextAlignmentLeft;
    self.tfOldPwd .delegate = self;
    self.tfOldPwd.secureTextEntry = YES;
    self.tfOldPwd .font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(35): ADJUSTPadAndPhoneW(46)];
    UIButton * oldPswRightBtn = [self pswTextFieldRightView];
    [oldPswRightBtn addTarget:self action:@selector(oldPswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tfOldPwd.rightView = oldPswRightBtn;
    
    VSTextBackView  * vertifiBackView  = [[VSTextBackView alloc]init];
    [self addSubview:vertifiBackView];
    [vertifiBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            make.left.equalTo(self.btnComfirm);
            make.top.equalTo(emainBackView.mas_bottom).with.offset(30);
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
            make.left.equalTo(self.btnComfirm);
            make.top.equalTo(emainBackView.mas_bottom).with.offset(30);
            make.size.mas_equalTo(CGSizeMake( ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(120)));
        }
        
    }];
    
    
    self.tfNewPwd  = [[UITextField alloc]init];
    [vertifiBackView addSubview:self.tfNewPwd];
    [self.tfNewPwd  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.top.equalTo(vertifiBackView);
        
        if (DEVICEPORTRAIT) {
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(120)));
        }
        
    }];
    self.tfNewPwd .leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];
    self.tfNewPwd .placeholder =VSLocalString(@"Confirm New Password");
    self.tfNewPwd.leftViewMode = UITextFieldViewModeAlways;
    self.tfNewPwd.rightViewMode =UITextFieldViewModeAlways;
    if (@available(iOS 13.0, *)) {
        
        self.tfNewPwd.backgroundColor = [UIColor systemBackgroundColor];
        
    }else{
        
        self.tfNewPwd.backgroundColor = VSDK_WHITE_COLOR;
    }
    self.tfNewPwd.textAlignment = NSTextAlignmentLeft;
    self.tfNewPwd.delegate = self;
    self.tfNewPwd.secureTextEntry = YES;
    self.tfNewPwd.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(35): ADJUSTPadAndPhoneW(46)];
    UIButton * cPswRightBtn = [self pswTextFieldRightView];
    [cPswRightBtn addTarget:self action:@selector(pswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tfNewPwd.rightView = cPswRightBtn;
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)confirmBtnAction:(UIButton *)button{
    
    if (![self.tfOldPwd.text isEqualToString:self.tfNewPwd.text]) {
        
        VS_SHOW_INFO_MSG(@"The two passwords entered do not match. Please confirm and re-enter");
        
    }else{
        
        if (self.pswViewBlock) {
            self.pswViewBlock(VSEditPswViewBlockComfirm);
        }
    }
}


-(void)oldPswRightBtnAction:(UIButton *)button{
    
    [self changeTextFieldSecure:self.tfOldPwd showBtn:button];
}

-(void)pswRightBtnAction:(UIButton *)button{
    
    [self changeTextFieldSecure:self.tfNewPwd showBtn:button];
    
}

-(void)backBtnAction:(UIButton *)button{
    
    if (self.pswViewBlock) {
        
        self.pswViewBlock(VSEditPswViewBlockBack);
    }
}

-(void)passwordViewBlock:(VSEditPassWordBlock)block{
    
    self.pswViewBlock = block;
}
@end
