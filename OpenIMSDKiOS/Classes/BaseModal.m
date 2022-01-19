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

- (NSString *)capitalizedOnlyFirstLetter:(NSString*)str {

    if (str.length < 1) {
        return @"";
    }
    else if (str.length == 1) {
        return [str capitalizedString];
    }
    else {

        NSString *firstChar = [str substringToIndex:1];
        NSString *otherChars = [str substringWithRange:NSMakeRange(1, str.length - 1)];

        return [NSString stringWithFormat:@"%@%@", [firstChar uppercaseString], otherChars];
    }
}

- (void)objectFromDictionary:(NSDictionary*) dict {
  unsigned int propCount, i;
  objc_property_t* properties = class_copyPropertyList([self class], &propCount);
  for (i = 0; i < propCount; i++) {
      NSString *propName = [NSString stringWithUTF8String:property_getName(properties[i])];
    if(propName) {
        NSString *name = propName;
      id obj = dict[name];
      if (!obj)
        continue;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        id subObj = [self valueForKey:name];
        if (subObj)
          [subObj objectFromDictionary:obj];
        else{
            if([[self className] isEqualToString:@"QuoteElem"]) {
                if([name isEqualToString:@"quoteMessage"]) {
                    Class c = NSClassFromString(@"Message");
                    if(c != nil) {
                        id ins = [(BaseModal *) [c alloc] initWithDictionary:obj];
                        [self setValue:ins forKeyPath:name];
                    }
                }
            }else if([[self className] isEqualToString:@"PictureElem"]) {
                if([name isEqualToString:@"sourcePicture"]) {
                    Class c = NSClassFromString(@"PictureInfo");
                    if(c != nil) {
                        id ins = [(BaseModal *) [c alloc] initWithDictionary:obj];
                        [self setValue:ins forKeyPath:name];
                    }
                }
            }else if([[self className] isEqualToString:@"PictureElem"]) {
                if([name isEqualToString:@"bigPicture"]) {
                    Class c = NSClassFromString(@"PictureInfo");
                    if(c != nil) {
                        id ins = [(BaseModal *) [c alloc] initWithDictionary:obj];
                        [self setValue:ins forKeyPath:name];
                    }
                }
            }else if([[self className] isEqualToString:@"PictureElem"]) {
                if([name isEqualToString:@"snapshotPicture"]) {
                    Class c = NSClassFromString(@"PictureInfo");
                    if(c != nil) {
                        id ins = [(BaseModal *) [c alloc] initWithDictionary:obj];
                        [self setValue:ins forKeyPath:name];
                    }
                }
            }else{
                NSString *cs = [self capitalizedOnlyFirstLetter:name];
                Class c = NSClassFromString(cs);
                if(c != nil) {
                    id ins = [(BaseModal *) [c alloc] initWithDictionary:obj];
                    [self setValue:ins forKeyPath:name];
                }
            }
        }
    }else if([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *arr = [NSMutableArray new];
        for(NSDictionary *dic in obj) {
            if([[self className] isEqualToString:@"GroupApplicationList"]) {
                if([name isEqualToString:@"user"]) {
                    Class c = NSClassFromString(@"GroupApplicationInfo");
                    [arr addObject:[(BaseModal *) [c alloc] initWithDictionary:dic]];
                }
            }else if([[self className] isEqualToString:@"GroupMembersList"]) {
                if([name isEqualToString:@"data"]) {
                    Class c = NSClassFromString(@"GroupMembersInfo");
                    [arr addObject:[(BaseModal *) [c alloc] initWithDictionary:dic]];
                }
            }else if([[self className] isEqualToString:@"MergeElem"]) {
                if([name isEqualToString:@"multiMessage"]) {
                    Class c = NSClassFromString(@"Message");
                    [arr addObject:[(BaseModal *) [c alloc] initWithDictionary:dic]];
                }
            }else{
                [arr addObject:dic];
            }
        }
        [self setValue:arr forKeyPath:name];
    }else{
          [self setValue:obj forKeyPath:name];
      }
    }
  }
  free(properties);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
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
            dictionary[key] = value;
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            dictionary[key] = [value dict];
        }
        else {
            NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
        }
    }
    
    free(properties);
    
    return dictionary;
}

@end
