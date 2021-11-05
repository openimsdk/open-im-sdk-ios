//
//  BaseModal.m
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/4.
//

#import "BaseModal.h"
#import <objc/runtime.h>

@implementation BaseModal

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dictionary];}
        return self;
}

- (NSDictionary *)dict {
    
    unsigned int count = 0;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {

        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        if (value == nil) {
            // nothing todo
        }
        else if ([value isKindOfClass:[NSNumber class]]
            || [value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSDictionary class]]) {
            [dictionary setObject:value forKey:key];
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            [dictionary setObject:[value dict] forKey:key];
        }
        else {
            NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
        }
    }
    
    free(properties);
    
    return dictionary;
}

@end
