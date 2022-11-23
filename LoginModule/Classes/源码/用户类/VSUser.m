//
//  VSUser.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSUser.h"

@implementation VSUser

+ (id)userWithAccount:(NSString *)account passWord:(NSString *)password Date:(NSString *)date nickName:(NSString *)nickName Token:(NSString *)token{
    
    VSUser * user = [[VSUser alloc]initWithAccount:account passWord:password Date:date nickName:nickName Token:token];
     return user;
}

-(id)initWithAccount:(NSString *)account passWord:(NSString *)password Date:(NSString *)date nickName:(NSString *)nickname Token:(NSString *)token{
    if (self = [super init]) {
        self.account = account;
        self.password = password;
        self.dateStr = date;
        self.token = token;
        self.nickName = nickname;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.dateStr forKey:@"date"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.nickName forKey:@"nickname"];
    [aCoder encodeObject:self.token forKey:@"token"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.nickName  = [aDecoder decodeObjectForKey:@"nickname"];
        self.account  = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.dateStr = [aDecoder decodeObjectForKey:@"date"];
        self.token = [aDecoder decodeObjectForKey :@"token"];
    }
    return self;
}
@end
