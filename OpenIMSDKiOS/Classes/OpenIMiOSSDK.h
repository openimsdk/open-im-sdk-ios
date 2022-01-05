//
//  OpenIMModule.h
//  OpenIMUniPlugin
//
//  Created by Snow on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import "CallbackProxy.h"
#import "Message.h"
#import "SendMessageCallbackProxy.h"
#import "ConversationInfo.h"
#import "GroupInviteResult.h"
#import "GroupMembersList.h"
#import "GroupMembersInfo.h"
#import "GroupInfo.h"
#import "GroupMemberRole.h"
#import "GroupApplicationInfo.h"
#import "GroupApplicationList.h"
#import "HaveReadInfo.h"
#import "UserInfo.h"
#import "NotDisturbInfo.h"

@import OpenIMCore;

typedef enum {
    IOS = 1,
    ANDROID = 2,
    WIN = 3,
    XOS = 4,
    WEB = 5,
    MINI_WEB = 6,
} Platform;

NS_ASSUME_NONNULL_BEGIN

typedef void (^VoidCallBack)(void);
typedef void (^onConnectFailed)(long ErrCode,NSString* _Nullable ErrMsg);
typedef void (^onSelfInfoUpdated)(UserInfo* _Nullable userInfo);

typedef void(^onRecvC2CReadReceipt)(NSArray<HaveReadInfo*> *haveReadInfoList);
typedef void(^onRecvMessageRevoked)(NSString *msgId);
typedef void(^onRecvNewMessage)(Message *msg);

typedef void(^onBlackListAdd)(UserInfo *user);
typedef void(^onBlackListDeleted)(UserInfo *user);
typedef void(^onFriendApplicationListAccept)(UserInfo *user);
typedef void(^onFriendApplicationListAdded)(UserInfo *user);
typedef void(^onFriendApplicationListDeleted)(UserInfo *user);
typedef void(^onFriendApplicationListReject)(UserInfo *user);
typedef void(^onFriendInfoChanged)(UserInfo *user);
typedef void(^onFriendListAdded)(UserInfo *user);
typedef void(^onFriendListDeleted)(UserInfo *user);

typedef void(^onConversationChanged)(NSArray<ConversationInfo*> *conversationInfoList);
typedef void(^onNewConversation)(NSArray<ConversationInfo*> *conversationInfoList);
typedef void(^onSyncServerFailed)(void);
typedef void(^onSyncServerFinish)(void);
typedef void(^onSyncServerStart)(void);
typedef void(^onTotalUnreadMessageCountChanged)(int count);

typedef void(^onApplicationProcessed)(NSString *s,GroupMembersInfo *groupMembersInfo,int i,NSString *s2);
typedef void(^onGroupCreated)(NSString *s);
typedef void(^onGroupInfoChanged)(NSString *s,GroupInfo *groupInfo);
typedef void(^onMemberEnter)(NSString *s,NSArray<GroupMembersInfo*> *list);
typedef void(^onMemberInvited)(NSString *s,GroupMembersInfo *groupMembersInfo,NSArray<GroupMembersInfo*> *groupMembersInfoList);
typedef void(^onMemberKicked)(NSString *s,GroupMembersInfo *groupMembersInfo,NSArray<GroupMembersInfo*> *groupMembersInfoList);
typedef void(^onMemberLeave)(NSString *s,GroupMembersInfo *groupMembersInfo);
typedef void(^onReceiveJoinApplication)(NSString *s,GroupMembersInfo *groupMembersInfo,NSString *s2);
typedef void(^onTransferGroupOwner)(NSString *groupId,NSString *oldUserID,NSString *newUserID);

@interface OpenIMiOSSDK : NSObject <Open_im_sdkIMSDKListener, Open_im_sdkOnAdvancedMsgListener, Open_im_sdkOnFriendshipListener, Open_im_sdkOnConversationListener, Open_im_sdkOnGroupListener>

+ (instancetype)shared;

