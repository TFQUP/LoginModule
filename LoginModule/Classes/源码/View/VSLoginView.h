//
//  VSLoginView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//  登录view


#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSLoginViewBlockType) {
    
    VSLoginViewBlockLogin = 0, //输入密码登录
    VSLoginViewBlockShowTerm = 1,//显示条款
    VSLoginViewBlockSeeLog = 2, // 差看日志


};

typedef void(^VSLoginViewBlock)(VSLoginViewBlockType type);
@interface VSLoginView : VSBaseView

@property (nonatomic,strong)UITextField * tfEmial;
@property (nonatomic,strong)UITextField * tfPwd;
@property (nonatomic,strong)UIButton * btnLogin;
@property (nonatomic,strong)NSMutableArray * userAccountData;
@property (nonatomic,strong)UITableView * tableAccount;
@property (nonatomic, copy) VSLoginViewBlock  loginCallback;
- (void)loginViewBlock:(VSLoginViewBlock) block;

@end

NS_ASSUME_NONNULL_END
