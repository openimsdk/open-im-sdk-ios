//
//  HaveReadInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface HaveReadInfo : BaseModal

/**
 * 用户id
 */
@property(nullable) NSString *uid;
/**
 * 已读消息id
 */
@property(nullable) NSArray<NSString*>/*List<String>*/ *msgIDList;
/**
 * 阅读时间
 */
@property int readTime;
/**
 * 标识消息是用户级别还是系统级别 100:用户 200:系统
 */
@property int msgFrom;
/**
 * 消息类型：
 * 101:文本消息
 * 102:图片消息
 * 103:语音消息
 * 104:视频消息
 * 105:文件消息
 * 106:@消息
 * 107:合并消息
 * 108:转发消息
 * 109:位置消息
 * 110:自定义消息
 * 111:撤回消息回执
 * 112:C2C已读回执
 * 113:正在输入状态
 */
@property int contentType;
/**
 * 会话类型 1:单聊 2:群聊
 */
@property int sessionType;

@end

NS_ASSUME_NONNULL_END
