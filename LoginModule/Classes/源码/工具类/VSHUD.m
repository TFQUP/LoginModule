//
//  VSHUD.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSHUD.h"
#import "VSSDKDefine.h"
#import "SVProgressHUD.h"
#import "VSToast.h"

@interface VSHUD ()

@end

static VSHUD *_qzhud;
@implementation VSHUD


+ (void)show:(UIView *)containerView {
    
    [[VSHUD sharedHUD] show:containerView];
}

+ (void)showWithContainerView:(UIView *)containerView status:(NSString *)status {
    
    [[VSHUD sharedHUD] showWithContainerView:containerView status:status];
}

+ (void)showInfoWithContainerView:(UIView *)containerView status:(NSString *)status {
    
      [SVProgressHUD setContainerView:containerView];
    [[VSHUD sharedHUD] showInfoWithContainerView:containerView status:status];
}

+ (void)showSuccessWithContainerView:(UIView *)containerView status:(NSString *)status {
    
    [SVProgressHUD setContainerView:containerView];
    [[VSHUD sharedHUD] showSuccessWithContainerView:containerView status:status];
}

+ (void)showErrorWithContainerView:(UIView *)containerView status:(NSString *)status {
    
    [SVProgressHUD setContainerView:containerView];
    
    [[VSHUD sharedHUD] showErrorWithContainerView:containerView status:status];
}

+ (void)showToastWithImage:(UIImage *)image message:(NSString *)text {
    
    [[VSHUD sharedHUD] showToastWithImage:image message:text];
}

+ (void)hide {
    
    [[VSHUD sharedHUD] hide];
}

+ (void)setStatus:(NSString *)string {
    
    [[VSHUD sharedHUD] setStatus:string];
}

+ (VSHUD *)sharedHUD {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _qzhud = [[[self class] alloc] init];
    });
    
    return _qzhud;
}

-  (instancetype)init {
    
    if (self = [super init]) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.2];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setCornerRadius:5.0];
        [SVProgressHUD setMinimumSize:CGSizeMake(60, 60)];
    }
    return self;
}

- (void)show:(UIView *)containerView {
    
//    [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD show];
}

- (void)showWithContainerView:(UIView *)containerView status:(NSString *)status {
    

     [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD showWithStatus:status];
    
}

- (void)showInfoWithContainerView:(UIView *)containerView status:(NSString *)status {
    
     [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD showInfoWithStatus:status];
}

- (void)showSuccessWithContainerView:(UIView *)containerView status:(NSString *)status {
   
    [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD showSuccessWithStatus:status];
}

- (void)showErrorWithContainerView:(UIView *)containerView status:(NSString *)status {
    
    [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD showErrorWithStatus:status];
}

- (void)showToastWithImage:(UIImage *)image message:(NSString *)text {
    
    VSToast *toast = [[VSToast alloc] initWithImage:image content:text];
    [toast showToast];
}

- (void)setStatus:(NSString *)string {
    
    [SVProgressHUD setStatus:string];
}

- (void)hide {
    
    [SVProgressHUD dismiss];
}

@end
