//
//  VSBadgeBtn.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBadgeBtn.h"
#import <objc/runtime.h>
#import "VSSDKDefine.h"

NSString const *badgeAlertImageViewKey = @"badgeAlertImageViewKey";
NSString const *badgeImageKey = @"badgeImageKey";
NSString const *badgeAlertOriginXKey          = @"badgeOriginXKey";
NSString const *badgeAlertOriginYKey          = @"badgeOriginYKey";
NSString const *showBadgeKey = @"showBadgeKey";
@implementation VSBadgeBtn

-(UIImageView *)badgeAlertImageView{
    
   return objc_getAssociatedObject(self, &badgeAlertImageViewKey);
}

-(void)setBadgeAlertImageView:(UIImageView *)badgeAlertImageView{
    
      objc_setAssociatedObject(self, &badgeAlertImageViewKey, badgeAlertImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)badgeInit{
    
    self.badgeOriginX   = self.frame.size.width - self.badgeAlertImageView.frame.size.width/2;
    self.badgeOriginY   = -4;
    self.showBadge = YES;
    self.clipsToBounds = NO;
    
}

-(CGFloat)badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &badgeAlertOriginXKey);
    return number.floatValue;
}

-(void) setBadgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &badgeAlertOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
}


-(CGFloat)badgeOriginY{
    
    NSNumber *number = objc_getAssociatedObject(self, &badgeAlertOriginYKey);
       return number.floatValue;
}


-(void)setBadgeOriginY:(CGFloat)badgeOriginY{
    
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
     objc_setAssociatedObject(self, &badgeAlertOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)showBadge{
    
    NSNumber *number = objc_getAssociatedObject(self, &showBadgeKey);
       return number.boolValue;
}

-(void)setShowBadge:(BOOL)showBadge{

    NSNumber *number = [NSNumber numberWithBool:showBadge];
    objc_setAssociatedObject(self, &showBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSString *)badgeImage{
    
     return objc_getAssociatedObject(self, &badgeImageKey);
}

-(void)setBadgeImage:(NSString *)badgeImage{
   
    objc_setAssociatedObject(self, &badgeImageKey, badgeImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.badgeAlertImageView = [[UIImageView alloc]initWithFrame:CGRectMake(VS_VIEW_RIGHT(self) + 2 ,0, 14, 14)];
    
    
    self.badgeAlertImageView.image = [UIImage imageNamed:badgeImage];
    [VSDeviceHelper addAnimationInView:self.badgeAlertImageView Duration:0.3];
    [self badgeInit];
    [self addSubview:self.badgeAlertImageView];
    
}

- (void)removeBadge
{

    [UIView animateWithDuration:0.2 animations:^{
        self.badgeAlertImageView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badgeAlertImageView removeFromSuperview];
    }];
}


@end
