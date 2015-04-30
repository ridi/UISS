//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSImageValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"
#import "UISSColorValueConverter.h"
#import "UISSImageRenderingModeConverter.h"
#import "UISSArgument.h"
#import "UIImage+UISS.h"
#import "UIColor+UISS.h"

@interface UISSImageValueConverter ()

@property (nonatomic, strong) UISSEdgeInsetsValueConverter *edgeInsetsValueConverter;
@property (nonatomic, strong) UISSImageRenderingModeConverter *imageRenderingModeConverter;

@end

@implementation UISSImageValueConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.edgeInsetsValueConverter = [[UISSEdgeInsetsValueConverter alloc] init];
        self.imageRenderingModeConverter = [[UISSImageRenderingModeConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type hasPrefix:@"@"] && [[argument.name lowercaseString] hasSuffix:@"image"];
}

- (id)edgeInsetsValueFromImageArray:(NSArray *)array
{
    id edgeInsetsValue;
    
    NSMutableArray *values = [NSMutableArray array];
    for (id value in array) {
        if ([value isKindOfClass:[NSArray class]]) {
            edgeInsetsValue = value;
            break;
        } else if ([value isKindOfClass:[NSValue class]]) {
            [values addObject:value];
        }
    }
    
    if (edgeInsetsValue == nil && values.count > 3) {
        edgeInsetsValue = [values subarrayWithRange:NSMakeRange(0, 4)];
    }

    return edgeInsetsValue;
}

- (id)alphaValueFromImageArray:(NSArray *)array
{
    NSMutableArray *values = [NSMutableArray array];
    for (id value in array) {
        if ([value isKindOfClass:[NSValue class]]) {
            [values addObject:value];
        }
    }
    
    if (values.count == 1 || values.count == 5) {
        return [values lastObject];
    } else {
        return nil;
    }
}

- (NSString *)modeValueFromImageArray:(NSArray *)array
{
    for (NSInteger i = 1; i < array.count; i++) {
        id value = array[i];
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        }
    }
    return nil;
}

- (BOOL)convertValue:(id)value imageHandler:(void (^)(UIImage *))imageHandler codeHandler:(void (^)(NSString *))codeHandler;
{
    if ([value isKindOfClass:[NSString class]]) {
        UISSColorValueConverter *colorValueConverter = [[UISSColorValueConverter alloc] init];
        colorValueConverter.shouldProcessPatternImageConvert = NO;
        
        if (imageHandler) {
            UIImage *image = [UIImage imageNamed:value];
            if (image == nil) {
                UIColor *color = [colorValueConverter convertValue:value];
                if (color != nil) {
                    image = [UIImage imageWithColor:color];
                }
            }
            imageHandler(image);
        }

        if (codeHandler) {
            UIImage *image = [UIImage imageNamed:value];
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
                            id alphaValue = [self alphaValueFromImageArray:array];
                            
                            if (alphaValue) {
                                image = [image imageByApplyingAlpha:[alphaValue floatValue]];
                            }
                            
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsConverted  = [self.edgeInsetsValueConverter convertValue:edgeInsetsValue];
                            
                            if (edgeInsetsValue) {
                                UIEdgeInsets edgeInsets = [edgeInsetsConverted UIEdgeInsetsValue];
                                image = [image resizableImageWithCapInsets:edgeInsets];
                            }
                            
                            NSString *modeValue = [self modeValueFromImageArray:array];
                            if (modeValue) {
                                image = [image imageWithRenderingMode:[[self.imageRenderingModeConverter convertValue:modeValue] integerValue]];
                            }

                            imageHandler(image);
                        }
                    }
                }
                codeHandler:^(NSString *code) {
                    if (codeHandler) {
                        if (code && array.count > 1) {
                            id alphaValue = [self alphaValueFromImageArray:array];
                            
                            if (alphaValue) {
                                code = [code stringByReplacingCharactersInRange:[code rangeOfString:@"alpha:.*]" options:NSRegularExpressionSearch]
                                                                     withString:[NSString stringWithFormat:@"alpha:%lf]", [alphaValue floatValue]]];
                            }
                            
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsCode = [self.edgeInsetsValueConverter generateCodeForValue:edgeInsetsValue];

                            if (edgeInsetsValue) {
                                code = [NSString stringWithFormat:@"[%@ resizableImageWithCapInsets:%@]", code, edgeInsetsCode];
                            }
                            
                            NSString *modeValue = [self modeValueFromImageArray:array];
                            if (modeValue) {
                                code = [NSString stringWithFormat:@"[%@ imageWithRenderingMode:%@]", code, [self.imageRenderingModeConverter generateCodeForValue:modeValue]];
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
