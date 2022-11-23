//
//  PatModel.h
//  VVSDK
//
//  Created by admin on 6/23/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Pic_PatModel : NSObject
@property(nonatomic,copy) NSString *open_server_time;
+(Pic_PatModel*)shareInstance;
@property (nonatomic,copy) NSString *img_id;
@property (nonatomic,copy) NSString *img_title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *btn_img;
@property (nonatomic,copy) NSString *jump_type;
@property (nonatomic,strong) UIImage *mainImg;
@property (nonatomic,strong) UIImage *btnImg;

@property (nonatomic,copy) NSString *jump_page;

@property (nonatomic,assign) BOOL up;
@property (nonatomic,assign) BOOL down;
@property (nonatomic,assign) BOOL range;
@end

NS_ASSUME_NONNULL_END