/**
  * 初始化
  *
  * @param platform 平台
  * @param ipApi    SDK的api地。如http:xxx:10000
  * @param ipWs     SDK的web socket地址。如： ws:xxx:17778
  * @param dbPath   数据存储路径
  * @param onConnecting
  *                 正在连接到服务器：onConnecting
  *                 连接服务器失败：onConnectFailed
  *                 已经成功连接到服务器：onConnectSuccess
  *                 当前用户被踢下线：onKickedOffline
  *                 登录票据已经过期：onUserTokenExpired
  *                 当前用户的资料发生了更新：onSelfInfoUpdated
  */
- (BOOL)initSDK:(Platform)platform ipApi:(NSString*)ipApi ipWs:(NSString*)ipWs dbPath:(NSString*)dbPath onConnecting:(VoidCallBack)onConnecting onConnectFailed:(onConnectFailed)onConnectFailed onConnectSuccess:(VoidCallBack)onConnectSuccess onKickedOffline:(VoidCallBack)onKickedOffline onUserTokenExpired:(VoidCallBack)onUserTokenExpired onSelfInfoUpdated:(onSelfInfoUpdated)onSelfInfoUpdated;

/**
    * 根据uid批量查询用户信息
    *
    * @param uidList 用户id列表
    * @param onSuccess    List<{@link UserInfo}>
    * @param onError
    */
- (void)getUsersInfo:(NSArray *)uidList onSuccess:(void(^)(NSArray<UserInfo*> *userInfoList))onSuccess onError:(onError)onError;

/**
   * 修改当前登录用户信息
   * <p>
   * 非null,则修改
   *
   * @param name   名称
   * @param icon   头像
   * @param gender 性别 1：男，2：女
   * @param mobile 手机号
   * @param birth  出生日期
   * @param email  邮箱
   * @param onSuccess   callback String
   * @param onError   callback String
   */
- (void)setSelfInfo:(NSString * _Nullable)name icon:(NSString*_Nullable)icon gender:(NSNumber*_Nullable)gender mobile:(NSString*_Nullable)mobile birth:(NSString*_Nullable)birth email:(NSString*_Nullable)email onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
    * 登录
    *
    * @param uid   用户ID
    *              uid来自于自身业务服务器
    * @param token 用户token
    *              token需要业务服务器根据secret向OpenIM服务端交换获取。
    * @param onSuccess  callback String
    * @param onError  callback String
    */
- (void)login:(NSString *)uid token:(NSString *)token onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
   * 登出
   *
   * @param onSuccess callback String
   * @param onError callback String
   */
- (void)logout:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 获取登录状态
 *
 * @return const (
 LoginSuccess = 101
 Logining     = 102
 LoginFailed  = 103

 LogoutCmd = 201
)
 */
- (long)getLoginStatus;

/**
 * 获取登录用户uid
 */
- (NSString *)getLoginUid;

- (UserInfo *)getLoginUser;

/**
  * 根据用户id，批量查询好友资料
  *
  * @param uidList 好友id集合
  * @param onSuccess    callback List<{@link UserInfo}>
  * @param onError callback String
  */
- (void)getFriendsInfo:(NSArray *)uidList onSuccess:(void(^)(NSArray<UserInfo*> *userList))onSuccess onError:(onError)onError;

/**
 * 添加朋友
 *
 * @param uid    对方userID
 * @param reqMessage 请求消息
 * @param onSuccess   callback String
 * @param onError   callback String
 */
- (void)addFriend:(NSString*)uid reqMessage:(NSString*)reqMessage onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
    * 好友申请列表
    *
    * @param onSuccess callback List<{@link UserInfo}>
    */
- (void)getFriendApplicationList:(void(^)(NSArray<UserInfo*>* userList))onSuccess onError:(onError)onError;

/**
  * 好友列表
  * 返回的好友里包含了已拉入黑名单的好友
  * 需要根据字段isInBlackList做筛选，isInBlackList==1 已拉入黑名单
  *
  * @param onSuccess callback List<{@link UserInfo}>
  */
- (void)getFriendList:(void(^)(NSArray<UserInfo*>* userInfoList))onSuccess onError:(onError)onError;

