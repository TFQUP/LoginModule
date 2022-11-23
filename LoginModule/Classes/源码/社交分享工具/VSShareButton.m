//
//  VSShareButton.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSShareButton.h"

@implementation VSShareButton
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGRect retValue = CGRectMake(0,self.frame.size.height-10,contentRect.size.width + 10,10);

    return retValue;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect retValue =  CGRectMake(self.frame.size.width/2 - 22,0,50,50);
    return retValue;
}
@end
