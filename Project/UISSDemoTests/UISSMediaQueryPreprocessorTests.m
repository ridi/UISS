//
//  UISSMediaQueryPreprocessorTests.m
//  UISS
//
//  Created by Da Vin Ahn on 2016. 6. 1..
//  Copyright © 2016년 57things. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UISSMediaQueryPreprocessor.h"

@interface UISSMediaQueryPreprocessorTests : XCTestCase

@property(nonatomic, strong) UISSMediaQueryPreprocessor *preprocessor;

@end

@implementation UISSMediaQueryPreprocessorTests

- (void)testDictionaryWithIdiomBranches; {
    NSDictionary *dictionary = @{
        @"@media(device: phone)": @"value",
    };
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPhone];
    
    XCTAssertNotNil(preprocessed);
    XCTAssertEqualObjects(dictionary, preprocessed);
}

- (void)testDictionaryWithOSBranches; {
    NSInteger currentVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
    
    NSDictionary *dictionary = @{
        @"@media(os: < 8)": @"value",
    };
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPhone];
    
    XCTAssertNotNil(preprocessed);
    if (currentVersion < 8) {
        XCTAssertEqualObjects(dictionary, preprocessed);
    } else {
        XCTAssertTrue(preprocessed.count == 0);
    }
}

- (void)testDictionaryWithOSAndIdiomBranches; {
    NSInteger currentVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
    
    NSDictionary *dictionary = @{
        @"@media(os: >= 8, device: pad)": @"value",
    };
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPad];
    
    XCTAssertNotNil(preprocessed);
    if (currentVersion >= 8) {
        XCTAssertEqualObjects(dictionary, preprocessed);
    } else {
        XCTAssertTrue(preprocessed.count == 0);
    }
}

- (void)setUp; {
    self.preprocessor = [[UISSMediaQueryPreprocessor alloc] init];
}

- (void)tearDown; {
    self.preprocessor = nil;
}

@end
