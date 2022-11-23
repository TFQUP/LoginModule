//
//  VSUserCenterTF.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSUserCenterTF.h"

@implementation VSUserCenterTF

-(CGRect)rightViewRectForBounds:(CGRect)bounds{

    CGRect rightRect =CGRectZero;

    rightRect.origin.x = bounds.size.width - 30;

    rightRect.size.height = 22;

    rightRect.origin.y = (bounds.size.height - rightRect.size.height)/2;

    rightRect.size.width = 22;

    return rightRect;

}


@end
