//
//  VSToast.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSToast.h"
#import <QuartzCore/QuartzCore.h>
#import "VSSDKDefine.h"
#import "SDKENTRANCE.h"
//#import "VerifyView.h"
//#import "ConsumeView.h"
#import "WriteeVC.h"
#define PhoneWidth  300
#define PhoneHeight 50
//50
#define ImageSize  CGSizeMake(32, 35)
#define PhoneFont  16
#define kMargin 16
#define kCornerRadius 5.0
#define kAlpha 0.8
#define kDuration 0.3

#define kYoffset  [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||  [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown?25:8

static BOOL ifSwitchAccount = NO;
@interface VSToast ()

@end

@implementation VSToast
@synthesize content      = _content;
@synthesize image        = _image;

- (void)dealloc {
    
    self.content = nil;
    self.image   = nil;

}

- (id)initWithContent:(NSString *)content {
    
    return [self initWithImage:nil content:content];
}

- (id)initWithImage:(UIImage *)image content:(NSString *)content {
    
    if (self = [super init]) {
        self.content = content;
        self.image = image;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin    |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin   |
        UIViewAutoresizingFlexibleRightMargin;
        
    }
    return self;
}

-(void)switchBtnAction{
    [SDKENTRANCE resignWindow];
    ifSwitchAccount = YES;
    if (self.toastBlock) {
        self.toastBlock(VSToastViewBlockSwitch);
        
    }
}

-(void)EnterGameAction{
    
    if (self.toastBlock) {
        self.toastBlock(VSToastViewBlockEnterGame);
        
    }
}

