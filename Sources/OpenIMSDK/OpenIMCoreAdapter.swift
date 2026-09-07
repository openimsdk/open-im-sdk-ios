import Foundation

/// Events emitted by the native OpenIMCore bridge.
public enum OpenIMCoreEvent: Equatable, Sendable {
    case connecting
    case connected
    case connectionFailed(code: Int, message: String?)
    case kickedOffline
    case tokenExpired
    case tokenInvalid(message: String?)
}

/// Boundary between the Swift API and the gomobile-generated OpenIMCore module.
public protocol OpenIMCoreAdapter: AnyObject {
    // MARK: - Lifecycle
    func initialize(
        configuration: OpenIMConfiguration,
        eventHandler: @escaping (OpenIMCoreEvent) -> Void
    ) throws

    func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    )

    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func uninitialize()

    // MARK: - User
    func getUsersInfo(userIDs: [String], completion: @escaping (Result<[OpenIMPublicUserInfo], OpenIMError>) -> Void)
    func getSelfUserInfo(completion: @escaping (Result<OpenIMUserInfo, OpenIMError>) -> Void)
    func setSelfUserInfo(userInfo: OpenIMUserInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func updateFcmToken(fcmToken: String, expireTime: Int, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func subscribeUsersStatus(userIDs: [String], completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void)
    func unsubscribeUsersStatus(userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getSubscribeUsersStatus(completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void)
    func getUserStatus(userIDs: [String], completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void)
    func setUserListener(_ listener: OpenIMUserListener?)

    // MARK: - Friend
    func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void)
    func getFriendList(filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void)
    func getFriendListPage(offset: Int, count: Int, filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void)
    func searchFriends(param: OpenIMSearchFriendsParam, completion: @escaping (Result<[OpenIMSearchFriendsInfo], OpenIMError>) -> Void)
    func checkFriend(userIDs: [String], completion: @escaping (Result<[OpenIMFriendCheckResult], OpenIMError>) -> Void)
    func addFriend(userID: String, reqMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setFriendRemark(userID: String, remark: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func deleteFriend(friendUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getFriendApplicationListAsRecipient(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void)
    func getFriendApplicationListAsApplicant(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void)
    func acceptFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func refuseFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func addBlack(blackUserID: String, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func removeBlack(blackUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getBlackList(completion: @escaping (Result<[OpenIMBlackInfo], OpenIMError>) -> Void)
    func setFriendshipListener(_ listener: OpenIMFriendshipListener?)

    // MARK: - Group
    func createGroup(createInfo: OpenIMGroupCreateInfo, completion: @escaping (Result<OpenIMGroupInfo, OpenIMError>) -> Void)
    func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func quitGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func dismissGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getJoinedGroupList(completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void)
    func getJoinedGroupListPage(offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void)
    func getSpecifiedGroupsInfo(groupIDs: [String], completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void)
    func searchGroups(param: OpenIMSearchGroupParam, completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void)
    func setGroupInfo(groupInfo: OpenIMGroupInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void)
    func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String], completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void)
    func searchGroupMembers(param: OpenIMSearchGroupMembersParam, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void)
    func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func changeGroupMute(groupID: String, isMute: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setGroupMemberNickname(groupID: String, userID: String, nickname: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func kickGroupMember(groupID: String, reason: String?, userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func inviteUserToGroup(groupID: String, reason: String?, userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getGroupApplicationListAsRecipient(completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void)
    func getGroupApplicationListAsApplicant(completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void)
    func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setGroupListener(_ listener: OpenIMGroupListener?)

    // MARK: - Conversation
    func getAllConversationList(completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void)
    func getConversationListSplit(offset: Int, count: Int, completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void)
    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String, completion: @escaping (Result<OpenIMConversationInfo, OpenIMError>) -> Void)
    func getMultipleConversation(conversationIDs: [String], completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void)
    func setConversation(conversationID: String, req: OpenIMConversationReq, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func hideConversation(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setConversationDraft(conversationID: String, draftText: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setConversationPinned(conversationID: String, isPinned: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func markConversationMessageAsRead(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func getTotalUnreadMsgCount(completion: @escaping (Result<Int, OpenIMError>) -> Void)
    func deleteConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func clearConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func setConversationListener(_ listener: OpenIMConversationListener?)

    // MARK: - Message
    func createTextMessage(text: String) throws -> OpenIMMessageInfo
    func createTextAtMessage(text: String, atUserIDs: [String], atUsersInfo: [OpenIMAtInfo], quoteMessage: OpenIMMessageInfo?) throws -> OpenIMMessageInfo
    func createImageMessage(imagePath: String) throws -> OpenIMMessageInfo
    func createSoundMessage(soundPath: String, duration: Int64) throws -> OpenIMMessageInfo
    func createVideoMessage(videoPath: String, videoType: String, duration: Int64, snapshotPath: String) throws -> OpenIMMessageInfo
    func createFileMessage(filePath: String, fileName: String) throws -> OpenIMMessageInfo
    func createLocationMessage(description: String, longitude: Double, latitude: Double) throws -> OpenIMMessageInfo
    func createCustomMessage(data: String, `extension`: String?, description: String?) throws -> OpenIMMessageInfo
    func createQuoteMessage(text: String, message: OpenIMMessageInfo) throws -> OpenIMMessageInfo
    func createCardMessage(cardInfo: OpenIMCardElem) throws -> OpenIMMessageInfo
    func createFaceMessage(index: Int, data: String) throws -> OpenIMMessageInfo
    func createMergerMessage(messageList: [OpenIMMessageInfo], title: String, summaryList: [String]) throws -> OpenIMMessageInfo
    func createForwardMessage(message: OpenIMMessageInfo) throws -> OpenIMMessageInfo
    func sendMessage(
        message: OpenIMMessageInfo,
        recvID: String?,
        groupID: String?,
        offlinePushInfo: OpenIMOfflinePushInfo?,
        isOnlineOnly: Bool,
        onProgress: ((Int) -> Void)?,
        completion: @escaping (Result<OpenIMMessageInfo, OpenIMError>) -> Void
    )
    func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions, completion: @escaping (Result<OpenIMGetAdvancedHistoryMessageListInfo, OpenIMError>) -> Void)
    func revokeMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func typingStatusUpdate(recvID: String, msgTip: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func deleteMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func deleteAllMsgFromLocal(completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func deleteAllMsgFromLocalAndSvr(completion: @escaping (Result<Void, OpenIMError>) -> Void)
    func searchLocalMessages(param: OpenIMSearchParam, completion: @escaping (Result<OpenIMSearchResultInfo, OpenIMError>) -> Void)
    func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?)
}

// MARK: - Default Implementations for OpenIMCoreAdapter
public extension OpenIMCoreAdapter {
    func getUsersInfo(userIDs: [String], completion: @escaping (Result<[OpenIMPublicUserInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getSelfUserInfo(completion: @escaping (Result<OpenIMUserInfo, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setSelfUserInfo(userInfo: OpenIMUserInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func updateFcmToken(fcmToken: String, expireTime: Int, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func subscribeUsersStatus(userIDs: [String], completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func unsubscribeUsersStatus(userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getSubscribeUsersStatus(completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getUserStatus(userIDs: [String], completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setUserListener(_ listener: OpenIMUserListener?) {}

    func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getFriendList(filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getFriendListPage(offset: Int, count: Int, filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func searchFriends(param: OpenIMSearchFriendsParam, completion: @escaping (Result<[OpenIMSearchFriendsInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func checkFriend(userIDs: [String], completion: @escaping (Result<[OpenIMFriendCheckResult], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func addFriend(userID: String, reqMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setFriendRemark(userID: String, remark: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func deleteFriend(friendUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getFriendApplicationListAsRecipient(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getFriendApplicationListAsApplicant(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func acceptFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func refuseFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func addBlack(blackUserID: String, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func removeBlack(blackUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getBlackList(completion: @escaping (Result<[OpenIMBlackInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setFriendshipListener(_ listener: OpenIMFriendshipListener?) {}

    func createGroup(createInfo: OpenIMGroupCreateInfo, completion: @escaping (Result<OpenIMGroupInfo, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func quitGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func dismissGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getJoinedGroupList(completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getJoinedGroupListPage(offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getSpecifiedGroupsInfo(groupIDs: [String], completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func searchGroups(param: OpenIMSearchGroupParam, completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setGroupInfo(groupInfo: OpenIMGroupInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String], completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func searchGroupMembers(param: OpenIMSearchGroupMembersParam, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func changeGroupMute(groupID: String, isMute: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setGroupMemberNickname(groupID: String, userID: String, nickname: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func kickGroupMember(groupID: String, reason: String?, userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func inviteUserToGroup(groupID: String, reason: String?, userIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getGroupApplicationListAsRecipient(completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getGroupApplicationListAsApplicant(completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setGroupListener(_ listener: OpenIMGroupListener?) {}

    func getAllConversationList(completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getConversationListSplit(offset: Int, count: Int, completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String, completion: @escaping (Result<OpenIMConversationInfo, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getMultipleConversation(conversationIDs: [String], completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setConversation(conversationID: String, req: OpenIMConversationReq, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func hideConversation(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setConversationDraft(conversationID: String, draftText: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setConversationPinned(conversationID: String, isPinned: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func markConversationMessageAsRead(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func getTotalUnreadMsgCount(completion: @escaping (Result<Int, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func deleteConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func clearConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setConversationListener(_ listener: OpenIMConversationListener?) {}

    func createTextMessage(text: String) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createTextAtMessage(text: String, atUserIDs: [String], atUsersInfo: [OpenIMAtInfo], quoteMessage: OpenIMMessageInfo?) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createImageMessage(imagePath: String) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createSoundMessage(soundPath: String, duration: Int64) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createVideoMessage(videoPath: String, videoType: String, duration: Int64, snapshotPath: String) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createFileMessage(filePath: String, fileName: String) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createLocationMessage(description: String, longitude: Double, latitude: Double) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createCustomMessage(data: String, `extension`: String?, description: String?) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createQuoteMessage(text: String, message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createCardMessage(cardInfo: OpenIMCardElem) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createFaceMessage(index: Int, data: String) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createMergerMessage(messageList: [OpenIMMessageInfo], title: String, summaryList: [String]) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func createForwardMessage(message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func sendMessage(
        message: OpenIMMessageInfo,
        recvID: String?,
        groupID: String?,
        offlinePushInfo: OpenIMOfflinePushInfo?,
        isOnlineOnly: Bool,
        onProgress: ((Int) -> Void)?,
        completion: @escaping (Result<OpenIMMessageInfo, OpenIMError>) -> Void
    ) {
        completion(.failure(.coreUnavailable))
    }
    func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions, completion: @escaping (Result<OpenIMGetAdvancedHistoryMessageListInfo, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func revokeMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func typingStatusUpdate(recvID: String, msgTip: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String], completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func deleteMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func deleteAllMsgFromLocal(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func deleteAllMsgFromLocalAndSvr(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func searchLocalMessages(param: OpenIMSearchParam, completion: @escaping (Result<OpenIMSearchResultInfo, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }
    func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?) {}
}

/// Default adapter used until an OpenIMCore XCFramework bridge is supplied.
public final class UnavailableOpenIMCoreAdapter: OpenIMCoreAdapter {
    public init() {}

    public func initialize(
        configuration: OpenIMConfiguration,
        eventHandler: @escaping (OpenIMCoreEvent) -> Void
    ) throws {
        throw OpenIMError.coreUnavailable
    }

    public func login(
        userID: String,
        token: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        completion(.failure(.coreUnavailable))
    }

    public func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        completion(.failure(.coreUnavailable))
    }

    public func uninitialize() {}
}
