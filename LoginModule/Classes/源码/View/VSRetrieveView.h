//
//  VSRetrieveView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSBaseView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSRetriveViewBlockType) {
    VSRetriveViewBlockBack   = 0,
    VSRetriveViewBlockSend = 1,
    VSRetriveViewBlockComfirm = 2,
};

typedef void(^VSRetriveViewBlock)(VSRetriveViewBlockType type);
@interface VSRetrieveView : VSBaseView

@property(nonatomic,strong)UIButton * btnSend;
@property(nonatomic,strong)UITextField * tfEmail;
@property(nonatomic,strong)UILabel * labelHead;
@property(nonatomic,strong)UITextField * tfVertify;
@property (nonatomic, copy)VSRetriveViewBlock  retriveViewBlock;

- (void)retriveViewBlock:(VSRetriveViewBlock) block;

@end

NS_ASSUME_NONNULL_END
