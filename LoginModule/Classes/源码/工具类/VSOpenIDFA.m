//
//  VSOpenIDFA.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSOpenIDFA.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#import <UIKit/UIKit.h>
@implementation VSOpenIDFA

+ (NSString*) sameDayVSOpenIDFA{
    
    return [[VSOpenIDFA threeDaysVSOpenIDFAArray] objectAtIndex:0];
}

+ (NSArray*) threeDaysVSOpenIDFAArray {
    
    // The following list represents a rather large array of ids used to detect
    // the presence of a number of apps available on the device. The apps on this
    // list have been handpicked by Appsfire AppGenome engine; they each carry
    // a statistically significant weight to define and differentiate a user from
    // another. For the purpose of obfuscation inside the lib, we only used apps
    // with Facebook-related URLHanders typically starting with the string "fb"
    // then followed by a numerical string.
    //
    // RATIONALE: an "appmap" profile may vary over time, however, the likeness that it
    // evolves between two tracking events over a large proportion of the user
    // base is low.
    //
    // NOTICE: this list is the property of Appsfire and may not be extracted from
    // the context of VSOpenIDFA which is governed by a Creative Commons (No Derivatives)
    //
    NSArray* base = @[ @101015295179ll, @102443183283204ll, @105130332854716ll, @110633906966ll, @111774748922919ll, @112953085413703ll, @113174082133029ll, @113246946530ll, @114870218560647ll, @115829135094686ll, @115862191798713ll, @118506164848956ll, @118589468194837ll, @118881298142408ll, @120176898077068ll, @121848807893603ll, @123448314320ll, @123591657714831ll, @124024574287414ll, @127449357267488ll, @127995567256931ll, @132363533491609ll, @134841016914ll, @138326442889677ll, @138713932872514ll, @146348772076164ll, @147364571964693ll, @147712241956950ll, @148327618516767ll, @152777738124418ll, @154615291248069ll, @156017694504926ll, @158761204309396ll, @159248674166087ll, @160888540611569ll, @161500167252219ll, @161599933913761ll, @162729813767876ll, @165482230209033ll, @176151905794941ll, @177821765590225ll, @178508429994ll, @192454074134796ll, @194714260574159ll, @208559595824260ll, @209864595695358ll, @210068525731476ll, @239823722730183ll, @246290217488ll, @255472420580ll, @267160383314960ll, @292065597989ll, @99197768694ll, @342234513642ll, @349724985922ll, @99554596360ll, @40343401983ll, @500407959994978ll, @52216716219ll, @90376669494ll];
    

    // Playing with the prefix some more for the purpose of obfuscation
    //
    NSMutableString* _s_appmap = [NSMutableString stringWithString:@""];
    NSString* _s = @"/";
    NSString* _c = @":";
    NSString* _b = @"b";
    NSString* _f = @"f";
    
    // Computing the "appmap" profile string for this user
    // STRENGTH: potential of 2^61 distinct combinations
    //
    [_s_appmap appendString:[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",_f,_b,_c,_s,_s]]]?@"|":@"-"];
    
    for (id baseid in base) {
        
        [_s_appmap appendString:[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@",_f,_b,[baseid stringValue],_c,_s,_s]]]?@"|":@"-"];
    }
    
    size_t size;
    struct timeval boottime;
    
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size = sizeof(boottime);
    NSString* _s_bt = @"";
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        _s_bt =[NSString stringWithFormat:@"%lu",boottime.tv_sec];
        _s_bt = [_s_bt substringToIndex:[_s_bt length]-4];
    }
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *_s_machine = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    // Collecting the device "model" identifier, for completition
    //
    // STRENGTH: adds little, helps in case of simulator
    //
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.model", model, &size, NULL, 0);
    NSString *_s_model = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);

    // Collecting the locale country code
    //
    // STRENGTH: its complicated, but at least 80 combinations not evenly distributed!
    // Check CLDR release 24 to know more: http://cldr.unicode.org/index/downloads/cldr-24
    //
    NSString *_s_ccode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    // Collecting an ordered array of preferred languages
    //
    // RATIONALE: this is an ordered list of preferred languages, theoretically speaking
    // Most people only configure one and thefore the rest of the list remains unchanged
    // However, polyglots will impact this list deeply.
    // I've chosen to only mark up to 8 languages. Infiniglots don't pass the Turing test.
    //
    // STRENGTH: something like 8! but not evenly distributed.
    //
    NSArray* preferredLang = [NSLocale preferredLanguages];
    NSString* _s_langs;
    if (preferredLang == nil || ![preferredLang isKindOfClass:[NSArray class]] || [ preferredLang count ] == 0)
        _s_langs = @"en";
    else
        _s_langs =  [[preferredLang subarrayWithRange:NSMakeRange(0, MIN(8,[preferredLang count]))] componentsJoinedByString:@""];
    
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSString *_s_disk = [[fattributes objectForKey:NSFileSystemSize] stringValue];
    NSString* _s_osv = [[UIDevice currentDevice] systemVersion];
    NSString* _s_tmz = [[NSTimeZone systemTimeZone] name];

 
    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateFormat:@"yyMMdd" ];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *hourShift = [[NSDateComponents alloc] init];
    [hourShift setHour:-4];
    NSDate *currentDay= [calendar dateByAddingComponents:hourShift toDate:[NSDate date] options:0];
    NSDateComponents *dayShift = [[NSDateComponents alloc] init];
    [dayShift setDay:1];
    
    // Creating array of 3 VSOpenIDFAs
    //
    NSMutableArray* VSOpenIDFAs = [NSMutableArray arrayWithCapacity:3];
    for (int j=0; j<3; j++) {
        
    
        NSString* _s_day = [dateFormatter stringFromDate:currentDay];
        NSString* fingerprint = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
                                 _s_bt,               _s_disk,
                                 _s_machine,          _s_model,
                                 _s_osv,              _s_ccode,
                                 _s_langs,            _s_appmap,
                                 _s_tmz,              _s_day];
        
        const char* str = [fingerprint UTF8String];
        
        unsigned char result[CC_SHA256_DIGEST_LENGTH];
        
        CC_SHA256(str, (CC_LONG)strlen(str), result);
        
        NSMutableString *hash = [NSMutableString stringWithCapacity:36];
        for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i+=2)
        {
            if (i==8 || i==12 || i==16 || i==20)
                [hash appendString:@"-"];
            [hash appendFormat:@"%02X",result[i]];
        }
        
        [VSOpenIDFAs addObject:hash];
    
        currentDay = [calendar dateByAddingComponents:dayShift toDate:currentDay options:0];
    }
  
    return VSOpenIDFAs;
}

@end
