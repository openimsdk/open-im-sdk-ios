import XCTest
@testable import OpenIMSDK

final class ListenerTests: XCTestCase {
    func testUserListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expInfo = expectation(description: "self info updated")
        let expStatus = expectation(description: "user status changed")

        let listener = TestUserListener(
            onSelfInfoUpdatedCallback: { info in
                XCTAssertEqual(info.userID, "6932496926")
                XCTAssertEqual(info.nickname, "5234")
                expInfo.fulfill()
            },
            onUserStatusChangedCallback: { status in
                XCTAssertEqual(status.userID, "6932496926")
                XCTAssertEqual(status.status, 1)
                expStatus.fulfill()
            }
        )

        client.setUserListener(listener)
        adapter.simulateSelfInfoUpdated(OpenIMUserInfo(userID: "6932496926", nickname: "5234"))
        adapter.simulateUserStatusChanged(OpenIMUserStatusInfo(userID: "6932496926", status: 1))

        wait(for: [expInfo, expStatus], timeout: 2.0)
    }

    func testFriendshipListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expAdded = expectation(description: "friend added")
        let expDeleted = expectation(description: "friend deleted")
        let expChanged = expectation(description: "friend info changed")
        let expAppAdded = expectation(description: "app added")
        let expAppDeleted = expectation(description: "app deleted")
        let expAppAccepted = expectation(description: "app accepted")
        let expAppRejected = expectation(description: "app rejected")
        let expBlackAdded = expectation(description: "black added")
        let expBlackDeleted = expectation(description: "black deleted")

        let listener = TestFriendshipListener(
            onFriendAddedCallback: { friend in
                XCTAssertEqual(friend.userID, "f_100")
                expAdded.fulfill()
            },
            onFriendDeletedCallback: { friend in
                XCTAssertEqual(friend.userID, "f_100")
                expDeleted.fulfill()
            },
            onFriendInfoChangedCallback: { friend in
                XCTAssertEqual(friend.userID, "f_100")
                expChanged.fulfill()
            },
            onFriendApplicationAddedCallback: { app in
                XCTAssertEqual(app.fromUserID, "app_1")
                expAppAdded.fulfill()
            },
            onFriendApplicationDeletedCallback: { app in
                XCTAssertEqual(app.fromUserID, "app_1")
                expAppDeleted.fulfill()
            },
            onFriendApplicationAcceptedCallback: { app in
                XCTAssertEqual(app.fromUserID, "app_1")
                expAppAccepted.fulfill()
            },
            onFriendApplicationRejectedCallback: { app in
                XCTAssertEqual(app.fromUserID, "app_1")
                expAppRejected.fulfill()
            },
            onBlackAddedCallback: { black in
                XCTAssertEqual(black.userID, "b_1")
                expBlackAdded.fulfill()
            },
            onBlackDeletedCallback: { black in
                XCTAssertEqual(black.userID, "b_1")
                expBlackDeleted.fulfill()
            }
        )

        client.setFriendshipListener(listener)
        adapter.simulateFriendAdded(OpenIMFriendInfo(userID: "f_100", nickname: "Friend 100"))
        adapter.simulateFriendDeleted(OpenIMFriendInfo(userID: "f_100", nickname: "Friend 100"))
        adapter.simulateFriendInfoChanged(OpenIMFriendInfo(userID: "f_100", nickname: "Friend 100 Changed"))
        adapter.simulateFriendApplicationAdded(OpenIMFriendApplication(fromUserID: "app_1"))
        adapter.simulateFriendApplicationDeleted(OpenIMFriendApplication(fromUserID: "app_1"))
        adapter.simulateFriendApplicationAccepted(OpenIMFriendApplication(fromUserID: "app_1"))
        adapter.simulateFriendApplicationRejected(OpenIMFriendApplication(fromUserID: "app_1"))
        adapter.simulateBlackAdded(OpenIMBlackInfo(userID: "b_1"))
        adapter.simulateBlackDeleted(OpenIMBlackInfo(userID: "b_1"))

        wait(for: [expAdded, expDeleted, expChanged, expAppAdded, expAppDeleted, expAppAccepted, expAppRejected, expBlackAdded, expBlackDeleted], timeout: 2.0)
    }

    func testGroupListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expJoined = expectation(description: "group added")
        let expJoinedDismissed = expectation(description: "group dismissed from joined")
        let expMemberAdded = expectation(description: "member added")
        let expMemberDeleted = expectation(description: "member deleted")
        let expMemberChanged = expectation(description: "member changed")
        let expAppAdded = expectation(description: "group app added")
        let expAppDeleted = expectation(description: "group app deleted")
        let expAppAccepted = expectation(description: "group app accepted")
        let expAppRejected = expectation(description: "group app rejected")
        let expInfoChanged = expectation(description: "group info changed")
        let expDismissed = expectation(description: "group dismissed")

        let listener = TestGroupListener(
            onJoinedGroupAddedCallback: { group in
                XCTAssertEqual(group.groupID, "g_1")
                expJoined.fulfill()
            },
            onJoinedGroupDismissedCallback: { group in
                XCTAssertEqual(group.groupID, "g_1")
                expJoinedDismissed.fulfill()
            },
            onGroupMemberAddedCallback: { member in
                XCTAssertEqual(member.userID, "m_1")
                expMemberAdded.fulfill()
            },
            onGroupMemberDeletedCallback: { member in
                XCTAssertEqual(member.userID, "m_1")
                expMemberDeleted.fulfill()
            },
            onGroupMemberInfoChangedCallback: { member in
                XCTAssertEqual(member.userID, "m_1")
                expMemberChanged.fulfill()
            },
            onGroupApplicationAddedCallback: { app in
                XCTAssertEqual(app.userID, "u_app_1")
                expAppAdded.fulfill()
            },
            onGroupApplicationDeletedCallback: { app in
                XCTAssertEqual(app.userID, "u_app_1")
                expAppDeleted.fulfill()
            },
            onGroupApplicationAcceptedCallback: { app in
                XCTAssertEqual(app.userID, "u_app_1")
                expAppAccepted.fulfill()
            },
            onGroupApplicationRejectedCallback: { app in
                XCTAssertEqual(app.userID, "u_app_1")
                expAppRejected.fulfill()
            },
            onGroupInfoChangedCallback: { group in
                XCTAssertEqual(group.groupID, "g_1")
                expInfoChanged.fulfill()
            },
            onGroupDismissedCallback: { group in
                XCTAssertEqual(group.groupID, "g_1")
                expDismissed.fulfill()
            }
        )

        client.setGroupListener(listener)
        adapter.simulateGroupAdded(OpenIMGroupInfo(groupID: "g_1"))
        adapter.simulateJoinedGroupDismissed(OpenIMGroupInfo(groupID: "g_1"))
        adapter.simulateGroupMemberAdded(OpenIMGroupMemberInfo(groupID: "g_1", userID: "m_1"))
        adapter.simulateGroupMemberDeleted(OpenIMGroupMemberInfo(groupID: "g_1", userID: "m_1"))
        adapter.simulateGroupMemberInfoChanged(OpenIMGroupMemberInfo(groupID: "g_1", userID: "m_1"))
        adapter.simulateGroupApplicationAdded(OpenIMGroupApplicationInfo(groupID: "g_1", userID: "u_app_1"))
        adapter.simulateGroupApplicationDeleted(OpenIMGroupApplicationInfo(groupID: "g_1", userID: "u_app_1"))
        adapter.simulateGroupApplicationAccepted(OpenIMGroupApplicationInfo(groupID: "g_1", userID: "u_app_1"))
        adapter.simulateGroupApplicationRejected(OpenIMGroupApplicationInfo(groupID: "g_1", userID: "u_app_1"))
        adapter.simulateGroupInfoChanged(OpenIMGroupInfo(groupID: "g_1"))
        adapter.simulateGroupDismissed(OpenIMGroupInfo(groupID: "g_1"))

        wait(for: [
            expJoined, expJoinedDismissed, expMemberAdded, expMemberDeleted,
            expMemberChanged, expAppAdded, expAppDeleted, expAppAccepted,
            expAppRejected, expInfoChanged, expDismissed
        ], timeout: 2.0)
    }

    func testConversationListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expStart = expectation(description: "sync start")
        let expFinish = expectation(description: "sync finish")
        let expProgress = expectation(description: "sync progress")
        let expFailed = expectation(description: "sync failed")
        let expNew = expectation(description: "new conversation")
        let expChanged = expectation(description: "conversation changed")
        let expUnread = expectation(description: "unread count changed")

        let listener = TestConversationListener(
            onSyncServerStartCallback: { expStart.fulfill() },
            onSyncServerFinishCallback: { expFinish.fulfill() },
            onSyncServerProgressCallback: { p in
                XCTAssertEqual(p, 80)
                expProgress.fulfill()
            },
            onSyncServerFailedCallback: { expFailed.fulfill() },
            onNewConversationCallback: { convs in
                XCTAssertEqual(convs.first?.conversationID, "c_new")
                expNew.fulfill()
            },
            onConversationChangedCallback: { convs in
                XCTAssertEqual(convs.first?.conversationID, "c_mod")
                expChanged.fulfill()
            },
            onTotalUnreadMessageCountChangedCallback: { count in
                XCTAssertEqual(count, 42)
                expUnread.fulfill()
            }
        )

        client.setConversationListener(listener)
        adapter.simulateSyncServerStart()
        adapter.simulateSyncServerFinish()
        adapter.simulateSyncServerProgress(80)
        adapter.simulateSyncServerFailed()
        adapter.simulateNewConversation([OpenIMConversationInfo(conversationID: "c_new")])
        adapter.simulateConversationChanged([OpenIMConversationInfo(conversationID: "c_mod")])
        adapter.simulateTotalUnreadCountChanged(42)

        wait(for: [expStart, expFinish, expProgress, expFailed, expNew, expChanged, expUnread], timeout: 2.0)
    }

    func testAdvancedMsgListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expMsg = expectation(description: "recv new message")
        let expC2C = expectation(description: "recv c2c receipt")
        let expGroup = expectation(description: "recv group receipt")
        let expRevoked = expectation(description: "recv message revoked")

        let listener = TestAdvancedMsgListener(
            onRecvNewMessageCallback: { msg in
                XCTAssertEqual(msg.clientMsgID, "msg_test_live_1")
                expMsg.fulfill()
            },
            onRecvC2CReadReceiptCallback: { receipts in
                XCTAssertEqual(receipts.first?.userID, "u_c2c")
                expC2C.fulfill()
            },
            onRecvGroupReadReceiptCallback: { receipts in
                XCTAssertEqual(receipts.first?.groupID, "g_group")
                expGroup.fulfill()
            },
            onRecvMessageRevokedCallback: { revoked in
                XCTAssertEqual(revoked.clientMsgID, "msg_test_live_1")
                expRevoked.fulfill()
            }
        )

        client.setAdvancedMsgListener(listener)

        let msg = OpenIMMessageInfo(clientMsgID: "msg_test_live_1", content: "Unit Test Message")
        let c2cReceipt = OpenIMReceiptInfo(userID: "u_c2c")
        let groupReceipt = OpenIMReceiptInfo(groupID: "g_group")
        let revoked = OpenIMMessageRevokedInfo(clientMsgID: "msg_test_live_1")

        adapter.simulateRecvNewMessage(msg)
        adapter.simulateRecvC2CReadReceipt([c2cReceipt])
        adapter.simulateRecvGroupReadReceipt([groupReceipt])
        adapter.simulateRecvMessageRevoked(revoked)

        wait(for: [expMsg, expC2C, expGroup, expRevoked], timeout: 2.0)
    }

    func testListenerRemovalStopsEvents() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        var eventCount = 0
        let listener = TestUserListener(onSelfInfoUpdatedCallback: { _ in
            eventCount += 1
        })

        client.setUserListener(listener)
        adapter.simulateSelfInfoUpdated(OpenIMUserInfo(userID: "u1"))

        let exp = expectation(description: "flush queue")
        DispatchQueue.main.async {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(eventCount, 1)

        client.setUserListener(nil)
        adapter.simulateSelfInfoUpdated(OpenIMUserInfo(userID: "u2"))

        let exp2 = expectation(description: "flush queue 2")
        DispatchQueue.main.async {
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 1.0)
        XCTAssertEqual(eventCount, 1, "Listener should not receive events after removal")
    }
}

