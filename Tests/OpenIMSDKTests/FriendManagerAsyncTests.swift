import XCTest
@testable import OpenIMSDK

final class FriendManagerAsyncTests: XCTestCase {
    func testAllFriendManagerAPIsUsingAsyncAwait() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        // 1. getFriendList
        let friends = try await client.friend.getFriendList()
        XCTAssertEqual(friends.first?.userID, "friend_1")

        // 2. getSpecifiedFriendsInfo
        let specified = try await client.friend.getSpecifiedFriendsInfo(userIDs: ["f1", "f2"])
        XCTAssertEqual(specified.count, 2)
        XCTAssertEqual(specified.first?.userID, "f1")

        // 3. getFriendListPage
        let page = try await client.friend.getFriendListPage(offset: 0, count: 10)
        XCTAssertEqual(page.first?.userID, "friend_page_1")

        // 4. searchFriends
        let searchParam = OpenIMSearchFriendsParam(keywordList: ["alice"], isSearchNickname: true)
        let searchResults = try await client.friend.searchFriends(param: searchParam)
        XCTAssertEqual(adapter.lastSearchFriendsParam?.keywordList, ["alice"])
        XCTAssertEqual(searchResults.first?.userID, "searched_alice")

        // 5. checkFriend
        let checks = try await client.friend.checkFriend(userIDs: ["friend_1"])
        XCTAssertEqual(checks.first?.result, 1)

        // 6. addFriend
        try await client.friend.addFriend(userID: "friend_2", reqMsg: "Hello!")
        XCTAssertEqual(adapter.lastAddedFriendID, "friend_2")

        // 7. setFriendRemark
        try await client.friend.setFriendRemark(userID: "friend_1", remark: "Best Buddy")
        XCTAssertEqual(adapter.lastFriendRemark?.userID, "friend_1")
        XCTAssertEqual(adapter.lastFriendRemark?.remark, "Best Buddy")

        // 8. deleteFriend
        try await client.friend.deleteFriend(friendUserID: "friend_1")
        XCTAssertEqual(adapter.lastDeletedFriendID, "friend_1")

        // 9. getFriendApplicationListAsRecipient
        let recApps = try await client.friend.getFriendApplicationListAsRecipient()
        XCTAssertEqual(recApps.first?.fromUserID, "applicant_1")

        // 10. getFriendApplicationListAsApplicant
        let appApps = try await client.friend.getFriendApplicationListAsApplicant()
        XCTAssertEqual(appApps.first?.toUserID, "applicant_2")

        // 11. acceptFriendApplication
        try await client.friend.acceptFriendApplication(userID: "applicant_1", handleMsg: "Welcome")
        XCTAssertEqual(adapter.lastHandledApplication?.userID, "applicant_1")
        XCTAssertTrue(adapter.lastHandledApplication?.accepted ?? false)

        // 12. refuseFriendApplication
        try await client.friend.refuseFriendApplication(userID: "applicant_2", handleMsg: "No thanks")
        XCTAssertEqual(adapter.lastHandledApplication?.userID, "applicant_2")
        XCTAssertFalse(adapter.lastHandledApplication?.accepted ?? true)

        // 13. addBlack
        try await client.friend.addBlack(blackUserID: "spammer_1", ex: "block ex")
        XCTAssertEqual(adapter.lastBlackID, "spammer_1")

        // 14. getBlackList
        let blacks = try await client.friend.getBlackList()
        XCTAssertEqual(blacks.first?.userID, "spammer_1")

        // 15. removeBlack
        try await client.friend.removeBlack(blackUserID: "spammer_1")
        XCTAssertEqual(adapter.lastRemovedBlackID, "spammer_1")

        // 16. setListener
        final class DummyFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {}
        let listener = DummyFriendshipListener()
        client.friend.setListener(listener)
        XCTAssertTrue(adapter.friendshipListener === listener)
    }

    func testFriendManagerErrorPropagation() async {
        let adapter = MockOpenIMCoreAdapter()
        adapter.shouldFail = true
        let client = OpenIMClient(adapter: adapter)

        do {
            _ = try await client.friend.getFriendList()
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
