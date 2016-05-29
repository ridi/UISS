//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UISSBarMetricsValueConverter.h"
#import "UISSControlStateValueConverter.h"
#import "UISSSegmentedControlSegmentValueConverter.h"
#import "UISSToolbarPositionValueConverter.h"
#import "UISSSearchBarIconValueConverter.h"
#import "UISSTextAlignmentValueConverter.h"
#import "UISSImageResizingModeValueConverter.h"
#import "UISSKeyboardAppearanceValueConverter.h"
#import "UISSBarStyleValueConverter.h"

@interface UISSUIKitEnumsValueConvertersTests : XCTestCase

@end

@implementation UISSUIKitEnumsValueConvertersTests

- (void)testBarMetrics {
    UISSBarMetricsValueConverter *converter = [[UISSBarMetricsValueConverter alloc] init];

    XCTAssertEqual([[converter convertValue:@"default"] integerValue], UIBarMetricsDefault);
    XCTAssertEqual([[converter convertValue:@"landscapePhone"] integerValue], UIBarMetricsLandscapePhone);

    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testResizingMode {
    UISSImageResizingModeValueConverter *converter = [[UISSImageResizingModeValueConverter alloc] init];

    XCTAssertEqual([[converter convertValue:@"stretch"] integerValue], UIImageResizingModeStretch);
    XCTAssertEqual([[converter convertValue:@"tile"] integerValue], UIImageResizingModeTile);

    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testSearchBarIcon {
    UISSSearchBarIconValueConverter *converter = [[UISSSearchBarIconValueConverter alloc] init];

    XCTAssertEqual([[converter convertValue:@"search"] integerValue], UISearchBarIconSearch);
    XCTAssertEqual([[converter convertValue:@"clear"] integerValue], UISearchBarIconClear);
    XCTAssertEqual([[converter convertValue:@"bookmark"] integerValue], UISearchBarIconBookmark);
    XCTAssertEqual([[converter convertValue:@"resultsList"] integerValue], UISearchBarIconResultsList);

    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testSegmentedControlSegment {
    UISSSegmentedControlSegmentValueConverter *converter = [[UISSSegmentedControlSegmentValueConverter alloc] init];

    XCTAssertEqual([[converter convertValue:@"any"] integerValue], UISegmentedControlSegmentAny);
    XCTAssertEqual([[converter convertValue:@"left"] integerValue], UISegmentedControlSegmentLeft);
    XCTAssertEqual([[converter convertValue:@"center"] integerValue], UISegmentedControlSegmentCenter);
    XCTAssertEqual([[converter convertValue:@"right"] integerValue], UISegmentedControlSegmentRight);
    XCTAssertEqual([[converter convertValue:@"alone"] integerValue], UISegmentedControlSegmentAlone);

    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testTextAlignment {
    UISSTextAlignmentValueConverter *converter = [[UISSTextAlignmentValueConverter alloc] init];

    XCTAssertEqual([[converter convertValue:@"center"] integerValue], NSTextAlignmentCenter);
    XCTAssertEqual([[converter convertValue:@"justified"] integerValue], NSTextAlignmentJustified);
    XCTAssertEqual([[converter convertValue:@"left"] integerValue], NSTextAlignmentLeft);
    XCTAssertEqual([[converter convertValue:@"natural"] integerValue], NSTextAlignmentNatural);
    XCTAssertEqual([[converter convertValue:@"right"] integerValue], NSTextAlignmentRight);

    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testToolbarPosition {
    UISSToolbarPositionValueConverter *converter = [[UISSToolbarPositionValueConverter alloc] init];

    XCTAssertEqual([[converter convertValue:@"any"] integerValue], UIToolbarPositionAny);
    XCTAssertEqual([[converter convertValue:@"bottom"] integerValue], UIToolbarPositionBottom);
    XCTAssertEqual([[converter convertValue:@"top"] integerValue], UIToolbarPositionTop);

    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testKeyboardAppearance {
    UISSKeyboardAppearanceValueConverter *converter = [[UISSKeyboardAppearanceValueConverter alloc] init];
    
    XCTAssertEqual([[converter convertValue:@"default"] integerValue], UIKeyboardAppearanceDefault);
    XCTAssertEqual([[converter convertValue:@"dark"] integerValue], UIKeyboardAppearanceDark);
    XCTAssertEqual([[converter convertValue:@"light"] integerValue], UIKeyboardAppearanceLight);
    XCTAssertEqual([[converter convertValue:@"alert"] integerValue], UIKeyboardAppearanceAlert);
    
    XCTAssertNil([converter convertValue:@"dummy"]);
}

- (void)testBarStyle {
    UISSBarStyleValueConverter *converter = [[UISSBarStyleValueConverter alloc] init];
    
    XCTAssertEqual([[converter convertValue:@"default"] integerValue], UIBarStyleDefault);
    XCTAssertEqual([[converter convertValue:@"black"] integerValue], UIBarStyleBlack);
    
    XCTAssertNil([converter convertValue:@"dummy"]);
}

@end
