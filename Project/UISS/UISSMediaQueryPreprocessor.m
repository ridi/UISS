//
//  UISSMediaQueryPreprocessor.m
//  UISS
//
//  Created by Da Vin Ahn on 2016. 6. 1..
//  Copyright © 2016년 57things. All rights reserved.
//

#import "UISSMediaQueryPreprocessor.h"
#import <sys/utsname.h>

#if TARGET_IPHONE_SIMULATOR
@interface UIDevice()
- (long long)_graphicsQuality;
@end
#endif

@interface UISSMediaQueryPreprocessor ()

@property (nonatomic, copy, readonly) NSRegularExpression *queryRegex;

@end


@implementation UISSMediaQueryPreprocessor

- (id)init {
    self = [super init];
    if (self) {
        _queryRegex = [[NSRegularExpression alloc] initWithPattern:@"@media\\s{0,}\\(([\\w\\s-]+(:|)[\\w\\s].*)\\)" options:0 error:nil];
    }
    return self;
}

- (NSString *)prefix {
    return @"@media";
}

- (id)preprocessValueIfNecessary:(id)value userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [self preprocess:value userInterfaceIdiom:userInterfaceIdiom];
    } else {
        return value;
    }
}

- (NSDictionary *)preprocess:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    NSMutableDictionary *preprocessed = [NSMutableDictionary dictionary];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([key hasPrefix:self.prefix]) {
            if ([self evaluateMediaQuery:key userInterfaceIdiom:userInterfaceIdiom]) {
                [preprocessed setObject:[self preprocessValueIfNecessary:object userInterfaceIdiom:userInterfaceIdiom] forKey:key];
            }
        } else {
            [preprocessed setObject:[self preprocessValueIfNecessary:object userInterfaceIdiom:userInterfaceIdiom] forKey:key];
        }
    }];
    
    return preprocessed;
}

- (BOOL)evaluateMediaQuery:(NSString *)key userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom
{
    for (NSTextCheckingResult *result in [self.queryRegex matchesInString:key options:0 range:NSMakeRange(0, key.length)]) {
        if (result.numberOfRanges > 1) {
            NSString *query = [key substringWithRange:[result rangeAtIndex:1]];
            NSArray *components = [query componentsSeparatedByString:@","];
            for (NSString *component in components) {
                NSArray *attr = [component componentsSeparatedByString:@":"];
                if (attr.count > 1) {
                    NSString *name = [[attr[0] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString *value = [attr[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([name isEqualToString:@"os"] && ![self evaluateOSVersion:value]) {
                        return NO;
                    } else if ([name isEqualToString:@"device"] && userInterfaceIdiom != [self userInterfaceIdiomFromString:value]) {
                        return NO;
                    }
                } else if (attr.count == 1) {
                    NSString *name = [[attr[0] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([name isEqualToString:@"poor"] && ![self evaluatePoorGraphics]) {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

- (BOOL)evaluateOSVersion:(NSString *)value
{
    NSInteger currentVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
    NSArray *components = [value componentsSeparatedByString:@" "];
    if (components.count != 2) {
        return NO;
    }
    
    NSString *cd = components[0];
    NSInteger version = [components[1] integerValue];
    if (([cd isEqualToString:@">"] && currentVersion > version) ||
        ([cd isEqualToString:@">="] && currentVersion >= version) ||
        ([cd isEqualToString:@"<"] && currentVersion < version) ||
        ([cd isEqualToString:@"<="] && currentVersion <= version) ||
        ([cd isEqualToString:@"="] && currentVersion == version)) {
        return YES;
    } else {
        return NO;
    }
}

- (UIUserInterfaceIdiom)userInterfaceIdiomFromString:(NSString *)string
{
    NSString *lowercaseString = [string lowercaseString];
    if ([@"phone" isEqual:lowercaseString] || [@"iphone" isEqual:lowercaseString]) {
        return UIUserInterfaceIdiomPhone;
    } else if ([@"pad" isEqual:lowercaseString] || [@"ipad" isEqual:lowercaseString]) {
        return UIUserInterfaceIdiomPad;
    } else {
        return NSNotFound;
    }
}

- (BOOL)evaluatePoorGraphics {
#if TARGET_IPHONE_SIMULATOR
    if ([[UIDevice currentDevice] _graphicsQuality] != 100) {
        return YES;
    }
#endif
    
    if (UIAccessibilityIsReduceTransparencyEnabled()) {
        return YES;
    }
    
    struct utsname u;
    uname(&u);
    NSString *modelName = [NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding];
    NSArray *poorModels = @[
        @"iPhone1,",
        @"iPhone2,",
        @"iPhone3,",
        @"iPod1,",
        @"iPod2,",
        @"iPod3,",
        @"iPod4,",
        @"iPad1,",
        @"iPad2,",
        @"iPad3,",
    ];
    for (NSString *prefix in poorModels) {
        if ([modelName hasPrefix:prefix]) {
            return YES;
        }
    }
    
    return NO;
}

@end
