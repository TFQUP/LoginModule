//
//  VSNotificationView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSNotificationView.h"
#import "VSSDKDefine.h"
@implementation VSNotificationView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        [self layoutNotificationView];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}


-(void)layoutNotificationView{
    
    self.labelTitleDes = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width /2, 15)];
    self.labelTitleDes.text = @"notice";
    self.labelTitleDes.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_labelTitleDes];
    
    self.labelContent = [VSWidget labelWithFrame:CGRectMake(15, self.labelTitleDes.frame.origin.y +self.labelTitleDes.frame.size.height + 3, self.frame.size.width - 115, self.frame.size.height >= 120?self.frame.size.height -55:self.frame.size.height-30) Text:@"" Font:16 TextColor:VSDK_BLACK_COLOR NumberOfLines:0 TextAlignment:NSTextAlignmentLeft];
    [self addSubview: self.labelContent];
    
    if (self.frame.size.height >= 120) {
        
        self.btnShowMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnShowMore setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_seemore")] forState:UIControlStateNormal];
        [self.btnShowMore setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_packup")] forState:UIControlStateSelected];
        self.btnShowMore.frame = CGRectMake(self.frame.size.width/2 - 25 , self.labelContent.frame.size.height + self.labelContent.frame.origin.y +3, 50, 20);
        [self.btnShowMore addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnShowMore];
    }
    
    if ([[VS_USERDEFAULTS valueForKey:@"importShow"] isEqualToString:@"YES"]) {
        
        self.btnComfirm  = [VSWidget buttonWithTitle:VSLocalString(@"Got it") titleColor:VSDK_WHITE_COLOR bgColor:VSDK_ORANGE_COLOR fontSize:16 textAlign:NSTextAlignmentCenter];
    }else{
       
        self.btnComfirm  = [VSWidget buttonWithTitle:VSLocalString(@"Got it") titleColor:VSDK_WHITE_COLOR bgColor:VSDK_ORANGE_COLOR fontSize:16 textAlign:NSTextAlignmentCenter];
        [self alertViewAutoHideAfterFiveSeconds];
        
    };
    
    self.btnComfirm.frame = CGRectMake(VS_VIEW_RIGHT(self.labelContent) + 15, self.labelContent.frame.origin.y, 70,self.frame.size.height/3);
     self.btnComfirm.layer.cornerRadius = 5;
     self.btnComfirm.layer.masksToBounds = YES;
    [self.btnComfirm addTarget:self action:@selector(hideUlImportantAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnComfirm];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideUlImportantAlertView)];
    [self addGestureRecognizer:tap];
     
}


-(void)alertViewAutoHideAfterFiveSeconds{
    
    __block NSInteger time = 10; //倒计时时间

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideUlImportantAlertView];
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
    
                self.btnComfirm .enabled = NO;
                [self.btnComfirm setTitle:[NSString stringWithFormat:@"%.1lds", (long)time] forState:UIControlStateNormal];
            });
            
            time--;
        }
    });
    
    dispatch_resume(_timer);
    
}

-(void)refreshView:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
      
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = self.frame;
            
            frame.size.height = self.showTextHeight;
            
            self.frame = frame;
            
            CGRect contentLabelFrame = self.labelContent.frame;
            
            contentLabelFrame.size.height = self.frame.size.height - 55;
            
            self.labelContent.frame = contentLabelFrame;
            
            CGRect showBtnFrame = self.btnShowMore.frame;
            
            showBtnFrame.origin.y = VS_VIEW_BOTTOM(self.labelContent) + 3;
            
            self.btnShowMore.frame = showBtnFrame;
        }];
        
    }else{
       
        [UIView animateWithDuration:0.3 animations:^{
           
            CGRect frame = self.frame;
            frame.size.height = 120;
            self.frame = frame;
            
            CGRect contentLabelFrame = self.labelContent.frame;
            contentLabelFrame.size.height = self.frame.size.height - 55;
            self.labelContent.frame = contentLabelFrame;
            
            CGRect showBtnFrame = self.btnShowMore.frame;
            showBtnFrame.origin.y = VS_VIEW_BOTTOM(self.labelContent) + 3;
            self.btnShowMore.frame = showBtnFrame;
            
        }];
    }
}

-(void)showUlImportantAlertViewWithNofi:(UNNotification *)nofi{
    
    self.notification = nofi;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.frame = CGRectMake((SCREE_WIDTH - SCREE_WIDTH*0.8)/2 , 10, SCREE_WIDTH*0.8, self.frame.size.height);
        }];
        
    });
}

-(void)hideUlImportantAlertView{
   
    if ([self.notification.request.content.userInfo objectForKey:@"ulsdk_equipment_uuid"]) {
        
        [[VSDKAPI shareAPI]  vsdk_reportDeviceToServiceWithEquipment_uuid:[self.notification.request.content.userInfo objectForKey:@"ulsdk_equipment_uuid"]];
    }

    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake((SCREE_WIDTH - SCREE_WIDTH*0.8)/2 , -self.frame.size.height-10, SCREE_WIDTH*0.8, self.frame.size.height);
    }];
    
}

@end

