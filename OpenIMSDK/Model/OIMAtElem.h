//
//  OIMAtElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMAtElem : NSObject

/*
 * at 消息内容
 */

@property(nonatomic, nullable, copy) NSString *text;

/*
 * 被@的用户id集合
 */
@property(nonatomic, nullable, copy) NSArray<NSString *> *atUserList;

/*
 * 自己是否被@了
 */
@property(nonatomic, assign) BOOL isAtSelf;

@end

NS_ASSUME_NONNULL_END
