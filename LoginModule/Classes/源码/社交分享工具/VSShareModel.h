//
//  VSShareModel.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSShareModel : NSObject
//分享标题 只分享文本是也用这个字段
@property (nonatomic,copy)NSString * title;
//描述内容
@property (nonatomic,copy)NSString * descr;
//缩略图
@property (nonatomic,strong)id thumbImage;
//网页链接
@property (nonatomic,copy)NSString * url;
//视频链接
@property (nonatomic,copy)NSString * videoUrl;
@end

NS_ASSUME_NONNULL_END
