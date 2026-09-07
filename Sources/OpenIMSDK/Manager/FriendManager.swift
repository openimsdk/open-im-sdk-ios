import Foundation

/// Manager handling friends, friend applications, and blacklist.
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
        filterBlack: Bool = false,
        completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void
    ) {
        adapter.getSpecifiedFriendsInfo(userIDs: userIDs, filterBlack: filterBlack, completion: completion)
    }

    public func getFriendList(
        filterBlack: Bool = false,
        completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void
    ) {
        adapter.getFriendList(filterBlack: filterBlack, completion: completion)
    }

    public func getFriendListPage(
        offset: Int,
        count: Int,
        filterBlack: Bool = false,
        completion: @escaping (Result<[OpenIMFriendInfo], OpenIMError>) -> Void
    ) {
        adapter.getFriendListPage(offset: offset, count: count, filterBlack: filterBlack, completion: completion)
    }

    public func searchFriends(
        param: OpenIMSearchFriendsParam,
        completion: @escaping (Result<[OpenIMSearchFriendsInfo], OpenIMError>) -> Void
    ) {
        adapter.searchFriends(param: param, completion: completion)
    }

    public func checkFriend(
        userIDs: [String],
        completion: @escaping (Result<[OpenIMFriendCheckResult], OpenIMError>) -> Void
    ) {
        adapter.checkFriend(userIDs: userIDs, completion: completion)
    }

    public func addFriend(
        userID: String,
        reqMsg: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.addFriend(userID: userID, reqMsg: reqMsg, completion: completion)
    }

    public func setFriendRemark(
        userID: String,
        remark: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setFriendRemark(userID: userID, remark: remark, completion: completion)
    }

    public func deleteFriend(
        friendUserID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.deleteFriend(friendUserID: friendUserID, completion: completion)
    }

    public func getFriendApplicationListAsRecipient(
        completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void
    ) {
        adapter.getFriendApplicationListAsRecipient(completion: completion)
    }

    public func getFriendApplicationListAsApplicant(
        completion: @escaping (Result<[OpenIMFriendApplication], OpenIMError>) -> Void
    ) {
        adapter.getFriendApplicationListAsApplicant(completion: completion)
    }

    public func acceptFriendApplication(
        userID: String,
        handleMsg: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.acceptFriendApplication(userID: userID, handleMsg: handleMsg, completion: completion)
    }

    public func refuseFriendApplication(
        userID: String,
        handleMsg: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.refuseFriendApplication(userID: userID, handleMsg: handleMsg, completion: completion)
    }

    public func addBlack(
        blackUserID: String,
        ex: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.addBlack(blackUserID: blackUserID, ex: ex, completion: completion)
    }

    public func removeBlack(
        blackUserID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.removeBlack(blackUserID: blackUserID, completion: completion)
    }

    public func getBlackList(
        completion: @escaping (Result<[OpenIMBlackInfo], OpenIMError>) -> Void
    ) {
        adapter.getBlackList(completion: completion)
    }
}

// MARK: - Async / Await Support (iOS 13.0+)
@available(iOS 13.0, macOS 10.15, *)
public extension OpenIMFriendManager {
    func getSpecifiedFriendsInfo(userIDs: [String], filterBlack: Bool = false) async throws -> [OpenIMFriendInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getSpecifiedFriendsInfo(userIDs: userIDs, filterBlack: filterBlack) { continuation.resume(with: $0) }
        }
    }

    func getFriendList(filterBlack: Bool = false) async throws -> [OpenIMFriendInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getFriendList(filterBlack: filterBlack) { continuation.resume(with: $0) }
        }
    }

    func getFriendListPage(offset: Int, count: Int, filterBlack: Bool = false) async throws -> [OpenIMFriendInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getFriendListPage(offset: offset, count: count, filterBlack: filterBlack) { continuation.resume(with: $0) }
        }
    }

    func searchFriends(param: OpenIMSearchFriendsParam) async throws -> [OpenIMSearchFriendsInfo] {
        try await withCheckedThrowingContinuation { continuation in
            searchFriends(param: param) { continuation.resume(with: $0) }
        }
    }

    func checkFriend(userIDs: [String]) async throws -> [OpenIMFriendCheckResult] {
        try await withCheckedThrowingContinuation { continuation in
            checkFriend(userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func addFriend(userID: String, reqMsg: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            addFriend(userID: userID, reqMsg: reqMsg) { continuation.resume(with: $0) }
        }
    }

    func setFriendRemark(userID: String, remark: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setFriendRemark(userID: userID, remark: remark) { continuation.resume(with: $0) }
        }
    }

    func deleteFriend(friendUserID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteFriend(friendUserID: friendUserID) { continuation.resume(with: $0) }
        }
    }

    func getFriendApplicationListAsRecipient() async throws -> [OpenIMFriendApplication] {
        try await withCheckedThrowingContinuation { continuation in
            getFriendApplicationListAsRecipient { continuation.resume(with: $0) }
        }
    }

    func getFriendApplicationListAsApplicant() async throws -> [OpenIMFriendApplication] {
        try await withCheckedThrowingContinuation { continuation in
            getFriendApplicationListAsApplicant { continuation.resume(with: $0) }
        }
    }

    func acceptFriendApplication(userID: String, handleMsg: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            acceptFriendApplication(userID: userID, handleMsg: handleMsg) { continuation.resume(with: $0) }
        }
    }

    func refuseFriendApplication(userID: String, handleMsg: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            refuseFriendApplication(userID: userID, handleMsg: handleMsg) { continuation.resume(with: $0) }
        }
    }

    func addBlack(blackUserID: String, ex: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            addBlack(blackUserID: blackUserID, ex: ex) { continuation.resume(with: $0) }
        }
    }

    func removeBlack(blackUserID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            removeBlack(blackUserID: blackUserID) { continuation.resume(with: $0) }
        }
    }

    func getBlackList() async throws -> [OpenIMBlackInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getBlackList { continuation.resume(with: $0) }
        }
    }
}
