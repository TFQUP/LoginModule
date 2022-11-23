//
//  VSEventView.m
//  VVSDK
//
//  Created by admin on 10/12/21.
//

#import "VSEventView.h"
#import "VSSDKDefine.h"
#import "VSWebView.h"
@implementation VSEventView

-(instancetype)initWithFrame:(CGRect)frame{
 
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = VSDK_WHITE_COLOR;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
 
    }
    return self;
}


-(void)vsdk_eventViewShow{
    
    self.bgMaskView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.bgMaskView addSubview:self];
    [VS_RootVC.view addSubview:self.bgMaskView];

    self.frame = DEVICEPORTRAIT?CGRectMake(0, 0, SCREE_WIDTH - 60, SCREE_HEIGHT /1.7): CGRectMake(0, 0, SCREE_WIDTH *1.2/3, SCREE_HEIGHT - 30);
   
    self.center = self.bgMaskView.center;
    
    UIButton * closeBtn = [[UIButton alloc]init];
     [self.bgMaskView addSubview:closeBtn];
     [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {

         if (DEVICEPORTRAIT) {
             make.bottom.equalTo(self.mas_top).with.offset(-4);
             make.right.equalTo(self.mas_right);
             make.size.mas_equalTo(CGSizeMake(26, 26));
         }else{
             make.top.equalTo(self.mas_top).with.offset(2);
             make.left.equalTo(self.mas_right).with.offset(8);
             make.size.mas_equalTo(CGSizeMake(28, 28));
         }

     }];
     
    [closeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeEventView:) forControlEvents:UIControlEventTouchUpInside];
    
    VSWebView  * web = [[VSWebView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, self.frame.size.width, self.frame.size.height):CGRectMake(0,0 , self.frame.size.width, self.frame.size.height)];
    
    web.url = self.webUrl;
    [web showWebView];
    [self addSubview:web];
    
    [VSDeviceHelper addAnimationInView:self Duration:0.4];
}


-(void)closeEventView:(UIButton *)sender{
    
    [[VSDKAPI shareAPI]vsdk_getRedpacketAlertStateSuccess:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
          
            VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_red_packet_state");
            
        }else{
            
            VS_USERDEFAULTS_SETVALUE(@NO, @"vsdk_red_packet_state");
        }
            
    } Failure:^(NSString *errorMsg) {
        
    }];
    
     [self.bgMaskView removeFromSuperview];
     [self removeFromSuperview];
    
    
}

@end
