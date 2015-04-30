//
//  UISSImageRenderingModeConverter.m
//  UISS
//
//  Created by Da Vin Ahn on 2015. 4. 30..
//  Copyright (c) 2015년 57things. All rights reserved.
//

#import "UISSImageRenderingModeConverter.h"

@implementation UISSImageRenderingModeConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInteger:UIImageRenderingModeAutomatic], @"automatic",
                                        [NSNumber numberWithInteger:UIImageRenderingModeAlwaysOriginal], @"original",
                                        [NSNumber numberWithInteger:UIImageRenderingModeAlwaysTemplate], @"template",
                                        nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UIImageRenderingModeAutomatic", @"automatic",
                                       @"UIImageRenderingModeAlwaysOriginal", @"original",
                                       @"UIImageRenderingModeAlwaysTemplate", @"template",
                                       nil];
    }
    return self;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding];
}

@end
