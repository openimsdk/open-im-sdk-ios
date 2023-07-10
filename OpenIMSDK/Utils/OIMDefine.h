//
//  IMDefine.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#ifndef IMDefine_h
#define IMDefine_h

typedef NS_ENUM(NSInteger, OIMPlatform) {
    iPhone = 1, // iPhone
    iPad = 9,   // iPad
};

typedef void (^OIMVoidCallback)(void);
typedef void (^OIMSuccessCallback)(NSString * _Nullable data);
typedef void (^OIMFailureCallback)(NSInteger code, NSString * _Nullable msg);
typedef void (^OIMNumberCallback)(NSInteger number);
typedef void (^OIMStringCallback)(NSString * _Nullable item);
typedef void (^OIMStringArrayCallback)(NSString * _Nullable value1, NSArray<NSString *> * _Nullable value2);
typedef void (^OIMObjectCallback)(NSDictionary * _Nullable item);

/*
 *  消息类型
 */
typedef NS_ENUM(NSInteger, OIMMessageContentType) {
    OIMMessageContentTypeText = 101,                /// 文本消息
    OIMMessageContentTypeImage = 102,               /// 图片消息
    OIMMessageContentTypeAudio = 103,               /// 语音消息
    OIMMessageContentTypeVideo = 104,               /// 视频消息
    OIMMessageContentTypeFile = 105,                /// 文件消息
    OIMMessageContentTypeAt = 106,                  /// @消息
    OIMMessageContentTypeMerge = 107,               /// 合并消息
    OIMMessageContentTypeCard = 108,                /// 名片消息
    OIMMessageContentTypeLocation = 109,            /// 位置消息
    OIMMessageContentTypeCustom = 110,              /// 自定义消息
    OIMMessageContentTypeTyping = 113,              /// 正在输入状态
    OIMMessageContentTypeQuote = 114,               /// 引用消息
    OIMMessageContentTypeFace = 115,                /// 动图消息
    OIMMessageContentTypeAdvancedText = 117,        /// Advanced消息
    OIMMessageContentTypeCustomMsgNotTriggerConversation = 119,      /// 后端API会用到
    OIMMessageContentTypeCustomMsgOnlineOnly = 120,      /// 后端API会用到
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
    OIMMessageContentTypeOANotification = 1400,                 /// oa 通知
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
    OIMMessageContentTypeGroupMemberMutedNotification = 1512,
    OIMMessageContentTypeGroupMemberCancelMutedNotification = 1513,
    OIMMessageContentTypeGroupMutedNotification = 1514,
    OIMMessageContentTypeGroupCancelMutedNotification = 1515,
    OIMMessageContentTypeGroupMemberInfoSetNotification = 1516,
    OIMMessageContentTypeGroupMemberSetToAdminNotification = 1517,
    OIMMessageContentTypeGroupMemberSetToOrdinaryUserNotification = 1518,
    OIMMessageContentTypeGroupAnnouncement = 1519,              /// 群公告
    OIMMessageContentTypeGroupSetNameNotification = 1520,       /// 修改群名称
    OIMMessageContentTypeSuperGroupUpdateNotification = 1651,
    OIMMessageContentTypeConversationPrivateChatNotification = 1701,
    OIMMessageContentTypeOrganizationChangedNotification = 1801,
    OIMMessageContentTypeIsPrivateMessage = 1701,               /// 阅后即焚通知
    OIMMessageContentTypeBusiness = 2001,                       /// 业务通知
    OIMMessageContentTypeRevoke = 2101,                         /// 撤回消息
    OIMMessageContentTypeHasReadReceipt = 2150,                 /// 单聊已读回执
    OIMMessageContentTypeGroupHasReadReceipt = 2155,            /// 群已读回执

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
    OIMMessageStatusRevoke          /// 已撤回，客户端不用关心
};

/*
 *  会话类型
 */
typedef NS_ENUM(NSInteger, OIMConversationType) {
    OIMConversationTypeUndefine = 0,
    OIMConversationTypeC2C,                 /// 单聊
    OIMConversationTypeGroup,               /// 群聊
    OIMConversationTypeSuperGroup = 3,      /// 超级大群
    OIMConversationTypeNotification = 4     /// 通知
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

typedef NS_ENUM(NSInteger, OIMGroupMemberFilter) {
    OIMGroupMemberFilterAll               = 0,    /// 所有，查询可用
    OIMGroupMemberFilterOwner             = 1,    /// 群主
    OIMGroupMemberFilterAdmin             = 2,    /// 群管理员
    OIMGroupMemberFilterMember            = 3,    /// 群成员
    OIMGroupMemberFilterAdminAndMember    = 4,    /// 管理员和成员
    OIMGroupMemberFilterSuperAndAdmin     = 5,    /// 群主和管理员
};

typedef NS_ENUM(NSInteger, OIMGroupMemberRole) {
    OIMGroupMemberRoleOwner     = 100,   /// 群主
    OIMGroupMemberRoleAdmin     = 60,    /// 群管理员
    OIMGroupMemberRoleMember    = 20,    /// 群成员
};

/*
 *  性别类型
 */
typedef NS_ENUM(NSInteger, OIMGender)  {
    OIMGenderMale = 1,  /// 男性
    OIMGenderFemale /// 女性
};

typedef NS_ENUM(NSInteger, OIMApplicationStatus) {
    OIMApplicationStatusDecline = -1,   /// 已拒绝
    OIMApplicationStatusNormal = 0,     /// 等待处理
    OIMApplicationStatusAccept = 1,     /// 已同意
};

typedef NS_ENUM(NSInteger, OIMRelationship) {
    OIMRelationshipBlack  = 0,
    OIMRelationshipFriend = 1
};

typedef NS_ENUM(NSInteger, OIMGroupAtType) {
    OIMGroupAtTypeAtNormal = 0,
    OIMGroupAtTypeAtMe = 1,
    OIMGroupAtTypeAtAll = 2,
    OIMGroupAtTypeAtAllAtMe = 3,
    OIMGroupAtTypeGroupNotification = 4
};

/*
 *  进群验证设置选项
 */
typedef NS_ENUM(NSInteger,  OIMGroupVerificationType) {
    OIMGroupVerificationTypeApplyNeedVerificationInviteDirectly = 0,    /// 申请需要同意 邀请直接进
    OIMGroupVerificationTypeAllNeedVerification = 1,                    /// 所有人进群需要验证，除了群主管理员邀
    OIMGroupVerificationTypeDirectly = 2,                               /// 直接进群
};

/**
 群类型
 */
typedef NS_ENUM(NSInteger, OIMGroupType) {
    OIMGroupTypeNormal = 0,     /// 普通群
    OIMGroupTypeSuper = 1,      /// 超级群
    OIMGroupTypeWorking = 2,    /// 工作群
};

/**
 群状态
 */
typedef NS_ENUM(NSInteger, OIMGroupStatus) {
    OIMGroupStatusOk = 0,       /// 正常
    OIMGroupStatusBanChat = 1,  /// 被封
    OIMGroupStatusDismissed = 2,/// 解散
    OIMGroupStatusMuted = 3,    /// 禁言
};

/**
 入群方式
 */
typedef NS_ENUM(int32_t, OIMJoinType) {
    OIMJoinTypeInvited = 2, /// 通过邀请
    OIMJoinTypeSearch = 3,  /// 通过搜索
    OIMJoinTypeQRCode = 4   /// 通过二维码
};

#endif /* IMDefine_h */
