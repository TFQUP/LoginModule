//
//  ConsumeView.h
//  TextTest
//
//  Created by admin on 7/13/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ConsumeView : UIView
@property(nonatomic,strong) UITextView *textV;
@property(nonatomic,strong) UITextField *textFild;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UIView *mainV;
@property(nonatomic,assign) int type;

@property(nonatomic,copy) void(^sureBlock)(int type);
@property(nonatomic,copy) void(^cancelBlock)(void);
-(void)setUI;
@end

NS_ASSUME_NONNULL_END
