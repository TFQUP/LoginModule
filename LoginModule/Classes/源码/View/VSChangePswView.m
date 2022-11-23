//
//  VSChangePswView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSChangePswView.h"
#import "VSTextBackView.h"
#import "VSWidget.h"
#import "VSSDKDefine.h"
@interface VSChangePswView()<UITextFieldDelegate>
@property (nonatomic,strong)UILabel * labelHead;
@property (nonatomic,strong)UIButton * btnBack;
@property (nonatomic,strong)UIImageView * imageHead;
@property(nonatomic,strong)UILabel * labelEmail;
@property(nonatomic,strong)UITextField * tfOldPwd;
@property(nonatomic,strong)UITextField * tfNewPwd;
@property(nonatomic,strong)UIButton * btnComfirmChange;
@end
@implementation VSChangePswView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self layOutChangeViews];
    }
    
    return self;
}

-(void)layOutChangeViews{
    
    UIView * headView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, VSDK_ADJUST_PORTRIAT_WIDTH, ADJUSTPadAndPhonePortraitH(95,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneH(120))];
    headView.layer.cornerRadius = 5;
    
    if (@available(iOS 13.0, *)) {
        
        headView.backgroundColor = [UIColor systemBackgroundColor];
        
    }else{
        
        headView.backgroundColor = VSDK_WHITE_COLOR;
    }
    
    [self addSubview:headView];
    
    _labelHead = [VSWidget labelWithFrame:CGRectMake(100, 0, 243, 50) Text:VSLocalString(@"Change Password") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54) TextColor:VSDK_WARN_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
    [headView addSubview:_labelHead];
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBack setImage:[UIImage imageNamed:kSrcName(@"vsdk_back")] forState:UIControlStateNormal];
    _btnBack.frame = DEVICEPORTRAIT?CGRectMake(15, 10, ADJUSTPadAndPhonePortraitW(42), ADJUSTPadAndPhonePortraitH(53,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(15, 10, ADJUSTPadAndPhoneW(42), ADJUSTPadAndPhoneH(60));
    [headView addSubview:_btnBack];
    
    _imageHead = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
    _imageHead.frame = DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhoneW(86) + 10  , VS_VIEW_BOTTOM(headView) + 20, ADJUSTPadAndPhonePortraitW(84), ADJUSTPadAndPhonePortraitH(90,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43 *2) + 10  , VS_VIEW_BOTTOM(headView) + 20, ADJUSTPadAndPhoneW(56 * 1.5), ADJUSTPadAndPhoneH(60 * 1.5));
    [self addSubview:_imageHead];
    
    
    _labelEmail = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(VS_VIEW_RIGHT(_imageHead) + 10, VS_VIEW_BOTTOM(headView) + 25, ADJUSTPadAndPhonePortraitW(660), ADJUSTPadAndPhonePortraitH(53,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(VS_VIEW_RIGHT(_imageHead) + 10,  VS_VIEW_BOTTOM(headView) + 25, ADJUSTPadAndPhoneW(660), ADJUSTPadAndPhoneH(60)) Text:@"jiangyunan@163.com" Font:ADJUSTPadAndPhoneW(52) TextColor:nil NumberOfLines:1 TextAlignment:NSTextAlignmentNatural];
    [self addSubview:_labelEmail];
    
    
    VSTextBackView * pswBackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhoneW(31), VS_VIEW_BOTTOM(_labelEmail) + 20, ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(95,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(_labelEmail) + 20, ADJUSTPadAndPhoneW(469 * 2), ADJUSTPadAndPhoneH(120))];
    
    
    _tfOldPwd = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Password") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:YES];
    _tfOldPwd.delegate = self;
    _tfOldPwd.frame = DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(95,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(440 * 2), ADJUSTPadAndPhoneH(120));
    _tfOldPwd.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];
    _tfOldPwd.secureTextEntry = YES;
    UIButton * pswRightBtn =  [self pswTextFieldRightView];
    _tfOldPwd.rightView = pswRightBtn;
    [pswRightBtn addTarget:self action:@selector(pswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pswBackView addSubview:_tfOldPwd];
    
    [self addSubview:pswBackView];
    
    
    VSTextBackView * changeBackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(31), VS_VIEW_BOTTOM(pswBackView) + 15, ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(95,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(pswBackView) + 13.5, ADJUSTPadAndPhoneW(469 * 2), ADJUSTPadAndPhoneH(120))];
    
    
    _tfNewPwd = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Password") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:YES];
    
    _tfNewPwd.delegate = self;
    
    _tfNewPwd.frame =DEVICEPORTRAIT?CGRectMake(0, 5, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(100,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 5, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(100));
    
    _tfNewPwd.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];
    
    UIButton * changeRightBtn =  [self pswTextFieldRightView];
    _tfNewPwd.rightView = changeRightBtn;
    
    [changeRightBtn addTarget:self action:@selector(pswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [changeBackView addSubview:_tfNewPwd];
    
    [self addSubview:changeBackView];
    
    _btnComfirmChange = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_btnComfirmChange setBackgroundColor:VSDK_WARN_COLOR];
    
    [_btnComfirmChange setTitle:@"Change Comfirm" forState:UIControlStateNormal];
    
    [_btnComfirmChange setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    _btnComfirmChange.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(56): ADJUSTPadAndPhoneW(56)];
    
    
    _btnComfirmChange.layer.cornerRadius = 5 ;
    _btnComfirmChange.frame = DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(31), VS_VIEW_BOTTOM(changeBackView) + 20, ADJUSTPadAndPhonePortraitW(940), ADJUSTPadAndPhonePortraitH(95,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(changeBackView) + 20, ADJUSTPadAndPhoneW(470 * 2), ADJUSTPadAndPhoneH(120));
    [_btnComfirmChange addTarget:self action:@selector(changeComfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnComfirmChange];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)changeComfirmAction:(UIButton *)button{
    
    
}
-(void)pswRightBtnAction:(UIButton *)button{
    
    [self changeTextFieldSecure:self.tfOldPwd showBtn:button];
    
}

@end
