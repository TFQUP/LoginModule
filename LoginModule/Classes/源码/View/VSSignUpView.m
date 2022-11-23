//
//  VSSignUpView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSignUpView.h"
#import "VSTextBackView.h"
#import "VSSDKDefine.h"
#import "VSHttpHelper.h"
#import "AFNetworking.h"
#import "VSDeviceHelper.h"
#import "VSHttpHelper.h"

@interface VSSignUpView()<UITextFieldDelegate>
@end
@implementation VSSignUpView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame: frame]) {
    
        [self layOutSignUpView];
        
    }
    return self;
    
}


-(void)layOutSignUpView{
    
    
    VSTextBackView * emainBackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), 20, ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), 20, ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(150))];

    _tfEmail = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Email") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:NO];
    _tfEmail.delegate = self;
    _tfEmail.tintColor = VSDK_GRAY_COLOR;
    _tfEmail.frame =DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(150));
    _tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
    [emainBackView addSubview:_tfEmail];
    
    [self addSubview:emainBackView];
    
    //密码输入框
    
    VSTextBackView * pswBackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5),  ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(emainBackView) + 60,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43),  ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(emainBackView) + 60), ADJUSTPadAndPhoneW(469 *2), ADJUSTPadAndPhoneH(150))];
    
    _tfPwd = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Password") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:YES];
    _tfPwd.delegate = self;
    _tfPwd.tintColor = VSDK_GRAY_COLOR;
    _tfPwd.frame =DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(150));
    _tfPwd.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];

    UIButton * pswRightBtn = [self pswTextFieldRightView];
    _tfPwd.rightView = pswRightBtn ;
    [pswRightBtn addTarget:self action:@selector(pswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pswBackView addSubview:_tfPwd];
    [self addSubview:pswBackView];
    
    
    
    _btnRegister  = [VSWidget buttonWithTitle:VSLocalString(@"Sign Up") titleColor:VSDK_WHITE_COLOR bgColor:VS_RGB(5, 51, 101) fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(46): ADJUSTPadAndPhoneW(60) textAlign:NSTextAlignmentCenter];
    _btnRegister.frame = DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), VS_VIEW_BOTTOM(pswBackView) + 20, pswBackView.frame.size.width, ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(pswBackView) + 20, pswBackView.frame.size.width, ADJUSTPadAndPhoneH(150));
    _btnRegister.layer.cornerRadius = 5;
    _btnRegister.layer.masksToBounds = YES;
    [_btnRegister addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnRegister];
    
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
//注册View密码右侧按钮

-(void)pswRightBtnAction:(UIButton *)button{
    
    [self changeTextFieldSecure:self.tfPwd showBtn:button];
    
    
}

- (void)signUpViewBlock:(VSSignUpViewBlock) block {
    
    self.registerCallback = block;
}


-(void)signUpAction:(UIButton *)button{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [paramDic setValue:@"registe" forKey:@"click_type"];
    
    if ([VSTool isBlankString:self.tfEmail.text]) {
        [paramDic setValue:@"" forKey:@"name"];
    }else{
        [paramDic setValue:self.tfEmail.text forKey:@"name"];
    }
    
    if ([VSTool isBlankString:self.tfPwd.text]) {
        [paramDic setValue:@"" forKey:@"pass"];
    }else{
        [paramDic setValue:[VSEncryption md5:self.tfPwd.text] forKey:@"pass"];
    }
    
    [paramDic setValue:@"1" forKey:@"agree"];
    NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:@"sign"];
    [VSHttpHelper POST:VSDk_LoginClick_API parameters:paramDic success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {

    }];
    
    if (![self checkInputAccount:self.tfEmail.text password:self.tfPwd.text]) {
    
        VS_SHOW_INFO_MSG(@"Please Enter The Correct Email Or Password");
        
    }else{
        
        if (self.registerCallback) {
            self.registerCallback(VSSignUpViewBlockSignUp);
        }
        
    }
    
}

@end
