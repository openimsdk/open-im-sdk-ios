import Foundation

/// Manager handling groups, group members, and join applications.
public final class OpenIMGroupManager {
    private weak var client: OpenIMClient?
    private let adapter: OpenIMCoreAdapter

    init(client: OpenIMClient, adapter: OpenIMCoreAdapter) {
        self.client = client
        self.adapter = adapter
    }

    public func setListener(_ listener: OpenIMGroupListener?) {
        adapter.setGroupListener(listener)
    }

    public func createGroup(
        createInfo: OpenIMGroupCreateInfo,
        completion: @escaping (Result<OpenIMGroupInfo, OpenIMError>) -> Void
    ) {
        adapter.createGroup(createInfo: createInfo, completion: completion)
    }

    public func joinGroup(
        groupID: String,
        reqMsg: String? = nil,
        joinSource: OpenIMJoinType = .search,
        ex: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.joinGroup(groupID: groupID, reqMsg: reqMsg, joinSource: joinSource, ex: ex, completion: completion)
    }

    public func quitGroup(
        groupID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.quitGroup(groupID: groupID, completion: completion)
    }

    public func dismissGroup(
        groupID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.dismissGroup(groupID: groupID, completion: completion)
    }

    public func getJoinedGroupList(
        completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void
    ) {
        adapter.getJoinedGroupList(completion: completion)
    }

    public func getJoinedGroupListPage(
        offset: Int,
        count: Int,
        completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void
    ) {
        adapter.getJoinedGroupListPage(offset: offset, count: count, completion: completion)
    }

    public func getSpecifiedGroupsInfo(
        groupIDs: [String],
        completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void
    ) {
        adapter.getSpecifiedGroupsInfo(groupIDs: groupIDs, completion: completion)
    }

    public func searchGroups(
        param: OpenIMSearchGroupParam,
        completion: @escaping (Result<[OpenIMGroupInfo], OpenIMError>) -> Void
    ) {
        adapter.searchGroups(param: param, completion: completion)
    }

    public func setGroupInfo(
        groupInfo: OpenIMGroupInfo,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setGroupInfo(groupInfo: groupInfo, completion: completion)
    }

    public func getGroupMemberList(
        groupID: String,
        filter: OpenIMGroupMemberFilter = .all,
        offset: Int = 0,
        count: Int = 40,
        completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void
    ) {
        adapter.getGroupMemberList(groupID: groupID, filter: filter, offset: offset, count: count, completion: completion)
    }

    public func getSpecifiedGroupMembersInfo(
        groupID: String,
        userIDs: [String],
        completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void
    ) {
        adapter.getSpecifiedGroupMembersInfo(groupID: groupID, userIDs: userIDs, completion: completion)
    }

    public func searchGroupMembers(
        param: OpenIMSearchGroupMembersParam,
        completion: @escaping (Result<[OpenIMGroupMemberInfo], OpenIMError>) -> Void
    ) {
        adapter.searchGroupMembers(param: param, completion: completion)
    }

    public func setGroupMemberRoleLevel(
        groupID: String,
        userID: String,
        roleLevel: OpenIMGroupMemberRole,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setGroupMemberRoleLevel(groupID: groupID, userID: userID, roleLevel: roleLevel, completion: completion)
    }

    public func changeGroupMute(
        groupID: String,
        isMute: Bool,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.changeGroupMute(groupID: groupID, isMute: isMute, completion: completion)
    }

    public func changeGroupMemberMute(
        groupID: String,
        userID: String,
        mutedSeconds: Int,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.changeGroupMemberMute(groupID: groupID, userID: userID, mutedSeconds: mutedSeconds, completion: completion)
    }

    public func setGroupMemberNickname(
        groupID: String,
        userID: String,
        nickname: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setGroupMemberNickname(groupID: groupID, userID: userID, nickname: nickname, completion: completion)
    }

    public func kickGroupMember(
        groupID: String,
        reason: String? = nil,
        userIDs: [String],
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.kickGroupMember(groupID: groupID, reason: reason, userIDs: userIDs, completion: completion)
    }

    public func inviteUserToGroup(
        groupID: String,
        reason: String? = nil,
        userIDs: [String],
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.inviteUserToGroup(groupID: groupID, reason: reason, userIDs: userIDs, completion: completion)
    }

    public func getGroupApplicationListAsRecipient(
        completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void
    ) {
        adapter.getGroupApplicationListAsRecipient(completion: completion)
    }

    public func getGroupApplicationListAsApplicant(
        completion: @escaping (Result<[OpenIMGroupApplicationInfo], OpenIMError>) -> Void
    ) {
        adapter.getGroupApplicationListAsApplicant(completion: completion)
    }

    public func acceptGroupApplication(
        groupID: String,
        fromUserID: String,
        handleMsg: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.acceptGroupApplication(groupID: groupID, fromUserID: fromUserID, handleMsg: handleMsg, completion: completion)
    }

    public func refuseGroupApplication(
        groupID: String,
        fromUserID: String,
        handleMsg: String? = nil,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.refuseGroupApplication(groupID: groupID, fromUserID: fromUserID, handleMsg: handleMsg, completion: completion)
    }
}

