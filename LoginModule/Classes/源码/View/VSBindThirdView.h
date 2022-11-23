//
//  VSBindThirdView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBaseView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSBindThirdViewBlockType) {
     
    VSBindThirdViewBlockBind = 0,
    VSBindThirdViewBlockContinue = 1,
    VSBindThirdViewBlockShowTerm = 2
};

typedef void(^VSBindThirdViewBlock)(VSBindThirdViewBlockType type);
@interface VSBindThirdView : VSBaseView

@property (nonatomic,strong)UITextField * tfEmail;
//密码文本款
@property (nonatomic,strong)UITextField * tfPwd;

@property (nonatomic,strong)UIButton * btnBind;

@property (nonatomic,strong)UIButton * btnComfirm;

@property (nonatomic, copy)VSBindThirdViewBlock  bindViewBlock;

- (void)loginViewBlock:(VSBindThirdViewBlock) block;

@end

NS_ASSUME_NONNULL_END