/**
   * 修改好友资料
   *
   * @param uid     用户id
   * @param comment 备注
   * @param onSuccess    callback String
   */
- (void)setFriendInfo:(NSString *)uid comment:(NSString*)comment onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 加入黑名单
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)addToBlackList:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
   * 黑名单
   *
   * @param onSuccess callback List<{@link UserInfo}>
   */
- (void)getBlackList:(void(^)(NSArray<UserInfo*>* userInfoList))onSuccess onError:(onError)onError;

/**
 * 从黑名单删除
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)deleteFromBlackList:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
   * 根据用户id检查好友关系
   * flag == 1 是好友
   *
   * @param uidList 用户ID列表
   * @param onSuccess    callback List<{@link UserInfo}>
   */
- (void)checkFriend:(NSArray *)uidList onSuccess:(void(^)(NSArray<UserInfo*>* userInfoList))onSuccess onError:(onError)onError;

/**
  * 接受好友请求
  *
  * @param uid  用户ID
  * @param onSuccess callback String
  */
- (void)acceptFriendApplication:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 拒绝好友申请
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)refuseFriendApplication:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 删除好友
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)deleteFromFriendList:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
   * 创建文本消息
   *
   * @param text 内容
   * @return {@link Message}
   */
- (Message *)createTextMessage:(NSString *)text;

/**
 * 创建@文本消息
 *
 * @param text      内容
 * @param atUidList 用户id列表
 * @return {@link Message}
 */
- (Message *)createTextAtMessage:(NSString *)text atUidList:(NSArray*)atUidList;

/**
 * 创建图片消息（
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将图片复制到A路径下后，如 A/pic/a.png路径，imagePath的值：“/pic/.png”
 *
 * @param imagePath 相对路径
 * @return {@link Message}
 */
- (Message *)createImageMessage:(NSString *)imagePath;

/**
 * 创建图片消息
 *
 * @param imagePath 绝对路径
 * @return {@link Message}
 */
- (Message *)createImageMessageFromFullPath:(NSString *)imagePath;

/**
 * 创建声音消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/voice/a.m4c路径，soundPath的值：“/voice/.m4c”
 *
 * @param soundPath 相对路径
 * @param duration  时长
 * @return {@link Message}
 */
- (Message *)createSoundMessage:(NSString *)soundPath duration:(NSInteger)duration;

/**
 * 创建声音消息
 *
 * @param soundPath 绝对路径
 * @param duration  时长
 * @return {@link Message}
 */
- (Message *)createSoundMessageFromFullPath:(NSString *)soundPath duration:(NSInteger)duration;

/**
 * 创建视频消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/video/a.mp4路径，soundPath的值：“/video/.mp4”
 *
 * @param videoPath    视频相对路径
 * @param videoType    mine type
 * @param duration     时长
 * @param snapshotPath 缩略图相对路径
 * @return {@link Message}
 */
- (Message *)createVideoMessage:(NSString *)videoPath videoType:(NSString *)videoType duration:(NSInteger)duration snapshotPath:(NSString *)snapshotPath;

/**
 * 创建视频消息
 *
 * @param videoPath    绝对路径
 * @param videoType    mine type
 * @param duration     时长
 * @param snapshotPath 缩略图绝对路径
 * @return {@link Message}
 */
- (Message *)createVideoMessageFromFullPath:(NSString *)videoPath videoType:(NSString *)videoType duration:(NSInteger)duration snapshotPath:(NSString *)snapshotPath;

/**
 * 创建文件消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/file/a.txt路径，soundPath的值：“/file/.txt”
 *
 * @param filePath 相对路径
 * @param fileName 文件名
 * @return {@link Message}
 */
- (Message *)createFileMessage:(NSString *)filePath fileName:(NSString *)fileName;

/**
 * 创建文件消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/file/a.txt路径，soundPath的值：“/file/.txt”
 *
 * @param filePath 绝对路径
 * @param fileName 文件名
 * @return {@link Message}
 */
- (Message *)createFileMessageFromFullPath:(NSString *)filePath fileName:(NSString *)fileName;

