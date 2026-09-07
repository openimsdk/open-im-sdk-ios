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

    func login(userID: String, token: String) async throws
    func logout() async throws
    func uninitialize()

    // MARK: - User
    func getUsersInfo(userIDs: [String]) async throws -> [OpenIMPublicUserInfo]
    func getSelfUserInfo() async throws -> OpenIMUserInfo
    func setSelfUserInfo(userInfo: OpenIMUserInfo) async throws
    func updateFcmToken(fcmToken: String, expireTime: Int) async throws
    func subscribeUsersStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo]
    func unsubscribeUsersStatus(userIDs: [String]) async throws
    func getSubscribeUsersStatus() async throws -> [OpenIMUserStatusInfo]
    func getUserStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo]
    func setUserListener(_ listener: OpenIMUserListener?)

    // MARK: - Friend
    func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool) async throws -> [OpenIMFriendInfo]
    func getFriendList(filterBlack: Bool) async throws -> [OpenIMFriendInfo]
    func getFriendListPage(offset: Int, count: Int, filterBlack: Bool) async throws -> [OpenIMFriendInfo]
    func searchFriends(param: OpenIMSearchFriendsParam) async throws -> [OpenIMSearchFriendsInfo]
    func checkFriend(userIDs: [String]) async throws -> [OpenIMFriendCheckResult]
    func addFriend(userID: String, reqMsg: String?) async throws
    func setFriendRemark(userID: String, remark: String) async throws
    func deleteFriend(friendUserID: String) async throws
    func getFriendApplicationListAsRecipient() async throws -> [OpenIMFriendApplication]
    func getFriendApplicationListAsApplicant() async throws -> [OpenIMFriendApplication]
    func acceptFriendApplication(userID: String, handleMsg: String?) async throws
    func refuseFriendApplication(userID: String, handleMsg: String?) async throws
    func addBlack(blackUserID: String, ex: String?) async throws
    func removeBlack(blackUserID: String) async throws
    func getBlackList() async throws -> [OpenIMBlackInfo]
    func setFriendshipListener(_ listener: OpenIMFriendshipListener?)

    // MARK: - Group
    func createGroup(createInfo: OpenIMGroupCreateInfo) async throws -> OpenIMGroupInfo
    func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?) async throws
    func quitGroup(groupID: String) async throws
    func dismissGroup(groupID: String) async throws
    func getJoinedGroupList() async throws -> [OpenIMGroupInfo]
    func getJoinedGroupListPage(offset: Int, count: Int) async throws -> [OpenIMGroupInfo]
    func getSpecifiedGroupsInfo(groupIDs: [String]) async throws -> [OpenIMGroupInfo]
    func searchGroups(param: OpenIMSearchGroupParam) async throws -> [OpenIMGroupInfo]
    func setGroupInfo(groupInfo: OpenIMGroupInfo) async throws
    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int) async throws -> [OpenIMGroupMemberInfo]
    func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String]) async throws -> [OpenIMGroupMemberInfo]
    func searchGroupMembers(param: OpenIMSearchGroupMembersParam) async throws -> [OpenIMGroupMemberInfo]
    func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole) async throws
    func changeGroupMute(groupID: String, isMute: Bool) async throws
    func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int) async throws
    func setGroupMemberNickname(groupID: String, userID: String, nickname: String) async throws
    func kickGroupMember(groupID: String, reason: String?, userIDs: [String]) async throws
    func inviteUserToGroup(groupID: String, reason: String?, userIDs: [String]) async throws
    func getGroupApplicationListAsRecipient() async throws -> [OpenIMGroupApplicationInfo]
    func getGroupApplicationListAsApplicant() async throws -> [OpenIMGroupApplicationInfo]
    func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String?) async throws
    func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String?) async throws
    func setGroupListener(_ listener: OpenIMGroupListener?)

    // MARK: - Conversation
    func getAllConversationList() async throws -> [OpenIMConversationInfo]
    func getConversationListSplit(offset: Int, count: Int) async throws -> [OpenIMConversationInfo]
    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String) async throws -> OpenIMConversationInfo
    func getMultipleConversation(conversationIDs: [String]) async throws -> [OpenIMConversationInfo]
    func setConversation(conversationID: String, req: OpenIMConversationReq) async throws
    func hideConversation(conversationID: String) async throws
    func setConversationDraft(conversationID: String, draftText: String) async throws
    func setConversationPinned(conversationID: String, isPinned: Bool) async throws
    func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt) async throws
    func markConversationMessageAsRead(conversationID: String) async throws
    func getTotalUnreadMsgCount() async throws -> Int
    func deleteConversationAndDeleteAllMsg(conversationID: String) async throws
    func clearConversationAndDeleteAllMsg(conversationID: String) async throws
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
        onProgress: ((Int) -> Void)?
    ) async throws -> OpenIMMessageInfo
    func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions) async throws -> OpenIMGetAdvancedHistoryMessageListInfo
    func revokeMessage(conversationID: String, clientMsgID: String) async throws
    func typingStatusUpdate(recvID: String, msgTip: String) async throws
    func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String]) async throws
    func deleteMessage(conversationID: String, clientMsgID: String) async throws
    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String) async throws
    func deleteAllMsgFromLocal() async throws
    func deleteAllMsgFromLocalAndSvr() async throws
    func searchLocalMessages(param: OpenIMSearchParam) async throws -> OpenIMSearchResultInfo
    func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?)
}

