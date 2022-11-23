//
//  VSSwitchBtn.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSwitchBtn.h"
#import "VSSDKDefine.h"
@implementation VSSwitchBtn

-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    
    CGRect retValue = CGRectMake(0,0,contentRect.size.width - 15,15);
    
    return retValue;
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect retValue = CGRectMake(contentRect.size.width - 20,0,15,15);
      return retValue;
}
@end
