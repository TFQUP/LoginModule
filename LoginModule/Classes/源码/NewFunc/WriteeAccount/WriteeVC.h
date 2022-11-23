//
//  WriteeVC.h
//  VVSDK
//
//  Created by admin on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "ConsumeView.h"
#import "VerifyView.h"
#import "AgreementV.h"
NS_ASSUME_NONNULL_BEGIN

@interface WriteeVC : UIViewController
@property(nonatomic,strong)ConsumeView *consumV;
@property(nonatomic,strong)VerifyView *verifyV;
@property(nonatomic,strong)AgreementV *agrV;
@property (nonatomic,copy) void(^closeBlock)(void);
@end

NS_ASSUME_NONNULL_END
