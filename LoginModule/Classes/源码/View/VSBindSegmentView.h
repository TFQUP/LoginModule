//
//  VSBindSegmentView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//


#import "VSBaseView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSBindSegmentViewBlockType) {
   
    VSBindSegmentViewBlockBack = 0,
   
};
typedef void(^VSBindSegmentViewBlock)(VSBindSegmentViewBlockType  type);

@interface VSBindSegmentView : VSBaseView

@property (nonatomic,copy)VSBindSegmentViewBlock segmentViewBlock;
-(void)setSegmentViewBlock:(VSBindSegmentViewBlock)segmentViewBlock;
@end

NS_ASSUME_NONNULL_END
