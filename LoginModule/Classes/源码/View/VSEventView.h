//
//  VSEventView.h
//  VVSDK
//
//  Created by admin on 10/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSEventView : UIView
@property(nonatomic,strong)UIView * bgMaskView;
@property(nonatomic,strong)NSString * webUrl;
-(void)vsdk_eventViewShow;
@end

NS_ASSUME_NONNULL_END
