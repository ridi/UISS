//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UISSControlStateValueConverter.h"

@interface UISSControlStateValueConverterTests : XCTestCase

@property(nonatomic, strong) UISSControlStateValueConverter *converter;

@end

@implementation UISSControlStateValueConverterTests

- (void)setUp; {
    self.converter = [[UISSControlStateValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

- (void)testControlStateNormal {
    XCTAssertEqual([[self.converter convertValue:@"normal"] unsignedIntegerValue], (UIControlState) UIControlStateNormal);
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"normal"], @"UIControlStateNormal");
}

- (void)testControlStateHighlighted {
    XCTAssertEqual([[self.converter convertValue:@"highlighted"] unsignedIntegerValue], (UIControlState) UIControlStateHighlighted);
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"highlighted"], @"UIControlStateHighlighted");
}

- (void)testControlStateDisabled {
    XCTAssertEqual([[self.converter convertValue:@"disabled"] unsignedIntegerValue], (UIControlState) UIControlStateDisabled);
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"disabled"], @"UIControlStateDisabled");
}

- (void)testControlStateSelected {
    XCTAssertEqual([[self.converter convertValue:@"selected"] unsignedIntegerValue], (UIControlState) UIControlStateSelected);
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"selected"], @"UIControlStateSelected");
}

- (void)testControlStateApplication {
    XCTAssertEqual([[self.converter convertValue:@"application"] unsignedIntegerValue], (UIControlState) UIControlStateApplication);
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"application"], @"UIControlStateApplication");
}

- (void)testControlStateReserved {
    XCTAssertEqual([[self.converter convertValue:@"reserved"] unsignedIntegerValue], (UIControlState) UIControlStateReserved);
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"reserved"], @"UIControlStateReserved");
}

- (void)testInvalidValue {
    XCTAssertNil([self.converter convertValue:@"dummy"]);
    XCTAssertNil([self.converter generateCodeForValue:@"dummy"]);
}

- (void)testControlStateSelectedAndHighlighted {
    XCTAssertEqual([[self.converter convertValue:@"selected|highlighted"] unsignedIntegerValue], (UIControlState) (UIControlStateSelected | UIControlStateHighlighted));
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"selected|highlighted"], @"UIControlStateSelected|UIControlStateHighlighted");
}

- (void)testControlStateNormalAndHighlighted {
    XCTAssertEqual([[self.converter convertValue:@"normal|highlighted"] unsignedIntegerValue], (UIControlState) (UIControlStateNormal | UIControlStateHighlighted));
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"normal|highlighted"], @"UIControlStateNormal|UIControlStateHighlighted");
}

- (void)testControlStateDisabledAndSelected {
    XCTAssertEqual([[self.converter convertValue:@"disabled|selected"] unsignedIntegerValue], (UIControlState) (UIControlStateDisabled | UIControlStateSelected));
    XCTAssertEqualObjects([self.converter generateCodeForValue:@"disabled|selected"], @"UIControlStateDisabled|UIControlStateSelected");
}

@end
