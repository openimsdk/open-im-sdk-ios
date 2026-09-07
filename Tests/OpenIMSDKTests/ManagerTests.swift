import XCTest
@testable import OpenIMSDK

final class ManagerTests: XCTestCase {
    func testUserManagerCallsAdapter() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let selfUser = try await client.user.getSelfUserInfo()
        XCTAssertEqual(selfUser.userID, "test_self_id")
        XCTAssertEqual(selfUser.nickname, "Test Self")

        let publicUsers = try await client.user.getUsersInfo(userIDs: ["u1", "u2"])
        XCTAssertEqual(publicUsers.count, 2)
        XCTAssertEqual(publicUsers.first?.userID, "u1")

        try await client.user.setSelfUserInfo(userInfo: OpenIMUserInfo(userID: "test_self_id", nickname: "Updated Self"))
        XCTAssertEqual(adapter.lastUpdatedSelfInfo?.nickname, "Updated Self")
    }

    func testFriendManagerOperations() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let friends = try await client.friend.getFriendList()
        XCTAssertEqual(friends.count, 1)
        XCTAssertEqual(friends.first?.userID, "friend_1")

        let checks = try await client.friend.checkFriend(userIDs: ["friend_1"])
        XCTAssertEqual(checks.first?.result, 1)

        try await client.friend.addFriend(userID: "friend_2", reqMsg: "Hello!")
        XCTAssertEqual(adapter.lastAddedFriendID, "friend_2")

        try await client.friend.setFriendRemark(userID: "friend_1", remark: "Best Buddy")
        XCTAssertEqual(adapter.lastFriendRemark?.userID, "friend_1")
        XCTAssertEqual(adapter.lastFriendRemark?.remark, "Best Buddy")

        try await client.friend.deleteFriend(friendUserID: "friend_1")
        XCTAssertEqual(adapter.lastDeletedFriendID, "friend_1")

        let apps = try await client.friend.getFriendApplicationListAsRecipient()
        XCTAssertEqual(apps.first?.fromUserID, "applicant_1")

        try await client.friend.acceptFriendApplication(userID: "applicant_1", handleMsg: "Welcome")
        XCTAssertEqual(adapter.lastHandledApplication?.userID, "applicant_1")
        XCTAssertTrue(adapter.lastHandledApplication?.accepted ?? false)

        try await client.friend.addBlack(blackUserID: "spammer_1")
        XCTAssertEqual(adapter.lastBlackID, "spammer_1")

        let blacks = try await client.friend.getBlackList()
        XCTAssertEqual(blacks.first?.userID, "spammer_1")

        try await client.friend.removeBlack(blackUserID: "spammer_1")
        XCTAssertEqual(adapter.lastRemovedBlackID, "spammer_1")
    }

    func testGroupManagerOperations() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let groups = try await client.group.getJoinedGroupList()
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups.first?.groupID, "group_1")

        let createInfo = OpenIMGroupCreateInfo(
            groupInfo: OpenIMGroupBaseInfo(groupName: "New Group"),
            memberUserIDs: ["u1", "u2"]
        )
        let created = try await client.group.createGroup(createInfo: createInfo)
        XCTAssertEqual(created.groupName, "New Group")

        let members = try await client.group.getGroupMemberList(groupID: "group_1", filter: .all, offset: 0, count: 20)
        XCTAssertEqual(members.first?.userID, "member_1")

        try await client.group.joinGroup(groupID: "group_2", reqMsg: "Please let me in", joinSource: .invited)
        XCTAssertEqual(adapter.lastJoinedGroupID, "group_2")

        try await client.group.quitGroup(groupID: "group_1")
        XCTAssertEqual(adapter.lastQuitGroupID, "group_1")

        try await client.group.dismissGroup(groupID: "group_1")
        XCTAssertEqual(adapter.lastDismissedGroupID, "group_1")
    }

    func testConversationManagerOperations() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let total = try await client.conversation.getTotalUnreadMsgCount()
        XCTAssertEqual(total, 5)

        let convs = try await client.conversation.getAllConversationList()
        XCTAssertEqual(convs.first?.conversationID, "c_1")

        let single = try await client.conversation.getOneConversation(sessionType: .c2c, sourceID: "u2")
        XCTAssertEqual(single.conversationID, "c_1_u2")

        try await client.conversation.setConversationDraft(conversationID: "c_1", draftText: "Drafting...")
        XCTAssertEqual(adapter.lastDraft?.conversationID, "c_1")
        XCTAssertEqual(adapter.lastDraft?.draftText, "Drafting...")

        try await client.conversation.setConversationPinned(conversationID: "c_1", isPinned: true)
        XCTAssertEqual(adapter.lastPinned?.conversationID, "c_1")
        XCTAssertTrue(adapter.lastPinned?.isPinned ?? false)

        try await client.conversation.markConversationMessageAsRead(conversationID: "c_1")
        XCTAssertEqual(adapter.lastReadConversationID, "c_1")

        try await client.conversation.clearConversationAndDeleteAllMsg(conversationID: "c_1")
        XCTAssertEqual(adapter.lastClearedConversationID, "c_1")
    }

    func testMessageManagerOperations() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let textMsg = try client.message.createTextMessage(text: "Hello Swift!")
        XCTAssertEqual(textMsg.clientMsgID, "msg_test_1")
        XCTAssertEqual(textMsg.content, "Hello Swift!")

        let sent = try await client.message.sendMessage(message: textMsg, recvID: "u2")
        XCTAssertEqual(sent.status, .sendSuccess)

        let imageMsg = try client.message.createImageMessage(imagePath: "/tmp/test.jpg")
        XCTAssertEqual(imageMsg.contentType, .image)

        let soundMsg = try client.message.createSoundMessage(soundPath: "/tmp/test.mp3", duration: 10)
        XCTAssertEqual(soundMsg.contentType, .audio)

        let videoMsg = try client.message.createVideoMessage(
            videoPath: "/tmp/test.mp4",
            videoType: "mp4",
            duration: 30,
            snapshotPath: "/tmp/snapshot.jpg"
        )
        XCTAssertEqual(videoMsg.contentType, .video)

        let fileMsg = try client.message.createFileMessage(filePath: "/tmp/test.pdf", fileName: "test.pdf")
        XCTAssertEqual(fileMsg.contentType, .file)

        let quoteMsg = try client.message.createQuoteMessage(text: "Quoting you", message: textMsg)
        XCTAssertEqual(quoteMsg.contentType, OpenIMMessageContentType.quote)

        let customMsg = try client.message.createCustomMessage(data: "{}", extension: "ext", description: "desc")
        XCTAssertEqual(customMsg.contentType, .custom)

        try await client.message.revokeMessage(conversationID: "c_1", clientMsgID: "msg_test_1")
        XCTAssertEqual(adapter.lastRevokedMessage?.clientMsgID, "msg_test_1")

        try await client.message.deleteMessageFromLocalStorage(conversationID: "c_1", clientMsgID: "msg_test_1")
        XCTAssertEqual(adapter.lastDeletedLocalMessage?.clientMsgID, "msg_test_1")
    }

    func testAdapterErrorPropagation() async {
        let adapter = MockOpenIMCoreAdapter()
        adapter.shouldFail = true
        let client = OpenIMClient(adapter: adapter)

        do {
            _ = try await client.user.getSelfUserInfo()
            XCTFail("Expected error not thrown")
        } catch let error as OpenIMError {
            if case let .core(code, message) = error {
                XCTAssertEqual(code, -999)
                XCTAssertEqual(message, "Simulated network failure")
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

// MARK: - Mock Adapter
private final class MockOpenIMCoreAdapter: OpenIMCoreAdapter, @unchecked Sendable {
    var shouldFail: Bool = false

    var lastUpdatedSelfInfo: OpenIMUserInfo?
    var lastAddedFriendID: String?
    var lastFriendRemark: (userID: String, remark: String)?
    var lastDeletedFriendID: String?
    var lastHandledApplication: (userID: String, accepted: Bool)?
    var lastBlackID: String?
    var lastRemovedBlackID: String?
    var lastJoinedGroupID: String?
    var lastQuitGroupID: String?
    var lastDismissedGroupID: String?
    var lastDraft: (conversationID: String, draftText: String)?
    var lastPinned: (conversationID: String, isPinned: Bool)?
    var lastReadConversationID: String?
    var lastClearedConversationID: String?
    var lastRevokedMessage: (conversationID: String, clientMsgID: String)?
    var lastDeletedLocalMessage: (conversationID: String, clientMsgID: String)?

    func initialize(configuration: OpenIMConfiguration, eventHandler: @escaping (OpenIMCoreEvent) -> Void) throws {}
    func login(userID: String, token: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) { completion(.success(())) }
    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) { completion(.success(())) }
    func uninitialize() {}

    private func returnOrError<T>(_ value: T, completion: @escaping (Result<T, OpenIMError>) -> Void) {
        if shouldFail {
            completion(.failure(.core(code: -999, message: "Simulated network failure")))
        } else {
            completion(.success(value))
        }
    }

    private func returnOrErrorVoid(completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        if shouldFail {
            completion(.failure(.core(code: -999, message: "Simulated network failure")))
        } else {
            completion(.success(()))
        }
    }

    func getSelfUserInfo(completion: @escaping (Result<OpenIMUserInfo, OpenIMError>) -> Void) {
        returnOrError(OpenIMUserInfo(userID: "test_self_id", nickname: "Test Self"), completion: completion)
    }

    func setSelfUserInfo(userInfo: OpenIMUserInfo, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastUpdatedSelfInfo = userInfo
        returnOrErrorVoid(completion: completion)
    }

    func getUsersInfo(userIDs: [String], completion: @escaping (Result<[OpenIMPublicUserInfo], OpenIMError>) -> Void) {
        let users = userIDs.map { OpenIMPublicUserInfo(userID: $0, nickname: "Nick_\($0)") }
        returnOrError(users, completion: completion)
    }

    func getFriendList(filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
        returnOrError([OpenIMFriendInfo(userID: "friend_1", nickname: "Friend 1")], completion: completion)
    }

    func checkFriend(userIDs: [String], completion: @escaping (Result<[OpenIMFriendCheckResult], OpenIMError>) -> Void) {
        returnOrError(userIDs.map { OpenIMFriendCheckResult(userID: $0, result: 1) }, completion: completion)
    }

    func addFriend(userID: String, reqMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastAddedFriendID = userID
        returnOrErrorVoid(completion: completion)
    }

    func setFriendRemark(userID: String, remark: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastFriendRemark = (userID, remark)
        returnOrErrorVoid(completion: completion)
    }

    func deleteFriend(friendUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastDeletedFriendID = friendUserID
        returnOrErrorVoid(completion: completion)
    }

    func getFriendApplicationListAsRecipient(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void) {
        returnOrError([OpenIMFriendApplication(fromUserID: "applicant_1", fromNickname: "Applicant 1")], completion: completion)
    }

    func getFriendApplicationListAsApplicant(completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void) {
        returnOrError([OpenIMFriendApplication(toUserID: "applicant_2", toNickname: "Applicant 2")], completion: completion)
    }

    func acceptFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastHandledApplication = (userID, true)
        returnOrErrorVoid(completion: completion)
    }

    func refuseFriendApplication(userID: String, handleMsg: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastHandledApplication = (userID, false)
        returnOrErrorVoid(completion: completion)
    }

    func addBlack(blackUserID: String, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastBlackID = blackUserID
        returnOrErrorVoid(completion: completion)
    }

    func removeBlack(blackUserID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastRemovedBlackID = blackUserID
        returnOrErrorVoid(completion: completion)
    }

    func getBlackList(completion: @escaping (Result<[OpenIMBlackInfo], OpenIMError>) -> Void) {
        returnOrError([OpenIMBlackInfo(ownerUserID: "self", userID: "spammer_1", nickname: "Spammer")], completion: completion)
    }

    func getJoinedGroupList(completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
        returnOrError([OpenIMGroupInfo(groupID: "group_1", groupName: "Group 1")], completion: completion)
    }

    func createGroup(createInfo: OpenIMGroupCreateInfo, completion: @escaping (Result<OpenIMGroupInfo, OpenIMError>) -> Void) {
        returnOrError(OpenIMGroupInfo(groupID: "new_g_1", groupName: createInfo.groupInfo.groupName), completion: completion)
    }

    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter, offset: Int, count: Int, completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void) {
        returnOrError([OpenIMGroupMemberInfo(groupID: groupID, userID: "member_1", nickname: "Member 1")], completion: completion)
    }

    func joinGroup(groupID: String, reqMsg: String?, joinSource: OpenIMJoinType, ex: String?, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastJoinedGroupID = groupID
        returnOrErrorVoid(completion: completion)
    }

    func quitGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastQuitGroupID = groupID
        returnOrErrorVoid(completion: completion)
    }

    func dismissGroup(groupID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastDismissedGroupID = groupID
        returnOrErrorVoid(completion: completion)
    }

    func getTotalUnreadMsgCount(completion: @escaping (Result<Int, OpenIMError>) -> Void) {
        returnOrError(5, completion: completion)
    }

    func getAllConversationList(completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
        returnOrError([OpenIMConversationInfo(conversationID: "c_1", unreadCount: 2)], completion: completion)
    }

    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String, completion: @escaping (Result<OpenIMConversationInfo, OpenIMError>) -> Void) {
        returnOrError(OpenIMConversationInfo(conversationID: "c_\(sessionType.rawValue)_\(sourceID)", conversationType: sessionType), completion: completion)
    }

    func setConversationDraft(conversationID: String, draftText: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastDraft = (conversationID, draftText)
        returnOrErrorVoid(completion: completion)
    }

    func setConversationPinned(conversationID: String, isPinned: Bool, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastPinned = (conversationID, isPinned)
        returnOrErrorVoid(completion: completion)
    }

    func markConversationMessageAsRead(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastReadConversationID = conversationID
        returnOrErrorVoid(completion: completion)
    }

    func clearConversationAndDeleteAllMsg(conversationID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastClearedConversationID = conversationID
        returnOrErrorVoid(completion: completion)
    }

    func createTextMessage(text: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_test_1",
            contentType: .text,
            content: text,
            status: .sending,
            textElem: OpenIMTextElem(content: text)
        )
    }

    func createImageMessage(imagePath: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_img_1",
            contentType: .image,
            pictureElem: OpenIMPictureElem(sourcePath: imagePath)
        )
    }

    func createSoundMessage(soundPath: String, duration: Int64) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_snd_1",
            contentType: .audio,
            soundElem: OpenIMSoundElem(soundPath: soundPath, duration: Int(duration))
        )
    }

    func createVideoMessage(videoPath: String, videoType: String, duration: Int64, snapshotPath: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_vid_1",
            contentType: .video,
            videoElem: OpenIMVideoElem(videoPath: videoPath, videoType: videoType, duration: Int(duration), snapshotPath: snapshotPath)
        )
    }

    func createFileMessage(filePath: String, fileName: String) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_file_1",
            contentType: .file,
            fileElem: OpenIMFileElem(filePath: filePath, fileName: fileName)
        )
    }

    func createQuoteMessage(text: String, message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_quote_1",
            contentType: .quote,
            content: text,
            quoteElem: OpenIMQuoteElem(text: text, quoteMessage: message)
        )
    }

    func createCustomMessage(data: String, `extension`: String?, description: String?) throws -> OpenIMMessageInfo {
        OpenIMMessageInfo(
            clientMsgID: "msg_custom_1",
            contentType: .custom,
            customElem: OpenIMCustomElem(data: data, desc: description, extension: `extension`)
        )
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
        message.status = .sendSuccess
        returnOrError(message, completion: completion)
    }

    func revokeMessage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastRevokedMessage = (conversationID, clientMsgID)
        returnOrErrorVoid(completion: completion)
    }

    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) {
        lastDeletedLocalMessage = (conversationID, clientMsgID)
        returnOrErrorVoid(completion: completion)
    }
}
