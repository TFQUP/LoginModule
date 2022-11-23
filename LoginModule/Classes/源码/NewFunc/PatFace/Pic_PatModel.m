//
//  PatModel.m
//  VVSDK
//
//  Created by admin on 6/23/22.
//

#import "Pic_PatModel.h"

@implementation Pic_PatModel
+(Pic_PatModel*)shareInstance{
    static Pic_PatModel *Instance = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        Instance = [[self alloc] init];
    });
    return Instance;
}
@end
