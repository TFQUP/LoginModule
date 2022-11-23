//
//  VSBadgeBtn.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSBadgeBtn : UIButton

/// 角标
@property (strong, nonatomic) UIImageView *badgeAlertImageView;
//角标背景图
@property(nonatomic)NSString * badgeImage;

/**
 *  角标的x值
 */
@property (nonatomic) CGFloat badgeOriginX;
/**
 *  角标的y值
 */
@property (nonatomic) CGFloat badgeOriginY;


@property (nonatomic) BOOL showBadge;


@end

NS_ASSUME_NONNULL_END
