import XCTest
@testable import OpenIMSDK

final class ListenerTests: XCTestCase {
    func testUserListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let exp = expectation(description: "self info updated")
        let listener = TestUserListener(onSelfInfoUpdatedCallback: { info in
            XCTAssertEqual(info.userID, "6932496926")
            XCTAssertEqual(info.nickname, "5234")
            exp.fulfill()
        })

        client.setUserListener(listener)
        adapter.simulateSelfInfoUpdated(OpenIMUserInfo(userID: "6932496926", nickname: "5234"))

        wait(for: [exp], timeout: 2.0)
    }

    func testFriendshipListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expAdded = expectation(description: "friend added")
        let expDeleted = expectation(description: "friend deleted")

        let listener = TestFriendshipListener(
            onFriendAddedCallback: { friend in
                XCTAssertEqual(friend.userID, "f_100")
                expAdded.fulfill()
            },
            onFriendDeletedCallback: { friend in
                XCTAssertEqual(friend.userID, "f_100")
                expDeleted.fulfill()
            }
        )

        client.setFriendshipListener(listener)
        adapter.simulateFriendAdded(OpenIMFriendInfo(userID: "f_100", nickname: "Friend 100"))
        adapter.simulateFriendDeleted(OpenIMFriendInfo(userID: "f_100", nickname: "Friend 100"))

        wait(for: [expAdded, expDeleted], timeout: 2.0)
    }

    func testGroupListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expGroup = expectation(description: "group added")
        let expMember = expectation(description: "member added")

        let listener = TestGroupListener(
            onJoinedGroupAddedCallback: { group in
                XCTAssertEqual(group.groupID, "g_3662920566")
                expGroup.fulfill()
            },
            onGroupMemberAddedCallback: { member in
                XCTAssertEqual(member.groupID, "g_3662920566")
                XCTAssertEqual(member.userID, "6932496926")
                expMember.fulfill()
            }
        )

        client.setGroupListener(listener)
        adapter.simulateGroupAdded(OpenIMGroupInfo(groupID: "g_3662920566", groupName: "The"))
        adapter.simulateGroupMemberAdded(OpenIMGroupMemberInfo(groupID: "g_3662920566", userID: "6932496926", nickname: "5234"))

        wait(for: [expGroup, expMember], timeout: 2.0)
    }

    func testConversationListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expConv = expectation(description: "conversation changed")
        let expUnread = expectation(description: "unread count changed")

        let listener = TestConversationListener(
            onConversationChangedCallback: { convs in
                XCTAssertEqual(convs.first?.conversationID, "si_6932496926_1110659206")
                expConv.fulfill()
            },
            onTotalUnreadMessageCountChangedCallback: { count in
                XCTAssertEqual(count, 42)
                expUnread.fulfill()
            }
        )

        client.setConversationListener(listener)
        adapter.simulateConversationChanged([OpenIMConversationInfo(conversationID: "si_6932496926_1110659206", unreadCount: 5)])
        adapter.simulateTotalUnreadCountChanged(42)

        wait(for: [expConv, expUnread], timeout: 2.0)
    }

    func testAdvancedMsgListenerDispatching() {
        let adapter = MockListenerOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter, callbackQueue: .main)

        let expMsg = expectation(description: "recv new message")
        let expRevoked = expectation(description: "recv message revoked")

        let listener = TestAdvancedMsgListener(
            onRecvNewMessageCallback: { msg in
                XCTAssertEqual(msg.clientMsgID, "msg_test_live_1")
                XCTAssertEqual(msg.content, "Unit Test Message")
                expMsg.fulfill()
            },
            onRecvMessageRevokedCallback: { revoked in
                XCTAssertEqual(revoked.clientMsgID, "msg_test_live_1")
                XCTAssertEqual(revoked.revokerID, "6932496926")
                expRevoked.fulfill()
            }
        )

        client.setAdvancedMsgListener(listener)

        let msg = OpenIMMessageInfo(
            clientMsgID: "msg_test_live_1",
            contentType: .text,
            content: "Unit Test Message",
            textElem: OpenIMTextElem(content: "Unit Test Message")
        )
        let revoked = OpenIMMessageRevokedInfo(
            revokerID: "6932496926",
            revokerNickname: "5234",
            clientMsgID: "msg_test_live_1",
            sessionType: 1
        )

        adapter.simulateRecvNewMessage(msg)
        adapter.simulateRecvMessageRevoked(revoked)

        wait(for: [expMsg, expRevoked], timeout: 2.0)
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
    init(onSelfInfoUpdatedCallback: ((OpenIMUserInfo) -> Void)? = nil) {
        self.onSelfInfoUpdatedCallback = onSelfInfoUpdatedCallback
    }
    func onSelfInfoUpdated(_ userInfo: OpenIMUserInfo) {
        onSelfInfoUpdatedCallback?(userInfo)
    }
}

private final class TestFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {
    var onFriendAddedCallback: ((OpenIMFriendInfo) -> Void)?
    var onFriendDeletedCallback: ((OpenIMFriendInfo) -> Void)?
    init(onFriendAddedCallback: ((OpenIMFriendInfo) -> Void)? = nil,
         onFriendDeletedCallback: ((OpenIMFriendInfo) -> Void)? = nil) {
        self.onFriendAddedCallback = onFriendAddedCallback
        self.onFriendDeletedCallback = onFriendDeletedCallback
    }
    func onFriendAdded(_ friendInfo: OpenIMFriendInfo) {
        onFriendAddedCallback?(friendInfo)
    }
    func onFriendDeleted(_ friendInfo: OpenIMFriendInfo) {
        onFriendDeletedCallback?(friendInfo)
    }
}

