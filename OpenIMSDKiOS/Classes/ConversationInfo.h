//
//  ConversationInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConversationInfo : BaseModal

/**
    * 会话id
    */
@property(nullable) NSString *conversationID;
   /**
    * 会话类型 1:单聊 2:群聊
    */
@property int conversationType;
   /**
    * 会话对象用户ID
    */
@property(nullable) NSString *userID;
   /**
    * 会话群聊ID
    */
@property(nullable) NSString *groupID;
   /**
    * 会话对象(用户或群聊)名称
    */
@property(nullable) NSString *showName;
   /**
    * 用户头像或群聊头像
    */
@property(nullable) NSString *faceUrl;
   /**
    * 接收消息选项：<br/>
    * 1:在线正常接收消息，离线时进行推送<br/>
    * 2:不会接收到消息<br/>
    * 3:在线正常接收消息，离线不会有推送
    */
@property int recvMsgOpt;
   /**
    * 未读消息数量
    */
@property int unreadCount;
   /**
    * 最后一条消息 消息对象json字符串
    */
@property(nullable) NSString *latestMsg;
   /**
    * 最后一条消息发送时间(ns)
    */
@property long latestMsgSendTime;
   /**
    * 会话草稿
    */
@property(nullable) NSString *draftText;
   /**
    * 会话草稿设置时间
    */
@property long draftTimestamp;
   /**
    * 是否置顶，1置顶
    */
@property int isPinned;

@end

NS_ASSUME_NONNULL_END
