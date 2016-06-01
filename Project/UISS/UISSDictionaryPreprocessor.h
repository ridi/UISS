//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UISSDictionaryPreprocessor <NSObject>

@property (nonatomic, copy, readonly) NSString *prefix;

- (NSDictionary *)preprocess:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;

@end
