//
//  OIMModelDefine.h
//  OpenIMSDK
//
//  Created by x on 2022/2/21.
//

#ifndef OIMModelDefine_h
#define OIMModelDefine_h


/*
 *  消息类型
 */
typedef NS_ENUM(NSInteger, OIMMessageContentType) {
    OIMMessageContentTypeText = 101,            /// 文本消息
    OIMMessageContentTypeImage = 102,           /// 图片消息
    OIMMessageContentTypeAudio = 103,           /// 语音消息
    OIMMessageContentTypeVideo = 104,           /// 视频消息
    OIMMessageContentTypeFile = 105,            /// 文件消息
    OIMMessageContentTypeAt = 106,              /// @消息
    OIMMessageContentTypeMerge = 107,           /// 合并消息
    OIMMessageContentTypeCard = 108,            /// 名片消息
    OIMMessageContentTypeLocation = 109,        /// 位置消息
    OIMMessageContentTypeCustom = 110,          /// 自定义消息
    OIMMessageContentTypeRevokeReciept = 111,   /// 撤回消息回执
    OIMMessageContentTypeC2CReciept = 112,      /// C2C已读回执
    OIMMessageContentTypeTyping = 113,          /// 正在输入状态
    OIMMessageContentTypeQuote = 114            /// 引用消息
};

/*
 *  消息状态
 */
typedef NS_ENUM(NSInteger, OIMMessageStatus) {
    OIMMessageStatusSending = 1,    /// 发送中
    OIMMessageStatusSendSuccess,    /// 发送成功
    OIMMessageStatusSendFailure,    /// 发送失败
    OIMMessageStatusDeleted,        /// 已删除
    OIMMessageStatusRevoke          /// 已撤回
};

/*
 *  会话类型
 */
typedef NS_ENUM(NSInteger, OIMConversationType) {
    OIMConversationTypeC2C = 1, /// 单聊
    OIMConversationTypeGroup    /// 群聊
};

/*
 *  标识消息级别
 */
typedef NS_ENUM(NSInteger, OIMMessageLevel) {
    OIMMessageLevelUser = 100,  /// 用户
    OIMMessageLevelSystem = 200 /// 系统
};

/*
 *  消息接收选项
 */
typedef NS_ENUM(NSInteger, OIMReceiveMessageOpt) {
    OIMReceiveMessageOptReceive = 0,    ///在线正常接收消息，离线时会进行 APNs 推送
    OIMReceiveMessageOptNotReceive = 1, ///不会接收到消息，离线不会有推送通知
    OIMReceiveMessageOptNotNotify = 2,  ///在线正常接收消息，离线不会有推送通知
};

/*
 *  群成员级别
 */
typedef NS_ENUM(NSInteger, OIMGroupMemberRole) {
    OIMGroupMemberRoleUndefine       = 0,    /// 未定义
    OIMGroupMemberRoleMember         = 1,    /// 群成员
    OIMGroupMemberRoleSuper          = 2,    ///< 群主
    OIMGroupMemberRoleAdmin          = 3,    ///< 群管理员
    
};

/*
 *  性别类型
 */
typedef NS_ENUM(NSInteger, OIMGender)  {
    OIMGenderMale,  /// 男性
    OIMGenderFemale /// 女性
};

#endif /* OIMModelDefine_h */
