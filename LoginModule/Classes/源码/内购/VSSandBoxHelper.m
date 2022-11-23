//
//  VSSandBoxHelper.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSandBoxHelper.h"

@implementation VSSandBoxHelper

+ (NSString *)homePath {
    return NSHomeDirectory();
}

+ (NSString *)appPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}
//缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)libCachePath {
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath {
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)iapReceiptPath {
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/EACEF35FE363A75A"];
    [self hasLive:path];
    return path;
}

+ (NSString *)subReceiptPath{
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/IGH5G40G5S7F2L1H6"];
       [self hasLive:path];
       return path;
}

+ (BOOL)hasLive:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

+(NSString *)SuccessIapPath{
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/SuccessReceiptPath"];
    
    [self hasLive:path];
    
    
    return path;
    
}


+(NSString *)SuccessSubPath{
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/SubSuccessReceiptPath"];
      
      [self hasLive:path];
      
      
      return path;
}


+(NSString *)promoPaymentPath{
   
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/promoPaymentPath"];
    
    [self hasLive:path];
    
    
    return path;
    
}


+(NSString *)tempOrderPath{
  
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/tempOrderPath"];
    
    [self hasLive:path];
   
    return path;
    
}

+(NSString *)rectiptSignPath{
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/rectiptSignPath"];
    
    [self hasLive:path];
    
    return path;
    
}

+(NSString *)SubscriptionFlagPath{
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/SubscriptionFlagPath"];
    
    [self hasLive:path];
    
    return path;
    
}

+(NSString *)crashLogInfo{
    
    NSString * path = [[self libPrefPath]stringByAppendingFormat:@"/crashLogInfoPath"];
    [self hasLive:path];
    
    return path;
}


+(NSString *)socialInfoPath{
    
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/socialInfoPath"];
    
    [self hasLive:path];
    
    return path;
}

+(NSString *)countryAreaCodePath{
    
    
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/countryAreaCodes"];
    
    [self hasLive:path];
    
    return path;
}


+(NSString *)DPBagInfoPath{
    
    NSString * path = [[self libPrefPath]stringByAppendingFormat:@"/dpbagInfoPath"];
    [self hasLive:path];
    
    return path;
}

@end
