//
//  VSBaseView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSWidget.h"
NS_ASSUME_NONNULL_BEGIN

@interface VSBaseView : UIView

-(void)showAlertWithMessage:(NSString *)meg;

-(UIButton *)textFieldRightView;
/**
 textFieldRightView
 
 @return textFieldRightView
 */
-(UIButton *)emailTextFieldRightView;


-(UIButton *)pswTextFieldRightView;
/**
 显示密码之后字符大小和长度不一致的问题
 
 @param textField textField
 @param btn 显示密码按钮
 */
- (void)changeTextFieldSecure:(UITextField *)textField showBtn:(UIButton *)btn;

/**
 textFieldLeftView
 
 @param title 文字描述
 @param image 图片描述
 @return textFieldLeftView
 */
- (UIView *)textFieldLeftView:(NSString *)title image:(UIImage *)image;


-(UIView *)textFieldLeftView:(UIImage*)image;
/**
 检测输入信息
 
 @param acount 账号
 @param password 密码
 @return 正确 YES 错误 NO
 */
- (BOOL)checkInputAccount:(NSString *)acount
                 password:(NSString *)password;


- (BOOL)checkInputAccount:(NSString *)acount;

@end

NS_ASSUME_NONNULL_END