private final class TestGroupListener: OpenIMGroupListener, @unchecked Sendable {
    var onJoinedGroupAddedCallback: ((OpenIMGroupInfo) -> Void)?
    var onGroupMemberAddedCallback: ((OpenIMGroupMemberInfo) -> Void)?
    init(onJoinedGroupAddedCallback: ((OpenIMGroupInfo) -> Void)? = nil,
         onGroupMemberAddedCallback: ((OpenIMGroupMemberInfo) -> Void)? = nil) {
        self.onJoinedGroupAddedCallback = onJoinedGroupAddedCallback
        self.onGroupMemberAddedCallback = onGroupMemberAddedCallback
    }
    func onJoinedGroupAdded(_ groupInfo: OpenIMGroupInfo) {
        onJoinedGroupAddedCallback?(groupInfo)
    }
    func onGroupMemberAdded(_ memberInfo: OpenIMGroupMemberInfo) {
        onGroupMemberAddedCallback?(memberInfo)
    }
}

private final class TestConversationListener: OpenIMConversationListener, @unchecked Sendable {
    var onConversationChangedCallback: (([OpenIMConversationInfo]) -> Void)?
    var onTotalUnreadMessageCountChangedCallback: ((Int) -> Void)?
    init(onConversationChangedCallback: (([OpenIMConversationInfo]) -> Void)? = nil,
         onTotalUnreadMessageCountChangedCallback: ((Int) -> Void)? = nil) {
        self.onConversationChangedCallback = onConversationChangedCallback
        self.onTotalUnreadMessageCountChangedCallback = onTotalUnreadMessageCountChangedCallback
    }
    func onConversationChanged(_ conversations: [OpenIMConversationInfo]) {
        onConversationChangedCallback?(conversations)
    }
    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int) {
        onTotalUnreadMessageCountChangedCallback?(totalUnreadCount)
    }
}

private final class TestAdvancedMsgListener: OpenIMAdvancedMsgListener, @unchecked Sendable {
    var onRecvNewMessageCallback: ((OpenIMMessageInfo) -> Void)?
    var onRecvMessageRevokedCallback: ((OpenIMMessageRevokedInfo) -> Void)?
    init(onRecvNewMessageCallback: ((OpenIMMessageInfo) -> Void)? = nil,
         onRecvMessageRevokedCallback: ((OpenIMMessageRevokedInfo) -> Void)? = nil) {
        self.onRecvNewMessageCallback = onRecvNewMessageCallback
        self.onRecvMessageRevokedCallback = onRecvMessageRevokedCallback
    }
    func onRecvNewMessage(_ message: OpenIMMessageInfo) {
        onRecvNewMessageCallback?(message)
    }
    func onRecvMessageRevoked(_ messageRevoked: OpenIMMessageRevokedInfo) {
        onRecvMessageRevokedCallback?(messageRevoked)
    }
}

// MARK: - Mock Listener Adapter
private final class MockListenerOpenIMCoreAdapter: OpenIMCoreAdapter {
    private var userListener: OpenIMUserListener?
    private var friendshipListener: OpenIMFriendshipListener?
    private var groupListener: OpenIMGroupListener?
    private var conversationListener: OpenIMConversationListener?
    private var advancedMsgListener: OpenIMAdvancedMsgListener?

    func initialize(configuration: OpenIMConfiguration, eventHandler: @escaping (OpenIMCoreEvent) -> Void) throws {}
    func login(userID: String, token: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) { completion(.success(())) }
    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) { completion(.success(())) }
    func uninitialize() {}

    func setUserListener(_ listener: OpenIMUserListener?) { self.userListener = listener }
    func setFriendshipListener(_ listener: OpenIMFriendshipListener?) { self.friendshipListener = listener }
    func setGroupListener(_ listener: OpenIMGroupListener?) { self.groupListener = listener }
    func setConversationListener(_ listener: OpenIMConversationListener?) { self.conversationListener = listener }
    func setAdvancedMsgListener(_ listener: OpenIMAdvancedMsgListener?) { self.advancedMsgListener = listener }

    func simulateSelfInfoUpdated(_ info: OpenIMUserInfo) { userListener?.onSelfInfoUpdated(info) }
    func simulateFriendAdded(_ friend: OpenIMFriendInfo) { friendshipListener?.onFriendAdded(friend) }
    func simulateFriendDeleted(_ friend: OpenIMFriendInfo) { friendshipListener?.onFriendDeleted(friend) }
    func simulateGroupAdded(_ group: OpenIMGroupInfo) { groupListener?.onJoinedGroupAdded(group) }
    func simulateGroupMemberAdded(_ member: OpenIMGroupMemberInfo) { groupListener?.onGroupMemberAdded(member) }
    func simulateConversationChanged(_ convs: [OpenIMConversationInfo]) { conversationListener?.onConversationChanged(convs) }
    func simulateTotalUnreadCountChanged(_ count: Int) { conversationListener?.onTotalUnreadMessageCountChanged(count) }
    func simulateRecvNewMessage(_ msg: OpenIMMessageInfo) { advancedMsgListener?.onRecvNewMessage(msg) }
    func simulateRecvMessageRevoked(_ revoked: OpenIMMessageRevokedInfo) { advancedMsgListener?.onRecvMessageRevoked(revoked) }
}
