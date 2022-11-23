//
//  VSSegmentView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSegmentView.h"
#import "VSSDKDefine.h"
#import "VSWidget.h"
#import "VSLoginView.h"
#import "VSSignUpView.h"
@interface VSSegmentView ()
@property (nonatomic,strong)UIButton * btnLogin;
@property (nonatomic,strong)UIButton * btnSignUp;
@property (nonatomic,strong)UIView * viewIndicator;
@end
@implementation VSSegmentView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        [self lauOutSegmentView];
        
    }
    return self;
}

-(void)lauOutSegmentView{
    
    self.clickCount = 0;
    self.btnLogin = [VSWidget buttonWithTitle:VSLocalString(@"Log In") titleColor:VSDK_GRAY_COLOR highlightedColor:VS_RGB(5, 51, 101) fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54)];

   if (@available(iOS 13.0, *)) {

       [self.btnLogin setBackgroundColor:[UIColor systemBackgroundColor]];

      }else{

       [self.btnLogin  setBackgroundColor:VSDK_WHITE_COLOR];
   }
       
    self.btnLogin.selected = YES;
    [self.btnLogin  setTitleColor:VS_RGB(5, 51, 101) forState:UIControlStateSelected];
    [self.btnLogin  addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnLogin];

    
    self.btnSignUp = [VSWidget buttonWithTitle:VSLocalString(@"Sign Up") titleColor:VSDK_GRAY_COLOR highlightedColor:VS_RGB(5, 51, 101) fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54)];
    [self.btnSignUp addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnSignUp];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
        make.top.equalTo(self);
        make.right.equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad]));
        make.width.mas_equalTo(ADJUSTPadAndPhonePortraitW(450));
        }else{
        make.top.equalTo(self);
        make.right.equalTo(self.mas_centerX).offset(0);
          make.width.mas_equalTo(ADJUSTPadAndPhoneW(513));
        make.height.mas_equalTo(ADJUSTPadAndPhoneH(115));

        }
        
    }];
    
    [self.btnSignUp mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(self.btnLogin);
            make.left.equalTo(self.mas_centerX).offset(0);
            make.width.height.equalTo(self.btnLogin);
       
        }else{
      
            make.top.equalTo(self.btnLogin);
            make.left.equalTo(self.mas_centerX).offset(0);
            make.width.height.equalTo(self.btnLogin);
            
        }
    }];
    
    
    [self addSubview:({
        
        self.viewIndicator = [[UIView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(180), ADJUSTPadAndPhonePortraitH(101,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(90), 6):CGRectMake(ADJUSTPadAndPhoneW(205.2), ADJUSTPadAndPhoneH(115), ADJUSTPadAndPhoneW(102.6), 6)];
        self.viewIndicator.layer.cornerRadius = 3;
        self.viewIndicator.backgroundColor = VS_RGB(5, 51, 101);
        self.viewIndicator;
        
    })];
    
    
    [VSDeviceHelper addAnimationInView:self Duration:0.45];


}

- (void)login {
    
    
    if (self.btnLogin.selected == NO) {
    
    }
    
    self.clickCount ++;
    
    if (self.clickCount >1) {
        
        [UIView animateWithDuration:0.15 animations:^{

            self.viewIndicator.center = CGPointMake(self.btnLogin.center.x,self.viewIndicator.center.y);

        } completion:^(BOOL finished) {

        }];
    
    }
    
    self.btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(64): ADJUSTPadAndPhoneW(64)];
    self.btnSignUp.titleLabel.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54)];
    
    [self.btnSignUp setSelected:NO]; // 注册button非选择状态
    [self.btnLogin setSelected:YES]; // 登录button选择状态
    self.btnLogin.userInteractionEnabled = NO; // 用户交互为NO
    self.btnSignUp.userInteractionEnabled = YES; // 用户交互为YES
    
    
    if (self.segmentViewBlock) {
        self.segmentViewBlock(VSSegmentViewBlockLogin);
    }
}

- (void)signUp {
    
    if (self.btnSignUp.selected == NO) {
  
    }
    

    [UIView animateWithDuration:0.15 animations:^{

        self.viewIndicator.center = CGPointMake(self.btnSignUp.center.x,self.viewIndicator.center.y);

    } completion:^(BOOL finished) {

    }];

    self.btnSignUp.titleLabel.font = [UIFont boldSystemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(64): ADJUSTPadAndPhoneW(64)];
    self.btnLogin.titleLabel.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(54): ADJUSTPadAndPhoneW(54)];
    
    [self.btnLogin setSelected:NO]; // 登录button非选择状态
    [self.btnSignUp setSelected:YES]; // 注册button选择状态
    self.btnSignUp.userInteractionEnabled = NO; // 用户交互为NO
    self.btnLogin.userInteractionEnabled = YES; // 用户交互为YES
    
    if (self.segmentViewBlock) {
        self.segmentViewBlock(VSSegmentViewBlockSignUp);
    }
    
}




- (void)segmentedViewBlock:(VSSegmentViewBlock)block {
    
    self.segmentViewBlock = block;
}


@end
