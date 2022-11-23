//
//  VSSeeLogView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSeeLogView.h"
#import "VSSDKDefine.h"

@implementation VSSeeLogView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
          
        self.layer.cornerRadius = 10;
        [self layOutSeelogView];
        
    }
    
    return self;
    
}
-(void)layOutSeelogView{
   
    
    UIView * headView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, VSDK_ADJUST_PORTRIAT_WIDTH, ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(0, 0, VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneH(120))];
    
        headView.layer.cornerRadius = 5;
    
      if (@available(iOS 13.0, *)) {

          headView.backgroundColor = [UIColor systemBackgroundColor];

       }else{
          headView.backgroundColor = VSDK_WHITE_COLOR;
       }
    
    [self addSubview:headView];
    
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnBack setImage:[UIImage imageNamed:kSrcName(@"vsdk_back")] forState:UIControlStateNormal];
    _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    _btnBack.frame = DEVICEPORTRAIT?CGRectMake(15, ADJUSTPadAndPhonePortraitH(16.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(80), ADJUSTPadAndPhonePortraitH(68,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(15, 8, ADJUSTPadAndPhoneW(80), ADJUSTPadAndPhoneH(68));
    
    [_btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [headView addSubview:_btnBack];
    
    _labelHead = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(100, 0, ADJUSTPadAndPhonePortraitW(700), ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(100, 0, ADJUSTPadAndPhoneW(512), ADJUSTPadAndPhoneH(120)) Text:@"Data Info" Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(50): ADJUSTPadAndPhoneW(54) TextColor:VSDK_WARN_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
    _labelHead.center = headView.center;
    [headView addSubview:_labelHead];
    
    self.btnCopy  = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.btnCopy];
    [self.btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
              make.bottom.equalTo(self.mas_bottom).with.offset(-10);
              make.centerX.equalTo(self);
              make.size.mas_equalTo(CGSizeMake(80, 30));
              
      }];
       self.btnCopy.layer.cornerRadius = 5;
       [self.btnCopy setTitle:_ifFeekback?VSLocalString(@"Submit"):VSLocalString(@"Copy Data") forState:UIControlStateNormal];
       [self.btnCopy setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
       [self.btnCopy setBackgroundColor:VSDK_ORANGE_COLOR];
       self.btnCopy.titleLabel.textAlignment = NSTextAlignmentCenter;
       [self.btnCopy addTarget:self action:@selector(copyDataInfo) forControlEvents:UIControlEventTouchUpInside];
       
       self.textView = [[UITextView alloc]init];
       [self addSubview:self.textView];
       [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
         
           make.bottom.equalTo(self.btnCopy.mas_top).with.offset(-10);
           make.left.equalTo(self.mas_left).with.offset(10);
           make.right.equalTo(self.mas_right).with.offset(-10);
           make.top.equalTo(headView.mas_bottom).with.offset(10);
           
       }];
       self.textView.layer.cornerRadius = 5;
       self.textView.layer.borderWidth = 0.8;
       self.textView.layer.borderColor = VSDK_LIGHT_GRAY_COLOR.CGColor;
       self.textView.editable = NO;
       self.textView.text = @"";
       self.textView.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(40)];
       self.textView.textColor = VSDK_LIGHT_GRAY_COLOR;

     [VSDeviceHelper addAnimationInView:self Duration:0.5];

}

-(void)copyDataInfo{
    
    if (_ifFeekback) {
        
        if (self.seeLogViewBlock) {
            self.seeLogViewBlock(VSSeeLogBlockTypeCopy);
        }
        
    }else{
        
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
    
    VS_SHOW_SUCCESS_STATUS(@"Copied");
    }
    
}

-(void)backBtnAction:(UIButton *)button{
    
    if (self.seeLogViewBlock) {
        self.seeLogViewBlock(VSSeeLogBlockTypeBack);
    }
    
}

- (void)SeeLogViewBlock:(VSSeeLogViewBlock) block{
    self.seeLogViewBlock = block;
    
}

@end