// MARK: - Test Listeners
private final class TestUserListener: OpenIMUserListener, @unchecked Sendable {
    var onSelfInfoUpdatedCallback: ((OpenIMUserInfo) -> Void)?
    var onUserStatusChangedCallback: ((OpenIMUserStatusInfo) -> Void)?

    init(
        onSelfInfoUpdatedCallback: ((OpenIMUserInfo) -> Void)? = nil,
        onUserStatusChangedCallback: ((OpenIMUserStatusInfo) -> Void)? = nil
    ) {
        self.onSelfInfoUpdatedCallback = onSelfInfoUpdatedCallback
        self.onUserStatusChangedCallback = onUserStatusChangedCallback
    }

    func onSelfInfoUpdated(_ userInfo: OpenIMUserInfo) {
        onSelfInfoUpdatedCallback?(userInfo)
    }

    func onUserStatusChanged(_ statusInfo: OpenIMUserStatusInfo) {
        onUserStatusChangedCallback?(statusInfo)
    }
}

private final class TestFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {
    var onFriendAddedCallback: ((OpenIMFriendInfo) -> Void)?
    var onFriendDeletedCallback: ((OpenIMFriendInfo) -> Void)?
    var onFriendInfoChangedCallback: ((OpenIMFriendInfo) -> Void)?
    var onFriendApplicationAddedCallback: ((OpenIMFriendApplication) -> Void)?
    var onFriendApplicationDeletedCallback: ((OpenIMFriendApplication) -> Void)?
    var onFriendApplicationAcceptedCallback: ((OpenIMFriendApplication) -> Void)?
    var onFriendApplicationRejectedCallback: ((OpenIMFriendApplication) -> Void)?
    var onBlackAddedCallback: ((OpenIMBlackInfo) -> Void)?
    var onBlackDeletedCallback: ((OpenIMBlackInfo) -> Void)?

