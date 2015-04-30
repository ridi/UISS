//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSImageValueConverter.h"

@interface UISSImageValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSImageValueConverter *converter;

@end

@implementation UISSImageValueConverterTests

- (void)testNullImage {
    UIImage *image = [self.converter convertValue:[NSNull null]];
    STAssertNil(image, nil);

    NSString *code = [self.converter generateCodeForValue:[NSNull null]];
    STAssertEqualObjects(code, @"nil", nil);
}

- (void)testSimleImageAsString {
    UIImage *image = [self.converter convertValue:@"background"];

    STAssertNotNil(image, nil);
    STAssertEqualObjects(image, [UIImage imageNamed:@"background"], nil);

    NSString *code = [self.converter generateCodeForValue:@"background"];
    STAssertEqualObjects(code, @"[UIImage imageNamed:@\"background\"]", nil);
}

- (void)testResizableWithEdgeInsetsDefinedInSubarray {
    id value = @[@"background", @[@1.0f, @2.0f, @3.0f, @4.0f]];

    UIImage *image = [self.converter convertValue:value];

    STAssertNotNil(image, nil);
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);

    NSString *code = [self.converter generateCodeForValue:value];
    STAssertEqualObjects(code, @"[[UIImage imageNamed:@\"background\"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)]", nil);
}

- (void)testResizableDefinedInOneArray {
    UIImage *image = [self.converter convertValue:@[@"background", @1.0f, @2.0f, @3.0f, @4.0f]];

    STAssertNotNil(image, nil);
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);
}

- (void)testBackgroundImageFromColor {
    UIImage *image = [self.converter convertValue:@"blueColor"];
    STAssertNotNil(image, nil);
    
    image = [self.converter convertValue:@"#FF0000"];
    STAssertNotNil(image, nil);
    
    NSString *code = [self.converter generateCodeForValue:@"greenColor"];
    STAssertEqualObjects(code, @"[UIImage imageWithRed:0.000000 green:1.000000 blue:0.000000 alpha:1.000000]", nil);
    
    code = [self.converter generateCodeForValue:@"#D9F321"];
    STAssertEqualObjects(code, @"[UIImage imageWithRed:0.850980 green:0.952941 blue:0.129412 alpha:1.000000]", nil);
    
    image = [self.converter convertValue:@[@"blueColor", @0.25, @[@1, @2, @3, @4]]];
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);
    STAssertNotNil(image, nil);
    
    code = [self.converter generateCodeForValue:@[@"blueColor", @[@1, @2, @3, @4], @0.25]];
    STAssertEqualObjects(code, @"[[UIImage imageWithRed:0.000000 green:0.000000 blue:1.000000 alpha:0.250000] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)]", nil);
    
    image = [self.converter convertValue:@[@"#FF0000", @1, @2, @3, @4, @0.1]];
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);
    STAssertNotNil(image, nil);
}

- (void)testImageRenderingMode {
    UIImage *image = [self.converter convertValue:@[@"blueColor", @"Automatic"]];
    STAssertNotNil(image, nil);
    
    NSString *code = [self.converter generateCodeForValue:@[@"blueColor", @"template"]];
    STAssertEqualObjects(code, @"[[UIImage imageWithRed:0.000000 green:0.000000 blue:1.000000 alpha:1.000000] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]", nil);
    
    image = [self.converter convertValue:@[@"#FF0000", @1, @2, @3, @4, @0.1, @"template"]];
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);
    STAssertEquals(image.renderingMode, UIImageRenderingModeAlwaysTemplate, nil);
    STAssertNotNil(image, nil);
    
    image = [self.converter convertValue:@[@"#FF0000", @1, @2, @3, @4, @"original"]];
    STAssertEquals(image.renderingMode, UIImageRenderingModeAlwaysOriginal, nil);
    STAssertNotNil(image, nil);
    
    code = [self.converter generateCodeForValue:@[@"background", @1, @2, @3, @4, @"template"]];
    STAssertEqualObjects(code, @"[[[UIImage imageNamed:@\"background\"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]", nil);
}

- (void)setUp {
    self.converter = [[UISSImageValueConverter alloc] init];
}

- (void)tearDown {
    self.converter = nil;
}

@end
