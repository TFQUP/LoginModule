//
//  VSUserCenterView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSUserCenterView : UIView
-(void)vsdk_openUserCenterWithSelectIndex:(NSUInteger)index;
@property(nonatomic,assign)NSUInteger selectIndex;


@end

NS_ASSUME_NONNULL_END

