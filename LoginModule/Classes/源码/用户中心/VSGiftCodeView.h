//
//  VSGiftCodeView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,VSGiftBlockType) {

    VSGiftBlockClose = 0,//关闭
    VSGiftBlockCopy = 1,//拷贝
    
};

typedef void(^giftCodeViewBlock)(VSGiftBlockType type);
@interface VSGiftCodeView : VSBaseView
@property(strong,nonatomic)UIView * bgView;
@property (nonatomic, copy)giftCodeViewBlock  codeViewBlock;
-(void)giftCodeViewBlock:(giftCodeViewBlock)block;
@end

NS_ASSUME_NONNULL_END
