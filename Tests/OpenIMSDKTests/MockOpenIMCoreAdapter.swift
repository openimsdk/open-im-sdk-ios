import Foundation
@testable import OpenIMSDK

final class MockOpenIMCoreAdapter: OpenIMCoreAdapter, @unchecked Sendable {
    var shouldFail: Bool = false

    // MARK: - Lifecycle Tracking
    var lastInitializedConfig: OpenIMConfiguration?
    var lastLoginCredentials: (userID: String, token: String)?
    var logoutCalled: Bool = false
    var uninitializeCalled: Bool = false

    // MARK: - User Tracking
    var lastUpdatedSelfInfo: OpenIMUserInfo?
    var lastFcmToken: (token: String, expireTime: Int)?
    var lastSubscribedUserIDs: [String]?
    var lastUnsubscribedUserIDs: [String]?
    var userListener: OpenIMUserListener?

    // MARK: - Friend Tracking
    var lastAddedFriendID: String?
    var lastFriendRemark: (userID: String, remark: String)?
    var lastDeletedFriendID: String?
    var lastHandledApplication: (userID: String, accepted: Bool)?
    var lastBlackID: String?
    var lastRemovedBlackID: String?
    var lastSearchFriendsParam: OpenIMSearchFriendsParam?
    var friendshipListener: OpenIMFriendshipListener?

    // MARK: - Group Tracking
    var lastJoinedGroupID: String?
    var lastQuitGroupID: String?
    var lastDismissedGroupID: String?
    var lastCreatedGroupInfo: OpenIMGroupCreateInfo?
    var lastUpdatedGroupInfo: OpenIMGroupInfo?
    var lastSearchGroupParam: OpenIMSearchGroupParam?
    var lastSearchGroupMembersParam: OpenIMSearchGroupMembersParam?
    var lastMemberRoleLevel: (groupID: String, userID: String, role: OpenIMGroupMemberRole)?
    var lastGroupMute: (groupID: String, isMute: Bool)?
    var lastGroupMemberMute: (groupID: String, userID: String, mutedSeconds: Int)?
    var lastGroupMemberNickname: (groupID: String, userID: String, nickname: String)?
    var lastKickedMembers: (groupID: String, reason: String?, userIDs: [String])?
    var lastInvitedMembers: (groupID: String, reason: String?, userIDs: [String])?
    var lastHandledGroupApp: (groupID: String, fromUserID: String, accepted: Bool)?
    var groupListener: OpenIMGroupListener?

    // MARK: - Conversation Tracking
    var lastDraft: (conversationID: String, draftText: String)?
    var lastPinned: (conversationID: String, isPinned: Bool)?
    var lastReadConversationID: String?
    var lastClearedConversationID: String?
    var lastDeletedConversationID: String?
    var lastConversationReq: (conversationID: String, req: OpenIMConversationReq)?
    var lastHiddenConversationID: String?
    var lastRecvMessageOpt: (conversationIDs: [String], status: OpenIMReceiveMessageOpt)?
    var conversationListener: OpenIMConversationListener?

    // MARK: - Message Tracking
    var lastSentMessage: OpenIMMessageInfo?
    var lastRevokedMessage: (conversationID: String, clientMsgID: String)?
    var lastTypingStatus: (recvID: String, msgTip: String)?
    var lastMarkedAsReadMsgIDs: (conversationID: String, clientMsgIDs: [String])?
    var lastDeletedMessage: (conversationID: String, clientMsgID: String)?
    var lastDeletedLocalMessage: (conversationID: String, clientMsgID: String)?
    var deleteAllLocalMsgCalled: Bool = false
    var deleteAllLocalAndSvrMsgCalled: Bool = false
    var lastSearchLocalMessagesParam: OpenIMSearchParam?
    var advancedMsgListener: OpenIMAdvancedMsgListener?

    private func returnOrThrow<T>(_ value: T) throws -> T {
        if shouldFail {
            throw OpenIMError.core(code: -999, message: "Simulated network failure")
        }
        return value
    }

    private func throwIfNeeded() throws {
        if shouldFail {
            throw OpenIMError.core(code: -999, message: "Simulated network failure")
        }
    }

    // MARK: - Lifecycle
    func initialize(configuration: OpenIMConfiguration, eventHandler: @escaping (OpenIMCoreEvent) -> Void) throws {
        lastInitializedConfig = configuration
        if shouldFail {
            throw OpenIMError.core(code: -1, message: "Init failed")
        }
    }

