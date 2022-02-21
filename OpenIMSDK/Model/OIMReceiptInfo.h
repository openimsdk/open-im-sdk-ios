//
//  OIMReceiptInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>

#import "OIMModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMReceiptInfo : NSObject

/*
 * 用户id
 */
@property(nonatomic, nullable, copy) NSString *uid;

/*
 * 已读消息id
 */
@property(nonatomic, nullable, copy) NSArray<NSString *> *msgIDList;

/*
 * 阅读时间
 */
@property (nonatomic, assign) NSInteger readTime;

@property (nonatomic, assign) OIMMessageLevel msgFrom;

@property (nonatomic, assign) OIMMessageContentType contentType;

@property (nonatomic, assign) OIMConversationType sessionType;

@end

NS_ASSUME_NONNULL_END
