//
//  OIMMessageElem.h
//  OpenIMSDK
//
//  Created by x on 2022/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMMessageEntity : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *info;
@end

@interface OIMMessageEntityElem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray <OIMMessageEntity *> *messageEntityList;

@end

@interface OIMMessageElem : NSObject



@end

NS_ASSUME_NONNULL_END
