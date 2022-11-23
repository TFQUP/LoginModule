//
//  VSWidget.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VSWidget : NSObject

#pragma mark + 控件工厂
/**
 返回UILabel
 
 @param text 文本
 @param color 文本颜色
 @param size 字体大小
 @param alignStyle 字体是否居中
 @return UILabel
 */
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)color
                  fontSize:(CGFloat)size
                 textAlign:(NSInteger)alignStyle;

/**
 返回UIButton
 
 @param bgImage 背景图片
 @param highlightedBgImage 高亮背景图片
 @return 返回UIButton
 */
+ (UIButton *)buttonWithBgImage:(UIImage *)bgImage
             highlightedBgImage:(UIImage *)highlightedBgImage;



+(UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titlecolor bgColor:(UIColor *)bgColor fontSize:(CGFloat)size textAlign:(NSInteger)aligment;
/**
 返回UIButton
 
 @param image 图片
 @param highlightedImage 高亮图片
 @return 返回UIButton
 */
+ (UIButton *)buttonWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage;

/**
 返回UIButton
 
 @param title 文本
 @param color 文本颜色
 @param highlightTtileColor 文本高亮颜色
 @param size 字体大小
 @param bgImg 背景图
 @param highlightBgImg 高亮背景图
 @return 返回UIButton
 */

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)color
          highlightTtileColor:(UIColor *)highlightTtileColor
                     fontSize:(CGFloat)size
                        bgImg:(UIImage *)bgImg
               highlightBgImg:(UIImage *)highlightBgImg;

/**
 返回UIButton
 
 @param title 文本
 @param color 文本颜色
 @param size 字体大小
 @param highlightedColor 文本高亮颜色
 @return 返回UIButton
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)color
             highlightedColor:(UIColor *)highlightedColor
                     fontSize:(CGFloat)size;

/**
 * @ brief :
 * @ param placeholder
 * @ param text        输入
 * @ param borderStyle
 * @ param bgColor
 * @ param delegate    代理对象
 * @ param fontSize
 */

/**
 返回UITextField
 
 @param placeholder 占位文本
 @param borderStyle 样式
 @param alignStyle 对齐方式
 @param bgColor 背景颜色
 @param fontSize 字体大小
 @param secure 设置安全输入
 @return 返回UITextField
 */
+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                              borderStyle:(NSInteger)borderStyle
                                textAlign:(NSInteger)alignStyle
                          backgroundColor:(UIColor *)bgColor
                                 fontSize:(CGFloat)fontSize
                                   secure:(BOOL)secure;

/**
 返回UITextField
 
 @param placeholder 占位文本
 @param borderStyle 样式
 @param alignStyle 对齐方式
 @param keyboardType 键盘类型
 @param bgColor 背景颜色
 @param fontSize 字体大小
 @param secure 设置安全输入
 @return 返回UITextField
 */
+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                              borderStyle:(NSInteger)borderStyle
                                textAlign:(NSInteger)alignStyle
                             keyboardType:(NSInteger)keyboardType
                          backgroundColor:(UIColor *)bgColor
                                 fontSize:(CGFloat)fontSize
                                   secure:(BOOL)secure;


/**
 返回imageView

 @param frame frame
 @param imageName image
 @return UIImageView
 */
+(UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName;



+(UILabel *)labelWithFrame:(CGRect)frame Text:(NSString *)text Font:(CGFloat)font TextColor:(UIColor *)textColor NumberOfLines:(NSInteger)numberOfLines TextAlignment:(NSTextAlignment)textAlignment;

+(UIButton *)vsdk_ButtonWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius ButtonType:(UIButtonType)buttonType Image:(NSString *)image Title:(NSString *)title TextAlignment:(NSTextAlignment)alignment TitleColor:(UIColor *)titleColor BGColor:(UIColor *)bgColor Font:(CGFloat)font BoldFont:(BOOL)ifBold Target:(id)target Action:(SEL)action;

@end

