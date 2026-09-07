import Foundation

/// Manager handling user profile, online status, and personal preferences.
public final class OpenIMUserManager {
    private weak var client: OpenIMClient?
    private let adapter: OpenIMCoreAdapter

    init(client: OpenIMClient, adapter: OpenIMCoreAdapter) {
        self.client = client
        self.adapter = adapter
    }

    public func setListener(_ listener: OpenIMUserListener?) {
        adapter.setUserListener(listener)
    }

    public func getUsersInfo(
        userIDs: [String],
        completion: @escaping (Result<[OpenIMPublicUserInfo], OpenIMError>) -> Void
    ) {
        adapter.getUsersInfo(userIDs: userIDs, completion: completion)
    }

    public func getSelfUserInfo(
        completion: @escaping (Result<OpenIMUserInfo, OpenIMError>) -> Void
    ) {
        adapter.getSelfUserInfo(completion: completion)
    }

    public func setSelfUserInfo(
        userInfo: OpenIMUserInfo,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setSelfUserInfo(userInfo: userInfo, completion: completion)
    }

    public func updateFcmToken(
        fcmToken: String,
        expireTime: Int,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.updateFcmToken(fcmToken: fcmToken, expireTime: expireTime, completion: completion)
    }

    public func subscribeUsersStatus(
        userIDs: [String],
        completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void
    ) {
        adapter.subscribeUsersStatus(userIDs: userIDs, completion: completion)
    }

    public func unsubscribeUsersStatus(
        userIDs: [String],
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.unsubscribeUsersStatus(userIDs: userIDs, completion: completion)
    }

    public func getSubscribeUsersStatus(
        completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void
    ) {
        adapter.getSubscribeUsersStatus(completion: completion)
    }

    public func getUserStatus(
        userIDs: [String],
        completion: @escaping (Result<[OpenIMUserStatusInfo], OpenIMError>) -> Void
    ) {
        adapter.getUserStatus(userIDs: userIDs, completion: completion)
    }
}

// MARK: - Async / Await Support (iOS 13.0+)
@available(iOS 13.0, macOS 10.15, *)
public extension OpenIMUserManager {
    func getUsersInfo(userIDs: [String]) async throws -> [OpenIMPublicUserInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getUsersInfo(userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func getSelfUserInfo() async throws -> OpenIMUserInfo {
        try await withCheckedThrowingContinuation { continuation in
            getSelfUserInfo { continuation.resume(with: $0) }
        }
    }

    func setSelfUserInfo(userInfo: OpenIMUserInfo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setSelfUserInfo(userInfo: userInfo) { continuation.resume(with: $0) }
        }
    }

    func updateFcmToken(fcmToken: String, expireTime: Int) async throws {
        try await withCheckedThrowingContinuation { continuation in
            updateFcmToken(fcmToken: fcmToken, expireTime: expireTime) { continuation.resume(with: $0) }
        }
    }

    func subscribeUsersStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        try await withCheckedThrowingContinuation { continuation in
            subscribeUsersStatus(userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func unsubscribeUsersStatus(userIDs: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            unsubscribeUsersStatus(userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func getSubscribeUsersStatus() async throws -> [OpenIMUserStatusInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getSubscribeUsersStatus { continuation.resume(with: $0) }
        }
    }

    func getUserStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getUserStatus(userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }
}
