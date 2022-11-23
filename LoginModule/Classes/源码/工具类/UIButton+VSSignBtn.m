//
//  UIButton+ULSignBtn.m

//
//  Created by admin on 6/10/20.
//  Copyright © 2020 LuisAnna. All rights reserved.
//

#import "UIButton+VSSignBtn.h"
#import <objc/runtime.h>
@implementation UIButton (VSSignBtn)

-(void)setSignInType:(NSString *)signInType{
    
    objc_setAssociatedObject(self, @selector(signInType), signInType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSString *)signInType{
 
    return objc_getAssociatedObject(self, _cmd);
    
}
@end