/**
 * 创建合并消息
 *
 * @param title       标题
 * @param summaryList 摘要
 * @param messageList 消息列表
 * @return {@link Message}
 */
- (Message *)createMergerMessage:(NSArray *)messageList title:(NSString *)title summaryList:(NSArray*)summaryList;

/**
 * 创建转发消息
 *
 * @param messageList 消息列表
 * @return {@link Message}
 */
- (Message *)createForwardMessage:(NSArray*)messageList;

/**
 * 创建位置消息
 *
 * @param latitude    经度
 * @param longitude   纬度
 * @param description 描述消息
 * @return {@link Message}
 */
- (Message *)createLocationMessage:(NSString*)description latitude:(double)latitude longitude:(double)longitude;

/**
 * 创建自定义消息
 *
 * @param data        json String
 * @param extension   json String
 * @param description 描述
 * @return {@link Message}
 */
- (Message *)createCustomMessage:(NSString*)data extension:(NSString*)extension description:(NSString*)description;

/**
 * 创建引用消息
 *
 * @param text    内容
 * @param message 被引用的消息体
 * @return {@link Message}
 */
- (Message *)createQuoteMessage:(NSString*)text message:(Message*)message;

/**
 * 发送消息
 *
 * @param message        消息体{@link Message}
 * @param recvUid        接受者用户id
 * @param recvGid        群id
 * @param onlineUserOnly 仅在线用户接受
 * @param onSuccess           callback
 *                       onProgress:消息发送进度，如图片，文件，视频等消息
 */
- (void)sendMessage:(Message *)message recvUid:(NSString *)recvUid recvGid:(NSString *)recvGid onlineUserOnly:(BOOL)onlineUserOnly onSuccess:(onSuccess)onSuccess onProgress:(void(^)(long progress))onProgress onError:(onError)onError;

/**
 * 获取历史消息
 *
 * @param userID   用户id
 * @param groupID  组ID
 * @param startMsg 从startMsg {@link Message}开始拉取消息
 *                 startMsg：如第一次拉取20条记录 startMsg=null && count=20 得到 list；
 *                 下一次拉取消息记录参数：startMsg=list.get(0) && count =20；以此内推，startMsg始终为list的第一条。
 * @param count    一次拉取count条
 * @param onSuccess     callback List<{@link Message}>
 */
- (void)getHistoryMessageList:(NSString *)userID groupID:(NSString*)groupID startMsg:(Message*_Nullable)startMsg count:(NSInteger)count onSuccess:(void(^)(NSArray<Message*>* messageList))onSuccess onError:(onError)onError;

/**
 * 撤回消息
 *
 * @param message {@link Message}
 * @param onSuccess    callback String
 *                撤回成功需要将已显示到界面的消息类型替换为revoke类型并刷新界面
 */
- (void)revokeMessage:(Message *)message onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 标记消息已读
 * 会触发userid的onRecvC2CReadReceipt方法
 *
 * @param userID        聊天对象id
 * @param messageIDList 消息clientMsgID列表
 * @param onSuccess          callback String
 */
- (void)markC2CMessageAsRead:(NSString*)userID msgIds:(NSArray*)messageIDList onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 提示对方我正在输入
 *
 * @param userID 用户ID
 * @param typing true：输入中 false：输入停止
 */
- (void)typingStatusUpdate:(NSString*)userID typing:(bool)typing;

/**
 * 删除消息
 *
 * @param message {@link Message}
 * @param onSuccess    callback String
 *                删除成功需要将已显示到界面的消息移除
 */
- (void)deleteMessageFromLocalStorage:(Message *)message onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 标记单聊会话为已读
 *
 * @param userID 单聊对象ID
 * @param onSuccess   callback String
 */
- (void)markSingleMessageHasRead:(NSString *)userID onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 插入单挑消息到本地
 *
 * @param message  {@link Message}
 * @param receiver 接收者
 * @param sender   发送者
 * @param onSuccess     callback String
 */
