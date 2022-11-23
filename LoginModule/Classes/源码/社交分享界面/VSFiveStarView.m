//
//  VSFiveStarView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSFiveStarView.h"
#import "VSSDKDefine.h"

@interface VSFiveStarView ()
@property(nonatomic,strong)UIView * fsMaskView;
@property(nonatomic,strong)UIView * calimBgView;
@end

@implementation VSFiveStarView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.masksToBounds = YES;
    }
    
    return self;
}


-(void)vsdk_requeustMarkReview{
    
    self.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = [VSDeviceHelper preSaveSocialData];
    NSNumber *inviteCodeNub = [[[[dic objectForKey:@"fivestar_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_state"];
    NSString *inviteCode = [inviteCodeNub stringValue];
//    NSString *localCode = VS_USERDEFAULTS_GETVALUE(@"vsdkFSGiftCode");
//    if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {
//
//        [self showClaimRewardUI];
    
    if ([inviteCode isEqualToString:@"2"]) {
        [self showClaimRewardUI];
    }else{
        self.fsMaskView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
        self.fsMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        [self.fsMaskView addSubview:self];
        
        [VS_RootVC.view addSubview:self.fsMaskView];
        
        CGFloat imageViewWidth = 0;
        
        CGFloat imageViewHeight = 0;
        
        if (isPad) {
            
            if (DEVICEPORTRAIT) {
                
                
                imageViewWidth = 414/1.2;
                imageViewHeight = 414/1.21;
                
                
            }else{
                
                imageViewWidth = 896/1.6;
                imageViewHeight = 414/1.6;
                
            }
            
        }else{
            
            if (DEVICEPORTRAIT) {
                
                imageViewWidth = self.fsMaskView.frame.size.width/1.2;
                imageViewHeight = self.fsMaskView.frame.size.width/1.21;
                
            }else{
                
                imageViewWidth = self.fsMaskView.frame.size.width/1.6;
                imageViewHeight = self.fsMaskView.frame.size.height/1.6;
            }
            
        }
        
        
        UIImageView *fsimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
        fsimageView.center = self.fsMaskView.center;
        fsimageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImage * placeHolderImage;
        
        if (DEVICEPORTRAIT) {
            
            if (![[SDImageCache sharedImageCache] imageFromCacheForKey:VS_USERDEFAULTS_GETVALUE(@"fiveStarImageData")]) {
                
                placeHolderImage = [UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_bg_p.png")];
            }else{
                
                placeHolderImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:VS_USERDEFAULTS_GETVALUE(@"fiveStarImageData")];
                
            }
            
            [fsimageView sd_setImageWithURL:[NSURL URLWithString:VS_USERDEFAULTS_GETVALUE(@"fiveStarImageData")] placeholderImage:placeHolderImage];
            
        }else{
            
            if (![[SDImageCache sharedImageCache] imageFromCacheForKey:VS_USERDEFAULTS_GETVALUE(@"fiveStarImageData")]) {
                
                placeHolderImage = [UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_bg.png")];
            }else{
                
                placeHolderImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:VS_USERDEFAULTS_GETVALUE(@"fiveStarImageData")];
                
            }
            
            [fsimageView sd_setImageWithURL:[NSURL URLWithString:VS_USERDEFAULTS_GETVALUE(@"fiveStarImageData")] placeholderImage:placeHolderImage];
        }
        
        fsimageView.userInteractionEnabled = YES;
        [self.fsMaskView addSubview:fsimageView];
        
        
        CGSize imageSize = [UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_ok_bt_bg")].size;
        
        CGFloat rightMargin = 0;
        
        CGFloat beishu = 0;
        
        if (IS_IPHONE12_ProMax||IS_IPHONE12||IS_IPHONE_Xs_Max||isPad) {
            
            rightMargin = -70;
            beishu = 2.5;
            
        }else if(IS_IPHONE_X||IS_IPHONE_Xr){
            
            rightMargin = -60;
            beishu = 2.5;
            
        }else if(kiPhone6||kiPhone6Plus){
            
            beishu = 2.3;
            rightMargin = -30;
        }else{
            
            beishu = 2.4;
            rightMargin = -20;
        }
        
        
        UIButton * markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [fsimageView addSubview:markBtn];
        
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (DEVICEPORTRAIT) {
                
                make.right.equalTo(fsimageView.mas_right).with.offset(-40);
                make.bottom.equalTo(fsimageView.mas_bottom).with.offset(-20);
                make.size.mas_equalTo(CGSizeMake((fsimageView.frame.size.width - 130)/2,(fsimageView.frame.size.width - 130)/2/3.2));
                
            }else{
                
                if (isPad) {
                    
                    make.right.equalTo(fsimageView.mas_right).with.offset(rightMargin);
                    make.bottom.equalTo(fsimageView.mas_bottom).with.offset(-12);
                    make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu, imageSize.height/beishu));
                    
                }else{
                    
                    make.right.equalTo(fsimageView.mas_right).with.offset(rightMargin);
                    make.bottom.equalTo(fsimageView.mas_bottom).with.offset(-12);
                    make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu * SCREE_WIDTH/896, imageSize.height/beishu*SCREE_HEIGHT/414));
                    
                }
            }
            
        }];
        
        [markBtn setTitle:VSLocalString(@"Yes") forState:UIControlStateNormal];
        [markBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [markBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_ok_bt_bg")] forState:UIControlStateNormal];
        markBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [markBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
        [markBtn addTarget:self action:@selector(markBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fsimageView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            if(DEVICEPORTRAIT) {
                
                make.right.equalTo(markBtn.mas_left).with.offset(-30);
                make.bottom.equalTo(fsimageView.mas_bottom).with.offset(-20);
                make.size.mas_equalTo(CGSizeMake((fsimageView.frame.size.width - 130)/2,(fsimageView.frame.size.width - 130)/2/3.2));
                
            }else{
                
                if (isPad) {
                    make.right.equalTo(markBtn.mas_left).with.offset(-30);
                    make.bottom.equalTo(fsimageView.mas_bottom).with.offset(-12);
                    make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu, imageSize.height/beishu));
                }else{
                    make.right.equalTo(markBtn.mas_left).with.offset(-30);
                    make.bottom.equalTo(fsimageView.mas_bottom).with.offset(-12);
                    make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu * SCREE_WIDTH/896, imageSize.height/beishu*SCREE_HEIGHT/414));
                    
                }
            }
            
        }];
        
        
        [cancelBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_no_bt_bg") ] forState:UIControlStateNormal];
        [cancelBtn setTitle:VSLocalString(@"No") forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [VSDeviceHelper addAnimationInView:fsimageView Duration:0.5];
        
    }
    
}

