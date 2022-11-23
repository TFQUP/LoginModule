//
//  VSTextBackView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSTextBackView.h"
#import "VSSDKDefine.h"
@implementation VSTextBackView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
      
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(10): ADJUSTPadAndPhoneW(10);
        self.layer.borderColor = VSDK_LIGHT_GRAY_COLOR.CGColor;

    }
    
    return self;
}

@end
