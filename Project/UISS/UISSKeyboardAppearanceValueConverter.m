//
//  UISSKeyboardAppearanceValueConverter.m
//  UISS
//
//  Created by Da Vin Ahn on 2015. 3. 11..
//  Copyright (c) 2015년 57things. All rights reserved.
//

#import "UISSKeyboardAppearanceValueConverter.h"

@implementation UISSKeyboardAppearanceValueConverter

- (NSString *)propertyNameSuffix;
{
    return @"keyboardAppearance";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithUnsignedInteger:UIKeyboardAppearanceDefault], @"default",
                                        [NSNumber numberWithUnsignedInteger:UIKeyboardAppearanceDark], @"dark",
                                        [NSNumber numberWithUnsignedInteger:UIKeyboardAppearanceLight], @"light",
                                        [NSNumber numberWithUnsignedInteger:UIKeyboardAppearanceAlert], @"alert",
                                        nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UIKeyboardAppearanceDefault", @"default",
                                       @"UIKeyboardAppearanceDark", @"dark",
                                       @"UIKeyboardAppearanceLight", @"light",
                                       @"UIKeyboardAppearanceAlert", @"alert",
                                       nil];
    }
    return self;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding];
}

@end
