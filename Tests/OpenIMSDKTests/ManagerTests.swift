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

