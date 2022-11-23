//
//  VSTempBulltein.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSTempBulltein.h"
#import "VSSDKDefine.h"
@implementation VSTempBulltein

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = VSDK_WHITE_COLOR;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self layOutTempBulltein];
        
    }
    
    return self;
}

-(void)layOutTempBulltein{
    
    NSDictionary * bulletinDic = VSDK_DIC_WITH_PATH(VSDK_TEMP_BULLETIIN_PATH);
    
    self.bgMaskView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.bgMaskView addSubview:self];
    
    [VS_RootVC.view addSubview:self.bgMaskView];
    
    UILabel * bullteinTitle = [[UILabel alloc]init];
    [self addSubview:bullteinTitle];
    [bullteinTitle mas_makeConstraints:^(MASConstraintMaker *make) {

     make.top.equalTo(self.mas_top).with.offset(0);
     make.left.equalTo(self.mas_left).with.offset(50);
     make.size.mas_equalTo(CGSizeMake(self.frame.size.width - 100, 45));
     
    }];

    bullteinTitle.text = NSLocalizedString(@"Announcement", @"");
    bullteinTitle.textAlignment = NSTextAlignmentCenter;
    bullteinTitle.font = [UIFont boldSystemFontOfSize:18];
    bullteinTitle.textColor = VSDK_ORANGE_COLOR;

    UIButton * closeBtn = [[UIButton alloc]init];

    if ([[bulletinDic objectForKey:@"bulletin_state"]  isEqual: @1]) {
        closeBtn.hidden = YES;
    }
    
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
     
      make.top.equalTo(bullteinTitle.mas_top).with.offset(10);
      make.left.equalTo(bullteinTitle.mas_right).with.offset(10);
      make.size.mas_equalTo(CGSizeMake(25, 25));
      
    }];

    [closeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];

    [closeBtn addTarget:self action:@selector(closeAnnouncementView:) forControlEvents:UIControlEventTouchUpInside];

    UIView * lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
     
      make.top.equalTo(bullteinTitle.mas_bottom).with.offset(0);
      make.left.equalTo(self.mas_left);
     make.size.mas_equalTo(CGSizeMake(self.frame.size.width , 0.8));
      
    }];
 
 
     lineView.backgroundColor = VSDK_GRAY_COLOR;

     WKWebView  * web = [[WKWebView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 46 , self.frame.size.width, self.frame.size.height-46):CGRectMake(0, 46 , self.frame.size.width, self.frame.size.height-46)];
    if ([[bulletinDic objectForKey:@"bulletin_url"] length] > 0) {
        
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[bulletinDic objectForKey:@"bulletin_url"]]]];
    }else{
        
        [web loadHTMLString:[bulletinDic objectForKey:@"bulletin_desc"] baseURL:nil];
    }

    
    [self addSubview:web];
    [VSDeviceHelper addAnimationInView:self Duration:0.6];

}

-(void)closeAnnouncementView:(UIButton *)sender{
   
    [self.bgMaskView removeFromSuperview];
    [self removeFromSuperview];

}


@end
