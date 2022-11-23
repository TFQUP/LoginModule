//
//  Level_PatModel.h
//  VVSDK
//
//  Created by admin on 6/23/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Level_PatModel : NSObject
@property (nonatomic,copy) NSString *img_id;
@property (nonatomic,copy) NSString *img_title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *btn_img;
@property (nonatomic,copy) NSString *jump_type;
@property (nonatomic,strong) UIImage *mainImg;
@property (nonatomic,strong) UIImage *btnImg;
@property (nonatomic,copy) NSString *level_type;
@property (nonatomic,assign) NSInteger start_level;
@property (nonatomic,assign) NSInteger end_level;

@property (nonatomic,copy) NSString *jump_page;
@end

NS_ASSUME_NONNULL_END
