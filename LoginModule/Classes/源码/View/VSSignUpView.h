//
//  VSSignUpView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//注册view



#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSSignUpViewBlockType) {
    VSSignUpViewBlockSignUp   = 0,
    VSSignUpViewBlockShowTerm = 1,
};

typedef void(^VSSignUpViewBlock)(VSSignUpViewBlockType type);

@interface VSSignUpView : VSBaseView

//邮箱文本框
@property (nonatomic,strong)UITextField * tfEmail;
//密码文本款
@property (nonatomic,strong)UITextField * tfPwd;
//登录按钮
@property (nonatomic,strong)UIButton * btnRegister;
//确认条款按钮
@property (nonatomic,strong)UIButton * btnComfirm;

@property (nonatomic, copy)VSSignUpViewBlock registerCallback;

- (void)signUpViewBlock:(VSSignUpViewBlock) block;

@end

NS_ASSUME_NONNULL_END
