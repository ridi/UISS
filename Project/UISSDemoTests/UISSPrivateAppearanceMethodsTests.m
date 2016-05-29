//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "UISSAppearancePrivate.h"

@interface UISSPrivateAppearanceMethodsTests : XCTestCase

@end

@implementation UISSPrivateAppearanceMethodsTests

#if UISS_DEBUG

- (void)testDebugAppearancePrivateMethodsAndProperties; {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(NSClassFromString(@"_UIAppearance"), &count);

    NSLog(@"Methods:");
    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        NSLog(@"%@", NSStringFromSelector(selector));
    }

    NSLog(@"Properies:");
    objc_property_t *properties = class_copyPropertyList(NSClassFromString(@"_UIAppearance"), &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSLog(@"%@", @(property_getName(property)));
    }
}

- (void)testAppearanceInvocationsGetterExistence; {
    id appearance = [UIView appearance];
    XCTAssertTrue([appearance respondsToSelector:@selector(_appearanceInvocations)], @"UISS assumes that appearance has _appearanceInvocations method");

    // just to create first appearance invocation
    [appearance setBackgroundColor:[UIColor redColor]];

    id appearanceInvocations = [appearance _appearanceInvocations];
    XCTAssertTrue([appearanceInvocations isKindOfClass:[NSMutableArray class]], @"UISS assumes that _appearanceInvocations returns NSMutableArray");
}

- (void)testClearingAllAppearanceInvocations; {
    id appearance = [UIToolbar appearance];
    [appearance setTintColor:[UIColor redColor]];

    NSMutableArray *appearanceInvocations = [appearance _appearanceInvocations];
    XCTAssertTrue(appearanceInvocations.count > 0, @"should have at least one invocation");
    [appearanceInvocations removeAllObjects];

    appearance = [UIToolbar appearance];
    appearanceInvocations = [appearance _appearanceInvocations];
    XCTAssertTrue(appearanceInvocations.count == 0, @"all invocations should have been removed");
}

#endif

@end
