//
//  VSIrregularBtn.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSIrregularBtn.h"
#import "VSSDKDefine.h"
@interface VSIrregularBtn()

@property (nonatomic, strong) UIBezierPath *path;

@end
@implementation VSIrregularBtn


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];

    if (DEVICEPORTRAIT) {

        [VS_RGB(5, 51, 101) set];
        self.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
        self.path.lineWidth     = 2.f;
        self.path.lineCapStyle  = kCGLineCapRound;
        self.path.lineJoinStyle = kCGLineJoinRound;
        [self.path stroke];
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.path = self.path.CGPath;
        self.layer.mask = layer;
        
    }else{
    
        [VS_RGB(5, 51, 101) set];
        self.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        self.path.lineWidth     = 2.f;
        self.path.lineCapStyle  = kCGLineCapRound;
        self.path.lineJoinStyle = kCGLineJoinRound;
        [self.path stroke];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.path = self.path.CGPath;
        self.layer.mask = layer;
    }
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL res = [super pointInside:point withEvent:event];
        if (res){
            
            if ([self.path containsPoint:point]){
                
                return YES;
            }
            return NO;
        }
    return NO;
}
@end

