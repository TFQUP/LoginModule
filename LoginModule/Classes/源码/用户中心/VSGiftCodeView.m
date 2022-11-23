//
//  VSGiftCodeView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSGiftCodeView.h"
#import "VSSDKDefine.h"

@interface VSGiftCodeView ()

@property(strong,nonatomic)UILabel * labelHead;
@property(strong,nonatomic)UIButton * btnClose;
@property(strong,nonatomic)UIButton * btnCopy;
@property(strong,nonatomic)UILabel * labelGiftCode;
@property(strong,nonatomic)NSString * giftCode;

@end

@implementation VSGiftCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self =  [super initWithFrame:frame]) {
      
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        if (@available(iOS 13.0, *)) {
           self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
         }
        
        [self showGiftCodeView];
     
    }
    
    return self;
}

-(void)showGiftCodeView{
    
        self.bgView = [[UIView alloc]initWithFrame:VS_RootVC.view.frame];
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [VS_RootVC.view addSubview:self.bgView];

        self.frame = DEVICEPORTRAIT?CGRectMake(100, ADJUSTPadAndPhonePortraitH(97,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), VSDK_ADJUST_PORTRIAT_WIDTH,VSDK_ADJUST_PORTRIAT_HEIGHT):CGRectMake(100, ADJUSTPadAndPhoneH(97), VSDK_ADJUST_LANDSCAPE_WIDTH, VSDK_ADJUST_LANDSCAPE_HEIGHT);
        self.center = self.bgView.center;
        [self.bgView addSubview:self];


        self.labelHead = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*1/6, 5, self.frame.size.width*2/3, 40)];

        self.labelHead.textColor = VSDK_ORANGE_COLOR;
        self.labelHead.font = [UIFont systemFontOfSize:22];
        self.labelHead.textAlignment = NSTextAlignmentCenter;
        self.labelHead.text =VSLocalString(@"Claim Reward");
     
     
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
        _btnClose.frame = DEVICEPORTRAIT?CGRectMake(self.frame.size.width - 40, ADJUSTPadAndPhonePortraitH(25,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(75), ADJUSTPadAndPhonePortraitH(75,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(self.frame.size.width - 40 , 12, ADJUSTPadAndPhoneW(75), ADJUSTPadAndPhoneH(75));


        [_btnClose addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_btnClose];
        [self addSubview:self.labelHead];
   
   
        UILabel * congratulationLabel = [[UILabel alloc]init];
        [self addSubview:congratulationLabel];
        [congratulationLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.labelHead.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(30);
            make.right.equalTo(self.mas_right).with.offset(-30);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width - 60, 70));
            
        }];
   
        congratulationLabel.text = [NSString stringWithFormat:@"%@%@",VSLocalString(@"Congrats on completing the task!"),VSLocalString(@"Please click to copy your gift code.")];

        congratulationLabel.textAlignment = NSTextAlignmentCenter;
        congratulationLabel.numberOfLines=0;

        self.btnCopy = [UIButton buttonWithType:UIButtonTypeSystem];

        [self addSubview:self.btnCopy];

        [self.btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width-30, 36 *(self.frame.size.height - 20)/280));

        }];
        self.btnCopy.layer.cornerRadius = 5;
        [self.btnCopy setTitle:VSLocalString(@"Copy Gift Code") forState:UIControlStateNormal];
        [self.btnCopy setBackgroundColor:VSDK_ORANGE_COLOR];
        [self.btnCopy setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
        [self.btnCopy addTarget:self action:@selector(copyGiftCode:) forControlEvents:UIControlEventTouchUpInside];



        UILabel * duihuanLabel = [[UILabel alloc]init];

        [self addSubview:duihuanLabel];

        [duihuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.equalTo(self.btnCopy);
        make.bottom.equalTo(self.btnCopy.mas_top).with.offset(-5);
        }];

        duihuanLabel.text =VSLocalString(@"Note: please copy the gift code and use it in the game exchange interface.");
        duihuanLabel.numberOfLines = 0;
        [duihuanLabel sizeToFit];
        duihuanLabel.textAlignment = NSTextAlignmentCenter;
        duihuanLabel.textColor = VSDK_ORANGE_COLOR;
        duihuanLabel.font = [UIFont boldSystemFontOfSize:14];
        [duihuanLabel layoutIfNeeded];


        self.labelGiftCode = [[UILabel alloc]init];

        [self addSubview:self.labelGiftCode];

        [self.labelGiftCode mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.right.equalTo(self);
            make.top.equalTo(congratulationLabel.mas_bottom).with.offset(0);
            make.bottom.equalTo(duihuanLabel.mas_top).with.offset(-15);


        }];

        self.labelGiftCode.text = VS_USERDEFAULTS_GETVALUE(VSDK_UCENTER_GIFT_CODE_KEY);
        self.labelGiftCode.textAlignment = NSTextAlignmentCenter;
        self.labelGiftCode.font = [UIFont boldSystemFontOfSize:20];
        self.labelGiftCode.textColor = VSDK_ORANGE_COLOR;

        [VSDeviceHelper addAnimationInView:self Duration:0.5];
}

-(void)closeBtnAction:(UIButton *)sender{
    
    
    if (self.codeViewBlock) {

        self.codeViewBlock(VSGiftBlockClose);
    }
    
}
    
    
-(void)copyGiftCode:(UIButton *)sender{
    
    
    if (self.codeViewBlock) {
        
        self.codeViewBlock(VSGiftBlockCopy);
    }

}

-(void)giftCodeViewBlock:(giftCodeViewBlock)block{
    
    self.codeViewBlock = block;
}


@end
