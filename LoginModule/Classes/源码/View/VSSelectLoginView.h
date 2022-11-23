//
//  VSSelectLoginView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, VSSelectLoginBlockType) {
    
    VSSelectLoginTypeAccount = 0, //输入密码登录
    VSSelectLoginTypeApple = 1, // apple
    VSSelectLoginTypeGuest = 2, // guest
    VSSelectLoginTypeFacebook = 3,//Facebook
    VSSelectLoginTypeGoogle =4,//google
    VSSelectLoginTypeTwitter = 5//推特

};

typedef void(^VSSelectLoginViewBlock)(VSSelectLoginBlockType type);

@interface VSSelectLoginView : VSBaseView
@property (nonatomic, copy) VSSelectLoginViewBlock selectBlock;

- (void)selectLoginViewBlock:(VSSelectLoginViewBlock) block;
@end

NS_ASSUME_NONNULL_END