    init(
        onFriendAddedCallback: ((OpenIMFriendInfo) -> Void)? = nil,
        onFriendDeletedCallback: ((OpenIMFriendInfo) -> Void)? = nil,
        onFriendInfoChangedCallback: ((OpenIMFriendInfo) -> Void)? = nil,
        onFriendApplicationAddedCallback: ((OpenIMFriendApplication) -> Void)? = nil,
        onFriendApplicationDeletedCallback: ((OpenIMFriendApplication) -> Void)? = nil,
        onFriendApplicationAcceptedCallback: ((OpenIMFriendApplication) -> Void)? = nil,
        onFriendApplicationRejectedCallback: ((OpenIMFriendApplication) -> Void)? = nil,
        onBlackAddedCallback: ((OpenIMBlackInfo) -> Void)? = nil,
        onBlackDeletedCallback: ((OpenIMBlackInfo) -> Void)? = nil
    ) {
        self.onFriendAddedCallback = onFriendAddedCallback
        self.onFriendDeletedCallback = onFriendDeletedCallback
        self.onFriendInfoChangedCallback = onFriendInfoChangedCallback
        self.onFriendApplicationAddedCallback = onFriendApplicationAddedCallback
        self.onFriendApplicationDeletedCallback = onFriendApplicationDeletedCallback
        self.onFriendApplicationAcceptedCallback = onFriendApplicationAcceptedCallback
        self.onFriendApplicationRejectedCallback = onFriendApplicationRejectedCallback
        self.onBlackAddedCallback = onBlackAddedCallback
        self.onBlackDeletedCallback = onBlackDeletedCallback
    }

