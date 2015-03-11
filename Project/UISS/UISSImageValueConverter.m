//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSImageValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"
#import "UISSColorValueConverter.h"
#import "UISSArgument.h"
#import "UIImage+UISS.h"
#import "UIColor+UISS.h"

@interface UISSImageValueConverter ()

@property (nonatomic, strong) UISSEdgeInsetsValueConverter *edgeInsetsValueConverter;

@end

@implementation UISSImageValueConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.edgeInsetsValueConverter = [[UISSEdgeInsetsValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type hasPrefix:@"@"] && [[argument.name lowercaseString] hasSuffix:@"image"];
}

- (id)edgeInsetsValueFromImageArray:(NSArray *)array;
{
    id edgeInsetsValue;

    if (array.count == 2) {
        edgeInsetsValue = [array objectAtIndex:1];
    } else {
        edgeInsetsValue = [array subarrayWithRange:NSMakeRange(1, array.count - 1)];
    }

    return edgeInsetsValue;
}

- (BOOL)convertValue:(id)value imageHandler:(void (^)(UIImage *))imageHandler codeHandler:(void (^)(NSString *))codeHandler;
{
    if ([value isKindOfClass:[NSString class]]) {
        UISSColorValueConverter *colorValueConverter = [[UISSColorValueConverter alloc] init];
        colorValueConverter.shouldProcessPatternImageConvert = NO;
        
        UIImage *image = [UIImage imageNamed:value];
        
        if (imageHandler) {
            if (image == nil) {
                UIColor *color = [colorValueConverter convertValue:value];
                if (color != nil) {
                    image = [UIImage imageWithColor:color];
                }
            }
            imageHandler(image);
        }

        if (codeHandler) {
            NSString *code = [NSString stringWithFormat:@"[UIImage imageNamed:@\"%@\"]", value];
            if (image == nil) {
                UIColor *color = [colorValueConverter convertValue:value];
                if (color != nil) {
                    NSArray *colorComponent = [color colorComponent];
                    code = [NSString stringWithFormat:@"[UIImage imageWithRed:%lf green:%lf blue:%lf alpha:%lf]",
                            [colorComponent[0] floatValue], [colorComponent[1] floatValue], [colorComponent[2] floatValue], [colorComponent[3] floatValue]];
                }
            }
            codeHandler(code);
        }

        return YES;
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) value;

        return [self convertValue:[array objectAtIndex:0]
                imageHandler:^(UIImage *image) {
                    if (imageHandler) {
                        if (image && array.count > 1) {
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsConverted  = [self.edgeInsetsValueConverter convertValue:edgeInsetsValue];

                            if (edgeInsetsConverted) {
                                UIEdgeInsets edgeInsets = [edgeInsetsConverted UIEdgeInsetsValue];
                                image = [image resizableImageWithCapInsets:edgeInsets];
                            }

                            imageHandler(image);
                        }
                    }
                }
                codeHandler:^(NSString *code) {
                    if (codeHandler) {
                        if (code && array.count > 1) {
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsCode = [self.edgeInsetsValueConverter generateCodeForValue:edgeInsetsValue];

                            if (edgeInsetsCode) {
                                code = [NSString stringWithFormat:@"[%@ resizableImageWithCapInsets:%@]", code,
                                                                  edgeInsetsCode];
                            }

                            codeHandler(code);
                        }
                    }
                }];
    } else if ([value isKindOfClass:[NSNull class]]) {
        if (imageHandler) {
            imageHandler(nil);
        }
        if (codeHandler) {
            codeHandler(@"nil");
        }
        
        return YES;
    }

    return NO;
}

- (id)convertValue:(id)value;
{
    __block UIImage *result = nil;

    [self convertValue:value
                  imageHandler:^(UIImage *image) {
                      result = image;
                  }
                   codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForValue:(id)value
{
    __block NSString *result = nil;

    [self convertValue:value imageHandler:nil codeHandler:^(NSString *code) {
        result = code;
    }];

    return result;
}

@end