- (void)insertSingleMessageToLocalStorage:(Message *)message receiver:(NSString *)receiver sender:(NSString *)sender onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 根据消息id批量查询消息记录
 *
 * @param messageIDList 消息id(clientMsgID)集合
 * @param onSuccess          callback List<{@link Message}>
 */
- (void)findMessages:(NSArray *)messageIDList onSuccess:(void(^)(NSArray<Message*> *messageList))onSuccess onError:(onError)onError;

/**
 * 获取会话记录
 *
 * @param onSuccess callback List<{@link ConversationInfo}>
 */
- (void)getAllConversationList:(void(^)(NSArray<ConversationInfo*> *conversationInfoList))onSuccess on:(onError)onError;

/**
 * 获取单个会话
 *
 * @param sourceId :    聊值：UserId；聊值：GroupId
 * @param sessionType : 单聊：1；群聊：2
 * @param onSuccess         callback {@link ConversationInfo}
 */
- (void)getOneConversation:(NSString *)sourceId session:(long)sessionType onSuccess:(void(^)(ConversationInfo *conversationInfo))onSuccess onError:(onError)onError;

/**
 * 根据会话id获取多个会话
 *
 * @param conversationIDs 会话ID 集合
 * @param onSuccess            callback List<{@link ConversationInfo}>
 */
- (void)getMultipleConversation:(NSArray *)conversationIDs onSuccess:(void(^)(NSArray<ConversationInfo*> *conversationInfoList))onSuccess onError:(onError)onError;

/**
 * 删除草稿
 *
 * @param conversationID 会话ID
 * @param onSuccess           callback String
 */
- (void)deleteConversation:(NSString *)conversationID onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 设置草稿
 *
 * @param conversationID 会话ID
 * @param draft          草稿
 * @param onSuccess           callback String
 **/
- (void)setConversationDraft:(NSString *)conversationID draft:(NSString *)draft onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 置顶会话
 *
 * @param conversationID 会话ID
 * @param isPinned       true 置顶； false 取消置顶
 * @param onSuccess           callback String
 **/
- (void)pinConversation:(NSString *)conversationID isPinned:(BOOL)isPinned onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 邀请进群
 *
 * @param groupId 群组ID
 * @param uidList 被要用的用户id列表
 * @param reason  邀请说明
 * @param onSuccess    callback List<{@link GroupInviteResult}>>
 */
- (void)inviteUserToGroup:(NSString *)groupId reason:(NSString *)reason uidList:(NSArray *)uidList onSuccess:(void(^)(NSArray<GroupInviteResult*> *groupInviteResultList))onSuccess onError:(onError)onError;

/**
 * 标记群组会话已读
 *
 * @param groupID 群组ID
 * @param onSuccess    callback String
 */
- (void)markGroupMessageHasRead:(NSString*)groupID onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 踢出群
 *
 * @param groupId 群组ID
 * @param uidList 被要踢出群的用户id列表
 * @param reason  说明
 * @param onSuccess    callback List<{@link GroupInviteResult}>>
 */
- (void)kickGroupMember:(NSString *)groupId reason:(NSString *)reason uidList:(NSArray *)uidList onSuccess:(void(^)(NSArray<GroupInviteResult*> *groupInviteResultList))onSuccess onError:(onError)onError;

/**
 * 批量获取群成员信息
 *
 * @param groupId 群组ID
 * @param uidList 群成员ID
 * @param onSuccess    callback List<{@link GroupMembersInfo}>
 **/
- (void)getGroupMembersInfo:(NSString *)groupId uidList:(NSArray *)uidList onSuccess:(void(^)(NSArray<GroupMembersInfo*> *groupMembersInfoList))onSuccess onError:(onError)onError;

/**
 * 获取群成员
 *
 * @param groupId 群组ID
 * @param filter  过滤成员，0不过滤，1群的创建者，2管理员；默认值0
 * @param next    分页，从next条开始获取，默认值0。参照{@link GroupMembersList}的nextSeq字段的值。
 */
- (void)getGroupMemberList:(NSString *)groupId filter:(int)filter next:(int)next onSuccess:(void(^)(GroupMembersList *groupMembersList))onSuccess onError:(onError)onError;