    func onFriendAdded(_ friendInfo: OpenIMFriendInfo) { onFriendAddedCallback?(friendInfo) }
    func onFriendDeleted(_ friendInfo: OpenIMFriendInfo) { onFriendDeletedCallback?(friendInfo) }
    func onFriendInfoChanged(_ friendInfo: OpenIMFriendInfo) { onFriendInfoChangedCallback?(friendInfo) }
    func onFriendApplicationAdded(_ application: OpenIMFriendApplication) { onFriendApplicationAddedCallback?(application) }
    func onFriendApplicationDeleted(_ application: OpenIMFriendApplication) { onFriendApplicationDeletedCallback?(application) }
    func onFriendApplicationAccepted(_ application: OpenIMFriendApplication) { onFriendApplicationAcceptedCallback?(application) }
    func onFriendApplicationRejected(_ application: OpenIMFriendApplication) { onFriendApplicationRejectedCallback?(application) }
    func onBlackAdded(_ blackInfo: OpenIMBlackInfo) { onBlackAddedCallback?(blackInfo) }
    func onBlackDeleted(_ blackInfo: OpenIMBlackInfo) { onBlackDeletedCallback?(blackInfo) }
}

private final class TestGroupListener: OpenIMGroupListener, @unchecked Sendable {
    var onJoinedGroupAddedCallback: ((OpenIMGroupInfo) -> Void)?
    var onJoinedGroupDismissedCallback: ((OpenIMGroupInfo) -> Void)?
    var onGroupMemberAddedCallback: ((OpenIMGroupMemberInfo) -> Void)?
    var onGroupMemberDeletedCallback: ((OpenIMGroupMemberInfo) -> Void)?
    var onGroupMemberInfoChangedCallback: ((OpenIMGroupMemberInfo) -> Void)?
    var onGroupApplicationAddedCallback: ((OpenIMGroupApplicationInfo) -> Void)?
    var onGroupApplicationDeletedCallback: ((OpenIMGroupApplicationInfo) -> Void)?
    var onGroupApplicationAcceptedCallback: ((OpenIMGroupApplicationInfo) -> Void)?
    var onGroupApplicationRejectedCallback: ((OpenIMGroupApplicationInfo) -> Void)?
    var onGroupInfoChangedCallback: ((OpenIMGroupInfo) -> Void)?
    var onGroupDismissedCallback: ((OpenIMGroupInfo) -> Void)?

