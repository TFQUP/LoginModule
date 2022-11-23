//
//  VSGameExpired.h
//  VVSDK
//
//  Created by admin on 8/17/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSGameExpired : UIView
-(void)vsdk_gameStopOperation;
@property(copy,nonatomic)NSString * btnText;
@property(assign,nonatomic)BOOL ifLogin;
@end

NS_ASSUME_NONNULL_END