-(void)cancelBtnClick:(UIButton *)sender{
    
    [self.fsMaskView removeFromSuperview];
    [self removeFromSuperview];
    
}

-(void)markBtnClick:(UIButton *)sender{
    
    [self.fsMaskView removeFromSuperview];
    [self removeFromSuperview];
    [VSDKShareHelper vsdk_popUpSKRequestView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[VSDKAPI shareAPI]  ssLikeRewardWithEventType:@"fivestar" EventId:[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_id"] EventCert:[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_cert"] Success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                NSDictionary * dic = [VSDeviceHelper preSaveSocialData];
                [[[[dic objectForKey:@"fivestar_event"]objectForKey:@"list"] firstObject]setValue:@2 forKey:@"item_event_state"];
                
               [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];
                
                if ([VSDK_GAM_REWARD_GIVEN_TYPE isEqualToString:@"prize_code"]) {
                    
                    VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"item_event_gift_code"], @"vsdkFSGiftCode");
                    [self showClaimRewardUI];
                    
                }else{
                    
                    VS_SHOW_SUCCESS_STATUS(@"The reward has been issued. please go to the mailbox to check.");
                }
                
                
            }else{
                
                VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            }
            
        } Failure:^(NSString *failure) {
            
        }];
    });
}

-(void)showClaimRewardUI{
    
    self.calimBgView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.calimBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.calimBgView addSubview:self];
    CGFloat imageViewWidth = 0;
    CGFloat imageViewHeight = 0;
    
    if (isPad) {
        
        if (DEVICEPORTRAIT) {
            
            
            imageViewWidth = 414/1.2;
            imageViewHeight = 414/1.21;
            
            
        }else{
            
            imageViewWidth = 896/1.6;
            imageViewHeight = 414/1.6;
            
        }
        
    }else{
        
        if (DEVICEPORTRAIT) {
            
            imageViewWidth = self.calimBgView.frame.size.width/1.2;
            imageViewHeight = self.calimBgView.frame.size.width/1.21;
            
        }else{
            
            imageViewWidth = self.calimBgView.frame.size.width/1.6;
            imageViewHeight = self.calimBgView.frame.size.height/1.6;
        }
        
    }
    
    
    UIImageView *claimImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    claimImageView.userInteractionEnabled = YES;
    claimImageView.center = VS_RootVC.view.center;
    claimImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (DEVICEPORTRAIT) {
        
        claimImageView.image = [UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_bg_p.png")];
        
    }else{
        
        claimImageView.image = [UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_bg.png")];
        
    }
    
    claimImageView.userInteractionEnabled = YES;
    [self.calimBgView addSubview:claimImageView];
    
    [VS_RootVC.view addSubview:self.calimBgView];
    
    
    CGSize imageSize = [UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_ok_bt_bg")].size;
    
    CGFloat rightMargin = 0;
    
    CGFloat beishu = 0;
    
    if (IS_IPHONE12_ProMax||IS_IPHONE12||IS_IPHONE_Xs_Max||isPad) {
        
        rightMargin = -70;
        beishu = 2.5;
        
    }else if(IS_IPHONE_X||IS_IPHONE_Xr){
        
        rightMargin = -60;
        beishu = 2.5;
        
    }else if(kiPhone6||kiPhone6Plus){
        
        beishu = 2.3;
        rightMargin = -30;
    }else{
        
        beishu = 2.4;
        rightMargin = -20;
    }
    
    
    UIButton * markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [claimImageView addSubview:markBtn];
    
    [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        if (DEVICEPORTRAIT) {
            
            make.right.equalTo(claimImageView.mas_right).with.offset(-40);
            make.bottom.equalTo(claimImageView.mas_bottom).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake((claimImageView.frame.size.width - 130)/2,(claimImageView.frame.size.width - 130)/2/3.2));
            
        }else{
            
            if (isPad) {
                make.right.equalTo(claimImageView.mas_right).with.offset(rightMargin);
                make.bottom.equalTo(claimImageView.mas_bottom).with.offset(-12);
                make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu, imageSize.height/beishu));
            }else{
                make.right.equalTo(claimImageView.mas_right).with.offset(rightMargin);
                make.bottom.equalTo(claimImageView.mas_bottom).with.offset(-12);
                make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu * SCREE_WIDTH/896, imageSize.height/beishu*SCREE_HEIGHT/414));
                
            }
        }
        
    }];
    
    [markBtn setTitle:VSLocalString(@"Copy") forState:UIControlStateNormal];
    [markBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [markBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_ok_bt_bg")] forState:UIControlStateNormal];
    markBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [markBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [markBtn addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [claimImageView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        if (DEVICEPORTRAIT) {
            
            make.right.equalTo(markBtn.mas_left).with.offset(-30);
            make.bottom.equalTo(claimImageView.mas_bottom).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake((claimImageView.frame.size.width - 130)/2,(claimImageView.frame.size.width - 130)/2/3.2));
            
        }else{
            
            
            
            if (isPad) {
                make.right.equalTo(markBtn.mas_left).with.offset(-30);
                make.bottom.equalTo(claimImageView.mas_bottom).with.offset(-12);
                make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu, imageSize.height/beishu));
            }else{
                make.right.equalTo(markBtn.mas_left).with.offset(-30);
                make.bottom.equalTo(claimImageView.mas_bottom).with.offset(-12);
                make.size.mas_equalTo(CGSizeMake(imageSize.width/beishu * SCREE_WIDTH/896, imageSize.height/beishu*SCREE_HEIGHT/414));
                
            }
            
        }
        
    }];
    
    
    [cancelBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_fivestar_reviews_dialog_no_bt_bg") ] forState:UIControlStateNormal];
    [cancelBtn setTitle:VSLocalString(@"Cancel") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [cancelBtn addTarget:self action:@selector(LaterClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * activeCodeLabel = [[UILabel alloc]init];
    [claimImageView addSubview:activeCodeLabel];
    [activeCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.bottom.equalTo(cancelBtn.mas_top).with.offset(-30);
            make.left.equalTo(claimImageView.mas_left).with.offset(17);
            make.right.equalTo(claimImageView);
            
        }else{
            
            make.bottom.equalTo(cancelBtn.mas_top).with.offset(-30);
            make.left.equalTo(cancelBtn);
            make.right.equalTo(markBtn.mas_centerX);
            
        }
        
        
    }];
    
    
    NSString * fsGiftCode = [[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"] firstObject]objectForKey:@"item_event_gift_code"]length]>0?[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"] firstObject]objectForKey:@"item_event_gift_code"]:VS_USERDEFAULTS_GETVALUE(@"vsdkFSGiftCode");
    
    activeCodeLabel.text =  [NSString stringWithFormat:@"%@\n[%@]",VSLocalString(@"Your Gift Code is"),fsGiftCode];
    
    [activeCodeLabel sizeToFit];
    activeCodeLabel.textAlignment = NSTextAlignmentCenter;
    activeCodeLabel.numberOfLines = 0;
    activeCodeLabel.font = [UIFont systemFontOfSize:17];
    
    [VSDeviceHelper addAnimationInView:claimImageView Duration:0.5];
    
    
}


-(void)copyClick:(UIButton *)sender{
    
    [self.calimBgView removeFromSuperview];
    self.calimBgView = nil;
    VS_SHOW_SUCCESS_STATUS(@"Copy successfully,Please go to the game to redeem");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"] firstObject]objectForKey:@"item_event_gift_code"]length]>0?[[[[[VSDeviceHelper preSaveSocialData]objectForKey:@"fivestar_event"]objectForKey:@"list"] firstObject]objectForKey:@"item_event_gift_code"]:VS_USERDEFAULTS_GETVALUE(@"vsdkFSGiftCode");
    
}

-(void)LaterClick:(UIButton *)sender{
    
    [self.calimBgView removeFromSuperview];
    self.calimBgView = nil;
    
}

@end