    init(
        onJoinedGroupAddedCallback: ((OpenIMGroupInfo) -> Void)? = nil,
        onJoinedGroupDismissedCallback: ((OpenIMGroupInfo) -> Void)? = nil,
        onGroupMemberAddedCallback: ((OpenIMGroupMemberInfo) -> Void)? = nil,
        onGroupMemberDeletedCallback: ((OpenIMGroupMemberInfo) -> Void)? = nil,
        onGroupMemberInfoChangedCallback: ((OpenIMGroupMemberInfo) -> Void)? = nil,
        onGroupApplicationAddedCallback: ((OpenIMGroupApplicationInfo) -> Void)? = nil,
        onGroupApplicationDeletedCallback: ((OpenIMGroupApplicationInfo) -> Void)? = nil,
        onGroupApplicationAcceptedCallback: ((OpenIMGroupApplicationInfo) -> Void)? = nil,
        onGroupApplicationRejectedCallback: ((OpenIMGroupApplicationInfo) -> Void)? = nil,
        onGroupInfoChangedCallback: ((OpenIMGroupInfo) -> Void)? = nil,
        onGroupDismissedCallback: ((OpenIMGroupInfo) -> Void)? = nil
    ) {
        self.onJoinedGroupAddedCallback = onJoinedGroupAddedCallback
        self.onJoinedGroupDismissedCallback = onJoinedGroupDismissedCallback
        self.onGroupMemberAddedCallback = onGroupMemberAddedCallback
        self.onGroupMemberDeletedCallback = onGroupMemberDeletedCallback
        self.onGroupMemberInfoChangedCallback = onGroupMemberInfoChangedCallback
        self.onGroupApplicationAddedCallback = onGroupApplicationAddedCallback
        self.onGroupApplicationDeletedCallback = onGroupApplicationDeletedCallback
        self.onGroupApplicationAcceptedCallback = onGroupApplicationAcceptedCallback
        self.onGroupApplicationRejectedCallback = onGroupApplicationRejectedCallback
        self.onGroupInfoChangedCallback = onGroupInfoChangedCallback
        self.onGroupDismissedCallback = onGroupDismissedCallback
    }

