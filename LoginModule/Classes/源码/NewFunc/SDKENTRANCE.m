//
//  SDKENTRANCE.m
//  VVSDK
//
//  Created by admin on 3/31/22.
//

#import "SDKENTRANCE.h"


@interface SDKENTRANCE()
@property (nonatomic, strong) UIWindow *sdkWindow;

@end

@implementation SDKENTRANCE

+(SDKENTRANCE*)shareInstance{
    static SDKENTRANCE *sdkInstance = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        sdkInstance = [[self alloc] init];
    });
    return sdkInstance;
}

- (UIWindow *)sdkWindow {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_sdkWindow) {
            _sdkWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    //        _sdkWindow.windowLevel = UIWindowLevelAlert - 1;
            _sdkWindow.windowLevel = UIWindowLevelAlert;
            _sdkWindow.hidden = NO;
        }
//    });
    return _sdkWindow;
}

+ (void)showViewController:(UIViewController *)vc {
//    dispatch_async(dispatch_get_main_queue(), ^{
        SDKENTRANCE *manager = self.shareInstance;
        manager.sdkWindow.rootViewController = vc;
        [manager.sdkWindow makeKeyAndVisible];
//    });
}

+ (void)resignWindow {
//    dispatch_async(dispatch_get_main_queue(), ^{
        SDKENTRANCE *manager = self.shareInstance;
        [manager.sdkWindow resignKeyWindow];
        [manager.sdkWindow removeFromSuperview];
        manager.sdkWindow.hidden = YES;
        manager.sdkWindow = nil;
//    });
}
@end
