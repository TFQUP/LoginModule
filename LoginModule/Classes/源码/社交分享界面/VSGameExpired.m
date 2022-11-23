//
//  VSGameExpired.m
//  VVSDK
//
//  Created by admin on 8/17/21.
//

#import "VSGameExpired.h"
#import "VSSDKDefine.h"
#import <WebKit/WebKit.h>


@interface VSGameExpired ()
@property(nonatomic,strong)UIView * fsMaskView;
@end


@implementation VSGameExpired

-(void)vsdk_gameStopOperation{
    
    
    self.fsMaskView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.fsMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.fsMaskView addSubview:self];
    [VS_RootVC.view addSubview:self.fsMaskView];
    
    UIView * expiredBgView = DEVICEPORTRAIT?[[UIView alloc]initWithFrame:CGRectMake(0, 0, (SCREE_WIDTH*4/5)*1.1,SCREE_WIDTH*4/5)]:[[UIView alloc]initWithFrame:CGRectMake(0, 0, (SCREE_HEIGHT*4/5)*1.2, SCREE_HEIGHT*4/5)];
    expiredBgView.backgroundColor =  VSDK_WHITE_COLOR;
    expiredBgView.center = self.fsMaskView.center;
    expiredBgView.layer.cornerRadius = 10;
    expiredBgView.layer.masksToBounds = YES;
    [self.fsMaskView addSubview:expiredBgView];
    
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [expiredBgView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(expiredBgView.mas_bottom).with.offset(-10);
        make.centerX.equalTo(expiredBgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(expiredBgView.frame.size.width/3, expiredBgView.frame.size.height/9));
        
    }];
    okBtn.layer.cornerRadius = 5;
    okBtn.backgroundColor = VSDK_ORANGE_COLOR;
    [okBtn setTitle:VSLocalString(self.btnText) forState:UIControlStateNormal];
    [okBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITextView * tx = [[UITextView alloc]init];
    [expiredBgView addSubview:tx];
    [tx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(okBtn.mas_top).with.offset(-10);
        make.left.equalTo(expiredBgView.mas_left).with.offset(15);
        make.right.equalTo(expiredBgView.mas_right).with.offset(-15);
        make.top.equalTo(expiredBgView.mas_top).with.offset(50);
    }];
    tx.layer.cornerRadius = 10;
    tx.layer.borderWidth = 0.5;
    tx.layer.borderColor = VSDK_ORANGE_COLOR.CGColor;
    tx.editable = NO;

    NSString * str;
    NSRange  range;
    NSRange  range1;
    
    if (_ifLogin) {
        
       str = [NSString stringWithFormat:@"\n%@\n\n%@",[VSDK_CLOSE_SERVER_DIC objectForKey:@"login_title"],[VSDK_CLOSE_SERVER_DIC objectForKey:@"login_tip"]];
        
       range = [str rangeOfString:[VSDK_CLOSE_SERVER_DIC objectForKey:@"login_title"]];
       range1 = [str rangeOfString:[VSDK_CLOSE_SERVER_DIC objectForKey:@"login_tip"]];
        
    }else{
        
        str = [NSString stringWithFormat:@"\n%@\n\n%@",[VSDK_CLOSE_SERVER_DIC objectForKey:@"pay_title"],[VSDK_CLOSE_SERVER_DIC objectForKey:@"pay_tip"]];
        range = [str rangeOfString:[VSDK_CLOSE_SERVER_DIC objectForKey:@"pay_title"]];
        range1 = [str rangeOfString:[VSDK_CLOSE_SERVER_DIC objectForKey:@"pay_tip"]];
        
    }

    
    NSMutableAttributedString * colorStr = [[NSMutableAttributedString alloc]initWithString:str];
    [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    [colorStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:range];
    
    [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
    [colorStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range1];
    
    tx.attributedText = colorStr;
    tx.textAlignment = NSTextAlignmentCenter;
    
    UIView * labelBgView = [[UIView alloc]init];
    [expiredBgView addSubview:labelBgView];
    [labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(expiredBgView);
        make.size.mas_equalTo(CGSizeMake(expiredBgView.frame.size.width,  expiredBgView.frame.size.height/9 + 5));
    }];
    
    labelBgView.backgroundColor = VSDK_ORANGE_COLOR;
    
    UILabel * labelTips = [[UILabel alloc]init];
    [labelBgView addSubview:labelTips];
    
    [labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(labelBgView);
        make.left.equalTo(labelBgView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(expiredBgView.frame.size.width,  expiredBgView.frame.size.height/9 + 5));
    }];
    
    labelTips.text = VSLocalString(@"UnlockGame");
    labelTips.textColor = VSDK_WHITE_COLOR;
    labelTips.textAlignment = NSTextAlignmentCenter;
    labelTips.font= [UIFont boldSystemFontOfSize:20];
    [VSDeviceHelper addAnimationInView:expiredBgView Duration:0.5];
    
}


//跳转外部链接
-(void)okBtnClick:(UIButton *)sender{
    
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"OK")]) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[VSDK_CLOSE_SERVER_DIC objectForKey:@"app_url"]?[VSDK_CLOSE_SERVER_DIC objectForKey:@"app_url"]:@"https://www.unlock.game"] options:@{} completionHandler:^(BOOL success) {
            
        }];
        
    }else{
        
        [self.fsMaskView removeFromSuperview];
        
    }
    
}

@end
