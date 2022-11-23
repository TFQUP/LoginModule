//
//  SDKENTRANCE.h
//  VVSDK
//
//  Created by admin on 3/31/22.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^CHECKBLOCK)(void);
typedef void (^CHECKGAMEBLOCK)(void);
NS_ASSUME_NONNULL_BEGIN

@interface SDKENTRANCE : NSObject
@property(nonatomic,strong) NSDictionary *checkDic;
@property(nonatomic,assign) BOOL isError;
+(SDKENTRANCE*)shareInstance;
+ (void)showViewController:(UIViewController *)vc;
+ (void)resignWindow;
@property (nonatomic,copy) CHECKBLOCK checkBlock;
@property (nonatomic,copy) CHECKGAMEBLOCK checkGameBlock;
@end

NS_ASSUME_NONNULL_END
