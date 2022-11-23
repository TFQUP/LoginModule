//
//  VSBindSecurityView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSBindSecurityViewBlockType) {
    
    VSBindSecurityViewBlockBack   = 0,
    VSBindSecurityViewBlockComfirm = 1,
    VSBindSecurityViewBlockSend = 2
    
};

typedef void(^VSBindSecurityBlock)(VSBindSecurityViewBlockType type);

@interface VSBindSecurityView : VSBaseView

@property(nonatomic,strong)UITextField * tfEmail;
@property(nonatomic,strong)UITextField * tfVertify;
@property(nonatomic, copy)VSBindSecurityBlock securityViewBlock;

- (void)bindSecurityViewBlock:(VSBindSecurityBlock) block;
@end


NS_ASSUME_NONNULL_END
