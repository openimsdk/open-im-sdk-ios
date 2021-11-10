//
//  BaseModal.m
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/4.
//

#import "BaseModal.h"
#import <objc/runtime.h>

@implementation BaseModal

- (instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
      if(self && dict)
        [self objectFromDictionary:dict];
      return self;
}

- (NSString *) className {
  return NSStringFromClass([self class]);
}

- (void)objectFromDictionary:(NSDictionary*) dict {
  unsigned int propCount, i;
  objc_property_t* properties = class_copyPropertyList([self class], &propCount);
  for (i = 0; i < propCount; i++) {
      NSString *propName = [NSString stringWithUTF8String:property_getName(properties[i])];
    if(propName) {
        NSString *name = propName;
      id obj = [dict objectForKey:name];
      if (!obj)
        continue;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        id subObj = [self valueForKey:name];
        if (subObj)
          [subObj objectFromDictionary:obj];
      }else{
          [self setValue:obj forKeyPath:name];
      }
    }
  }
  free(properties);
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
        else if ([value isKindOfClass:[NSNull class]]) {
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
