//
//  VSBindThirdView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBindThirdView.h"
#import "VSBindThirdView.h"
#import "VSTextBackView.h"
#import "VSSDKDefine.h"

@interface VSBindThirdView ()<UITextFieldDelegate>

@end
@implementation VSBindThirdView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self  = [super initWithFrame:frame]) {
        
          
        [self layOutBindView];
    }
    return self;

}

-(void)layOutBindView{
    
    VSTextBackView * emainBackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), 20, ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), 15, ADJUSTPadAndPhoneW(938), ADJUSTPadAndPhoneH(150))];
    
    
    _tfEmail = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Email") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:NO];
    _tfEmail.delegate = self;
    _tfEmail.frame =DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(150));
    _tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];

    [emainBackView addSubview:_tfEmail];
    
    [self addSubview:emainBackView];
    
    //密码输入框
    VSTextBackView * pswBackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(emainBackView) + 50,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(ADJUSTPadAndPhoneW(43), ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(emainBackView) + 50), ADJUSTPadAndPhoneW(938), ADJUSTPadAndPhoneH(150))];

    _tfPwd = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Password") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40):ADJUSTPadAndPhoneW(46) secure:YES];
    _tfPwd.delegate = self;
    _tfPwd.frame = DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(150));
 
    _tfPwd.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];
    
    UIButton * pswRightBtn =  [self pswTextFieldRightView];
    _tfPwd.rightView = pswRightBtn;
    
    [pswRightBtn addTarget:self action:@selector(pswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [pswBackView addSubview:_tfPwd];
    
    [self addSubview:pswBackView];
    
    _btnBind = [VSWidget buttonWithTitle:VSLocalString(@"Register And Bind") titleColor:VSDK_WHITE_COLOR bgColor:VS_RGB(5, 51, 101) fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(49):ADJUSTPadAndPhoneW(56) textAlign:NSTextAlignmentCenter];
    _btnBind.frame =DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), VS_VIEW_BOTTOM(pswBackView) + 15 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?padScreenAdjudtPortraitH:screenAdjudtPortraitH), pswBackView.frame.size.width, ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(pswBackView) + 25 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?padScreenAdjudtH:screenAdjudtH), pswBackView.frame.size.width, ADJUSTPadAndPhoneH(150));
    
    _btnBind.layer.cornerRadius = 5;
    _btnBind.layer.masksToBounds = YES;
    [_btnBind addTarget:self action:@selector(bingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnBind];
    
    
    UIButton * continueGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    continueGameBtn.frame = DEVICEPORTRAIT?CGRectMake(self.frame.size.width - 100, VS_VIEW_BOTTOM(self.btnBind) + 8 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?padScreenAdjudtPortraitH:screenAdjudtPortraitH), 80, 25 ): CGRectMake(self.frame.size.width - 100, VS_VIEW_BOTTOM(self.btnBind) + 8 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?padScreenAdjudtH:screenAdjudtH), 80, 30 );
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:VSLocalString(@"Continue")];
    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:VS_RGB(5, 51, 101)  range:NSMakeRange(0,[string length])];
    [continueGameBtn setAttributedTitle:string forState:UIControlStateNormal];
    continueGameBtn.titleLabel.font = DEVICEPORTRAIT?[UIFont systemFontOfSize:12.5]: [UIFont systemFontOfSize:14];

    [continueGameBtn addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:continueGameBtn];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

/**
 邮箱右侧按钮事件

 @param button 文本框右侧按钮
 */
-(void)emainRightBtnAction:(UIButton *)button{
    
    
}


/**
 密码框右侧按钮事件

 @param button <#button description#>
 */
-(void)pswRightBtnAction:(UIButton *)button{
    
    [self changeTextFieldSecure:self.tfPwd showBtn:button];
    
}

/**
 确认条款按钮

 @param button 条款同意按钮
 */
#pragma mark -- 条款统一按钮

-(void)comfirmAction:(UIButton *)button{
    
   button.selected = !button.selected;
    
}

-(void)continueAction:(UIButton *)button{

    if (self.bindViewBlock) {
        self.bindViewBlock(VSBindThirdViewBlockContinue);
    }
}

/**
 显示条款按钮事件

 @param button  条款按钮
 */
-(void)showTermAction:(UIButton *)button{

    if (self.bindViewBlock) {
        self.bindViewBlock(VSBindThirdViewBlockShowTerm);
    }
}

-(void)bingBtnAction:(UIButton *)button{

    if (![self checkInputAccount:self.tfEmail.text password:self.tfPwd.text]) {
        
          VS_SHOW_INFO_MSG(@"Please Enter The Correct Email Or Password");
    }else{
        
        if (self.bindViewBlock) {
            self.bindViewBlock(VSBindThirdViewBlockBind);
        }
    }
}

-(void)loginViewBlock:(VSBindThirdViewBlock)block{
    
    self.bindViewBlock = block;
}
@end
