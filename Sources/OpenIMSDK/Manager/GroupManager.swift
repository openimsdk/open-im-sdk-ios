import Foundation

/// Manager handling group memberships, permissions, invitations, and applications.
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
        createInfo: OpenIMGroupCreateInfo
    ) async throws -> OpenIMGroupInfo {
        try await adapter.createGroup(createInfo: createInfo)
    }

    public func joinGroup(
        groupID: String,
        reqMsg: String? = nil,
        joinSource: OpenIMJoinType = .search,
        ex: String? = nil
    ) async throws {
        try await adapter.joinGroup(groupID: groupID, reqMsg: reqMsg, joinSource: joinSource, ex: ex)
    }

    public func quitGroup(groupID: String) async throws {
        try await adapter.quitGroup(groupID: groupID)
    }

    public func dismissGroup(groupID: String) async throws {
        try await adapter.dismissGroup(groupID: groupID)
    }

    public func getJoinedGroupList() async throws -> [OpenIMGroupInfo] {
        try await adapter.getJoinedGroupList()
    }

    public func getJoinedGroupListPage(
        offset: Int,
        count: Int
    ) async throws -> [OpenIMGroupInfo] {
        try await adapter.getJoinedGroupListPage(offset: offset, count: count)
    }

    public func getSpecifiedGroupsInfo(
        groupIDs: [String]
    ) async throws -> [OpenIMGroupInfo] {
        try await adapter.getSpecifiedGroupsInfo(groupIDs: groupIDs)
    }

    public func searchGroups(
        param: OpenIMSearchGroupParam
    ) async throws -> [OpenIMGroupInfo] {
        try await adapter.searchGroups(param: param)
    }

    public func setGroupInfo(
        groupInfo: OpenIMGroupInfo
    ) async throws {
        try await adapter.setGroupInfo(groupInfo: groupInfo)
    }

    public func getGroupMemberList(
        groupID: String,
        filter: OpenIMGroupMemberFilter = .all,
        offset: Int = 0,
        count: Int = 40
    ) async throws -> [OpenIMGroupMemberInfo] {
        try await adapter.getGroupMemberList(groupID: groupID, filter: filter, offset: offset, count: count)
    }

    public func getSpecifiedGroupMembersInfo(
        groupID: String,
        userIDs: [String]
    ) async throws -> [OpenIMGroupMemberInfo] {
        try await adapter.getSpecifiedGroupMembersInfo(groupID: groupID, userIDs: userIDs)
    }

    public func searchGroupMembers(
        param: OpenIMSearchGroupMembersParam
    ) async throws -> [OpenIMGroupMemberInfo] {
        try await adapter.searchGroupMembers(param: param)
    }

    public func setGroupMemberRoleLevel(
        groupID: String,
        userID: String,
        roleLevel: OpenIMGroupMemberRole
    ) async throws {
        try await adapter.setGroupMemberRoleLevel(groupID: groupID, userID: userID, roleLevel: roleLevel)
    }

    public func changeGroupMute(
        groupID: String,
        isMute: Bool
    ) async throws {
        try await adapter.changeGroupMute(groupID: groupID, isMute: isMute)
    }

    public func changeGroupMemberMute(
        groupID: String,
        userID: String,
        mutedSeconds: Int
    ) async throws {
        try await adapter.changeGroupMemberMute(groupID: groupID, userID: userID, mutedSeconds: mutedSeconds)
    }

    public func setGroupMemberNickname(
        groupID: String,
        userID: String,
        nickname: String
    ) async throws {
        try await adapter.setGroupMemberNickname(groupID: groupID, userID: userID, nickname: nickname)
    }

    public func kickGroupMember(
        groupID: String,
        reason: String? = nil,
        userIDs: [String]
    ) async throws {
        try await adapter.kickGroupMember(groupID: groupID, reason: reason, userIDs: userIDs)
    }

    public func inviteUserToGroup(
        groupID: String,
        reason: String? = nil,
        userIDs: [String]
    ) async throws {
        try await adapter.inviteUserToGroup(groupID: groupID, reason: reason, userIDs: userIDs)
    }

    public func getGroupApplicationListAsRecipient() async throws -> [OpenIMGroupApplicationInfo] {
        try await adapter.getGroupApplicationListAsRecipient()
    }

    public func getGroupApplicationListAsApplicant() async throws -> [OpenIMGroupApplicationInfo] {
        try await adapter.getGroupApplicationListAsApplicant()
    }

    public func acceptGroupApplication(
        groupID: String,
        fromUserID: String,
        handleMsg: String? = nil
    ) async throws {
        try await adapter.acceptGroupApplication(groupID: groupID, fromUserID: fromUserID, handleMsg: handleMsg)
    }

    public func refuseGroupApplication(
        groupID: String,
        fromUserID: String,
        handleMsg: String? = nil
    ) async throws {
        try await adapter.refuseGroupApplication(groupID: groupID, fromUserID: fromUserID, handleMsg: handleMsg)
    }
}
