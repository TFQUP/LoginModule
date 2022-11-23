//
//  VerifyView.h
//  TextTest
//
//  Created by admin on 7/12/22.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Step1,
    Step2,
    Step3,
} DeleteStep;

NS_ASSUME_NONNULL_BEGIN

@interface VerifyView : UIView
@property(nonatomic,strong) UITextView *agreeTextV;
@property(nonatomic,strong) UIView *bottomV;
@property(nonatomic,strong) UIView *containV;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UIImageView *selectImgV;

@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UILabel *clickTextLabel;
//@property(nonatomic,strong) UILabel *endLabel;

@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UIView *mainV;

@property(nonatomic,strong) UIView *topV;
@property(nonatomic,strong) UILabel *topLabel;
@property(nonatomic,strong) UIButton *topCloseBtn;

@property(nonatomic,strong) UIButton *coolingBtn;
@property(nonatomic,strong) UIButton *noCoolingBtn;

@property(nonatomic,assign) DeleteStep *deleteType;

@property(nonatomic,assign) int step;

@property(nonatomic,copy) void(^clickBlock)(BOOL isAgree);
@property(nonatomic,copy) void(^vcloseBlock)(void);

@property(nonatomic,copy) void(^labelClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