    func onJoinedGroupAdded(_ groupInfo: OpenIMGroupInfo) { onJoinedGroupAddedCallback?(groupInfo) }
    func onJoinedGroupDismissed(_ groupInfo: OpenIMGroupInfo) { onJoinedGroupDismissedCallback?(groupInfo) }
    func onGroupMemberAdded(_ memberInfo: OpenIMGroupMemberInfo) { onGroupMemberAddedCallback?(memberInfo) }
    func onGroupMemberDeleted(_ memberInfo: OpenIMGroupMemberInfo) { onGroupMemberDeletedCallback?(memberInfo) }
    func onGroupMemberInfoChanged(_ memberInfo: OpenIMGroupMemberInfo) { onGroupMemberInfoChangedCallback?(memberInfo) }
    func onGroupApplicationAdded(_ application: OpenIMGroupApplicationInfo) { onGroupApplicationAddedCallback?(application) }
    func onGroupApplicationDeleted(_ application: OpenIMGroupApplicationInfo) { onGroupApplicationDeletedCallback?(application) }
    func onGroupApplicationAccepted(_ application: OpenIMGroupApplicationInfo) { onGroupApplicationAcceptedCallback?(application) }
    func onGroupApplicationRejected(_ application: OpenIMGroupApplicationInfo) { onGroupApplicationRejectedCallback?(application) }
    func onGroupInfoChanged(_ groupInfo: OpenIMGroupInfo) { onGroupInfoChangedCallback?(groupInfo) }
    func onGroupDismissed(_ groupInfo: OpenIMGroupInfo) { onGroupDismissedCallback?(groupInfo) }
}

private final class TestConversationListener: OpenIMConversationListener, @unchecked Sendable {
    var onSyncServerStartCallback: (() -> Void)?
    var onSyncServerFinishCallback: (() -> Void)?
    var onSyncServerProgressCallback: ((Int) -> Void)?
    var onSyncServerFailedCallback: (() -> Void)?
    var onNewConversationCallback: (([OpenIMConversationInfo]) -> Void)?
    var onConversationChangedCallback: (([OpenIMConversationInfo]) -> Void)?
    var onTotalUnreadMessageCountChangedCallback: ((Int) -> Void)?

    init(
        onSyncServerStartCallback: (() -> Void)? = nil,
        onSyncServerFinishCallback: (() -> Void)? = nil,
        onSyncServerProgressCallback: ((Int) -> Void)? = nil,
        onSyncServerFailedCallback: (() -> Void)? = nil,
        onNewConversationCallback: (([OpenIMConversationInfo]) -> Void)? = nil,
        onConversationChangedCallback: (([OpenIMConversationInfo]) -> Void)? = nil,
        onTotalUnreadMessageCountChangedCallback: ((Int) -> Void)? = nil
    ) {
        self.onSyncServerStartCallback = onSyncServerStartCallback
        self.onSyncServerFinishCallback = onSyncServerFinishCallback
        self.onSyncServerProgressCallback = onSyncServerProgressCallback
        self.onSyncServerFailedCallback = onSyncServerFailedCallback
        self.onNewConversationCallback = onNewConversationCallback
        self.onConversationChangedCallback = onConversationChangedCallback
        self.onTotalUnreadMessageCountChangedCallback = onTotalUnreadMessageCountChangedCallback
    }

