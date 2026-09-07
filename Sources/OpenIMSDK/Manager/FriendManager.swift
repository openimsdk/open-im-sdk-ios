import Foundation

/// Manager handling friend relationships, applications, blacklists, and searches.
public final class OpenIMFriendManager {
    private weak var client: OpenIMClient?
    private let adapter: OpenIMCoreAdapter

    init(client: OpenIMClient, adapter: OpenIMCoreAdapter) {
        self.client = client
        self.adapter = adapter
    }

    public func setListener(_ listener: OpenIMFriendshipListener?) {
        adapter.setFriendshipListener(listener)
    }

    public func getSpecifiedFriendsInfo(
        userIDs: [String],
        filterBlack: Bool = false
    ) async throws -> [OpenIMFriendInfo] {
        try await adapter.getSpecifiedFriendsInfo(userIDs: userIDs, filterBlack: filterBlack)
    }

    public func getFriendList(filterBlack: Bool = false) async throws -> [OpenIMFriendInfo] {
        try await adapter.getFriendList(filterBlack: filterBlack)
    }

    public func getFriendListPage(
        offset: Int,
        count: Int,
        filterBlack: Bool = false
    ) async throws -> [OpenIMFriendInfo] {
        try await adapter.getFriendListPage(offset: offset, count: count, filterBlack: filterBlack)
    }

    public func searchFriends(
        param: OpenIMSearchFriendsParam
    ) async throws -> [OpenIMSearchFriendsInfo] {
        try await adapter.searchFriends(param: param)
    }

    public func checkFriend(
        userIDs: [String]
    ) async throws -> [OpenIMFriendCheckResult] {
        try await adapter.checkFriend(userIDs: userIDs)
    }

    public func addFriend(
        userID: String,
        reqMsg: String? = nil
    ) async throws {
        try await adapter.addFriend(userID: userID, reqMsg: reqMsg)
    }

    public func setFriendRemark(
        userID: String,
        remark: String
    ) async throws {
        try await adapter.setFriendRemark(userID: userID, remark: remark)
    }

    public func deleteFriend(
        friendUserID: String
    ) async throws {
        try await adapter.deleteFriend(friendUserID: friendUserID)
    }

    public func getFriendApplicationListAsRecipient() async throws -> [OpenIMFriendApplication] {
        try await adapter.getFriendApplicationListAsRecipient()
    }

    public func getFriendApplicationListAsApplicant() async throws -> [OpenIMFriendApplication] {
        try await adapter.getFriendApplicationListAsApplicant()
    }

    public func acceptFriendApplication(
        userID: String,
        handleMsg: String? = nil
    ) async throws {
        try await adapter.acceptFriendApplication(userID: userID, handleMsg: handleMsg)
    }

    public func refuseFriendApplication(
        userID: String,
        handleMsg: String? = nil
    ) async throws {
        try await adapter.refuseFriendApplication(userID: userID, handleMsg: handleMsg)
    }

    public func addBlack(
        blackUserID: String,
        ex: String? = nil
    ) async throws {
        try await adapter.addBlack(blackUserID: blackUserID, ex: ex)
    }

    public func removeBlack(
        blackUserID: String
    ) async throws {
        try await adapter.removeBlack(blackUserID: blackUserID)
    }

    public func getBlackList() async throws -> [OpenIMBlackInfo] {
        try await adapter.getBlackList()
    }
}
