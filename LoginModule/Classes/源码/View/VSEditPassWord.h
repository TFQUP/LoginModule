//
//  VSEditPassWord.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBaseView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSEditPswViewBlockType) {
    VSEditPswViewBlockBack   = 0,
    VSEditPswViewBlockComfirm = 1,

};
typedef void(^VSEditPassWordBlock)(VSEditPswViewBlockType type);
@interface VSEditPassWord : VSBaseView

@property (nonatomic ,strong)UITextField * tfNewPwd;
@property (nonatomic,strong)UIButton  * btnComfirm;
@property (nonatomic,strong)UILabel * labelAccount;

@property (nonatomic, copy)VSEditPassWordBlock pswViewBlock;

- (void)passwordViewBlock:(VSEditPassWordBlock) block;

@end

NS_ASSUME_NONNULL_END
