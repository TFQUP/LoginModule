//
//  VSBindSecurityView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//


#import "VSBindSecurityView.h"
#import "VSWidget.h"
#import "VSTextBackView.h"
#import "VSSDKDefine.h"
@interface VSBindSecurityView()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton * btnBack;
@property(nonatomic,strong)UILabel * labelHead;
@property(nonatomic,strong)UIButton * btnSend;
@property(nonatomic,strong)UILabel * labelHelp;
@property(nonatomic,strong)UIButton * btnComfirm;

@end
@implementation VSBindSecurityView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
          
        self.layer.cornerRadius = 10;
        [self layOutBindSecurityViews];
    }
    
    return self;
    
}

-(void)layOutBindSecurityViews{
    
    UIView * headView = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, VSDK_ADJUST_PORTRIAT_WIDTH, ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, VSDK_ADJUST_LANDSCAPE_WIDTH, ADJUSTPadAndPhoneH(120))];
    headView.layer.cornerRadius = 5;
    
       if (@available(iOS 13.0, *)) {
            
      headView.backgroundColor = [UIColor systemBackgroundColor];
         
     }else{
         
      headView.backgroundColor = VSDK_WHITE_COLOR;
     }
    
    [self addSubview:headView];
    
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnBack setImage:[UIImage imageNamed:kSrcName(@"vsdk_back")] forState:UIControlStateNormal];
    if (DEVICEPORTRAIT) {
        _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    _btnBack.frame =DEVICEPORTRAIT?CGRectMake(15, ADJUSTPadAndPhonePortraitH(16.5,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(80), ADJUSTPadAndPhonePortraitH(68,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(15, 10, ADJUSTPadAndPhoneW(42), ADJUSTPadAndPhoneH(60));

    [_btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_btnBack];
    
    
    _labelHead = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(700), ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(100, 0, 243, 50) Text:VSLocalString(@"Bind Security Email") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54) TextColor:VSDK_NEW_STYLE_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentCenter];
    _labelHead.center = headView.center;
    [headView addSubview:_labelHead];
    
    
    VSTextBackView  * emainbackView = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5),  ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(headView) + 77,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(825), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43),  ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(headView) + 77), ADJUSTPadAndPhoneW(470 * 2), ADJUSTPadAndPhoneH(120))];
    
    _tfEmail = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Security Email") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:NO];
    
    _tfEmail.delegate = self;
    _tfEmail.frame = DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(440 * 2), ADJUSTPadAndPhoneH(120));
    _tfEmail.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
    [emainbackView addSubview:_tfEmail];
    [self addSubview:emainbackView];
    
 
    VSTextBackView  * vertifiBackView  = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(emainbackView) + 50,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(626), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(emainbackView) + 50), ADJUSTPadAndPhoneW(720), ADJUSTPadAndPhoneH(120))];
    
    
    _tfVertify = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Vertification Code") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:NO];
    
    _tfVertify.delegate = self;
    
    _tfVertify.frame = DEVICEPORTRAIT? CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(614), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 5, ADJUSTPadAndPhoneW(700), ADJUSTPadAndPhoneH(100));
    
    _tfVertify.leftView = [self textFieldLeftView:[UIImage imageNamed: kSrcName(@"vsdk_vercode")]];
    [vertifiBackView addSubview:_tfVertify];
    
    [self addSubview:vertifiBackView];
    
    
    _btnSend = [VSWidget vsdk_ButtonWithFrame:DEVICEPORTRAIT?CGRectMake(VS_VIEW_RIGHT(vertifiBackView)+ 10, vertifiBackView.frame.origin.y  , ADJUSTPadAndPhonePortraitW(180), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(VS_VIEW_RIGHT(vertifiBackView) + 10, VS_VIEW_TOP(vertifiBackView) + 3 , ADJUSTPadAndPhoneW(180), ADJUSTPadAndPhoneH(110)) cornerRadius:5 ButtonType:UIButtonTypeCustom Image:nil Title:VSLocalString(@"Send") TextAlignment:NSTextAlignmentCenter TitleColor:VSDK_WHITE_COLOR BGColor:VSDK_NEW_STYLE_COLOR Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(42): ADJUSTPadAndPhoneW(48) BoldFont:YES Target:self Action:@selector(sendBtnAction:)];
    
    [self addSubview:_btnSend];
    
    
    self.btnComfirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.btnComfirm];
    [self.btnComfirm mas_makeConstraints:^(MASConstraintMaker *make) {
           
           if (DEVICEPORTRAIT) {
               make.bottom.equalTo(self.mas_bottom).with.offset(-20);
               make.left.equalTo(self.mas_left).with.offset(ADJUSTPadAndPhonePortraitW(38.5));
               make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(824.5), ADJUSTPadAndPhonePortraitH(105,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
           }else{
               make.bottom.equalTo(self.mas_bottom).with.offset(-20);
               make.left.equalTo(self.mas_left).with.offset(ADJUSTPadAndPhoneW(43));
               make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(940),ADJUSTPadAndPhoneH(120)));
           }
          
       }];
       self.btnComfirm.layer.cornerRadius = 5;
       [self.btnComfirm setTitle:VSLocalString(@"Confirm") forState:UIControlStateNormal];
       [self.btnComfirm setBackgroundColor:VSDK_NEW_STYLE_COLOR];
       [self.btnComfirm setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
       self.btnComfirm.titleLabel.textAlignment = NSTextAlignmentCenter;
       self.btnComfirm.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(43):ADJUSTPadAndPhoneW(56)];
       [self.btnComfirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       
    
    self.labelHead = [[UILabel alloc]init];
    [self addSubview:self.labelHead];
    [self.labelHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnComfirm);
        make.right.equalTo(self.btnComfirm);
        make.bottom.equalTo(self.btnComfirm.mas_top).with.offset(-15);
        
    }];
    self.labelHead.text =VSLocalString(@"Security email could be used to retrieve password if you forget your password.");
    self.labelHead.textAlignment = NSTextAlignmentCenter;
    self.labelHead.numberOfLines = 0;
    self.labelHead.textColor = VSDK_HEAD_LABEL_COLOR;
    [self.labelHead sizeToFit];
    self.labelHead.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(38.5): ADJUSTPadAndPhoneW(44)];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)backBtnAction:(UIButton *)button{
   
    if (self.securityViewBlock) {
        self.securityViewBlock(VSBindSecurityViewBlockBack);
    }
    
}



-(void)sendBtnAction:(UIButton *)button{
    
    
    
    if (![self checkInputAccount:self.tfEmail.text]) {
      
        VS_SHOW_INFO_MSG(@"Please Enter The Correct Email Or Password");
        
    }else{
    
    if (self.securityViewBlock) {
        self.securityViewBlock(VSBindSecurityViewBlockSend);
        }
    }
}

-(void)confirmBtnAction:(UIButton *)button{
   
    
    if (![self checkInputAccount:self.tfEmail.text]) {
        
        VS_SHOW_INFO_MSG(@"Please Enter The Correct Email Or Password");
        
    }else{
        
        if (self.securityViewBlock) {
            self.securityViewBlock(VSBindSecurityViewBlockComfirm);
        }
    }
    
    
}
- (void)bindSecurityViewBlock:(VSBindSecurityBlock) block{
    
    self.securityViewBlock = block;
}
@end
