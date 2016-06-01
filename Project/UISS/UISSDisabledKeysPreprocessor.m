//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSDisabledKeysPreprocessor.h"

@implementation UISSDisabledKeysPreprocessor

- (NSString *)prefix {
    return @"-";
}

- (NSDictionary *)preprocess:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    NSMutableDictionary *preprocessed = [NSMutableDictionary dictionary];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([key hasPrefix:self.prefix] == NO) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                object = [self preprocess:object userInterfaceIdiom:userInterfaceIdiom];
            }

            [preprocessed setObject:object forKey:key];
        }
    }];
    
    return preprocessed;
}

@end
