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
    }

    func testFriendManagerCallsAdapter() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let friends = try await client.friend.getFriendList()
        XCTAssertEqual(friends.count, 1)
        XCTAssertEqual(friends.first?.userID, "friend_1")

        let checks = try await client.friend.checkFriend(userIDs: ["friend_1"])
        XCTAssertEqual(checks.first?.result, 1)
    }

    func testGroupManagerCallsAdapter() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let groups = try await client.group.getJoinedGroupList()
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups.first?.groupID, "group_1")
    }

    func testConversationManagerCallsAdapter() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let total = try await client.conversation.getTotalUnreadMsgCount()
        XCTAssertEqual(total, 5)

        let convs = try await client.conversation.getAllConversationList()
        XCTAssertEqual(convs.first?.conversationID, "c_1")
    }

    func testMessageManagerCallsAdapter() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        let msg = try client.message.createTextMessage(text: "Hello Swift!")
        XCTAssertEqual(msg.clientMsgID, "msg_test_1")
        XCTAssertEqual(msg.content, "Hello Swift!")

        let sent = try await client.message.sendMessage(message: msg, recvID: "u2")
        XCTAssertEqual(sent.status, .sendSuccess)
    }
}

// MARK: - Mock Adapter
private final class MockOpenIMCoreAdapter: OpenIMCoreAdapter {
    func initialize(configuration: OpenIMConfiguration, eventHandler: @escaping (OpenIMCoreEvent) -> Void) throws {}
    func login(userID: String, token: String, completion: @escaping (Result<Void, OpenIMError>) -> Void) { completion(.success(())) }
    func logout(completion: @escaping (Result<Void, OpenIMError>) -> Void) { completion(.success(())) }
    func uninitialize() {}

    func getSelfUserInfo(completion: @escaping (Result<OpenIMUserInfo, OpenIMError>) -> Void) {
        completion(.success(OpenIMUserInfo(userID: "test_self_id", nickname: "Test Self")))
    }

    func getUsersInfo(userIDs: [String], completion: @escaping (Result<[OpenIMPublicUserInfo], OpenIMError>) -> Void) {
        let users = userIDs.map { OpenIMPublicUserInfo(userID: $0, nickname: "Nick_\($0)") }
        completion(.success(users))
    }

    func getFriendList(filterBlack: Bool, completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void) {
        completion(.success([OpenIMFriendInfo(userID: "friend_1", nickname: "Friend 1")]))
    }

    func checkFriend(userIDs: [String], completion: @escaping (Result<[OpenIMFriendCheckResult], OpenIMError>) -> Void) {
        completion(.success(userIDs.map { OpenIMFriendCheckResult(userID: $0, result: 1) }))
    }

    func getJoinedGroupList(completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void) {
        completion(.success([OpenIMGroupInfo(groupID: "group_1", groupName: "Group 1")]))
    }

    func getTotalUnreadMsgCount(completion: @escaping (Result<Int, OpenIMError>) -> Void) {
        completion(.success(5))
    }

    func getAllConversationList(completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void) {
        completion(.success([OpenIMConversationInfo(conversationID: "c_1", unreadCount: 2)]))
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
        completion(.success(message))
    }
}
