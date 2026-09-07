import XCTest
@testable import OpenIMSDK

final class UserManagerAsyncTests: XCTestCase {
    func testAllUserManagerAPIsUsingAsyncAwait() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        // 1. getSelfUserInfo
        let selfUser = try await client.user.getSelfUserInfo()
        XCTAssertEqual(selfUser.userID, "test_self_id")
        XCTAssertEqual(selfUser.nickname, "Test Self")

        // 2. getUsersInfo
        let users = try await client.user.getUsersInfo(userIDs: ["u1", "u2"])
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.userID, "u1")

        // 3. setSelfUserInfo
        try await client.user.setSelfUserInfo(userInfo: OpenIMUserInfo(userID: "test_self_id", nickname: "Updated Self"))
        XCTAssertEqual(adapter.lastUpdatedSelfInfo?.nickname, "Updated Self")

        // 4. updateFcmToken
        try await client.user.updateFcmToken(fcmToken: "fcm_token_xyz", expireTime: 3600)
        XCTAssertEqual(adapter.lastFcmToken?.token, "fcm_token_xyz")
        XCTAssertEqual(adapter.lastFcmToken?.expireTime, 3600)

        // 5. subscribeUsersStatus
        let subscribed = try await client.user.subscribeUsersStatus(userIDs: ["u1", "u2"])
        XCTAssertEqual(adapter.lastSubscribedUserIDs, ["u1", "u2"])
        XCTAssertEqual(subscribed.count, 2)

        // 6. getSubscribeUsersStatus
        let subStatus = try await client.user.getSubscribeUsersStatus()
        XCTAssertFalse(subStatus.isEmpty)

        // 7. getUserStatus
        let statuses = try await client.user.getUserStatus(userIDs: ["u1"])
        XCTAssertEqual(statuses.first?.userID, "u1")

        // 8. unsubscribeUsersStatus
        try await client.user.unsubscribeUsersStatus(userIDs: ["u1"])
        XCTAssertEqual(adapter.lastUnsubscribedUserIDs, ["u1"])

        // 9. setListener
        final class DummyUserListener: OpenIMUserListener, @unchecked Sendable {}
        let listener = DummyUserListener()
        client.user.setListener(listener)
        XCTAssertTrue(adapter.userListener === listener)
    }

    func testUserManagerErrorPropagation() async {
        let adapter = MockOpenIMCoreAdapter()
        adapter.shouldFail = true
        let client = OpenIMClient(adapter: adapter)

        do {
            _ = try await client.user.getSelfUserInfo()
            XCTFail("Expected failure")
        } catch let error as OpenIMError {
            if case let .core(code, message) = error {
                XCTAssertEqual(code, -999)
                XCTAssertEqual(message, "Simulated network failure")
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
