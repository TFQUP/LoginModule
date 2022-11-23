//
//  TermsView.m
//  VVSDK
//
//  Created by admin on 7/9/21.
//

#import "VSTermsView.h"
#import "VSSDKDefine.h"

@interface VSTermsView ()

@property(strong,nonatomic)UILabel * agreeDesLabel;

@end
@implementation VSTermsView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self layOutTermView];
    }
    
    return self;
}


-(void)layOutTermView{
   
    
    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.agreeBtn];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.height, self.frame.size.height));
    }];
    
    [self.agreeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_term_clicked")] forState:UIControlStateSelected];
    [self.agreeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_term_unclicked")] forState:UIControlStateNormal];
    self.agreeBtn.selected = [VS_USERDEFAULTS_GETVALUE(@"vsdk_comfirm_select") isEqual:@1] ?YES:NO;
    
    self.agreeDesLabel =  [VSWidget labelWithText:VSLocalString(@"I Agree And Accept The") textColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(28): ADJUSTPadAndPhoneW(38) textAlign:NSTextAlignmentLeft];
    
    [self addSubview:self.agreeDesLabel];
    [self.agreeDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.agreeBtn.mas_right).with.offset(5);
    }];

    [self.agreeDesLabel sizeToFit];
    
    
    
    self.agreeTermBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.agreeTermBtn];
    [self.agreeTermBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.agreeDesLabel.mas_right).with.offset(3);
        
    }];
    
    [self.agreeTermBtn sizeToFit];
    self.agreeTermBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.agreeTermBtn.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(29): ADJUSTPadAndPhoneW(38)];
    [self.agreeTermBtn setTitle:VSLocalString(@"Term of Services") forState:UIControlStateNormal];
    [self.agreeTermBtn setTitleColor:VS_RGB(41, 157, 255) forState:UIControlStateNormal];

}

@end
