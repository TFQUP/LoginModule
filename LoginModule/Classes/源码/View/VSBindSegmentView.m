//
//  VSBindSegmentView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBindSegmentView.h"
#import "VSSDKDefine.h"
#import "VSWidget.h"
#import "VSBindThirdView.h"

@implementation VSBindSegmentView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self lauOutSegmentView];
        
    }
    return self;
}



-(void)lauOutSegmentView{


  UILabel * labelRegister = [VSWidget labelWithText:VSLocalString(@"Sign Up") textColor:VS_RGB(5, 51, 101)  fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(46): ADJUSTPadAndPhoneW(60) textAlign:NSTextAlignmentCenter];

    [self addSubview:labelRegister];
    
    [labelRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad]));
        make.width.mas_equalTo(ADJUSTPadAndPhonePortraitW(700));
        }else{
        make.top.equalTo(self.mas_top).with.offset(5);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(ADJUSTPadAndPhoneH(115));
        make.width.mas_equalTo(ADJUSTPadAndPhoneW(513));
        }
    }];
    
    
}


-(void)backBtnAction:(UIButton *)button{
    
    if (self.segmentViewBlock) {
        self.segmentViewBlock(VSBindSegmentViewBlockBack);
    }
}


- (void)segmentedViewBlock:(VSBindSegmentViewBlock)block {
    
    self.segmentViewBlock = block;
}
@end

