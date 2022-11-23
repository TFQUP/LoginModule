//
//  EditerStr.h
//  TextTest
//
//  Created by admin on 7/13/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditerStr : NSObject
+(instancetype)shareInstance;
@property(nonatomic,copy) NSString *str1;
@property(nonatomic,copy) NSString *str11;
@property(nonatomic,copy) NSString *str2;
@property(nonatomic,copy) NSString *tipLabel1;
@property(nonatomic,copy) NSString * tipLabel2;
//@property(nonatomic,copy) NSString * tipLabel3;
@property(nonatomic,copy) NSString *str3;
@property(nonatomic,copy) NSString *str33;
@property(nonatomic,copy) NSString *str4;
@property(nonatomic,copy) NSString *str5;
@property(nonatomic,copy) NSString *str6;


- (NSString *)stepWithSelect:(BOOL)select WithStep:(int)step;
//-(NSString *)step2WithSelect:(BOOL)select;
- (NSString *)showAgreementWithStep:(int)step;
- (id)showTipStrWithStep:(int)step;
- (NSString *)showifHesitate:(BOOL)isShow;
-(BOOL)isKorean;
@end

NS_ASSUME_NONNULL_END
