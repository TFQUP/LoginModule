//
//  VSSegmentView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSSegmentViewBlockType) {
    VSSegmentViewBlockLogin  = 0,
    VSSegmentViewBlockSignUp = 1,
};

typedef void(^VSSegmentViewBlock)(VSSegmentViewBlockType  type);

@interface VSSegmentView : VSBaseView

@property (nonatomic,copy)VSSegmentViewBlock  segmentViewBlock;
@property(nonatomic,assign)NSUInteger clickCount;
//切换为登录界面
-(void)login;

-(void)setSegmentViewBlock:(VSSegmentViewBlock)segmentViewBlock;
@end


NS_ASSUME_NONNULL_END
