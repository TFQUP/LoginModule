//
//  VSAskToBindView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSAskToBindView.h"
#import "VSSDKDefine.h"
@implementation VSAskToBindView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
        
        self.layer.cornerRadius = 10;
    

        _tipsLabel = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, ADJUSTPadAndPhonePortraitH(0,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(114,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, ADJUSTPadAndPhoneH(0), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(132)) Text:VSLocalString(@"Notice") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(58): ADJUSTPadAndPhoneW(58) TextColor:VSDK_WARN_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_tipsLabel];
        // 说明Label
        
        
        
        _desLabel = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, VS_VIEW_BOTTOM(_tipsLabel), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(154,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, VS_VIEW_BOTTOM(_tipsLabel), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(175)) Text:VSLocalString(@"Bind a security email to retrieve the password") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitH(42,[VSDeviceHelper getExpansionFactorWithphoneOrPad]): ADJUSTPadAndPhoneH(48) TextColor:nil NumberOfLines:0 TextAlignment:NSTextAlignmentCenter];
 
        [self addSubview:_desLabel];
    
        
        
        UIView * retireView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, VS_VIEW_BOTTOM(_desLabel), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(124.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, VS_VIEW_BOTTOM(_desLabel), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(142))];
        
        retireView.backgroundColor = [UIColor colorWithRed:253/255.0 green:249/255.0 blue:224/255.0 alpha:1];
        
        retireView.layer.borderWidth = 1;
        
        retireView.layer.borderColor = [UIColor colorWithRed:253/255.0 green:209/255.0 blue:144/255.0 alpha:1].CGColor;
        
        [self addSubview:retireView];
        
        if (@available(iOS 13.0, *)) {
            _retireBtn = [VSWidget vsdk_ButtonWithFrame:CGRectMake(0, 0, retireView.frame.size.width, retireView.frame.size.height) cornerRadius:0 ButtonType:UIButtonTypeSystem Image:nil Title:VSLocalString(@"OK") TextAlignment:NSTextAlignmentCenter TitleColor:VSDK_ORANGE_COLOR BGColor:[UIColor systemBackgroundColor] Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:NO Target:self Action:@selector(retireBtnAction:)];
        } else {
            
            _retireBtn = [VSWidget vsdk_ButtonWithFrame:CGRectMake(0, 0, retireView.frame.size.width, retireView.frame.size.height) cornerRadius:0 ButtonType:UIButtonTypeSystem Image:nil Title:VSLocalString(@"OK") TextAlignment:NSTextAlignmentCenter TitleColor:VSDK_ORANGE_COLOR BGColor:VSDK_WHITE_COLOR Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:NO Target:self Action:@selector(retireBtnAction:)];
        }
         [retireView addSubview:_retireBtn];
      
        
        _retryBtn  = [VSWidget vsdk_ButtonWithFrame:DEVICEPORTRAIT?CGRectMake(0, VS_VIEW_BOTTOM(retireView), ADJUSTPadAndPhonePortraitW(784), ADJUSTPadAndPhonePortraitH(124.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, VS_VIEW_BOTTOM(retireView), ADJUSTPadAndPhoneW(894), ADJUSTPadAndPhoneH(142)) cornerRadius:0 ButtonType:UIButtonTypeSystem Image:nil Title:VSLocalString(@"Cancel") TextAlignment:NSTextAlignmentCenter TitleColor:VSDK_GRAY_COLOR BGColor:nil Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:NO Target:self Action:@selector(retryBtnAction:)];
        
        [self addSubview:_retryBtn];
        
         [VSDeviceHelper addAnimationInView:self Duration:0.6];

    }
    
    return self;
    
}

-(void)retireBtnAction:(UIButton *)button{
    
    if (self.askBindBlock) {
        self.askBindBlock(VSAskToBindBlockTypeOK);
    }
}

-(void)retryBtnAction:(UIButton *)button{
    
    if (self.askBindBlock) {
        self.askBindBlock(VSAskToBindBlockTypeNextTime);
    }
}

-(void)askToBindViewBlock:(VSAskToBindBlock)block{
    
    self.askBindBlock = block;
}


@end