    func login(userID: String, token: String) async throws {
        lastLoginCredentials = (userID, token)
        try throwIfNeeded()
    }

    func logout() async throws {
        logoutCalled = true
        try throwIfNeeded()
    }

    func uninitialize() {
        uninitializeCalled = true
    }

    // MARK: - User
    func getUsersInfo(userIDs: [String]) async throws -> [OpenIMPublicUserInfo] {
        let users = userIDs.map { OpenIMPublicUserInfo(userID: $0, nickname: "Nick_\($0)") }
        return try returnOrThrow(users)
    }

    func getSelfUserInfo() async throws -> OpenIMUserInfo {
        return try returnOrThrow(OpenIMUserInfo(userID: "test_self_id", nickname: "Test Self"))
    }

    func setSelfUserInfo(userInfo: OpenIMUserInfo) async throws {
        lastUpdatedSelfInfo = userInfo
        try throwIfNeeded()
    }

    func updateFcmToken(fcmToken: String, expireTime: Int) async throws {
        lastFcmToken = (fcmToken, expireTime)
        try throwIfNeeded()
    }

    func subscribeUsersStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        lastSubscribedUserIDs = userIDs
        let statuses = userIDs.map { OpenIMUserStatusInfo(userID: $0, platformIDs: [1], status: 1) }
        return try returnOrThrow(statuses)
    }

    func unsubscribeUsersStatus(userIDs: [String]) async throws {
        lastUnsubscribedUserIDs = userIDs
        try throwIfNeeded()
    }

    func getSubscribeUsersStatus() async throws -> [OpenIMUserStatusInfo] {
        let statuses = (lastSubscribedUserIDs ?? ["u1"]).map { OpenIMUserStatusInfo(userID: $0, platformIDs: [1], status: 1) }
        return try returnOrThrow(statuses)
    }

    func getUserStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        let statuses = userIDs.map { OpenIMUserStatusInfo(userID: $0, platformIDs: [1], status: 1) }
        return try returnOrThrow(statuses)
    }

    func setUserListener(_ listener: OpenIMUserListener?) {
        userListener = listener
    }

    // MARK: - Friend
    func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool) async throws -> [OpenIMFriendInfo] {
        let friends = userIDs.map { OpenIMFriendInfo(userID: $0, nickname: "Friend_\($0)") }
        return try returnOrThrow(friends)
    }

    func getFriendList(filterBlack: Bool) async throws -> [OpenIMFriendInfo] {
        return try returnOrThrow([OpenIMFriendInfo(userID: "friend_1", nickname: "Friend 1")])
    }

    func getFriendListPage(offset: Int, count: Int, filterBlack: Bool) async throws -> [OpenIMFriendInfo] {
        return try returnOrThrow([OpenIMFriendInfo(userID: "friend_page_1", nickname: "Friend Page 1")])
    }

    func searchFriends(param: OpenIMSearchFriendsParam) async throws -> [OpenIMSearchFriendsInfo] {
        lastSearchFriendsParam = param
        let results = param.keywordList.map { OpenIMSearchFriendsInfo(ownerUserID: "self", userID: "searched_\($0)", nickname: "Searched \($0)") }
        return try returnOrThrow(results)
    }

    func checkFriend(userIDs: [String]) async throws -> [OpenIMFriendCheckResult] {
        return try returnOrThrow(userIDs.map { OpenIMFriendCheckResult(userID: $0, result: 1) })
    }

    func addFriend(userID: String, reqMsg: String?) async throws {
        lastAddedFriendID = userID
        try throwIfNeeded()
    }

    func setFriendRemark(userID: String, remark: String) async throws {
        lastFriendRemark = (userID, remark)
        try throwIfNeeded()
    }

    func deleteFriend(friendUserID: String) async throws {
        lastDeletedFriendID = friendUserID
        try throwIfNeeded()
    }

    func getFriendApplicationListAsRecipient() async throws -> [OpenIMFriendApplication] {
        return try returnOrThrow([OpenIMFriendApplication(fromUserID: "applicant_1", fromNickname: "Applicant 1")])
    }

    func getFriendApplicationListAsApplicant() async throws -> [OpenIMFriendApplication] {
        return try returnOrThrow([OpenIMFriendApplication(toUserID: "applicant_2", toNickname: "Applicant 2")])
    }

    func acceptFriendApplication(userID: String, handleMsg: String?) async throws {
        lastHandledApplication = (userID, true)
        try throwIfNeeded()
    }

    func refuseFriendApplication(userID: String, handleMsg: String?) async throws {
        lastHandledApplication = (userID, false)
        try throwIfNeeded()
    }

    func addBlack(blackUserID: String, ex: String?) async throws {
        lastBlackID = blackUserID
        try throwIfNeeded()
    }

    func removeBlack(blackUserID: String) async throws {
        lastRemovedBlackID = blackUserID
        try throwIfNeeded()
    }

    func getBlackList() async throws -> [OpenIMBlackInfo] {
        return try returnOrThrow([OpenIMBlackInfo(ownerUserID: "self", userID: "spammer_1", nickname: "Spammer")])
    }

    func setFriendshipListener(_ listener: OpenIMFriendshipListener?) {
        friendshipListener = listener
    }

    // MARK: - Group
    func createGroup(createInfo: OpenIMGroupCreateInfo) async throws -> OpenIMGroupInfo {
        lastCreatedGroupInfo = createInfo
        return try returnOrThrow(OpenIMGroupInfo(groupID: "new_g_1", groupName: createInfo.groupInfo.groupName))
    }

    func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?) async throws {
        lastJoinedGroupID = groupID
        try throwIfNeeded()
    }

    func quitGroup(groupID: String) async throws {
        lastQuitGroupID = groupID
        try throwIfNeeded()
    }

    func dismissGroup(groupID: String) async throws {
        lastDismissedGroupID = groupID
        try throwIfNeeded()
    }

    func getJoinedGroupList() async throws -> [OpenIMGroupInfo] {
        return try returnOrThrow([OpenIMGroupInfo(groupID: "group_1", groupName: "Group 1")])
    }

    func getJoinedGroupListPage(offset: Int, count: Int) async throws -> [OpenIMGroupInfo] {
        return try returnOrThrow([OpenIMGroupInfo(groupID: "group_page_1", groupName: "Group Page 1")])
    }

    func getSpecifiedGroupsInfo(groupIDs: [String]) async throws -> [OpenIMGroupInfo] {
        let groups = groupIDs.map { OpenIMGroupInfo(groupID: $0, groupName: "Group_\($0)") }
        return try returnOrThrow(groups)
    }

    func searchGroups(param: OpenIMSearchGroupParam) async throws -> [OpenIMGroupInfo] {
        lastSearchGroupParam = param
        let groups = param.keywordList.map { OpenIMGroupInfo(groupID: "searched_\($0)", groupName: "Group \($0)") }
        return try returnOrThrow(groups)
    }

    func setGroupInfo(groupInfo: OpenIMGroupInfo) async throws {
        lastUpdatedGroupInfo = groupInfo
        try throwIfNeeded()
    }

    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int) async throws -> [OpenIMGroupMemberInfo] {
        return try returnOrThrow([OpenIMGroupMemberInfo(groupID: groupID, userID: "member_1", nickname: "Member 1")])
    }

    func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String]) async throws -> [OpenIMGroupMemberInfo] {
        let members = userIDs.map { OpenIMGroupMemberInfo(groupID: groupID, userID: $0, nickname: "Nick_\($0)") }
        return try returnOrThrow(members)
    }

    func searchGroupMembers(param: OpenIMSearchGroupMembersParam) async throws -> [OpenIMGroupMemberInfo] {
        lastSearchGroupMembersParam = param
        let members = param.keywordList.map { OpenIMGroupMemberInfo(groupID: param.groupID, userID: "member_\($0)", nickname: "Member \($0)") }
        return try returnOrThrow(members)
    }

    func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole) async throws {
        lastMemberRoleLevel = (groupID, userID, roleLevel)
        try throwIfNeeded()
    }

    func changeGroupMute(groupID: String, isMute: Bool) async throws {
        lastGroupMute = (groupID, isMute)
        try throwIfNeeded()
    }

    func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int) async throws {
        lastGroupMemberMute = (groupID, userID, mutedSeconds)
        try throwIfNeeded()
    }

    func setGroupMemberNickname(groupID: String, userID: String, nickname: String) async throws {
        lastGroupMemberNickname = (groupID, userID, nickname)
        try throwIfNeeded()
    }

    func kickGroupMember(groupID: String, reason: String?, userIDs: [String]) async throws {
        lastKickedMembers = (groupID, reason, userIDs)
        try throwIfNeeded()
    }

    func inviteUserToGroup(groupID: String, reason: String?, userIDs: [String]) async throws {
        lastInvitedMembers = (groupID, reason, userIDs)
        try throwIfNeeded()
    }

    func getGroupApplicationListAsRecipient() async throws -> [OpenIMGroupApplicationInfo] {
        return try returnOrThrow([OpenIMGroupApplicationInfo(groupID: "g1", userID: "applicant_1")])
    }

    func getGroupApplicationListAsApplicant() async throws -> [OpenIMGroupApplicationInfo] {
        return try returnOrThrow([OpenIMGroupApplicationInfo(groupID: "g2", userID: "applicant_2")])
    }

    func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String?) async throws {
        lastHandledGroupApp = (groupID, fromUserID, true)
        try throwIfNeeded()
    }

    func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String?) async throws {
        lastHandledGroupApp = (groupID, fromUserID, false)
        try throwIfNeeded()
    }

    func setGroupListener(_ listener: OpenIMGroupListener?) {
        groupListener = listener
    }

    // MARK: - Conversation
    func getAllConversationList() async throws -> [OpenIMConversationInfo] {
        return try returnOrThrow([OpenIMConversationInfo(conversationID: "c_1", unreadCount: 2)])
    }

    func getConversationListSplit(offset: Int, count: Int) async throws -> [OpenIMConversationInfo] {
        return try returnOrThrow([OpenIMConversationInfo(conversationID: "c_split_\(offset)", unreadCount: 1)])
    }

    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String) async throws -> OpenIMConversationInfo {
        return try returnOrThrow(OpenIMConversationInfo(conversationID: "c_\(sessionType.rawValue)_\(sourceID)", conversationType: sessionType))
    }

    func getMultipleConversation(conversationIDs: [String]) async throws -> [OpenIMConversationInfo] {
        let convs = conversationIDs.map { OpenIMConversationInfo(conversationID: $0) }
        return try returnOrThrow(convs)
    }

    func setConversation(conversationID: String, req: OpenIMConversationReq) async throws {
        lastConversationReq = (conversationID, req)
        try throwIfNeeded()
    }

    func hideConversation(conversationID: String) async throws {
        lastHiddenConversationID = conversationID
        try throwIfNeeded()
    }

    func setConversationDraft(conversationID: String, draftText: String) async throws {
        lastDraft = (conversationID, draftText)
        try throwIfNeeded()
    }

    func setConversationPinned(conversationID: String, isPinned: Bool) async throws {
        lastPinned = (conversationID, isPinned)
        try throwIfNeeded()
    }

    func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt) async throws {
        lastRecvMessageOpt = (conversationIDs, status)
        try throwIfNeeded()
    }

    func markConversationMessageAsRead(conversationID: String) async throws {
        lastReadConversationID = conversationID
        try throwIfNeeded()
    }

    func getTotalUnreadMsgCount() async throws -> Int {
        return try returnOrThrow(5)
    }

    func deleteConversationAndDeleteAllMsg(conversationID: String) async throws {
        lastDeletedConversationID = conversationID
        try throwIfNeeded()
    }

    func clearConversationAndDeleteAllMsg(conversationID: String) async throws {
        lastClearedConversationID = conversationID
        try throwIfNeeded()
    }

    func setConversationListener(_ listener: OpenIMConversationListener?) {
        conversationListener = listener
    }

    // MARK: - Message
    func createTextMessage(text: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_1",
            contentType: .text,
            content: text,
            status: .sending,
            textElem: OpenIMTextElem(content: text)
        )
    }

    func createTextAtMessage(text: String, atUserIDs: [String], atUsersInfo: [OpenIMAtInfo], quoteMessage: OpenIMMessageInfo?) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_at",
            contentType: .at,
            content: text,
            atTextElem: OpenIMAtTextElem(text: text, atUserList: atUserIDs, atUsersInfo: atUsersInfo, quoteMessage: quoteMessage)
        )
    }

    func createImageMessage(imagePath: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_img",
            contentType: .image,
            pictureElem: OpenIMPictureElem(sourcePath: imagePath)
        )
    }

    func createSoundMessage(soundPath: String, duration: Int64) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_snd",
            contentType: .audio,
            soundElem: OpenIMSoundElem(soundPath: soundPath, duration: Int(duration))
        )
    }

    func createVideoMessage(videoPath: String, videoType: String, duration: Int64, snapshotPath: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_vid",
            contentType: .video,
            videoElem: OpenIMVideoElem(videoPath: videoPath, videoType: videoType, duration: Int(duration), snapshotPath: snapshotPath)
        )
    }

    func createFileMessage(filePath: String, fileName: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_file",
            contentType: .file,
            fileElem: OpenIMFileElem(filePath: filePath, fileName: fileName)
        )
    }

    func createLocationMessage(description: String, longitude: Double, latitude: Double) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_loc",
            contentType: .location,
            locationElem: OpenIMLocationElem(desc: description, longitude: longitude, latitude: latitude)
        )
    }

    func createCustomMessage(data: String, `extension`: String?, description: String?) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_custom",
            contentType: .custom,
            customElem: OpenIMCustomElem(data: data, desc: description, extension: `extension`)
        )
    }

    func createQuoteMessage(text: String, message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_quote",
            contentType: .quote,
            content: text,
            quoteElem: OpenIMQuoteElem(text: text, quoteMessage: message)
        )
    }

    func createCardMessage(cardInfo: OpenIMCardElem) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_card",
            contentType: .card,
            cardElem: cardInfo
        )
    }

    func createFaceMessage(index: Int, data: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_face",
            contentType: .face,
            faceElem: OpenIMFaceElem(index: index, data: data)
        )
    }

    func createMergerMessage(messageList: [OpenIMMessageInfo], title: String, summaryList: [String]) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_merge",
            contentType: .merge,
            mergeElem: OpenIMMergeElem(title: title, abstractList: summaryList, multiMessage: messageList)
        )
    }

    func createForwardMessage(message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        let copy = message
        copy.clientMsgID = "msg_test_fwd"
        return copy
    }

    func sendMessage(
        message: OpenIMMessageInfo,
        recvID: String?,
        groupID: String?,
        offlinePushInfo: OpenIMOfflinePushInfo?,
        isOnlineOnly: Bool,
        onProgress: ((Int) -> Void)?
    ) async throws -> OpenIMMessageInfo {
        message.recvID = recvID
        message.groupID = groupID
        lastSentMessage = message
        onProgress?(50)
        onProgress?(100)
        message.status = .sendSuccess
        return try returnOrThrow(message)
    }

    func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions) async throws -> OpenIMGetAdvancedHistoryMessageListInfo {
        let info = OpenIMGetAdvancedHistoryMessageListInfo(
            isEnd: true,
            lastMinSeq: 100,
            errCode: 0,
            errMsg: "",
            messageList: [
                OpenIMMessageInfo(clientMsgID: "hist_1", content: "History msg 1")
            ]
        )
        return try returnOrThrow(info)
    }

    func revokeMessage(conversationID: String, clientMsgID: String) async throws {
        lastRevokedMessage = (conversationID, clientMsgID)
        try throwIfNeeded()
    }

    func typingStatusUpdate(recvID: String, msgTip: String) async throws {
        lastTypingStatus = (recvID, msgTip)
        try throwIfNeeded()
    }

    func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String]) async throws {
        lastMarkedAsReadMsgIDs = (conversationID, clientMsgIDs)
        try throwIfNeeded()
    }

    func deleteMessage(conversationID: String, clientMsgID: String) async throws {
        lastDeletedMessage = (conversationID, clientMsgID)
        try throwIfNeeded()
    }

    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String) async throws {
        lastDeletedLocalMessage = (conversationID, clientMsgID)
        try throwIfNeeded()
    }

    func deleteAllMsgFromLocal() async throws {
        deleteAllLocalMsgCalled = true
        try throwIfNeeded()
    }

    func deleteAllMsgFromLocalAndSvr() async throws {
        deleteAllLocalAndSvrMsgCalled = true
        try throwIfNeeded()
    }

    func searchLocalMessages(param: OpenIMSearchParam) async throws -> OpenIMSearchResultInfo {
        lastSearchLocalMessagesParam = param
        let res = OpenIMSearchResultInfo(
            totalCount: 1,
            searchResultItems: [
                OpenIMSearchResultItemInfo(conversationID: "c1", messageCount: 1)
            ]
        )
        return try returnOrThrow(res)
    }

    func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?) {
        advancedMsgListener = listener
    }
}
