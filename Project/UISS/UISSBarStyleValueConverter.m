//
//  UISSBarStyleValueConverter.m
//  UISS
//
//  Created by Da Vin Ahn on 2015. 3. 12..
//  Copyright (c) 2015년 57things. All rights reserved.
//

#import "UISSBarStyleValueConverter.h"

@implementation UISSBarStyleValueConverter

- (NSString *)propertyNameSuffix;
{
    return @"barStyle";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInteger:UIBarStyleDefault], @"default",
                                        [NSNumber numberWithInteger:UIBarStyleBlack], @"black",
                                        nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UIBarStyleDefault", @"default",
                                       @"UIBarStyleBlack", @"black",
                                       nil];
    }
    return self;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding];
}

@end
