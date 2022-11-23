//
//  VSAskToBindView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSBaseView.h"
typedef NS_ENUM(NSUInteger,VSAskToBindBlockType) {
    
    VSAskToBindBlockTypeOK = 0,
    VSAskToBindBlockTypeNextTime = 1,
    
};
NS_ASSUME_NONNULL_BEGIN

typedef void(^ VSAskToBindBlock) (VSAskToBindBlockType type);

@interface VSAskToBindView : VSBaseView

@property (nonatomic,strong)UILabel * tipsLabel;

@property (nonatomic,strong)UILabel * desLabel;

@property (nonatomic ,strong)UIButton * retireBtn;

@property (nonatomic,strong)UIButton * retryBtn;

@property (nonatomic, copy)VSAskToBindBlock askBindBlock;

-(void)askToBindViewBlock:(VSAskToBindBlock)block;

@end

NS_ASSUME_NONNULL_END
