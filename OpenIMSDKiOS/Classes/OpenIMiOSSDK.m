//
//  OpenIMModule.m
//  OpenIMUniPlugin
//
//  Created by Snow on 2021/6/24.
//

#import "OpenIMiOSSDK.h"

@implementation NSDictionary (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end


@implementation NSArray (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

- (NSDictionary *)dict {
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:[[self json] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
}

@end

@implementation NSString (Extensions)

- (NSString *)json {
    return [NSString stringWithFormat:@"\"%@\"",self];
}

- (NSDictionary*)dict {
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
}

- (NSArray*)array {
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
}

@end

@interface OpenIMiOSSDK() {
    VoidCallBack _onConnecting;
    onConnectFailed _onConnectFailed;
    VoidCallBack _onConnectSuccess;
    VoidCallBack _onKickedOffline;
    VoidCallBack _onUserTokenExpired;
    onSelfInfoUpdated _onSelfInfoUpdated;
    
    onRecvC2CReadReceipt _onRecvC2CReadReceipt;
    onRecvMessageRevoked _onRecvMessageRevoked;
    onRecvNewMessage _onRecvNewMessage;
    
    onBlackListAdd _onBlackListAdd;
    onBlackListDeleted _onBlackListDeleted;
    onFriendApplicationListAccept _onFriendApplicationListAccept;
    onFriendApplicationListAdded _onFriendApplicationListAdded;
    onFriendApplicationListDeleted _onFriendApplicationListDeleted;
    onFriendApplicationListReject _onFriendApplicationListReject;
    onFriendInfoChanged _onFriendInfoChanged;
    onFriendListAdded _onFriendListAdded;
    onFriendListDeleted _onFriendListDeleted;
    
    onConversationChanged _onConversationChanged;
    onNewConversation _onNewConversation;
    onSyncServerFailed _onSyncServerFailed;
    onSyncServerFinish _onSyncServerFinish;
    onSyncServerStart _onSyncServerStart;
    onTotalUnreadMessageCountChanged _onTotalUnreadMessageCountChanged;
    
    onApplicationProcessed _onApplicationProcessed;
    onGroupCreated _onGroupCreated;
    onGroupInfoChanged _onGroupInfoChanged;
    onMemberEnter _onMemberEnter;
    onMemberInvited _onMemberInvited;
    onMemberKicked _onMemberKicked;
    onMemberLeave _onMemberLeave;
    onReceiveJoinApplication _onReceiveJoinApplication;
    onTransferGroupOwner _onTransferGroupOwner;
}

@end

@implementation OpenIMiOSSDK

+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        Open_im_sdkSetFriendListener(self);
        Open_im_sdkSetConversationListener(self);
        Open_im_sdkSetGroupListener(self);
        Open_im_sdkAddAdvancedMsgListener(self);
    }
    return self;
}

// MARK: - Init

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
- (BOOL)initSDK:(Platform)platform ipApi:(NSString*)ipApi ipWs:(NSString*)ipWs dbPath:(NSString*)dbPath onConnecting:(VoidCallBack)onConnecting onConnectFailed:(onConnectFailed)onConnectFailed onConnectSuccess:(VoidCallBack)onConnectSuccess onKickedOffline:(VoidCallBack)onKickedOffline onUserTokenExpired:(VoidCallBack)onUserTokenExpired onSelfInfoUpdated:(onSelfInfoUpdated)onSelfInfoUpdated{
    
    _onConnecting = [onConnecting copy];
    _onConnectFailed = [onConnectFailed copy];
    _onConnectSuccess = [onConnectSuccess copy];
    _onKickedOffline = [onKickedOffline copy];
    _onUserTokenExpired = [onUserTokenExpired copy];
    _onSelfInfoUpdated = [onSelfInfoUpdated copy];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"platform"] = @(platform);
    if(ipApi != nil) {
        param[@"ipApi"] = ipApi;
    }
    if(ipWs != nil) {
        param[@"ipWs"] = ipWs;
    }
    if(dbPath != nil) {
        param[@"dbDir"] = dbPath;
    }
    return Open_im_sdkInitSDK([param json], self);
}

// MARK: - Open_im_sdkIMSDKListener

- (void)onConnectFailed:(long)ErrCode ErrMsg:(NSString* _Nullable)ErrMsg {
    _onConnectFailed ? _onConnectFailed(ErrCode,ErrMsg) : nil;
}

- (void)onConnectSuccess {
    _onConnectSuccess ? _onConnectSuccess() : nil;
}

- (void)onConnecting {
    _onConnecting ? _onConnecting() : nil;
}

- (void)onKickedOffline {
    _onKickedOffline ? _onKickedOffline() : nil;
}

- (void)onSelfInfoUpdated:(NSString* _Nullable)userInfo {
    _onSelfInfoUpdated ? _onSelfInfoUpdated([[UserInfo alloc] initWithDictionary:[userInfo dict]]) : nil;
}

- (void)onUserTokenExpired {
    _onUserTokenExpired ? _onUserTokenExpired() : nil;
}

// MARK: - User

/**
    * 根据uid批量查询用户信息
    *
    * @param uidList 用户id列表
    * @param onSuccess    List<{@link UserInfo}>
    * @param onError
    */