    func onSyncServerStart() { onSyncServerStartCallback?() }
    func onSyncServerFinish() { onSyncServerFinishCallback?() }
    func onSyncServerProgress(_ progress: Int) { onSyncServerProgressCallback?(progress) }
    func onSyncServerFailed() { onSyncServerFailedCallback?() }
    func onNewConversation(_ conversations: [OpenIMConversationInfo]) { onNewConversationCallback?(conversations) }
    func onConversationChanged(_ conversations: [OpenIMConversationInfo]) { onConversationChangedCallback?(conversations) }
    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int) { onTotalUnreadMessageCountChangedCallback?(totalUnreadCount) }
}

private final class TestAdvancedMsgListener: OpenIMAdvancedMsgListener, @unchecked Sendable {
    var onRecvNewMessageCallback: ((OpenIMMessageInfo) -> Void)?
    var onRecvC2CReadReceiptCallback: (([OpenIMReceiptInfo]) -> Void)?
    var onRecvGroupReadReceiptCallback: (([OpenIMReceiptInfo]) -> Void)?
    var onRecvMessageRevokedCallback: ((OpenIMMessageRevokedInfo) -> Void)?

    init(
        onRecvNewMessageCallback: ((OpenIMMessageInfo) -> Void)? = nil,
        onRecvC2CReadReceiptCallback: (([OpenIMReceiptInfo]) -> Void)? = nil,
        onRecvGroupReadReceiptCallback: (([OpenIMReceiptInfo]) -> Void)? = nil,
        onRecvMessageRevokedCallback: ((OpenIMMessageRevokedInfo) -> Void)? = nil
    ) {
        self.onRecvNewMessageCallback = onRecvNewMessageCallback
        self.onRecvC2CReadReceiptCallback = onRecvC2CReadReceiptCallback
        self.onRecvGroupReadReceiptCallback = onRecvGroupReadReceiptCallback
        self.onRecvMessageRevokedCallback = onRecvMessageRevokedCallback
    }

    func onRecvNewMessage(_ message: OpenIMMessageInfo) { onRecvNewMessageCallback?(message) }
    func onRecvC2CReadReceipt(_ receipts: [OpenIMReceiptInfo]) { onRecvC2CReadReceiptCallback?(receipts) }
    func onRecvGroupReadReceipt(_ receipts: [OpenIMReceiptInfo]) { onRecvGroupReadReceiptCallback?(receipts) }
    func onRecvMessageRevoked(_ messageRevoked: OpenIMMessageRevokedInfo) { onRecvMessageRevokedCallback?(messageRevoked) }
}

// MARK: - Mock Listener Adapter
private final class MockListenerOpenIMCoreAdapter: OpenIMCoreAdapter {
    private var userListener: OpenIMUserListener?
    private var friendshipListener: OpenIMFriendshipListener?
    private var groupListener: OpenIMGroupListener?
    private var conversationListener: OpenIMConversationListener?
    private var advancedMsgListener: OpenIMAdvancedMsgListener?

    func initialize(configuration: OpenIMConfiguration, eventHandler: @escaping (OpenIMCoreEvent) -> Void) throws {}
    func login(userID: String, token: String) async throws {}
    func logout() async throws {}
    func uninitialize() {}

