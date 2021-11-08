//
//  Message.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
#import "PictureElem.h"
#import "SoundElem.h"
#import "VideoElem.h"
#import "FileElem.h"
#import "AtElem.h"
#import "LocationElem.h"
#import "QuoteElem.h"
#import "CustomElem.h"
#import "MergeElem.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : BaseModal

/**
     * 消息唯一ID
     */
@property(nullable) NSString *clientMsgID;
    /**
     * 消息服务器ID，暂时不使用
     */
@property(nullable) NSString *serverMsgID;
    /**
     * 消息创建时间，单位纳秒
     */
@property long createTime;
    /**
     * 消息发送时间，单位纳秒
     */
@property long sendTime;
    /**
     * 发送者ID
     */
@property(nullable) NSString *sendID;
    /**
     * 接收者ID
     */
@property(nullable) NSString *recvID;
    /**
     * 标识消息是用户级别还是系统级别 100:用户 200:系统
     */
@property int msgFrom;
    /**
     * 消息类型：<br/>
     * 101:文本消息<br/>
     * 102:图片消息<br/>
     * 103:语音消息<br/>
     * 104:视频消息<br/>
     * 105:文件消息<br/>
     * 106:@消息<br/>
     * 107:合并消息<br/>
     * 108:转发消息<br/>
     * 109:位置消息<br/>
     * 110:自定义消息<br/>
     * 111:撤回消息回执<br/>
     * 112:C2C已读回执<br/>
     * 113:正在输入状态
     */
@property int contentType;
    /**
     * 平台类型 1:ios 2:android 3:windows 4:osx 5:web 6:mini 7:linux
     */
@property int platformID;
    /**
     * 强制推送列表(被@的用户)
     */
@property(nullable) NSArray *forceList;
    /**
     * 发送者昵称
     */
@property(nullable) NSString *senderNickName;
    /**
     * 发送者头像
     */
@property(nullable) NSString *senderFaceUrl;
    /**
     * 群聊ID
     */
@property(nullable) NSString *groupID;
    /**
     * 消息内容
     */
@property(nullable) NSString *content;
    /**
     * 消息唯一序列号
     */
@property int seq;
    /**
     * 是否已读
     */
@property Boolean isRead;
    /**
     * 消息状态 1:发送中 2:发送成功 3:发送失败 4:已删除 5:已撤回
     */
@property int status;
    /**
     * 消息备注
     */
@property(nullable) NSString *remark;
    /**
     *
     */
@property(nullable) id ext;
    /**
     * 会话类型 1:单聊 2:群聊
     */
@property int sessionType;
    /**
     * 图片信息
     */
@property(nullable) PictureElem *pictureElem;
    /**
     * 语音信息
     */
@property(nullable) SoundElem *soundElem;
    /**
     * 视频信息
     */
@property(nullable) VideoElem *videoElem;
    /**
     * 文件信息
     */
@property(nullable) FileElem *fileElem;
    /**
     * _@信息
     */
@property(nullable) AtElem *atElem;
    /**
     * 位置信息
     */
@property(nullable) LocationElem *locationElem;
    /**
     * 引用消息
     */
@property(nullable) QuoteElem *quoteElem;
    /**
     * 自定义信息
     */
@property(nullable) CustomElem *customElem;
    /**
     * 合并信息
     */
@property(nullable) MergeElem *mergeElem;

@end

NS_ASSUME_NONNULL_END
