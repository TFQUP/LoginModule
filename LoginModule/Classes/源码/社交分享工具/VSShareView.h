//
//  VSShareView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import "VSShareModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,VSPlatformType){
    VSPlatformTypeFacebook = 0, // facebook 平台
    VSPlatformTypeTwitter = 1, //twitter
    VSPlatformTypeMore = 5,
};

typedef NS_ENUM(NSUInteger , VSShareType) {
    VSShareTypeFacebook   = 0,//分享到facebook
    VSShareTypeTwitter   = 1, //推特
    VSShareTypeMore = 5,//分享到更多平台
};

typedef NS_ENUM(NSUInteger , VSShareContentType) {
    VSShareContentTypeText    = 1,               //文本分享
    VSShareContentTypeImage   = 2,               //图片分享
    VSShareContentTypeLink    = 3,               //链接分享
    VSShareContentTypeVideo = 4,                //视频分享

};


@interface VSShareView : UIView


/**
 分享视图弹窗

 @param shareModel 分享的数据
 @param shareContentType 分享类型
 */
-(void)vsdk_showShareViewWithModel:(VSShareModel*)shareModel shareContentType:(VSShareContentType)shareContentType shareResult:(void (^)(BOOL ifSuceess, id resultInfo ,NSError * error))result;

@end

NS_ASSUME_NONNULL_END