// MARK: - Async / Await Support (iOS 13.0+)
@available(iOS 13.0, macOS 10.15, *)
public extension OpenIMGroupManager {
    func createGroup(createInfo: OpenIMGroupCreateInfo) async throws -> OpenIMGroupInfo {
        try await withCheckedThrowingContinuation { continuation in
            createGroup(createInfo: createInfo) { continuation.resume(with: $0) }
        }
    }

    func joinGroup(groupID: String, reqMsg: String? = nil, joinSource: OpenIMJoinType = .search, ex: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            joinGroup(groupID: groupID, reqMsg: reqMsg, joinSource: joinSource, ex: ex) { continuation.resume(with: $0) }
        }
    }

    func quitGroup(groupID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            quitGroup(groupID: groupID) { continuation.resume(with: $0) }
        }
    }

    func dismissGroup(groupID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            dismissGroup(groupID: groupID) { continuation.resume(with: $0) }
        }
    }

    func getJoinedGroupList() async throws -> [OpenIMGroupInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getJoinedGroupList { continuation.resume(with: $0) }
        }
    }

    func getJoinedGroupListPage(offset: Int, count: Int) async throws -> [OpenIMGroupInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getJoinedGroupListPage(offset: offset, count: count) { continuation.resume(with: $0) }
        }
    }

    func getSpecifiedGroupsInfo(groupIDs: [String]) async throws -> [OpenIMGroupInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getSpecifiedGroupsInfo(groupIDs: groupIDs) { continuation.resume(with: $0) }
        }
    }

    func searchGroups(param: OpenIMSearchGroupParam) async throws -> [OpenIMGroupInfo] {
        try await withCheckedThrowingContinuation { continuation in
            searchGroups(param: param) { continuation.resume(with: $0) }
        }
    }

    func setGroupInfo(groupInfo: OpenIMGroupInfo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setGroupInfo(groupInfo: groupInfo) { continuation.resume(with: $0) }
        }
    }

    func getGroupMemberList(groupID: String, filter: OpenIMGroupMemberFilter = .all, offset: Int = 0, count: Int = 40) async throws -> [OpenIMGroupMemberInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getGroupMemberList(groupID: groupID, filter: filter, offset: offset, count: count) { continuation.resume(with: $0) }
        }
    }

    func getSpecifiedGroupMembersInfo(groupID: String, userIDs: [String]) async throws -> [OpenIMGroupMemberInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getSpecifiedGroupMembersInfo(groupID: groupID, userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func searchGroupMembers(param: OpenIMSearchGroupMembersParam) async throws -> [OpenIMGroupMemberInfo] {
        try await withCheckedThrowingContinuation { continuation in
            searchGroupMembers(param: param) { continuation.resume(with: $0) }
        }
    }

    func setGroupMemberRoleLevel(groupID: String, userID: String, roleLevel: OpenIMGroupMemberRole) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setGroupMemberRoleLevel(groupID: groupID, userID: userID, roleLevel: roleLevel) { continuation.resume(with: $0) }
        }
    }

    func changeGroupMute(groupID: String, isMute: Bool) async throws {
        try await withCheckedThrowingContinuation { continuation in
            changeGroupMute(groupID: groupID, isMute: isMute) { continuation.resume(with: $0) }
        }
    }

    func changeGroupMemberMute(groupID: String, userID: String, mutedSeconds: Int) async throws {
        try await withCheckedThrowingContinuation { continuation in
            changeGroupMemberMute(groupID: groupID, userID: userID, mutedSeconds: mutedSeconds) { continuation.resume(with: $0) }
        }
    }

    func setGroupMemberNickname(groupID: String, userID: String, nickname: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setGroupMemberNickname(groupID: groupID, userID: userID, nickname: nickname) { continuation.resume(with: $0) }
        }
    }

    func kickGroupMember(groupID: String, reason: String? = nil, userIDs: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            kickGroupMember(groupID: groupID, reason: reason, userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func inviteUserToGroup(groupID: String, reason: String? = nil, userIDs: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            inviteUserToGroup(groupID: groupID, reason: reason, userIDs: userIDs) { continuation.resume(with: $0) }
        }
    }

    func getGroupApplicationListAsRecipient() async throws -> [OpenIMGroupApplicationInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getGroupApplicationListAsRecipient { continuation.resume(with: $0) }
        }
    }

    func getGroupApplicationListAsApplicant() async throws -> [OpenIMGroupApplicationInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getGroupApplicationListAsApplicant { continuation.resume(with: $0) }
        }
    }

    func acceptGroupApplication(groupID: String, fromUserID: String, handleMsg: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            acceptGroupApplication(groupID: groupID, fromUserID: fromUserID, handleMsg: handleMsg) { continuation.resume(with: $0) }
        }
    }

    func refuseGroupApplication(groupID: String, fromUserID: String, handleMsg: String? = nil) async throws {
        try await withCheckedThrowingContinuation { continuation in
            refuseGroupApplication(groupID: groupID, fromUserID: fromUserID, handleMsg: handleMsg) { continuation.resume(with: $0) }
        }
    }
}
