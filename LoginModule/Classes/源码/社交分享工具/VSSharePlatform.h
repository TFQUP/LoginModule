//
//  VSSharePlatform.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <Foundation/Foundation.h>
#import "VSShareView.h"
NS_ASSUME_NONNULL_BEGIN

@interface VSSharePlatform : NSObject
@property (nonatomic,copy)NSString * iconStateNormal;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,assign)VSShareType sharePlatform;
@end

NS_ASSUME_NONNULL_END
