//
//  VSHUD.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VSHUD : NSObject


+ (void)show:(UIView *)containerView;

+ (void)showWithContainerView:(UIView *)containerView status:(NSString *)status;

+ (void)showInfoWithContainerView:(UIView *)containerView status:(NSString *)status;

+ (void)showSuccessWithContainerView:(UIView *)containerView status:(NSString *)status;

+ (void)showErrorWithContainerView:(UIView *)containerView status:(NSString *)status;

+ (void)showToastWithImage:(UIImage *)image message:(NSString *)text;

+ (void)hide;

+ (void)setStatus:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
