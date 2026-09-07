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

    public func getUsersInfo(userIDs: [String]) async throws -> [OpenIMPublicUserInfo] {
        try await adapter.getUsersInfo(userIDs: userIDs)
    }

    public func getSelfUserInfo() async throws -> OpenIMUserInfo {
        try await adapter.getSelfUserInfo()
    }

    public func setSelfUserInfo(userInfo: OpenIMUserInfo) async throws {
        try await adapter.setSelfUserInfo(userInfo: userInfo)
    }

    public func updateFcmToken(fcmToken: String, expireTime: Int) async throws {
        try await adapter.updateFcmToken(fcmToken: fcmToken, expireTime: expireTime)
    }

    public func subscribeUsersStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        try await adapter.subscribeUsersStatus(userIDs: userIDs)
    }

    public func unsubscribeUsersStatus(userIDs: [String]) async throws {
        try await adapter.unsubscribeUsersStatus(userIDs: userIDs)
    }

    public func getSubscribeUsersStatus() async throws -> [OpenIMUserStatusInfo] {
        try await adapter.getSubscribeUsersStatus()
    }

    public func getUserStatus(userIDs: [String]) async throws -> [OpenIMUserStatusInfo] {
        try await adapter.getUserStatus(userIDs: userIDs)
    }
}
