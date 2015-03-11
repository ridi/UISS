//
//  UIImage+UISS.m
//  UISS
//
//  Created by Da Vin Ahn on 2015. 3. 11..
//  Copyright (c) 2015년 57things. All rights reserved.
//

#import "UIImage+UISS.h"

@implementation UIImage (UISS)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return [UIImage imageWithColor:color];
}

@end
