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

@interface OIMAdvancedTextElem : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSArray <OIMMessageEntity *> *messageEntityList;

@end

@interface OIMMessageElem : NSObject



@end

@interface OIMTextElem : NSObject

@property (nonatomic, copy) NSString *content;

@end

@interface OIMCardElem : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *faceURL;
@property (nonatomic, copy) NSString *ex;

@end

@interface OIMTypingElem : NSObject

@property (nonatomic, copy) NSString *msgTips;

@end

NS_ASSUME_NONNULL_END
