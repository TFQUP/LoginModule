//
//  VSWidget.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSWidget.h"
#import "VSSDKDefine.h"
@implementation VSWidget

#pragma mark - 控件工厂
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)color fontSize:(CGFloat)size textAlign:(NSInteger)alignStyle {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = alignStyle;
    return label;
}

+(UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titlecolor bgColor:(UIColor *)bgColor fontSize:(CGFloat)size textAlign:(NSInteger)aligment{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setBackgroundColor:bgColor];
    
    [button setTitleColor:titlecolor forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    
    button.titleLabel.textAlignment = aligment;
    
    return button;
    
}

+ (UIButton *)buttonWithBgImage:(UIImage *)bgImage highlightedBgImage:(UIImage *)highlightedBgImage {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    return button;
}

+ (UIButton *)buttonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setImage:highlightedImage forState:UIControlStateSelected];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color highlightTtileColor:(UIColor *)highlightTtileColor fontSize:(CGFloat)size bgImg:(UIImage *)bgImg highlightBgImg:(UIImage *)highlightBgImg {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:highlightTtileColor forState:UIControlStateSelected];
    [button setTitleColor:highlightTtileColor forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:bgImg forState:UIControlStateNormal];
    [button setBackgroundImage:highlightBgImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:highlightBgImg forState:UIControlStateSelected];
    
    return button;
}


+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color highlightedColor:(UIColor *)highlightedColor fontSize:(CGFloat)size {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button setTitleColor:highlightedColor forState:UIControlStateSelected];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    return button;
}

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder borderStyle:(NSInteger)borderStyle textAlign:(NSInteger)alignStyle backgroundColor:(UIColor *)bgColor fontSize:(CGFloat)fontSize secure:(BOOL)secure {
    
    return [self textFieldWithPlaceholder:placeholder
                              borderStyle:borderStyle
                                textAlign:alignStyle
                             keyboardType:UIKeyboardTypeDefault
                          backgroundColor:bgColor
                                 fontSize:fontSize
                                   secure:secure];
}

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder borderStyle:(NSInteger)borderStyle textAlign:(NSInteger)alignStyle keyboardType:(NSInteger)keyboardType backgroundColor:(UIColor *)bgColor fontSize:(CGFloat)fontSize secure:(BOOL)secure {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.tintColor = VS_RGB(68, 68, 68); // 光标颜色
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = alignStyle;

    if (@available(iOS 13.0, *)) {
        
     textField.backgroundColor = [UIColor systemBackgroundColor];
        
    }else{
        
     textField.backgroundColor = VSDK_WHITE_COLOR;
    }
    textField.keyboardType = keyboardType;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (secure) {
        textField.secureTextEntry = YES;
    }
    textField.font = [UIFont systemFontOfSize:fontSize];
    
    textField.layer.cornerRadius = 15;
    textField.layer.masksToBounds = YES;
    
    return textField;
}

+(UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName{
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    
    imageView.image = [UIImage imageNamed:kSrcName(imageName)];
    
    return imageView;
}

+(UILabel *)labelWithFrame:(CGRect)frame Text:(NSString *)text Font:(CGFloat)font TextColor:(UIColor *)textColor NumberOfLines:(NSInteger)numberOfLines TextAlignment:(NSTextAlignment)textAlignment{
    
     UILabel * label = [[UILabel alloc]initWithFrame:frame];
     
     label.text =VSLocalString(text);
     label.font = [UIFont systemFontOfSize:font];
     label.textColor = textColor;
     label.numberOfLines = numberOfLines;
     label.textAlignment = textAlignment;
    
     return label;
}

+(UIButton *)vsdk_ButtonWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius ButtonType:(UIButtonType)buttonType Image:(NSString *)image Title:(NSString *)title TextAlignment:(NSTextAlignment)alignment TitleColor:(UIColor *)titleColor BGColor:(UIColor *)bgColor Font:(CGFloat)font BoldFont:(BOOL)ifBold Target:(id)target Action:(SEL)action{
    
    UIButton * button = [UIButton buttonWithType:buttonType];
    button.layer.cornerRadius = radius;
    button.frame = frame;
    [button setTitle:VSLocalString(title) forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (image!=nil) {
    [button setImage:[UIImage imageNamed:kSrcName(image)] forState:UIControlStateNormal];
    }
    
    button.titleLabel.textAlignment = alignment;
    button.titleLabel.font = ifBold?[UIFont boldSystemFontOfSize:font]: [UIFont systemFontOfSize:font];
    [button setBackgroundColor:bgColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
