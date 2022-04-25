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
    OIMMessageContentTypeQuote = 114,           /// 引用消息
    OIMMessageContentTypeFace = 115,            /// 动图消息
    /// 以下皆是通知消息枚举
    OIMMessageContentTypeFriendAppApproved = 1201,              /// 同意加好友申请通知
    OIMMessageContentTypeFriendAppRejected = 1202,              /// 拒绝加好友申请通知
    OIMMessageContentTypeFriendApplication = 1203,              /// 加好友通知
    OIMMessageContentTypeFriendAdded = 1204,                    /// 添加好友通知
    OIMMessageContentTypeFriendDeleted = 1205,                  /// 删除好友通知
    OIMMessageContentTypeFriendRemarkSet = 1206,                /// 设置好友备注通知
    OIMMessageContentTypeBlackAdded = 1207,                     /// 加黑名单通知
    OIMMessageContentTypeBlackDeleted = 1208,                   /// 移除黑名单通知
    OIMMessageContentTypeConversationOptChange = 1300,          /// 会话免打扰设置通知
    OIMMessageContentTypeUserInfoUpdated = 1303,                /// 个人信息变更通知
    OIMMessageContentTypeGroupCreated = 1501,                   /// 群创建通知
    OIMMessageContentTypeGroupInfoSet = 1502,                   /// 更新群信息通知
    OIMMessageContentTypeJoinGroupApplication = 1503,           /// 申请加群通知
    OIMMessageContentTypeMemberQuit = 1504,                     /// 群成员退出通知
    OIMMessageContentTypeGroupAppAccepted = 1505,               /// 同意加群申请通知
    OIMMessageContentTypeGroupAppRejected = 1506,               /// 拒绝加群申请通知
    OIMMessageContentTypeGroupOwnerTransferred = 1507,          /// 群主更换通知
    OIMMessageContentTypeMemberKicked = 1508,                   /// 群成员被踢通知
    OIMMessageContentTypeMemberInvited = 1509,                  /// 邀请群成员通知
    OIMMessageContentTypeMemberEnter = 1510,                    /// 群成员进群通知
    OIMMessageContentTypeDismissGroup = 1511,                   /// 解散群通知
    OIMMessageContentTypeDismissGroup = 1701,                   /// 阅后即焚通知
};

/*
 *  消息状态
 */
typedef NS_ENUM(NSInteger, OIMMessageStatus) {
    OIMMessageStatusUndefine = 0,   /// 为定义
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
    OIMConversationTypeUndefine = 0,
    OIMConversationTypeC2C,             /// 单聊
    OIMConversationTypeGroup            /// 群聊
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
    OIMReceiveMessageOptReceive = 0,    /// 在线正常接收消息，离线时会进行 APNs 推送
    OIMReceiveMessageOptNotReceive = 1, /// 不会接收到消息，离线不会有推送通知
    OIMReceiveMessageOptNotNotify = 2,  /// 在线正常接收消息，离线不会有推送通知
};

/*
 *  群成员级别
 */
typedef NS_ENUM(NSInteger, OIMGroupMemberRole) {
    OIMGroupMemberRoleUndefine       = 0,    /// 未定义
    OIMGroupMemberRoleMember         = 1,    /// 群成员
    OIMGroupMemberRoleSuper          = 2,    /// 群主
    OIMGroupMemberRoleAdmin          = 3,    /// 群管理员
    
};

/*
 *  性别类型
 */
typedef NS_ENUM(NSInteger, OIMGender)  {
    OIMGenderMale,  /// 男性
    OIMGenderFemale /// 女性
};

typedef NS_ENUM(NSInteger, OIMApplicationStatus) {
    OIMApplicationStatusDecline = -1,   /// 已拒绝
    OIMApplicationStatusNormal = 0,     /// 等待处理
    OIMApplicationStatusAccept = 1,     /// 已同意
};

#endif /* OIMModelDefine_h */
