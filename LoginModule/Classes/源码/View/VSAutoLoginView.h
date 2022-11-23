//
//  VSAutoLoginView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//


#import "VSBaseView.h"
#import "VSSDKDefine.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, VSBindAccountBlockType) {
    
    VSBindAccountBlockPlatform = 0,//账号绑定
    VSBindAccountBlockFacebook  = 1,// fb绑定
    VSBindAccountBlockGoogle = 2, // 谷歌绑定
    VSBindAccountBlockSwitch = 3,//返回登录界面
    VSBindAccountBlockContinue = 4,
    VSBindAccountBlockTwitter = 5,//twitter 绑定
    VSBindAccountBlockApple = 6,//苹果绑定
};

typedef void(^VSAutoLoginViewBlock)(VSBindAccountBlockType type);

@interface VSAutoLoginView : VSBaseView

@property(nonatomic,strong)UIImageView * imageAvatar;
@property(nonatomic,strong)UILabel * lbWelcome;
@property(nonatomic,strong)UILabel * lbPlayerName;
@property(nonatomic,strong)UIView * viewConbine;
@property(nonatomic,strong)UILabel * labelDes;
@property(nonatomic,strong)UIButton * btnContinue;
@property(nonatomic,strong)VSSwitchBtn * btnSwitch;

@property(nonatomic,copy)VSAutoLoginViewBlock  bindViewBlock;

- (void)BindViewBlock:(VSAutoLoginViewBlock) block;

@end

NS_ASSUME_NONNULL_END