- (void)showToast {
    
    ifSwitchAccount = NO;
    
    if (@available(iOS 13.0, *)) {
     
        self.backgroundColor = [UIColor systemBackgroundColor];
     
     }else{
         
         self.backgroundColor = VSDK_WHITE_COLOR;
     }
    
    self.layer.cornerRadius = kCornerRadius;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = self.content;
    textLabel.textColor = VS_RGB(5, 51, 101);
    textLabel.font = [UIFont systemFontOfSize:PhoneFont];
    textLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:textLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    [self addSubview:imageView];
    
    
    UIButton * switchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    switchBtn.layer.cornerRadius = 5;
    [switchBtn setTitle:VSLocalString(@"ID Settings") forState:UIControlStateNormal];
    [switchBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    [switchBtn setBackgroundColor:VS_RGB(5, 51, 101)];
    [switchBtn addTarget:self action:@selector(switchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchBtn];
    
    UIButton *writeoffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    writeoffBtn.layer.cornerRadius = 5;
    [writeoffBtn setTitle:VSLocalString(@"Delete Account") forState:UIControlStateNormal];
    [writeoffBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    [writeoffBtn setBackgroundColor:VS_RGB(5, 51, 101)];
    [writeoffBtn addTarget:self action:@selector(writeeAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:writeoffBtn];
    
    if (DEVICEPORTRAIT) {
        CGFloat imgY = (PhoneHeight - ImageSize.height)/2;
        imageView.frame = CGRectMake(5, imgY, ImageSize.width, ImageSize.height);
        CGFloat textX = CGRectGetMaxX(imageView.frame) + 5;
        
        textLabel.frame = CGRectMake(textX, 10, [VSDeviceHelper sizeWithFontStr:VSLocalString(textLabel.text) WithFontSize:PhoneFont], PhoneHeight-20);
        CGFloat buttonX = CGRectGetMaxX(textLabel.frame) + 5;
        
        switchBtn.frame = CGRectMake(buttonX, 10,   [VSDeviceHelper sizeWithFontStr:VSLocalString(@"ID Settings") WithFontSize:PhoneFont] + 5, PhoneHeight - 20);
        CGFloat writeBtnX = CGRectGetMaxX(switchBtn.frame) + 5;
        
        writeoffBtn.frame = CGRectMake(writeBtnX, 10, [VSDeviceHelper sizeWithFontStr:VSLocalString(@"Delete Account") WithFontSize:PhoneFont] + 5, PhoneHeight - 20);
        writeoffBtn.titleLabel.font = [UIFont systemFontOfSize:PhoneFont];
        
        CGFloat bgViewW = CGRectGetMaxX(textLabel.frame);
        CGFloat width = bgViewW + 5 +  switchBtn.frame.size.width + writeoffBtn.frame.size.width + 10;
        CGFloat scWidth = [[UIScreen mainScreen] bounds].size.width;
        self.frame = CGRectMake((scWidth - width)/2.0, -PhoneHeight, width, PhoneHeight);
    }else{
        CGFloat imgY = (PhoneHeight - ImageSize.height)/2;
        imageView.frame = CGRectMake(kMargin, imgY, ImageSize.width, ImageSize.height);
        CGFloat textX = CGRectGetMaxX(imageView.frame) + 10;
        
        textLabel.frame = CGRectMake(textX, 10, [VSDeviceHelper sizeWithFontStr:VSLocalString(textLabel.text) WithFontSize:PhoneFont], PhoneHeight-20);
        CGFloat buttonX = CGRectGetMaxX(textLabel.frame) + 10;
        
        switchBtn.frame = CGRectMake(buttonX, 10,   [VSDeviceHelper sizeWithFontStr:VSLocalString(@"ID Settings") WithFontSize:PhoneFont] + 10, PhoneHeight - 20);
        CGFloat writeBtnX = CGRectGetMaxX(switchBtn.frame) + 10;
        
        writeoffBtn.frame = CGRectMake(writeBtnX, 10, [VSDeviceHelper sizeWithFontStr:VSLocalString(@"Delete Account") WithFontSize:PhoneFont] + 10, PhoneHeight - 20);
        writeoffBtn.titleLabel.font = [UIFont systemFontOfSize:PhoneFont];
        
        CGFloat bgViewW = CGRectGetMaxX(textLabel.frame);
        CGFloat width = bgViewW + kMargin +  switchBtn.frame.size.width + writeoffBtn.frame.size.width + kMargin;
        CGFloat scWidth = [[UIScreen mainScreen] bounds].size.width;
        self.frame = CGRectMake((scWidth - width)/2.0, -PhoneHeight, width, PhoneHeight);
    }
    
    
    
//    CGFloat bgViewW = CGRectGetMaxX(textLabel.frame);
//    CGFloat width = bgViewW + kMargin +  switchBtn.frame.size.width + writeoffBtn.frame.size.width + kMargin;
//    CGFloat scWidth = [[UIScreen mainScreen] bounds].size.width;
//    self.frame = CGRectMake((scWidth - width)/2.0, -PhoneHeight, width, PhoneHeight);
    
    UIViewController *vc = [self currentViewController];
    [vc.view addSubview:self];
    
    [UIView animateWithDuration:kDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = kYoffset;
//        if(DEVICEPORTRAIT){
//            frame.origin.y = 20;
//        }else{
//            frame.origin.y = 10;
//        }
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    }];
    
}

- (void)hideToast {
    
    if (ifSwitchAccount == YES) {
        
        [UIView animateWithDuration:kDuration animations:^{
            CGRect frame = self.frame;
            frame.origin.y = - frame.size.height;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
        
    }else{
        
        [UIView animateWithDuration:kDuration animations:^{
            CGRect frame = self.frame;
            frame.origin.y = - frame.size.height;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
        
        [self EnterGameAction];
        
    }
    
}

- (UIViewController *)currentViewController {
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *currentVc = window.rootViewController;
    while (currentVc.presentedViewController) {
        currentVc = currentVc.presentedViewController;
    }
    return currentVc;
}

- (UIInterfaceOrientation)currentOrientation {
    
    return [UIApplication sharedApplication].statusBarOrientation;
}

-(void)toastViewBlock:(VSToastViewBlock)block{
    
    self.toastBlock = block;
    
}

-(void)writeeAccount:(UIButton *)btn{
    ifSwitchAccount = YES;
//    WriteeVC *writevc = [[WriteeVC alloc] init];
//    [SDKENTRANCE showViewController:writevc];
    __weak typeof(self) ws = self;
//    writevc.verifyV.vcloseBlock = ^{
//        [SDKENTRANCE resignWindow];
//        if (ws.toastBlock) {
//            ws.toastBlock(VSToastViewBlockSwitch);
//
//        }
//    };
//
//    writevc.consumV.cancelBlock = ^{
//        [SDKENTRANCE resignWindow];
//        if (ws.toastBlock) {
//            ws.toastBlock(VSToastViewBlockSwitch);
//
//        }
//    };
    
    [VSDKHelper sharedHelper].Ablock = ^{
        [SDKENTRANCE resignWindow];
        if (ws.toastBlock) {
            ws.toastBlock(VSToastViewBlockSwitch);
        }
        
    };
    
    [VSDKHelper sharedHelper].Bblock = ^{
        [SDKENTRANCE resignWindow];
        if (ws.toastBlock) {
            ws.toastBlock(VSToastViewBlockSwitch);
        }
        
    };
    
//    [[VSDKHelper sharedHelper] vsdk_delectUserAccount];
    VSDelAccontView * delCount = [[VSDelAccontView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    delCount.center = VS_RootVC.view.center;
    [VS_RootVC.view addSubview:delCount];
    
    delCount.closeBlock = ^{
        if (ws.toastBlock) {
            ws.toastBlock(VSToastViewBlockSwitch);
        }
    };
    
}

@end
