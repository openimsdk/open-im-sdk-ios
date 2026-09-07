import XCTest
@testable import OpenIMSDK

final class GroupManagerAsyncTests: XCTestCase {
    func testAllGroupManagerAPIsUsingAsyncAwait() async throws {
        let adapter = MockOpenIMCoreAdapter()
        let client = OpenIMClient(adapter: adapter)

        // 1. getJoinedGroupList
        let groups = try await client.group.getJoinedGroupList()
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups.first?.groupID, "group_1")

        // 2. getJoinedGroupListPage
        let page = try await client.group.getJoinedGroupListPage(offset: 0, count: 20)
        XCTAssertEqual(page.first?.groupID, "group_page_1")

        // 3. createGroup
        let createInfo = OpenIMGroupCreateInfo(
            groupInfo: OpenIMGroupBaseInfo(groupName: "New Group"),
            memberUserIDs: ["u1", "u2"]
        )
        let created = try await client.group.createGroup(createInfo: createInfo)
        XCTAssertEqual(created.groupName, "New Group")

        // 4. getSpecifiedGroupsInfo
        let specified = try await client.group.getSpecifiedGroupsInfo(groupIDs: ["g1", "g2"])
        XCTAssertEqual(specified.count, 2)
        XCTAssertEqual(specified.first?.groupID, "g1")

        // 5. searchGroups
        let searchParam = OpenIMSearchGroupParam(keywordList: ["Tech"], isSearchGroupName: true)
        let searchResults = try await client.group.searchGroups(param: searchParam)
        XCTAssertEqual(adapter.lastSearchGroupParam?.keywordList, ["Tech"])
        XCTAssertEqual(searchResults.first?.groupID, "searched_Tech")

        // 6. setGroupInfo
        try await client.group.setGroupInfo(groupInfo: OpenIMGroupInfo(groupID: "group_1", groupName: "Renamed"))
        XCTAssertEqual(adapter.lastUpdatedGroupInfo?.groupName, "Renamed")

        // 7. getGroupMemberList
        let members = try await client.group.getGroupMemberList(groupID: "group_1", filter: .all, offset: 0, count: 20)
        XCTAssertEqual(members.first?.userID, "member_1")

        // 8. getSpecifiedGroupMembersInfo
        let specMembers = try await client.group.getSpecifiedGroupMembersInfo(groupID: "group_1", userIDs: ["m1", "m2"])
        XCTAssertEqual(specMembers.count, 2)
        XCTAssertEqual(specMembers.first?.userID, "m1")

        // 9. searchGroupMembers
        let searchMembersParam = OpenIMSearchGroupMembersParam(groupID: "group_1", keywordList: ["bob"])
        let searchedMembers = try await client.group.searchGroupMembers(param: searchMembersParam)
        XCTAssertEqual(adapter.lastSearchGroupMembersParam?.keywordList, ["bob"])
        XCTAssertEqual(searchedMembers.first?.userID, "member_bob")

        // 10. setGroupMemberRoleLevel
        try await client.group.setGroupMemberRoleLevel(groupID: "group_1", userID: "m1", roleLevel: .admin)
        XCTAssertEqual(adapter.lastMemberRoleLevel?.role, .admin)

        // 11. changeGroupMute
        try await client.group.changeGroupMute(groupID: "group_1", isMute: true)
        XCTAssertEqual(adapter.lastGroupMute?.isMute, true)

        // 12. changeGroupMemberMute
        try await client.group.changeGroupMemberMute(groupID: "group_1", userID: "m1", mutedSeconds: 600)
        XCTAssertEqual(adapter.lastGroupMemberMute?.mutedSeconds, 600)

        // 13. setGroupMemberNickname
        try await client.group.setGroupMemberNickname(groupID: "group_1", userID: "m1", nickname: "SuperAdmin")
        XCTAssertEqual(adapter.lastGroupMemberNickname?.nickname, "SuperAdmin")

        // 14. kickGroupMember
        try await client.group.kickGroupMember(groupID: "group_1", reason: "rules", userIDs: ["bad_user"])
        XCTAssertEqual(adapter.lastKickedMembers?.userIDs, ["bad_user"])

        // 15. inviteUserToGroup
        try await client.group.inviteUserToGroup(groupID: "group_1", reason: "welcome", userIDs: ["new_user"])
        XCTAssertEqual(adapter.lastInvitedMembers?.userIDs, ["new_user"])

        // 16. joinGroup
        try await client.group.joinGroup(groupID: "group_2", reqMsg: "Please let me in", joinSource: .invited)
        XCTAssertEqual(adapter.lastJoinedGroupID, "group_2")

        // 17. getGroupApplicationListAsRecipient
        let recApps = try await client.group.getGroupApplicationListAsRecipient()
        XCTAssertEqual(recApps.first?.groupID, "g1")

        // 18. getGroupApplicationListAsApplicant
        let appApps = try await client.group.getGroupApplicationListAsApplicant()
        XCTAssertEqual(appApps.first?.groupID, "g2")

        // 19. acceptGroupApplication
        try await client.group.acceptGroupApplication(groupID: "group_1", fromUserID: "applicant_1", handleMsg: "OK")
        XCTAssertEqual(adapter.lastHandledGroupApp?.fromUserID, "applicant_1")
        XCTAssertTrue(adapter.lastHandledGroupApp?.accepted ?? false)

        // 20. refuseGroupApplication
        try await client.group.refuseGroupApplication(groupID: "group_1", fromUserID: "applicant_2", handleMsg: "No")
        XCTAssertEqual(adapter.lastHandledGroupApp?.fromUserID, "applicant_2")
        XCTAssertFalse(adapter.lastHandledGroupApp?.accepted ?? true)

        // 21. quitGroup
        try await client.group.quitGroup(groupID: "group_1")
        XCTAssertEqual(adapter.lastQuitGroupID, "group_1")

        // 22. dismissGroup
        try await client.group.dismissGroup(groupID: "group_1")
        XCTAssertEqual(adapter.lastDismissedGroupID, "group_1")

        // 23. setListener
        final class DummyGroupListener: OpenIMGroupListener, @unchecked Sendable {}
        let listener = DummyGroupListener()
        client.group.setListener(listener)
        XCTAssertTrue(adapter.groupListener === listener)
    }

    func testGroupManagerErrorPropagation() async {
        let adapter = MockOpenIMCoreAdapter()
        adapter.shouldFail = true
        let client = OpenIMClient(adapter: adapter)

        do {
            _ = try await client.group.getJoinedGroupList()
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