- (void)getUsersInfo:(NSArray *)uidList onSuccess:(void(^)(NSArray<UserInfo*> *userInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *uList = [data array];
        NSMutableArray *userList = [NSMutableArray new];
        for (NSDictionary *dt in uList) {
            [userList addObject:[[UserInfo alloc] initWithDictionary:dt]];
        }
        onSuccess ? onSuccess(userList) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    Open_im_sdkGetUsersInfo([uidList json], proxy);
}

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
- (void)setSelfInfo:(NSString *)name icon:(NSString*)icon gender:(NSNumber*)gender mobile:(NSString*)mobile birth:(NSString*)birth email:(NSString*)email onSuccess:(onSuccess)onSuccess onError:(onError)onError{
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess ? onSuccess(data) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if(name != nil) {
        param[@"name"] = name;
    }
    if(icon != nil) {
        param[@"icon"] = icon;
    }
    if(gender != nil) {
        param[@"gender"] = gender;
    }
    if(mobile != nil) {
        param[@"mobile"] = mobile;
    }
    if(birth != nil) {
        param[@"birth"] = birth;
    }
    if(email != nil) {
        param[@"email"] = email;
    }
    Open_im_sdkSetSelfInfo([param json], proxy);
}


// MARK: - Login

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
- (void)login:(NSString *)uid token:(NSString *)token onSuccess:(onSuccess)onSuccess onError:(onError)onError{
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess ? onSuccess(data) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    Open_im_sdkLogin(uid, token, proxy);
}

- (void)forceReConn {
//    Open_im_sdkForceReConn();
}

/**
   * 登出
   *
   * @param onSuccess callback String
   * @param onError callback String
   */
- (void)logout:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess ? onSuccess(data) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    Open_im_sdkLogout(proxy);
}

/**
 * 获取登录状态
 *
 * @return 1:success
 */
- (long)getLoginStatus {
    return Open_im_sdkGetLoginStatus();
}

    /**
     * 获取登录用户uid
     */
- (NSString *)getLoginUid {
    return Open_im_sdkGetLoginUser();
}

- (UserInfo *)getLoginUser {
    NSString *json = Open_im_sdkGetLoginUser();
    return [[UserInfo alloc] initWithDictionary:[json dict]];
}


// MARK: - Friend

/**
  * 根据用户id，批量查询好友资料
  *
  * @param uidList 好友id集合
  * @param onSuccess    callback List<{@link UserInfo}>
  * @param onError callback String
  */
- (void)getFriendsInfo:(NSArray *)uidList onSuccess:(void(^)(NSArray<UserInfo*>* userList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSMutableArray *userList = [NSMutableArray new];
        NSArray* jsonList = [data array];
        for (NSDictionary* dt in jsonList) {
            [userList addObject:[[UserInfo alloc] initWithDictionary:dt]];
        }
        onSuccess ? onSuccess(userList) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    Open_im_sdkGetFriendsInfo(proxy, [uidList json]);
}

/**
 * 添加朋友
 *
 * @param uid    对方userID
 * @param reqMessage 请求消息
 * @param onSuccess   callback String
 * @param onError   callback String
 */
- (void)addFriend:(NSString*)uid reqMessage:(NSString*)reqMessage onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess ? onSuccess(data) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if(uid != nil) {
        param[@"uid"] = uid;
    }
    if(reqMessage != nil) {
        param[@"reqMessage"] = reqMessage;
    }
    Open_im_sdkAddFriend(proxy, [param json]);
}

/**
    * 好友申请列表
    *
    * @param onSuccess callback List<{@link UserInfo}>
    */
- (void)getFriendApplicationList:(void(^)(NSArray<UserInfo*>* userList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *JsonList = [data array];
        NSMutableArray *userList = [NSMutableArray new];
        for (NSDictionary* dt in JsonList) {
            [userList addObject:[[UserInfo alloc] initWithDictionary:dt]];
        }
        onSuccess ? onSuccess(userList) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    Open_im_sdkGetFriendApplicationList(proxy);
}

/**
  * 好友列表
  * 返回的好友里包含了已拉入黑名单的好友
  * 需要根据字段isInBlackList做筛选，isInBlackList==1 已拉入黑名单
  *
  * @param onSuccess callback List<{@link UserInfo}>
  */
- (void)getFriendList:(void(^)(NSArray<UserInfo*>* userInfoList))onSuccess onError:(onError)onError{
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *userList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [userList addObject:[[UserInfo alloc] initWithDictionary:dt]];
        }
        onSuccess ? onSuccess(userList) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg)  : nil;
    }];
    Open_im_sdkGetFriendList(proxy);
}

/**
   * 修改好友资料
   *
   * @param uid     用户id
   * @param comment 备注
   * @param onSuccess    callback String
   */
- (void)setFriendInfo:(NSString *)uid comment:(NSString*)comment onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess ? onSuccess(data) : nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError ? onError(ErrCode,ErrMsg) : nil;
    }];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if(uid != nil) {
        param[@"uid"] = uid;
    }
    if(comment != nil) {
        param[@"comment"] = comment;
    }
    Open_im_sdkSetFriendInfo([param json], proxy);
}

/**
 * 加入黑名单
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)addToBlackList:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkAddToBlackList(proxy, [uid json]);
}

/**
   * 黑名单
   *
   * @param onSuccess callback List<{@link UserInfo}>
   */
