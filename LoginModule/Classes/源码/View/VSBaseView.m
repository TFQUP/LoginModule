//
//  VSBaseView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBaseView.h"
#import "VSSDKDefine.h"
@implementation VSBaseView


-(instancetype)initWithFrame:(CGRect)frame{

 if (self = [super initWithFrame:frame]) {
     
       if (@available(iOS 13.0, *)) {
     
           [self setBackgroundColor:[UIColor systemBackgroundColor]];
           
          }else{
              
           [self setBackgroundColor:VSDK_WHITE_COLOR];
              
          }
 }

 return self;
    
}
 

-(void)showAlertWithMessage:(NSString *)meg{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:meg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [VS_RootVC presentViewController:alert animated:YES completion:^{
  
    }];
  
}

-(UIButton *)textFieldRightView {
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 25)];
    [rightBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_drop")] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_drop")] forState:UIControlStateSelected];
    return rightBtn;
}

- (UIButton *)emailTextFieldRightView {
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 16)];
    
    [rightBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_drop")] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 6, 4, 7)];
    [rightBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_up")] forState:UIControlStateSelected];
    
    return rightBtn;
}

-(UIButton *)pswTextFieldRightView{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 18)];
    [rightBtn setImage:[UIImage imageNamed: kSrcName(@"vsdk_password_unvisible")] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 6)];
    [rightBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_password_visible")] forState:UIControlStateSelected];

    return rightBtn;
    
}

// 显示密码之后 字符大小和长度不一致的问题
- (void)changeTextFieldSecure:(UITextField *)textField showBtn:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    textField.secureTextEntry = !textField.secureTextEntry;
    NSString *textStr = textField.text;
    textField.text = @"";
    textField.text = textStr;

}

// textView leftView
- (UIView *)textFieldLeftView:(NSString *)title image:(UIImage *)image{
    
    UIView *view = [[UIView alloc] init];
    // 文字
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = VS_RGB(255, 131, 51);
    leftLabel.text =VSLocalString(title);
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    CGSize maxSzie = CGSizeMake(CGFLOAT_MAX, 14);
    CGSize textMaxSize = CGSizeZero;
    
    textMaxSize = [leftLabel.text boundingRectWithSize:maxSzie options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    leftLabel.frame = CGRectMake(0, 0, ceil(textMaxSize.width), kTFHeight);
    [view addSubview:leftLabel];
 
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    if (image) {
        [view addSubview:imgView];
        imgView.frame = CGRectMake((100-24-10), (kTFHeight-24)*0.5, 24, 24);
        view.frame = CGRectMake(0, 0, 80, kTFHeight);
    } else {
        view.frame = CGRectMake(0, 0, textMaxSize.width, kTFHeight);
    }
    return view;
}


-(UIView *)textFieldLeftView:(UIImage*)image{

    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 18, 20)];
    UIView  * lineView = [[UIView alloc]initWithFrame:CGRectMake(VS_VIEW_RIGHT(imageView) + 15 , 8, 0.5, 25)];
    lineView.backgroundColor = VSDK_LIGHT_GRAY_COLOR;
    [leftView addSubview:lineView];
    imageView.image = image;
    [leftView addSubview:imageView];
   return leftView;
}


- (BOOL)checkInputAccount:(NSString *)acount
                 password:(NSString *)password{
    NSString *pattern = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$";
    BOOL isEmail = [VSDeviceHelper RegexWithString:acount pattern:pattern];
    
    if (password.length >=6&&acount.length>0&&isEmail) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkInputAccount:(NSString *)acount{
    
    NSString *pattern = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}+$";
    return  [VSDeviceHelper RegexWithString:acount pattern:pattern];
}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
