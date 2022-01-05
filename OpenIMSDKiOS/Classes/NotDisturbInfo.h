//
//  NotDisturbInfo.h
//  OpenIMSDKiOS
//
//  Created by xpg on 2022/1/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotDisturbInfo : BaseModal

//    {"conversationId":"single_13922222222","result":0}
   /*
    * 会话id
    * */
@property(nullable) NSString *conversationId;
   /*
    * 免打扰状态
    * 1:屏蔽消息; 2:接收消息但不提示; 3:正常
    * */
@property int result;

@end

NS_ASSUME_NONNULL_END
