//
//  VSRetrieveView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSRetrieveView.h"
#import "VSWidget.h"
#import "VSTextBackView.h"
#import "VSSDKDefine.h"

@interface VSRetrieveView()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton * btnBack;
@property(nonatomic,strong)UILabel * labelTips;
@property(nonatomic,strong)UIButton * btnComfirm;

@end
@implementation VSRetrieveView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
          
        self.layer.cornerRadius = 10;
        [self layOutRetrieveViews];
        
    }
    
    return self;

}

-(void)layOutRetrieveViews{
   
    
    UIView * headView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, VSDK_ADJUST_PORTRIAT_WIDTH, ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneH(120))];
    headView.layer.cornerRadius = 5;
    
    if (@available(iOS 13.0, *)) {
        
         headView.backgroundColor = [UIColor systemBackgroundColor];
        
     } else {
         
         headView.backgroundColor = VSDK_WHITE_COLOR;
     }
    
    [self addSubview:headView];

    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBack setImage:[UIImage imageNamed:kSrcName(@"vsdk_back")] forState:UIControlStateNormal];
    _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    _btnBack.frame = DEVICEPORTRAIT?CGRectMake(15, ADJUSTPadAndPhonePortraitH(16.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(80), ADJUSTPadAndPhonePortraitH(68,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(15, 8, ADJUSTPadAndPhoneW(80), ADJUSTPadAndPhoneH(68));
    
    [_btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_btnBack];
    
    _labelHead = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(700), ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(100, 0, 243, 50) Text:VSLocalString(@"Retrieve Password") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54) TextColor:VS_RGB(5, 51, 101) NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
    _labelHead.center = headView.center;
    [headView addSubview:_labelHead];
    
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
    [self.btnComfirm setBackgroundColor:VS_RGB(5, 51, 101)];
    [self.btnComfirm setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    self.btnComfirm.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnComfirm.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(43):ADJUSTPadAndPhoneW(56)];
    [self.btnComfirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.labelTips = [[UILabel alloc]init];
    [self addSubview:self.labelTips];
    [self.labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnComfirm);
        make.right.equalTo(self.btnComfirm);
        make.bottom.equalTo(self.btnComfirm.mas_top).with.offset(-15);
        
    }];
    self.labelTips.text =VSLocalString(@"Enter Security Email. Please contact customer service if you need help.");
    self.labelTips.textAlignment = NSTextAlignmentCenter;
    self.labelTips.numberOfLines = 0;
    self.labelTips.textColor = VS_RGB(5, 51, 101);
    [self.labelTips sizeToFit];
    self.labelTips.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(38.5): ADJUSTPadAndPhoneW(44)];
    
    VSTextBackView  * vertifiBackView  = [[VSTextBackView alloc]init];
    [self addSubview:vertifiBackView];
    [vertifiBackView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        if (DEVICEPORTRAIT) {
            make.left.equalTo(self.btnComfirm);
            make.bottom.equalTo(self.labelTips.mas_top).with.offset(-18);
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(626), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
            make.left.equalTo(self.btnComfirm);
            make.bottom.equalTo(self.labelTips.mas_top).with.offset(-18);
            make.size.mas_equalTo(CGSizeMake( ADJUSTPadAndPhoneW(720), ADJUSTPadAndPhoneH(120)));
        }
        
    }];
    
    self.tfVertify = [[UITextField alloc]init];
    [vertifiBackView addSubview:self.tfVertify];
    [self.tfVertify mas_makeConstraints:^(MASConstraintMaker *make) {
    
          make.right.bottom.top.equalTo(vertifiBackView);
        if (DEVICEPORTRAIT) {
            
           make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(626), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
            
        }else{
         
             make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(720), ADJUSTPadAndPhoneH(120)));
        }
     
    }];
    
    if (@available(iOS 13.0, *)) {
          
        self.tfVertify.backgroundColor = [UIColor systemBackgroundColor];
          
      }else{
          
        self.tfVertify.backgroundColor = VSDK_WHITE_COLOR;
      }
    
    self.tfVertify.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_vercode")]];
    self.tfVertify.placeholder =VSLocalString(@"Enter Vertification Code");
    self.tfVertify.leftViewMode = UITextFieldViewModeAlways;
    self.tfVertify.textAlignment = NSTextAlignmentLeft;
    self.tfVertify.delegate = self;
    self.tfVertify.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(35): ADJUSTPadAndPhoneW(46)];

    self.btnSend = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.btnSend];
    [self.btnSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vertifiBackView.mas_right).with.offset(10);
        make.right.equalTo(self.btnComfirm.mas_right);
        make.bottom.equalTo(vertifiBackView.mas_bottom).with.offset(-2.5);
        make.top.equalTo(vertifiBackView.mas_top).with.offset(2.5);
    }];
    [self.btnSend setTitle:VSLocalString(@"Send") forState:UIControlStateNormal];
    [self.btnSend setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    [self.btnSend setBackgroundColor:VS_RGB(5, 51, 101)];
    self.btnSend.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48)];
    self.btnSend.layer.cornerRadius = 5;
    [self.btnSend addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
      VSTextBackView  * emainbackView  = [[VSTextBackView alloc]init];
      [self addSubview:emainbackView];
      [emainbackView mas_makeConstraints:^(MASConstraintMaker *make) {
      
          if (DEVICEPORTRAIT) {
              make.left.equalTo(self.btnComfirm);
              make.top.equalTo(headView.mas_bottom).with.offset(ADJUSTPadAndPhonePortraitH(77, [VSDeviceHelper getExpansionFactorWithphoneOrPad]));
              make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
          }else{
              make.left.equalTo(self.btnComfirm);
              make.top.equalTo(headView.mas_bottom).with.offset(ADJUSTPadAndPhoneH(80));
              make.size.mas_equalTo(CGSizeMake( ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(120)));
          }
          
      }];
      
      self.tfEmail = [[UITextField alloc]init];
      [emainbackView addSubview:self.tfEmail];
      [self.tfEmail mas_makeConstraints:^(MASConstraintMaker *make) {
      
            make.right.bottom.top.equalTo(emainbackView);
          
          if (DEVICEPORTRAIT) {
              make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
          }else{
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(120)));
          }
        
      }];
    
    if (@available(iOS 13.0, *)) {
          
        self.tfEmail.backgroundColor = [UIColor systemBackgroundColor];
          
      }else{
          
        self.tfEmail.backgroundColor = VSDK_WHITE_COLOR;
      }
    
      self.tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
      self.tfEmail.placeholder =VSLocalString(@"Enter Your Security Email");
      self.tfEmail.leftViewMode = UITextFieldViewModeAlways;
      self.tfEmail.textAlignment = NSTextAlignmentLeft;
      self.tfEmail.delegate = self;
      self.tfEmail.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(35): ADJUSTPadAndPhoneW(46)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)confirmBtnAction:(UIButton *)button{
    
    if (self.retriveViewBlock) {
        self.retriveViewBlock(VSRetriveViewBlockComfirm);
    }
    
}



-(void)sendBtnAction:(UIButton *)sendBtn{
  
    if (![self checkInputAccount:self.tfEmail.text]) {
        
        VS_SHOW_INFO_MSG(@"Please Enter The Correct Email Or Password");

    }else{
        
        if (self.retriveViewBlock) {
            self.retriveViewBlock(VSRetriveViewBlockSend);
        }
    }
}



-(void)backBtnAction:(UIButton * )button{
    
    if (self.retriveViewBlock) {
        self.retriveViewBlock(VSRetriveViewBlockBack);
    }
}

- (void)retriveViewBlock:(VSRetriveViewBlock) block{
    
    self.retriveViewBlock = block;
}

@end
