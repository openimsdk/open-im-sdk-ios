//
//  OIMSimpleRequstInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMSimpleRequstInfo : NSObject

@property (nonatomic, nullable, copy) NSString *toUserID;
/**
 *  Only for adding friend requests
 */
@property (nonatomic, nullable, copy) NSString *reqMsg;
/**
 *  Only for setting friend remarks
 */
@property (nonatomic, nullable, copy) NSString *remark;
/**
 *  Only for approving a friend request from someone
 */
@property (nonatomic, nullable, copy) NSString *handleMsg;

@end

NS_ASSUME_NONNULL_END