/**
 * 获取已加入的群列表
 *
 * @param onSuccess callback List<{@link GroupInfo}></>
 */
- (void)getJoinedGroupList:(void(^)(NSArray<GroupInfo*> *groupInfoList))onSuccess onError:(onError)onError;

/**
 * 创建群
 *
 * @param groupName    群名称
 * @param notification 群公告
 * @param introduction 群简介
 * @param faceUrl      群icon
 * @param list         List<{@link GroupMemberRole}> 创建群是选择的成员. setRole：0:普通成员 2:管理员；1：群主
 */
- (void)createGroup:(NSString *_Nullable)groupName notification:(NSString*_Nullable)notification introduction:(NSString*_Nullable)introduction faceUrl:(NSString*_Nullable)faceUrl list:(NSArray<GroupMemberRole*> *)list onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 设置或更新群资料
 *
 * @param groupID      群ID
 * @param groupName    群名称
 * @param notification 群公告
 * @param introduction 群简介
 * @param faceUrl      群icon
 * @param onSuccess         callback String
 */
- (void)setGroupInfo:(NSString *_Nullable)groupID groupName:(NSString*_Nullable)groupName notification:(NSString*_Nullable)notification introduction:(NSString*_Nullable)introduction faceUrl:(NSString*_Nullable)faceUrl onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 批量获取群资料
 *
 * @param gidList 群ID集合
 * @param onSuccess    callback List<{@link GroupInfo}>
 */
- (void)getGroupsInfo:(NSArray *)gidList onSuccess:(void(^)(NSArray<GroupInfo*>* groupInfoList))onSuccess onError:(onError)onError;

/**
 * 申请加入群组
 *
 * @param gid    群组ID
 * @param reason 请求原因
 * @param onSuccess   callback String
 */
- (void)joinGroup:(NSString *)gid reason:(NSString *)reason onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 退群
 *
 * @param gid  群组ID
 * @param onSuccess callback String
 */
- (void)quitGroup:(NSString *)gid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 转让群主
 *
 * @param gid  群组ID
 * @param uid  被转让的用户ID
 * @param onSuccess callback String
 */
- (void)transferGroupOwner:(NSString *)gid uid:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 获取群申请列表
 *
 * @param onSuccess callback {@link GroupApplicationList}
 */
- (void)getGroupApplicationList:(void(^)(GroupApplicationList *groupApplicationList))onSuccess onError:(onError)onError;

/**
 * 接受入群申请
 *
 * @param info   getGroupApplicationList返回值的item
 * @param reason 说明
 * @param onSuccess   callback String
 */
- (void)acceptGroupApplication:(GroupApplicationInfo *)info reason:(NSString *)reason onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 拒绝入群申请
 *
 * @param info   getGroupApplicationList返回值的item
 * @param reason 说明
 * @param onSuccess   callback String
 */
- (void)refuseGroupApplication:(GroupApplicationInfo *)info reason:(NSString *)reason onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
 * 添加消息监听
 * <p>
 * 当对方撤回条消息：onRecvMessageRevoked，通过回调将界面已显示的消息替换为"xx撤回了一套消息"
 * 当对方阅读了消息：onRecvC2CReadReceipt，通过回调将已读的消息更改状态。
 * 新增消息：onRecvNewMessage，向界面添加消息
 */
- (void)addAdvancedMsgListenerWithOnRecvMessageRevoked:(onRecvMessageRevoked)onRecvMessageRevoked onRecvC2CReadReceipt:(onRecvC2CReadReceipt)onRecvC2CReadReceipt onRecvNewMessage:(onRecvNewMessage)onRecvNewMessage;

/**
 * 设置好友关系监听器
 * <p>
 * 好友被拉入黑名单回调onBlackListAdd
 * 好友从黑名单移除回调onBlackListDeleted
 * 发起的好友请求被接受时回调onFriendApplicationListAccept
 * 我接受别人的发起的好友请求时回调onFriendApplicationListAdded
 * 删除好友请求时回调onFriendApplicationListDeleted
 * 请求被拒绝回调onFriendApplicationListReject
 * 好友资料发生变化时回调onFriendInfoChanged
 * 已添加好友回调onFriendListAdded
 * 好友被删除时回调onFriendListDeleted
 **/
