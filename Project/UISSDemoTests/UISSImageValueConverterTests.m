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
    STAssertEqualObjects(code, @"[UIImage imageWithRed:0.000000 green:0.000000 blue:1.000000 alpha:1.000000]", nil);
    
    code = [self.converter generateCodeForValue:@"#D9F321"];
    STAssertEqualObjects(code, @"[UIImage imageWithRed:0.850980 green:0.129412 blue:0.952941 alpha:1.000000]", nil);
}

- (void)setUp; {
    self.converter = [[UISSImageValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

@end