- (void)getBlackList:(void(^)(NSArray<UserInfo*>* userInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *userList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [userList addObject:[[UserInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(userList):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkGetBlackList(proxy);
}

/**
 * 从黑名单删除
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)deleteFromBlackList:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkDeleteFromBlackList(proxy, [uid json]);
}

/**
   * 根据用户id检查好友关系
   * flag == 1 是好友
   *
   * @param uidList 用户ID列表
   * @param onSuccess    callback List<{@link UserInfo}>
   */
- (void)checkFriend:(NSArray *)uidList onSuccess:(void(^)(NSArray<UserInfo*>* userInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonLiat = [data array];
        NSMutableArray *userList = [NSMutableArray new];
        for (NSDictionary *dt in jsonLiat) {
            [userList addObject:[[UserInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(userList):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkCheckFriend(proxy, [uidList json]);
}

/**
  * 接受好友请求
  *
  * @param uid  用户ID
  * @param onSuccess callback String
  */
- (void)acceptFriendApplication:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkAcceptFriendApplication(proxy, [uid json]);
}

/**
 * 拒绝好友申请
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)refuseFriendApplication:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkRefuseFriendApplication(proxy, [uid json]);
}

/**
 * 删除好友
 *
 * @param uid  用户ID
 * @param onSuccess callback String
 */
- (void)deleteFromFriendList:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkDeleteFromFriendList([uid json], proxy);
}


// MARK: - Message

/**
   * 创建文本消息
   *
   * @param text 内容
   * @return {@link Message}
   */
- (Message *)createTextMessage:(NSString *)text {
    NSString *json = Open_im_sdkCreateTextMessage(text);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建@文本消息
 *
 * @param text      内容
 * @param atUidList 用户id列表
 * @return {@link Message}
 */
- (Message *)createTextAtMessage:(NSString *)text atUidList:(NSArray*)atUidList {
    NSString *json = Open_im_sdkCreateTextAtMessage(text, [atUidList json]);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建图片消息（
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将图片复制到A路径下后，如 A/pic/a.png路径，imagePath的值：“/pic/.png”
 *
 * @param imagePath 相对路径
 * @return {@link Message}
 */
- (Message *)createImageMessage:(NSString *)imagePath {
    NSString *json = Open_im_sdkCreateImageMessage(imagePath);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建图片消息
 *
 * @param imagePath 绝对路径
 * @return {@link Message}
 */
- (Message *)createImageMessageFromFullPath:(NSString *)imagePath {
    NSString *json = Open_im_sdkCreateImageMessageFromFullPath(imagePath);
    return [[Message alloc] initWithDictionary:[json dict]];
}

//- (NSString *)createImageMessageByURL:(NSDictionary *)args0 args1:(NSDictionary *)args1  args2:(NSDictionary *)args2 {
//    return Open_im_sdkCreateImageMessageByURL([args0 json], [args1 json], [args2 json]);
//}

/**
 * 创建声音消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/voice/a.m4c路径，soundPath的值：“/voice/.m4c”
 *
 * @param soundPath 相对路径
 * @param duration  时长
 * @return {@link Message}
 */
- (Message *)createSoundMessage:(NSString *)soundPath duration:(NSInteger)duration {
    NSString *json = Open_im_sdkCreateSoundMessage(soundPath, duration);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建声音消息
 *
 * @param soundPath 绝对路径
 * @param duration  时长
 * @return {@link Message}
 */
- (Message *)createSoundMessageFromFullPath:(NSString *)soundPath duration:(NSInteger)duration {
    NSString *json = Open_im_sdkCreateSoundMessageFromFullPath(soundPath, duration);
    return [[Message alloc] initWithDictionary:[json dict]];
}

//- (NSString *)createSoundMessageByURL:(NSDictionary *)args0 {
//    return Open_im_sdkCreateSoundMessageByURL([args0 json]);
//}

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
- (Message *)createVideoMessage:(NSString *)videoPath videoType:(NSString *)videoType duration:(NSInteger)duration snapshotPath:(NSString *)snapshotPath {
    NSString *json = Open_im_sdkCreateVideoMessage(videoPath, videoType, duration, snapshotPath);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建视频消息
 *
 * @param videoPath    绝对路径
 * @param videoType    mine type
 * @param duration     时长
 * @param snapshotPath 缩略图绝对路径
 * @return {@link Message}
 */
- (Message *)createVideoMessageFromFullPath:(NSString *)videoPath videoType:(NSString *)videoType duration:(NSInteger)duration snapshotPath:(NSString *)snapshotPath {
    NSString *json = Open_im_sdkCreateVideoMessageFromFullPath(videoPath, videoType, duration, snapshotPath);
    return [[Message alloc] initWithDictionary:[json dict]];
}

//- (NSString *)createVideoMessageByURL:(NSDictionary *)args0 {
//    return Open_im_sdkCreateVideoMessageByURL([args0 json]);
//}

/**
 * 创建文件消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/file/a.txt路径，soundPath的值：“/file/.txt”
 *
 * @param filePath 相对路径
 * @param fileName 文件名
 * @return {@link Message}
 */
- (Message *)createFileMessage:(NSString *)filePath fileName:(NSString *)fileName {
    NSString *json = Open_im_sdkCreateFileMessage(filePath, fileName);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建文件消息
 * initSDK时传入了数据缓存路径，如路径：A，这时需要你将声音文件复制到A路径下后，如 A/file/a.txt路径，soundPath的值：“/file/.txt”
 *
 * @param filePath 绝对路径
 * @param fileName 文件名
 * @return {@link Message}
 */
- (Message *)createFileMessageFromFullPath:(NSString *)filePath fileName:(NSString *)fileName {
    NSString *json = Open_im_sdkCreateFileMessageFromFullPath(filePath, fileName);
    return [[Message alloc] initWithDictionary:[json dict]];
}

//- (NSString *)createFileMessageByURL:(NSDictionary *)args0 {
//    return Open_im_sdkCreateFileMessageByURL([args0 json]);
//}

/**
 * 创建合并消息
 *
 * @param title       标题
 * @param summaryList 摘要
 * @param messageList 消息列表
 * @return {@link Message}
 */
- (Message *)createMergerMessage:(NSArray *)messageList title:(NSString *)title summaryList:(NSArray*)summaryList {
    NSString *json = Open_im_sdkCreateMergerMessage([messageList json], title, [summaryList json]);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建转发消息
 *
 * @param messageList 消息列表
 * @return {@link Message}
 */
- (Message *)createForwardMessage:(NSArray*)messageList {
    NSString *json = Open_im_sdkCreateForwardMessage([messageList json]);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建位置消息
 *
 * @param latitude    经度
 * @param longitude   纬度
 * @param description 描述消息
 * @return {@link Message}
 */
- (Message *)createLocationMessage:(NSString*)description latitude:(double)latitude longitude:(double)longitude {
    NSString *json = Open_im_sdkCreateLocationMessage(description, longitude, latitude);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建自定义消息
 *
 * @param data        json String
 * @param extension   json String
 * @param description 描述
 * @return {@link Message}
 */
- (Message *)createCustomMessage:(NSString*)data extension:(NSString*)extension description:(NSString*)description {
    NSString *json = Open_im_sdkCreateCustomMessage(data, extension, description);
    return [[Message alloc] initWithDictionary:[json dict]];
}

/**
 * 创建引用消息
 *
 * @param text    内容
 * @param message 被引用的消息体
 * @return {@link Message}
 */
- (Message *)createQuoteMessage:(NSString*)text message:(Message*)message {
    NSString *json = Open_im_sdkCreateQuoteMessage(text, [[message dict] json]);
    return [[Message alloc] initWithDictionary:[json dict]];
}

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
- (void)sendMessage:(Message *)message recvUid:(NSString *)recvUid recvGid:(NSString *)recvGid onlineUserOnly:(BOOL)onlineUserOnly onSuccess:(onSuccess)onSuccess onProgress:(void(^)(long progress))onProgress onError:(onError)onError {
    SendMessageCallbackProxy *proxy = [[SendMessageCallbackProxy alloc] initWithMessage:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onProgress:^(long progress) {
        onProgress?onProgress(progress):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkSendMessage(proxy, [[message dict] json], recvUid, recvGid, onlineUserOnly);
}

//- (NSString *)sendMessageNotOss:(NSString *)args0 args1:(NSString *)args1 args2:(NSString *)args2 args3:(BOOL)args3 {
//    SendMessageCallbackProxy *proxy = [[SendMessageCallbackProxy alloc] initWithMessage:args0 module:self];
//    return Open_im_sdkSendMessageNotOss(proxy, args0, args1, args2, args3);
//}

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
- (void)getHistoryMessageList:(NSString *)userID groupID:(NSString*)groupID startMsg:(Message*)startMsg count:(NSInteger)count onSuccess:(void(^)(NSArray<Message*>* messageList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[Message alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if(userID != nil) {
        param[@"userID"] = userID;
    }
    if(groupID != nil) {
        param[@"groupID"] = groupID;
    }
    if(startMsg != nil) {
        param[@"startMsg"] = [startMsg dict];
    }
    param[@"count"] = @(count);
    Open_im_sdkGetHistoryMessageList(proxy, [param json]);
}

/**
 * 撤回消息
 *
 * @param message {@link Message}
 * @param onSuccess    callback String
 *                撤回成功需要将已显示到界面的消息类型替换为revoke类型并刷新界面
 */
- (void)revokeMessage:(Message *)message onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkRevokeMessage(proxy, [[message dict] json]);
}

/**
 * 标记消息已读
 * 会触发userid的onRecvC2CReadReceipt方法
 *
 * @param userID        聊天对象id
 * @param messageIDList 消息clientMsgID列表
 * @param onSuccess          callback String
 */
- (void)markC2CMessageAsRead:(NSString*)userID msgIds:(NSArray*)messageIDList onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkMarkC2CMessageAsRead(proxy, userID, [messageIDList json]);
}

/**
 * 提示对方我正在输入
 *
 * @param userID 用户ID
 * @param typing true：输入中 false：输入停止
 */
- (void)typingStatusUpdate:(NSString*)userID typing:(bool)typing {
    Open_im_sdkTypingStatusUpdate(userID, typing ? @"YES" : @"NO");
}

/**
 * 删除消息
 *
 * @param message {@link Message}
 * @param onSuccess    callback String
 *                删除成功需要将已显示到界面的消息移除
 */
- (void)deleteMessageFromLocalStorage:(Message *)message onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkDeleteMessageFromLocalStorage(proxy, [[message dict] json]);
}

/**
 * 标记单聊会话为已读
 *
 * @param userID 单聊对象ID
 * @param onSuccess   callback String
 */
- (void)markSingleMessageHasRead:(NSString *)userID onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkMarkSingleMessageHasRead(proxy, userID);
}

/**
 * 插入单挑消息到本地
 *
 * @param message  {@link Message}
 * @param receiver 接收者
 * @param sender   发送者
 * @param onSuccess     callback String
 */
- (void)insertSingleMessageToLocalStorage:(Message *)message receiver:(NSString *)receiver sender:(NSString *)sender onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess(data):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkInsertSingleMessageToLocalStorage(proxy, [[message dict] json], receiver, sender);
}

/**
 * 根据消息id批量查询消息记录
 *
 * @param messageIDList 消息id(clientMsgID)集合
 * @param onSuccess          callback List<{@link Message}>
 */
- (void)findMessages:(NSArray *)messageIDList onSuccess:(void(^)(NSArray<Message*> *messageList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[Message alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:^(long ErrCode, NSString * _Nullable ErrMsg) {
        onError?onError(ErrCode,ErrMsg):nil;
    }];
    Open_im_sdkFindMessages(proxy, [messageIDList json]);
}

// MARK: - Conversation

/**
 * 获取会话记录
 *
 * @param onSuccess callback List<{@link ConversationInfo}>
 */
- (void)getAllConversationList:(void(^)(NSArray<ConversationInfo*> *conversationInfoList))onSuccess on:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[ConversationInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkGetAllConversationList(proxy);
}

/**
 * 获取单个会话
 *
 * @param sourceId :    聊值：UserId；聊值：GroupId
 * @param sessionType : 单聊：1；群聊：2
 * @param onSuccess         callback {@link ConversationInfo}
 */
- (void)getOneConversation:(NSString *)sourceId session:(long)sessionType onSuccess:(void(^)(ConversationInfo *conversationInfo))onSuccess onError:(onError)onError{
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        ConversationInfo *conversationInfo = [[ConversationInfo alloc] initWithDictionary:[data dict]];
        onSuccess?onSuccess(conversationInfo):nil;
    } onError:onError];
    Open_im_sdkGetOneConversation(sourceId, sessionType, proxy);
}

/**
 * 根据会话id获取多个会话
 *
 * @param conversationIDs 会话ID 集合
 * @param onSuccess            callback List<{@link ConversationInfo}>
 */
- (void)getMultipleConversation:(NSArray *)conversationIDs onSuccess:(void(^)(NSArray<ConversationInfo*> *conversationInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[ConversationInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkGetMultipleConversation([conversationIDs json], proxy);
}

/**
 * 删除草稿
 *
 * @param conversationID 会话ID
 * @param onSuccess           callback String
 */
- (void)deleteConversation:(NSString *)conversationID onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkDeleteConversation(conversationID, proxy);
}

/**
 * 设置草稿
 *
 * @param conversationID 会话ID
 * @param draft          草稿
 * @param onSuccess           callback String
 **/
- (void)setConversationDraft:(NSString *)conversationID draft:(NSString *)draft onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkSetConversationDraft(conversationID, draft, proxy);
}

/**
 * 置顶会话
 *
 * @param conversationID 会话ID
 * @param isPinned       true 置顶； false 取消置顶
 * @param onSuccess           callback String
 **/
- (void)pinConversation:(NSString *)conversationID isPinned:(BOOL)isPinned onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkPinConversation(conversationID, isPinned, proxy);
}

/**
 * 得到消息未读总数
 *
 * @param onSuccess String
 */
- (void)getTotalUnreadMsgCount:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkGetTotalUnreadMsgCount(proxy);
}

// MARK: - Group

/**
 * 邀请进群
 *
 * @param groupId 群组ID
 * @param uidList 被要用的用户id列表
 * @param reason  邀请说明
 * @param onSuccess    callback List<{@link GroupInviteResult}>>
 */
- (void)inviteUserToGroup:(NSString *)groupId reason:(NSString *)reason uidList:(NSArray *)uidList onSuccess:(void(^)(NSArray<GroupInviteResult*> *groupInviteResultList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[GroupInviteResult alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkInviteUserToGroup(groupId, reason, [uidList json], proxy);
}

/**
 * 标记群组会话已读
 *
 * @param groupID 群组ID
 * @param onSuccess    callback String
 */
- (void)markGroupMessageHasRead:(NSString*)groupID onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkMarkGroupMessageHasRead(proxy, groupID);
}

/**
 * 踢出群
 *
 * @param groupId 群组ID
 * @param uidList 被要踢出群的用户id列表
 * @param reason  说明
 * @param onSuccess    callback List<{@link GroupInviteResult}>>
 */
- (void)kickGroupMember:(NSString *)groupId reason:(NSString *)reason uidList:(NSArray *)uidList onSuccess:(void(^)(NSArray<GroupInviteResult*> *groupInviteResultList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[GroupInviteResult alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkKickGroupMember(groupId, reason, [uidList json], proxy);
}

/**
 * 批量获取群成员信息
 *
 * @param groupId 群组ID
 * @param uidList 群成员ID
 * @param onSuccess    callback List<{@link GroupMembersInfo}>
 **/
- (void)getGroupMembersInfo:(NSString *)groupId uidList:(NSArray *)uidList onSuccess:(void(^)(NSArray<GroupMembersInfo*> *groupMembersInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[GroupMembersInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkGetGroupMembersInfo(groupId, [uidList json], proxy);
}

/**
 * 获取群成员
 *
 * @param groupId 群组ID
 * @param filter  过滤成员，0不过滤，1群的创建者，2管理员；默认值0
 * @param next    分页，从next条开始获取，默认值0。参照{@link GroupMembersList}的nextSeq字段的值。
 */
- (void)getGroupMemberList:(NSString *)groupId filter:(int)filter next:(int)next onSuccess:(void(^)(GroupMembersList *groupMembersList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess([[GroupMembersList alloc] initWithDictionary:[data dict]]):nil;
    } onError:onError];
    Open_im_sdkGetGroupMemberList(groupId, filter, next, proxy);
}

/**
 * 获取已加入的群列表
 *
 * @param onSuccess callback List<{@link GroupInfo}></>
 */
- (void)getJoinedGroupList:(void(^)(NSArray<GroupInfo*> *groupInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[GroupInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkGetJoinedGroupList(proxy);
}

/**
 * 创建群
 *
 * @param groupName    群名称
 * @param notification 群公告
 * @param introduction 群简介
 * @param faceUrl      群icon
 * @param list         List<{@link GroupMemberRole}> 创建群是选择的成员. setRole：0:普通成员 2:管理员；1：群主
 */
- (void)createGroup:(NSString *)groupName notification:(NSString*)notification introduction:(NSString*)introduction faceUrl:(NSString*)faceUrl list:(NSArray *)list onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if(groupName != nil) {
        param[@"groupName"] = groupName;
    }
    if(notification != nil) {
        param[@"notification"] = notification;
    }
    if(introduction != nil) {
        param[@"introduction"] = introduction;
    }
    if(faceUrl != nil) {
        param[@"faceUrl"] = faceUrl;
    }
    Open_im_sdkCreateGroup([param json], [list json], proxy);
}

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
- (void)setGroupInfo:(NSString *)groupID groupName:(NSString*)groupName notification:(NSString*)notification introduction:(NSString*)introduction faceUrl:(NSString*)faceUrl onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    NSMutableDictionary *param = [NSMutableDictionary new];
    if(groupID != nil) {
        param[@"groupID"] = groupID;
    }
    if(groupName != nil) {
        param[@"groupName"] = groupName;
    }
    if(notification != nil) {
        param[@"notification"] = notification;
    }
    if(introduction != nil) {
        param[@"introduction"] = introduction;
    }
    if(faceUrl != nil) {
        param[@"faceUrl"] = faceUrl;
    }
    Open_im_sdkSetGroupInfo([param json], proxy);
}

/**
 * 批量获取群资料
 *
 * @param gidList 群ID集合
 * @param onSuccess    callback List<{@link GroupInfo}>
 */
- (void)getGroupsInfo:(NSArray *)gidList onSuccess:(void(^)(NSArray<GroupInfo*>* groupInfoList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        NSArray *jsonList = [data array];
        NSMutableArray *msgList = [NSMutableArray new];
        for (NSDictionary *dt in jsonList) {
            [msgList addObject:[[GroupInfo alloc] initWithDictionary:dt]];
        }
        onSuccess?onSuccess(msgList):nil;
    } onError:onError];
    Open_im_sdkGetGroupsInfo([gidList json], proxy);
}

/**
 * 申请加入群组
 *
 * @param gid    群组ID
 * @param reason 请求原因
 * @param onSuccess   callback String
 */
- (void)joinGroup:(NSString *)gid reason:(NSString *)reason onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkJoinGroup(gid, reason, proxy);
}

/**
 * 退群
 *
 * @param gid  群组ID
 * @param onSuccess callback String
 */
- (void)quitGroup:(NSString *)gid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkQuitGroup(gid, proxy);
}

/**
 * 转让群主
 *
 * @param gid  群组ID
 * @param uid  被转让的用户ID
 * @param onSuccess callback String
 */
- (void)transferGroupOwner:(NSString *)gid uid:(NSString *)uid onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkTransferGroupOwner(gid, uid, proxy);
}

/**
 * 获取群申请列表
 *
 * @param onSuccess callback {@link GroupApplicationList}
 */
- (void)getGroupApplicationList:(void(^)(GroupApplicationList *groupApplicationList))onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:^(NSString * _Nullable data) {
        onSuccess?onSuccess([[GroupApplicationList alloc] initWithDictionary:[data dict]]):nil;
    } onError:onError];
    Open_im_sdkGetGroupApplicationList(proxy);
}

/**
 * 接受入群申请
 *
 * @param info   getGroupApplicationList返回值的item
 * @param reason 说明
 * @param onSuccess   callback String
 */
- (void)acceptGroupApplication:(GroupApplicationInfo *)info reason:(NSString *)reason onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkAcceptGroupApplication([[info dict] json], reason, proxy);
}

/**
 * 拒绝入群申请
 *
 * @param info   getGroupApplicationList返回值的item
 * @param reason 说明
 * @param onSuccess   callback String
 */
- (void)refuseGroupApplication:(GroupApplicationInfo *)info reason:(NSString *)reason onSuccess:(onSuccess)onSuccess onError:(onError)onError {
    CallbackProxy *proxy = [[CallbackProxy alloc] initWithCallback:onSuccess onError:onError];
    Open_im_sdkRefuseGroupApplication([[info dict] json], reason, proxy);
}

// MARK: - Open_im_sdkOnAdvancedMsgListener

/**
 * 添加消息监听
 * <p>
 * 当对方撤回条消息：onRecvMessageRevoked，通过回调将界面已显示的消息替换为"xx撤回了一套消息"
 * 当对方阅读了消息：onRecvC2CReadReceipt，通过回调将已读的消息更改状态。
 * 新增消息：onRecvNewMessage，向界面添加消息
 */
- (void)addAdvancedMsgListenerWithOnRecvMessageRevoked:(onRecvMessageRevoked)onRecvMessageRevoked onRecvC2CReadReceipt:(onRecvC2CReadReceipt)onRecvC2CReadReceipt onRecvNewMessage:(onRecvNewMessage)onRecvNewMessage{
    _onRecvMessageRevoked = [onRecvMessageRevoked copy];
    _onRecvC2CReadReceipt = [onRecvC2CReadReceipt copy];
    _onRecvNewMessage = [onRecvNewMessage copy];
    Open_im_sdkAddAdvancedMsgListener(self);
}

///**
// * 移除消息监听
// */
//- (void)removeAdvancedMsgListener {
//    Open_im_sdkRemoveAdvancedMsgListener(self);
//}

- (void)onRecvC2CReadReceipt:(NSString* _Nullable)msgReceiptList {
    NSArray *jsonList = [msgReceiptList array];
    NSMutableArray *haveReadInfoList = [NSMutableArray new];
    for (NSDictionary *dt in jsonList) {
        [haveReadInfoList addObject:[[HaveReadInfo alloc] initWithDictionary:dt]];
    }
    if(_onRecvC2CReadReceipt != nil) {
        _onRecvC2CReadReceipt(haveReadInfoList);
    }
}

- (void)onRecvMessageRevoked:(NSString* _Nullable)msgId {
    if(_onRecvMessageRevoked != nil) {
        _onRecvMessageRevoked(msgId);
    }
}

- (void)onRecvNewMessage:(NSString* _Nullable)message {
    if(_onRecvNewMessage != nil) {
        _onRecvNewMessage([[Message alloc] initWithDictionary:[message dict]]);
    }
}


// MARK: - Open_im_sdkOnFriendshipListener

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
- (void)setFriendListenerWithonBlackListAdd:(onBlackListAdd)onBlackListAdd onBlackListDeleted:(onBlackListDeleted)onBlackListDeleted onFriendApplicationListAccept:(onFriendApplicationListAccept)onFriendApplicationListAccept onFriendApplicationListAdded:(onFriendApplicationListAdded)onFriendApplicationListAdded onFriendApplicationListDeleted:(onFriendApplicationListDeleted)onFriendApplicationListDeleted onFriendApplicationListReject:(onFriendApplicationListReject)onFriendApplicationListReject onFriendInfoChanged:(onFriendInfoChanged)onFriendInfoChanged onFriendListAdded:(onFriendListAdded)onFriendListAdded onFriendListDeleted:(onFriendListDeleted)onFriendListDeleted {
    _onBlackListAdd = [onBlackListAdd copy];
    _onBlackListDeleted = [onBlackListDeleted copy];
    _onFriendApplicationListAccept = [onFriendApplicationListAccept copy];
    _onFriendApplicationListAdded = [onFriendApplicationListAdded copy];
    _onFriendApplicationListDeleted = [onFriendApplicationListDeleted copy];
    _onFriendApplicationListReject = [onFriendApplicationListReject copy];
    _onFriendInfoChanged = [onFriendInfoChanged copy];
    _onFriendListAdded = [onFriendListAdded copy];
    _onFriendListDeleted = [onFriendListDeleted copy];
    Open_im_sdkSetFriendListener(self);
}

- (void)onBlackListAdd:(NSString* _Nullable)info {
    if(_onBlackListAdd != nil) {
        _onBlackListAdd([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onBlackListDeleted:(NSString* _Nullable)info {
    if(_onBlackListDeleted != nil) {
        _onBlackListDeleted([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendApplicationListAccept:(NSString* _Nullable)info {
    if(_onFriendApplicationListAccept != nil) {
        _onFriendApplicationListAccept([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendApplicationListAdded:(NSString* _Nullable)info {
    if(_onFriendApplicationListAdded != nil) {
        _onFriendApplicationListAdded([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendApplicationListDeleted:(NSString* _Nullable)info {
    if(_onFriendApplicationListDeleted != nil) {
        _onFriendApplicationListDeleted([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendApplicationListReject:(NSString* _Nullable)info {
    if(_onFriendApplicationListReject != nil) {
        _onFriendApplicationListReject([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendInfoChanged:(NSString* _Nullable)info {
    if(_onFriendInfoChanged != nil) {
        _onFriendInfoChanged([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendListAdded:(NSString* _Nullable)info {
    if(_onFriendListAdded != nil) {
        _onFriendListAdded([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}

- (void)onFriendListDeleted:(NSString* _Nullable)info {
    if(_onFriendListDeleted != nil) {
        _onFriendListDeleted([[UserInfo alloc] initWithDictionary:[info dict]]);
    }
}


// MARK: - Open_im_sdkOnConversationListener

/**
 * 设置会话监听器
 * 如果会话改变，会触发onConversationChanged方法回调
 * 如果新增会话，会触发onNewConversation回调
 * 如果未读消息数改变，会触发onTotalUnreadMessageCountChanged回调
 * <p>
 * 启动app时主动拉取一次会话记录，后续会话改变可以根据监听器回调再刷新数据
 */
- (void)setConversationListenerWithonConversationChanged:(onConversationChanged)onConversationChanged onNewConversation:(onNewConversation)onNewConversation onSyncServerFailed:(onSyncServerFailed)onSyncServerFailed onSyncServerFinish:(onSyncServerFinish)onSyncServerFinish onSyncServerStart:(onSyncServerStart)onSyncServerStart onTotalUnreadMessageCountChanged:(onTotalUnreadMessageCountChanged)onTotalUnreadMessageCountChanged {
    _onConversationChanged = [onConversationChanged copy];
    _onNewConversation = [onNewConversation copy];
    _onSyncServerFailed = [onSyncServerFailed copy];
    _onSyncServerFinish = [onSyncServerFinish copy];
    _onSyncServerStart = [onSyncServerStart copy];
    _onTotalUnreadMessageCountChanged = [onTotalUnreadMessageCountChanged copy];
    Open_im_sdkSetConversationListener(self);
}

- (void)onConversationChanged:(NSString* _Nullable)conversationList {
    NSArray *jsonList = [conversationList array];
    NSMutableArray *conversationInfoList = [NSMutableArray new];
    for (NSDictionary *dt in jsonList) {
        [conversationInfoList addObject:[[ConversationInfo alloc] initWithDictionary:dt]];
    }
    if(_onConversationChanged != nil) {
        _onConversationChanged(conversationInfoList);
    }
}

- (void)onNewConversation:(NSString* _Nullable)conversationList {
    NSArray *jsonList = [conversationList array];
    NSMutableArray *conversationInfoList = [NSMutableArray new];
    for (NSDictionary *dt in jsonList) {
        [conversationInfoList addObject:[[ConversationInfo alloc] initWithDictionary:dt]];
    }
    if(_onNewConversation != nil) {
        _onNewConversation(conversationInfoList);
    }
}

- (void)onSyncServerFailed {
    if(_onSyncServerFailed != nil) {
        _onSyncServerFailed();
    }
}

- (void)onSyncServerFinish {
    if(_onSyncServerFinish != nil) {
        _onSyncServerFinish();
    }
}

- (void)onSyncServerStart {
    if(_onSyncServerStart != nil) {
        _onSyncServerStart();
    }
}

- (void)onTotalUnreadMessageCountChanged:(int)totalUnreadCount {
    if(_onTotalUnreadMessageCountChanged != nil) {
        _onTotalUnreadMessageCountChanged(totalUnreadCount);
    }
}


// MARK: - Open_im_sdkOnGroupListener

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
- (void)setGroupListenerWithonApplicationProcessed:(onApplicationProcessed)onApplicationProcessed onGroupCreated:(onGroupCreated)onGroupCreated onGroupInfoChanged:(onGroupInfoChanged)onGroupInfoChanged onMemberEnter:(onMemberEnter)onMemberEnter onMemberInvited:(onMemberInvited)onMemberInvited onMemberKicked:(onMemberKicked)onMemberKicked onMemberLeave:(onMemberLeave)onMemberLeave onReceiveJoinApplication:(onReceiveJoinApplication)onReceiveJoinApplication onTransferGroupOwner:(onTransferGroupOwner)onTransferGroupOwner {
    _onApplicationProcessed = [onApplicationProcessed copy];
    _onGroupCreated = [onGroupCreated copy];
    _onGroupInfoChanged = [onGroupInfoChanged copy];
    _onMemberEnter = [onMemberEnter copy];
    _onMemberInvited = [onMemberInvited copy];
    _onMemberKicked = [onMemberKicked copy];
    _onMemberLeave = [onMemberLeave copy];
    _onReceiveJoinApplication = [onReceiveJoinApplication copy];
    _onTransferGroupOwner = [onTransferGroupOwner copy];
    Open_im_sdkSetGroupListener(self);
}

- (void)onApplicationProcessed:(NSString* _Nullable)groupId opUser:(NSString* _Nullable)opUser AgreeOrReject:(int32_t)AgreeOrReject opReason:(NSString* _Nullable)opReason {
    if(_onApplicationProcessed != nil) {
        _onApplicationProcessed(groupId,[[GroupMembersInfo alloc] initWithDictionary:[opUser dict]],AgreeOrReject,opReason);
    }
}

- (void)onGroupCreated:(NSString* _Nullable)groupId {
    if(_onGroupCreated != nil) {
        _onGroupCreated(groupId);
    }
}

- (void)onGroupInfoChanged:(NSString* _Nullable)groupId groupInfo:(NSString* _Nullable)groupInfo {
    if(_onGroupInfoChanged != nil) {
        _onGroupInfoChanged(groupId,[[GroupInfo alloc] initWithDictionary:[groupInfo dict]]);
    }
}

- (void)onMemberEnter:(NSString* _Nullable)groupId memberList:(NSString* _Nullable)memberList {
    NSArray *jsonList = [memberList array];
    NSMutableArray *groupMembersInfolist = [NSMutableArray new];
    for (NSDictionary *dt in jsonList) {
        [groupMembersInfolist addObject:[[GroupMembersInfo alloc] initWithDictionary:dt]];
    }
    if(_onMemberEnter != nil) {
        _onMemberEnter(groupId,groupMembersInfolist);
    }
}

- (void)onMemberInvited:(NSString* _Nullable)groupId opUser:(NSString* _Nullable)opUser memberList:(NSString* _Nullable)memberList {
    NSArray *jsonList = [memberList array];
    NSMutableArray *groupMembersInfolist = [NSMutableArray new];
    for (NSDictionary *dt in jsonList) {
        [groupMembersInfolist addObject:[[GroupMembersInfo alloc] initWithDictionary:dt]];
    }
    if(_onMemberInvited != nil) {
        _onMemberInvited(groupId,[[GroupMembersInfo alloc] initWithDictionary:[opUser dict]],groupMembersInfolist);
    }
}

- (void)onMemberKicked:(NSString* _Nullable)groupId opUser:(NSString* _Nullable)opUser memberList:(NSString* _Nullable)memberList {
    NSArray *jsonList = [memberList array];
    NSMutableArray *groupMembersInfolist = [NSMutableArray new];
    for (NSDictionary *dt in jsonList) {
        [groupMembersInfolist addObject:[[GroupMembersInfo alloc] initWithDictionary:dt]];
    }
    if(_onMemberKicked != nil) {
        _onMemberKicked(groupId,[[GroupMembersInfo alloc] initWithDictionary:[opUser dict]],groupMembersInfolist);
    }
}

- (void)onMemberLeave:(NSString* _Nullable)groupId member:(NSString* _Nullable)member {
    if(_onMemberLeave != nil) {
        _onMemberLeave(groupId,[[GroupMembersInfo alloc] initWithDictionary:[member dict]]);
    }
}

- (void)onReceiveJoinApplication:(NSString* _Nullable)groupId member:(NSString* _Nullable)member opReason:(NSString* _Nullable)opReason {
    if(_onReceiveJoinApplication != nil) {
        _onReceiveJoinApplication(groupId,[[GroupMembersInfo alloc] initWithDictionary:[member dict]],opReason);
    }
}

- (void)onTransferGroupOwner:(NSString* _Nullable)groupId oldUserID:(NSString* _Nullable)oldUserID newUserID:(NSString* _Nullable)newUserID {
    if(_onTransferGroupOwner != nil) {
        _onTransferGroupOwner(groupId,oldUserID,newUserID);
    }
}

@end