- (void)setFriendListenerWithonBlackListAdd:(onBlackListAdd)onBlackListAdd onBlackListDeleted:(onBlackListDeleted)onBlackListDeleted onFriendApplicationListAccept:(onFriendApplicationListAccept)onFriendApplicationListAccept onFriendApplicationListAdded:(onFriendApplicationListAdded)onFriendApplicationListAdded onFriendApplicationListDeleted:(onFriendApplicationListDeleted)onFriendApplicationListDeleted onFriendApplicationListReject:(onFriendApplicationListReject)onFriendApplicationListReject onFriendInfoChanged:(onFriendInfoChanged)onFriendInfoChanged onFriendListAdded:(onFriendListAdded)onFriendListAdded onFriendListDeleted:(onFriendListDeleted)onFriendListDeleted;

/**
 * 设置会话监听器
 * 如果会话改变，会触发onConversationChanged方法回调
 * 如果新增会话，会触发onNewConversation回调
 * 如果未读消息数改变，会触发onTotalUnreadMessageCountChanged回调
 * <p>
 * 启动app时主动拉取一次会话记录，后续会话改变可以根据监听器回调再刷新数据
 */
- (void)setConversationListenerWithonConversationChanged:(onConversationChanged)onConversationChanged onNewConversation:(onNewConversation)onNewConversation onSyncServerFailed:(onSyncServerFailed)onSyncServerFailed onSyncServerFinish:(onSyncServerFinish)onSyncServerFinish onSyncServerStart:(onSyncServerStart)onSyncServerStart onTotalUnreadMessageCountChanged:(onTotalUnreadMessageCountChanged)onTotalUnreadMessageCountChanged;

/**
 * 设置组监听器
 * <p>
 * 群申请被处理：onApplicationProcessed
 * 群创建完成：onGroupCreated
 * 群资料发生变化：onGroupInfoChanged
 * 进群：onMemberEnter
 * 接受邀请：onMemberInvited
 * 成员被踢出：onMemberKicked
 * 群成员退群：onMemberLeave
 * 收到入群申请：onReceiveJoinApplication
 */
- (void)setGroupListenerWithonApplicationProcessed:(onApplicationProcessed)onApplicationProcessed onGroupCreated:(onGroupCreated)onGroupCreated onGroupInfoChanged:(onGroupInfoChanged)onGroupInfoChanged onMemberEnter:(onMemberEnter)onMemberEnter onMemberInvited:(onMemberInvited)onMemberInvited onMemberKicked:(onMemberKicked)onMemberKicked onMemberLeave:(onMemberLeave)onMemberLeave onReceiveJoinApplication:(onReceiveJoinApplication)onReceiveJoinApplication onTransferGroupOwner:(onTransferGroupOwner)onTransferGroupOwner;

/**
 * 得到消息未读总数
 *
 * @param onSuccess String
 */
- (void)getTotalUnreadMsgCount:(onSuccess)onSuccess onError:(onError)onError;

- (void)setSdkLog:(Boolean)enable;

/**
     * 设置会话免打扰状态
     *
     * @param status 1:屏蔽消息; 2:接收消息但不提示; 0:正常
     */
- (void)setConversationRecvMessageOpt:(NSArray<NSString*>*)conversationIDs status:(long)status onSuccess:(onSuccess)onSuccess onError:(onError)onError;

/**
     * 获取会话免打扰状态
     * 1: Do not receive messages, 2: Do not notify when messages are received; 0: Normal
     * [{"conversationId":"single_13922222222","result":0}]
     */
- (void)getConversationRecvMessageOpt:(NSArray<NSString*>*)conversationIDs onSuccess:(void(^)(NSArray<NotDisturbInfo*>* notDisturbInfoList))onSuccess onError:(onError)onError;

@end

NS_ASSUME_NONNULL_END
