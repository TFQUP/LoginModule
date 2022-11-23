//
//  VSForgetPswView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSForgetPswView.h"
#import "VSSDKDefine.h"

@interface VSForgetPswView ()

@property (nonatomic,strong)UILabel * labelTips;

@property (nonatomic,strong)UILabel * labelDes;

@property (nonatomic ,strong)UIButton * btnRetire;

@property (nonatomic,strong)UIButton * btnRetry;

@end

@implementation VSForgetPswView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
        self.layer.cornerRadius = 10;

        _labelTips = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, ADJUSTPadAndPhonePortraitH(0,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(124.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, ADJUSTPadAndPhoneH(0), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(142)) Text:VSLocalString(@"Notice") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(58): ADJUSTPadAndPhoneW(58) TextColor:VS_RGB(5, 51, 101) NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_labelTips];
        // 说明Label
        
        _labelDes = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, VS_VIEW_BOTTOM(_labelTips), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(148.2,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, VS_VIEW_BOTTOM(_labelTips), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(169)) Text:VSLocalString(@"Invalid Username or Password!") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitH(42,[VSDeviceHelper getExpansionFactorWithphoneOrPad]): ADJUSTPadAndPhoneH(48) TextColor:nil NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
        
        
        [self addSubview:_labelDes];
        
        
        UIView * retireView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, VS_VIEW_BOTTOM(_labelDes), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(124.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, VS_VIEW_BOTTOM(_labelDes), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(142))];
        
        retireView.backgroundColor = [UIColor colorWithRed:253/255.0 green:249/255.0 blue:224/255.0 alpha:1];
        
        retireView.layer.borderWidth = 1;
        
        retireView.layer.borderColor = [UIColor colorWithRed:253/255.0 green:209/255.0 blue:144/255.0 alpha:1].CGColor;
        
        [self addSubview:retireView];
        
        if (@available(iOS 13.0, *)) {
            _btnRetire = [VSWidget vsdk_ButtonWithFrame:CGRectMake(0, 0, retireView.frame.size.width, retireView.frame.size.height) cornerRadius:0 ButtonType:UIButtonTypeSystem Image:nil Title:VSLocalString(@"Retrieve Password") TextAlignment:NSTextAlignmentCenter TitleColor:VS_RGB(5, 51, 101) BGColor:[UIColor systemBackgroundColor] Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:NO Target:self Action:@selector(retireBtnAction:)];
        } else {
            
            _btnRetire = [VSWidget vsdk_ButtonWithFrame:CGRectMake(0, 0, retireView.frame.size.width, retireView.frame.size.height) cornerRadius:0 ButtonType:UIButtonTypeSystem Image:nil Title:VSLocalString(@"Retrieve Password") TextAlignment:NSTextAlignmentCenter TitleColor:VS_RGB(5, 51, 101) BGColor:VSDK_WHITE_COLOR Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:NO Target:self Action:@selector(retireBtnAction:)];
        }
         [retireView addSubview:_btnRetire];
      
        
        _btnRetry = [VSWidget vsdk_ButtonWithFrame:DEVICEPORTRAIT?CGRectMake(0, VS_VIEW_BOTTOM(retireView), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(124.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, VS_VIEW_BOTTOM(retireView), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(142)) cornerRadius:0 ButtonType:UIButtonTypeSystem Image:nil Title:VSLocalString(@"Try Again") TextAlignment:NSTextAlignmentCenter TitleColor:VSDK_GRAY_COLOR BGColor:nil Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:NO Target:self Action:@selector(retryBtnAction:)];
        
        [self addSubview:_btnRetry];
        
         [VSDeviceHelper addAnimationInView:self Duration:0.6];

    }
    
    return self;
    
}

-(void)retireBtnAction:(UIButton *)button{
    
    if (self.forgetViewBlock) {
        self.forgetViewBlock(VSForgetViewBlockRetrive);
    }
}

-(void)retryBtnAction:(UIButton *)button{
    
    if (self.forgetViewBlock) {
        self.forgetViewBlock(VSForgetViewBlockRetry);
    }
}

- (void)ForgetViewBlock:(VSForgetPswViewBlock) block{
    
    self.forgetViewBlock = block;
}

@end
