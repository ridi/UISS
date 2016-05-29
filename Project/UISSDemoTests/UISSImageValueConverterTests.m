//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UISSImageValueConverter.h"

@interface UISSImageValueConverterTests : XCTestCase

@property(nonatomic, strong) UISSImageValueConverter *converter;

@end

@implementation UISSImageValueConverterTests

- (void)testNullImage {
    UIImage *image = [self.converter convertValue:[NSNull null]];
    XCTAssertNil(image);

    NSString *code = [self.converter generateCodeForValue:[NSNull null]];
    XCTAssertEqualObjects(code, @"nil");
}

- (void)testSimleImageAsString {
    UIImage *image = [self.converter convertValue:@"background"];

    XCTAssertNotNil(image);
    XCTAssertEqualObjects(image, [UIImage imageNamed:@"background"]);

    NSString *code = [self.converter generateCodeForValue:@"background"];
    XCTAssertEqualObjects(code, @"[UIImage imageNamed:@\"background\"]");
}

- (void)testResizableWithEdgeInsetsDefinedInSubarray {
    id value = @[@"background", @[@1.0f, @2.0f, @3.0f, @4.0f]];

    UIImage *image = [self.converter convertValue:value];

    XCTAssertNotNil(image);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4)));

    NSString *code = [self.converter generateCodeForValue:value];
    XCTAssertEqualObjects(code, @"[[UIImage imageNamed:@\"background\"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)]");
}

- (void)testResizableDefinedInOneArray {
    UIImage *image = [self.converter convertValue:@[@"background", @1.0f, @2.0f, @3.0f, @4.0f]];

    XCTAssertNotNil(image);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4)));
}

- (void)testBackgroundImageFromColor {
    UIImage *image = [self.converter convertValue:@"blueColor"];
    XCTAssertNotNil(image);
    
    image = [self.converter convertValue:@"#FF0000"];
    XCTAssertNotNil(image);
    
    NSString *code = [self.converter generateCodeForValue:@"greenColor"];
    XCTAssertEqualObjects(code, @"[UIImage imageWithRed:0.000000 green:1.000000 blue:0.000000 alpha:1.000000]");
    
    code = [self.converter generateCodeForValue:@"#D9F321"];
    XCTAssertEqualObjects(code, @"[UIImage imageWithRed:0.850980 green:0.952941 blue:0.129412 alpha:1.000000]");
    
    image = [self.converter convertValue:@[@"blueColor", @0.25, @[@1, @2, @3, @4]]];
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4)));
    XCTAssertNotNil(image);
    
    code = [self.converter generateCodeForValue:@[@"blueColor", @[@1, @2, @3, @4], @0.25]];
    XCTAssertEqualObjects(code, @"[[UIImage imageWithRed:0.000000 green:0.000000 blue:1.000000 alpha:0.250000] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)]");
    
    image = [self.converter convertValue:@[@"#FF0000", @1, @2, @3, @4, @0.1]];
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4)));
    XCTAssertNotNil(image);
}

- (void)testImageRenderingMode {
    UIImage *image = [self.converter convertValue:@[@"blueColor", @"Automatic"]];
    XCTAssertNotNil(image);
    
    NSString *code = [self.converter generateCodeForValue:@[@"blueColor", @"template"]];
    XCTAssertEqualObjects(code, @"[[UIImage imageWithRed:0.000000 green:0.000000 blue:1.000000 alpha:1.000000] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]");
    
    image = [self.converter convertValue:@[@"#FF0000", @1, @2, @3, @4, @0.1, @"template"]];
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4)));
    XCTAssertTrue(image.renderingMode == UIImageRenderingModeAlwaysTemplate);
    XCTAssertNotNil(image);
    
    image = [self.converter convertValue:@[@"#FF0000", @1, @2, @3, @4, @"original"]];
    XCTAssertTrue(image.renderingMode == UIImageRenderingModeAlwaysOriginal);
    XCTAssertNotNil(image);
    
    code = [self.converter generateCodeForValue:@[@"background", @1, @2, @3, @4, @"template"]];
    XCTAssertEqualObjects(code, @"[[[UIImage imageNamed:@\"background\"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]");
}

- (void)setUp {
    self.converter = [[UISSImageValueConverter alloc] init];
}

- (void)tearDown {
    self.converter = nil;
}

@end
