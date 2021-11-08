//
//  GroupApplicationList.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
#import "GroupApplicationInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupApplicationList : BaseModal

/**
 * 未处理数量
 */
@property int count;
/**
 * 申请记录
 */
@property(nullable) NSArray<GroupApplicationInfo*>/*List<GroupApplicationInfo>*/ *user;

@end

NS_ASSUME_NONNULL_END
