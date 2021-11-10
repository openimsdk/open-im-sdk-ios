//
//  AtElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface AtElem : BaseModal

/**
 * at 消息内容
 */
@property(nullable) NSString *text;
/**
 * 被@的用户id集合
 */
@property(nullable) NSArray<NSString*>/*List<String>*/ *atUserList;
/**
 * 自己是否被@了
 */
@property bool isAtSelf;

@end

NS_ASSUME_NONNULL_END
