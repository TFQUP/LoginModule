//
//  VSNotificationView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
@import UserNotifications;
NS_ASSUME_NONNULL_BEGIN

@interface VSNotificationView : UIView
@property(nonatomic,strong)UILabel * labelContent;
@property(nonatomic,strong)UILabel * labelTitleDes;
@property(nonatomic,strong)UIButton * btnComfirm;
@property(nonatomic,strong)UIButton * btnShowMore;
@property(nonatomic,strong)UNNotification * notification;
@property(assign,nonatomic)CGFloat showTextHeight;
@property(assign,nonatomic)BOOL importantShow;

-(void)showUlImportantAlertViewWithNofi:(UNNotification *)nofi;
-(void)hideUlImportantAlertView;
@end

NS_ASSUME_NONNULL_END
