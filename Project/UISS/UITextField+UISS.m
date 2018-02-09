#import "UITextField+UISS.h"

#import <objc/message.h>
#import <objc/runtime.h>

static void * placeholderTextAttributesPropertyKey = &placeholderTextAttributesPropertyKey;

BOOL SwizzleMethod(Class class, SEL originalSelector, SEL newSelector, id block);

BOOL SwizzleMethod(Class class, SEL originalSelector, SEL newSelector, id block) {
    if (class == nil || originalSelector == nil || newSelector == nil || block == nil) {
        return NO;
    }
    
    if ([class instancesRespondToSelector:newSelector]) {
        return YES;
    }
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    IMP implementForNewSelector = imp_implementationWithBlock(block);
    if (!class_addMethod(class, newSelector, implementForNewSelector, method_getTypeEncoding(originalMethod))) {
        return NO;
    }
    
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(originalMethod))) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(newMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
    return YES;
}

@implementation UITextField (UISS)

+ (void)initialize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL swizzleSelector = @selector(uiss_setPlaceholder:);
    SwizzleMethod([UITextField class], @selector(setPlaceholder:), swizzleSelector, ^(UITextField *textField, NSString *placeholder) {
        if (textField.placeholderTextAttributes) {
            [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder]];
        }
        else {
            ((void ( *)(id, SEL, NSString *))objc_msgSend)(textField, swizzleSelector, placeholder);
        }
    });
    swizzleSelector = @selector(uiss_setAttributedPlaceholder:);
    SwizzleMethod([UITextField class], @selector(setAttributedPlaceholder:), swizzleSelector, ^(UITextField *textField, NSAttributedString *attributedPlaceholder) {
        if (textField.placeholderTextAttributes) {
            id attributedString = [[NSAttributedString alloc] initWithString:[attributedPlaceholder string] attributes:textField.placeholderTextAttributes];
            ((void ( *)(id, SEL, NSAttributedString *))objc_msgSend)(textField, swizzleSelector, attributedString);
        }
        else {
            ((void ( *)(id, SEL, NSAttributedString *))objc_msgSend)(textField, swizzleSelector, attributedPlaceholder);
        }
    });
#pragma clang diagnostic pop
}

- (void)setPlaceholderTextAttributes:(NSDictionary<NSString *, id> *)placeholderTextAttributes {
    objc_setAssociatedObject(self, placeholderTextAttributesPropertyKey, placeholderTextAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) {
        self.placeholder = self.placeholder;
    } else if (self.attributedPlaceholder) {
        self.attributedPlaceholder = self.attributedPlaceholder;
    }
}

- (NSDictionary<NSString *, id> *)placeholderTextAttributes {
    return objc_getAssociatedObject(self, placeholderTextAttributesPropertyKey);
}

@end