    func setUserListener(_ listener: OpenIMUserListener?) { self.userListener = listener }
    func setFriendshipListener(_ listener: OpenIMFriendshipListener?) { self.friendshipListener = listener }
    func setGroupListener(_ listener: OpenIMGroupListener?) { self.groupListener = listener }
    func setConversationListener(_ listener: OpenIMConversationListener?) { self.conversationListener = listener }
    func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?) { self.advancedMsgListener = listener }

    // User
    func simulateSelfInfoUpdated(_ info: OpenIMUserInfo) { userListener?.onSelfInfoUpdated(info) }
    func simulateUserStatusChanged(_ status: OpenIMUserStatusInfo) { userListener?.onUserStatusChanged(status) }

    // Friend
    func simulateFriendAdded(_ friend: OpenIMFriendInfo) { friendshipListener?.onFriendAdded(friend) }
    func simulateFriendDeleted(_ friend: OpenIMFriendInfo) { friendshipListener?.onFriendDeleted(friend) }
    func simulateFriendInfoChanged(_ friend: OpenIMFriendInfo) { friendshipListener?.onFriendInfoChanged(friend) }
    func simulateFriendApplicationAdded(_ app: OpenIMFriendApplication) { friendshipListener?.onFriendApplicationAdded(app) }
    func simulateFriendApplicationDeleted(_ app: OpenIMFriendApplication) { friendshipListener?.onFriendApplicationDeleted(app) }
    func simulateFriendApplicationAccepted(_ app: OpenIMFriendApplication) { friendshipListener?.onFriendApplicationAccepted(app) }
    func simulateFriendApplicationRejected(_ app: OpenIMFriendApplication) { friendshipListener?.onFriendApplicationRejected(app) }
    func simulateBlackAdded(_ black: OpenIMBlackInfo) { friendshipListener?.onBlackAdded(black) }
    func simulateBlackDeleted(_ black: OpenIMBlackInfo) { friendshipListener?.onBlackDeleted(black) }

    // Group
    func simulateGroupAdded(_ group: OpenIMGroupInfo) { groupListener?.onJoinedGroupAdded(group) }
    func simulateJoinedGroupDismissed(_ group: OpenIMGroupInfo) { groupListener?.onJoinedGroupDismissed(group) }
    func simulateGroupMemberAdded(_ member: OpenIMGroupMemberInfo) { groupListener?.onGroupMemberAdded(member) }
    func simulateGroupMemberDeleted(_ member: OpenIMGroupMemberInfo) { groupListener?.onGroupMemberDeleted(member) }
    func simulateGroupMemberInfoChanged(_ member: OpenIMGroupMemberInfo) { groupListener?.onGroupMemberInfoChanged(member) }
    func simulateGroupApplicationAdded(_ app: OpenIMGroupApplicationInfo) { groupListener?.onGroupApplicationAdded(app) }
    func simulateGroupApplicationDeleted(_ app: OpenIMGroupApplicationInfo) { groupListener?.onGroupApplicationDeleted(app) }
    func simulateGroupApplicationAccepted(_ app: OpenIMGroupApplicationInfo) { groupListener?.onGroupApplicationAccepted(app) }
    func simulateGroupApplicationRejected(_ app: OpenIMGroupApplicationInfo) { groupListener?.onGroupApplicationRejected(app) }
    func simulateGroupInfoChanged(_ group: OpenIMGroupInfo) { groupListener?.onGroupInfoChanged(group) }
    func simulateGroupDismissed(_ group: OpenIMGroupInfo) { groupListener?.onGroupDismissed(group) }

    // Conversation
    func simulateSyncServerStart() { conversationListener?.onSyncServerStart() }
    func simulateSyncServerFinish() { conversationListener?.onSyncServerFinish() }
    func simulateSyncServerProgress(_ progress: Int) { conversationListener?.onSyncServerProgress(progress) }
    func simulateSyncServerFailed() { conversationListener?.onSyncServerFailed() }
    func simulateNewConversation(_ convs: [OpenIMConversationInfo]) { conversationListener?.onNewConversation(convs) }
    func simulateConversationChanged(_ convs: [OpenIMConversationInfo]) { conversationListener?.onConversationChanged(convs) }
    func simulateTotalUnreadCountChanged(_ count: Int) { conversationListener?.onTotalUnreadMessageCountChanged(count) }

    // Message
    func simulateRecvNewMessage(_ msg: OpenIMMessageInfo) { advancedMsgListener?.onRecvNewMessage(msg) }
    func simulateRecvC2CReadReceipt(_ receipts: [OpenIMReceiptInfo]) { advancedMsgListener?.onRecvC2CReadReceipt(receipts) }
    func simulateRecvGroupReadReceipt(_ receipts: [OpenIMReceiptInfo]) { advancedMsgListener?.onRecvGroupReadReceipt(receipts) }
    func simulateRecvMessageRevoked(_ revoked: OpenIMMessageRevokedInfo) { advancedMsgListener?.onRecvMessageRevoked(revoked) }
}
