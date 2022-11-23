//
//  VSSeeLogView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSSeeLogViewBlockType) {
    
    VSSeeLogBlockTypeBack   = 0,
    VSSeeLogBlockTypeCopy = 1
};

typedef void(^VSSeeLogViewBlock)(VSSeeLogViewBlockType type);

@interface VSSeeLogView : VSBaseView
@property(nonatomic,strong)UIButton * btnBack;
@property (nonatomic,strong)UILabel * labelHead;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UIButton * btnCopy; //拷贝文本按钮
@property(assign,nonatomic)BOOL ifFeekback;//是否反馈问题
@property (nonatomic, copy) VSSeeLogViewBlock  seeLogViewBlock;

- (void)SeeLogViewBlock:(VSSeeLogViewBlock) block;
@end

NS_ASSUME_NONNULL_END
