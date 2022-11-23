//
//  VSToast.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VSToastViewBlockType){
    
    VSToastViewBlockSwitch = 0, //切换账号
    VSToastViewBlockEnterGame = 1,//进入游戏
};


@class VSToast;
typedef void(^VSToastViewBlock)(VSToastViewBlockType type);

@interface VSToast : UIView {
@private
    NSString        * __nullable _content;
    UIImage         * __nullable _image;
    
}
//内容
@property (nonatomic, copy) NSString * __nullable content;
//图片
@property (nonatomic, strong) UIImage *image;

@property(nonatomic,copy) VSToastViewBlock  toastBlock;


-(void)toastViewBlock:(VSToastViewBlock)block;

/**
 * @brief: 初始化
 * @paramcontent message -> 内容
 */
- (id)initWithContent:(NSString *)content;

/**
 * @brief: 初始化
 * @paramcontent: image   -> 图片
 * @paramcontent: message -> 内容
 */
- (id)initWithImage:(UIImage *)image content:(NSString *)content;

/**
 * @brief: 显示toast
 */
- (void)showToast;

- (void)hideToast;


@end

NS_ASSUME_NONNULL_END