// MARK: - Default Implementations for OpenIMCoreAdapter
public extension OpenIMCoreAdapter {
    func getUsersInfo(userIDs: [String]) async throws -> [OpenIMPublicUserInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getSelfUserInfo() async throws -> OpenIMUserInfo {
        throw OpenIMError.coreUnavailable
    }
    func setSelfUserInfo(userInfo: OpenIMUserInfo) async throws {
        throw OpenIMError.coreUnavailable
    }
    func updateFcmToken(fcmToken: String, expireTime: Int) async throws {
        throw OpenIMError.coreUnavailable
    }
    func subscribeUsersStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        throw OpenIMError.coreUnavailable
    }
    func unsubscribeUsersStatus(userIDs: [String]) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getSubscribeUsersStatus() async throws -> [OpenIMUserStatusInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getUserStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        throw OpenIMError.coreUnavailable
    }
    func setUserListener(_ listener: OpenIMUserListener?) {}

    func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool) async throws -> [OpenIMFriendInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getFriendList(filterBlack: Bool) async throws -> [OpenIMFriendInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getFriendListPage(offset: Int, count: Int, filterBlack: Bool) async throws -> [OpenIMFriendInfo] {
        throw OpenIMError.coreUnavailable
    }
    func searchFriends(param: OpenIMSearchFriendsParam) async throws -> [OpenIMSearchFriendsInfo] {
        throw OpenIMError.coreUnavailable
    }
    func checkFriend(userIDs: [String]) async throws -> [OpenIMFriendCheckResult] {
        throw OpenIMError.coreUnavailable
    }
    func addFriend(userID: String, reqMsg: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func setFriendRemark(userID: String, remark: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func deleteFriend(friendUserID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getFriendApplicationListAsRecipient() async throws -> [OpenIMFriendApplication] {
        throw OpenIMError.coreUnavailable
    }
    func getFriendApplicationListAsApplicant() async throws -> [OpenIMFriendApplication] {
        throw OpenIMError.coreUnavailable
    }
    func acceptFriendApplication(userID: String, handleMsg: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func refuseFriendApplication(userID: String, handleMsg: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func addBlack(blackUserID: String, ex: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func removeBlack(blackUserID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getBlackList() async throws -> [OpenIMBlackInfo] {
        throw OpenIMError.coreUnavailable
    }
    func setFriendshipListener(_ listener: OpenIMFriendshipListener?) {}

    func createGroup(createInfo: OpenIMGroupCreateInfo) async throws -> OpenIMGroupInfo {
        throw OpenIMError.coreUnavailable
    }
    func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func quitGroup(groupID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func dismissGroup(groupID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getJoinedGroupList() async throws -> [OpenIMGroupInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getJoinedGroupListPage(offset: Int, count: Int) async throws -> [OpenIMGroupInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getSpecifiedGroupsInfo(groupIDs: [String]) async throws -> [OpenIMGroupInfo] {
        throw OpenIMError.coreUnavailable
    }
    func searchGroups(param: OpenIMSearchGroupParam) async throws -> [OpenIMGroupInfo] {
        throw OpenIMError.coreUnavailable
    }
    func setGroupInfo(groupInfo: OpenIMGroupInfo) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int) async throws -> [OpenIMGroupMemberInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String]) async throws -> [OpenIMGroupMemberInfo] {
        throw OpenIMError.coreUnavailable
    }
    func searchGroupMembers(param: OpenIMSearchGroupMembersParam) async throws -> [OpenIMGroupMemberInfo] {
        throw OpenIMError.coreUnavailable
    }
    func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole) async throws {
        throw OpenIMError.coreUnavailable
    }
    func changeGroupMute(groupID: String, isMute: Bool) async throws {
        throw OpenIMError.coreUnavailable
    }
    func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int) async throws {
        throw OpenIMError.coreUnavailable
    }
    func setGroupMemberNickname(groupID: String, userID: String, nickname: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func kickGroupMember(groupID: String, reason: String?, userIDs: [String]) async throws {
        throw OpenIMError.coreUnavailable
    }
    func inviteUserToGroup(groupID: String, reason: String?, userIDs: [String]) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getGroupApplicationListAsRecipient() async throws -> [OpenIMGroupApplicationInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getGroupApplicationListAsApplicant() async throws -> [OpenIMGroupApplicationInfo] {
        throw OpenIMError.coreUnavailable
    }
    func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String?) async throws {
        throw OpenIMError.coreUnavailable
    }
    func setGroupListener(_ listener: OpenIMGroupListener?) {}

    func getAllConversationList() async throws -> [OpenIMConversationInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getConversationListSplit(offset: Int, count: Int) async throws -> [OpenIMConversationInfo] {
        throw OpenIMError.coreUnavailable
    }
    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String) async throws -> OpenIMConversationInfo {
        throw OpenIMError.coreUnavailable
    }
    func getMultipleConversation(conversationIDs: [String]) async throws -> [OpenIMConversationInfo] {
        throw OpenIMError.coreUnavailable
    }
    func setConversation(conversationID: String, req: OpenIMConversationReq) async throws {
        throw OpenIMError.coreUnavailable
    }
    func hideConversation(conversationID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func setConversationDraft(conversationID: String, draftText: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func setConversationPinned(conversationID: String, isPinned: Bool) async throws {
        throw OpenIMError.coreUnavailable
    }
    func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt) async throws {
        throw OpenIMError.coreUnavailable
    }
    func markConversationMessageAsRead(conversationID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func getTotalUnreadMsgCount() async throws -> Int {
        throw OpenIMError.coreUnavailable
    }
    func deleteConversationAndDeleteAllMsg(conversationID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func clearConversationAndDeleteAllMsg(conversationID: String) async throws {
        throw OpenIMError.coreUnavailable
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
        onProgress: ((Int) -> Void)?
    ) async throws -> OpenIMMessageInfo {
        throw OpenIMError.coreUnavailable
    }
    func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions) async throws -> OpenIMGetAdvancedHistoryMessageListInfo {
        throw OpenIMError.coreUnavailable
    }
    func revokeMessage(conversationID: String, clientMsgID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func typingStatusUpdate(recvID: String, msgTip: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String]) async throws {
        throw OpenIMError.coreUnavailable
    }
    func deleteMessage(conversationID: String, clientMsgID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String) async throws {
        throw OpenIMError.coreUnavailable
    }
    func deleteAllMsgFromLocal() async throws {
        throw OpenIMError.coreUnavailable
    }
    func deleteAllMsgFromLocalAndSvr() async throws {
        throw OpenIMError.coreUnavailable
    }
    func searchLocalMessages(param: OpenIMSearchParam) async throws -> OpenIMSearchResultInfo {
        throw OpenIMError.coreUnavailable
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

    public func login(userID: String, token: String) async throws {
        throw OpenIMError.coreUnavailable
    }

    public func logout() async throws {
        throw OpenIMError.coreUnavailable
    }

    public func uninitialize() {}
}
