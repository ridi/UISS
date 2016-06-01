//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSDictionaryPreprocessor.h"

// removes from dictionary all keys that begins with a configured prefix (default is '-')
@interface UISSDisabledKeysPreprocessor : NSObject <UISSDictionaryPreprocessor>

@end
