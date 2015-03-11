//
//  UIColor+UISS.m
//  UISS
//
//  Created by Da Vin Ahn on 2015. 3. 11..
//  Copyright (c) 2015년 57things. All rights reserved.
//

#import "UIColor+UISS.h"

@implementation UIColor (UISS)

- (NSArray *)colorComponent {
    CGFloat red = 0, blue = 0, green = 0, alpha = 0;
    
    if (![self getRed:&red green:&blue blue:&green alpha:&alpha]) {
        CGFloat white = 0;
        if ([self getWhite:&white alpha:&alpha]) {
            if (red > 0) {
                red = white;
            }
            if (green > 0) {
                green = white;
            }
            if (blue > 0) {
                blue = white;
            }
        } else {
            red = 0;
            green = 0;
            blue = 0;
        }
    }
    
    return @[@(red), @(green), @(blue), @(alpha)];
}

@end
