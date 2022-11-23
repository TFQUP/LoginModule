//
//  VSForgetPswView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSBaseView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSForgetViewBlockType) {
    
    VSForgetViewBlockRetrive = 0, //找回密码
    VSForgetViewBlockRetry = 1, //重试登陆

};

typedef void(^VSForgetPswViewBlock)(VSForgetViewBlockType type);

@interface VSForgetPswView : VSBaseView

@property (nonatomic, copy) VSForgetPswViewBlock  forgetViewBlock;
- (void)ForgetViewBlock:(VSForgetPswViewBlock) block;


@end

NS_ASSUME_NONNULL_END
