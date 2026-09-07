import Foundation
@testable import OpenIMSDK
import XCTest

private final class BareCoreAdapter: OpenIMCoreAdapter {
    func initialize(configuration: OpenIMConfiguration, eventHandler: @escaping (OpenIMCoreEvent) -> Void) throws {}
    func login(userID: String, token: String) async throws {}
    func logout() async throws {}
    func uninitialize() {}
}

final class OpenIMCoreAdapterDefaultsTests: XCTestCase {
    private func assertThrowsCoreUnavailable<T>(_ expression: @autoclosure () async throws -> T) async {
        do {
            _ = try await expression()
            XCTFail("Expected coreUnavailable error")
        } catch let error as OpenIMError {
            XCTAssertEqual(error, .coreUnavailable)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    private func assertThrowsCoreUnavailableSync<T>(_ expression: @autoclosure () throws -> T) {
        XCTAssertThrowsError(try expression()) { error in
            XCTAssertEqual(error as? OpenIMError, .coreUnavailable)
        }
    }

    func testDefaultImplementationsThrowCoreUnavailable() async {
        let adapter = BareCoreAdapter()

        // User
        await assertThrowsCoreUnavailable(try await adapter.getUsersInfo(userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.getSelfUserInfo())
        await assertThrowsCoreUnavailable(try await adapter.setSelfUserInfo(userInfo: OpenIMUserInfo(userID: "u1")))
        await assertThrowsCoreUnavailable(try await adapter.updateFcmToken(fcmToken: "token", expireTime: 100))
        await assertThrowsCoreUnavailable(try await adapter.subscribeUsersStatus(userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.unsubscribeUsersStatus(userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.getSubscribeUsersStatus())
        await assertThrowsCoreUnavailable(try await adapter.getUserStatus(userIDs: ["u1"]))
        adapter.setUserListener(nil)

        // Friend
        await assertThrowsCoreUnavailable(try await adapter.getSpecifiedFriendsInfo(userIDs: ["u1"], filterBlack: false))
        await assertThrowsCoreUnavailable(try await adapter.getFriendList(filterBlack: false))
        await assertThrowsCoreUnavailable(try await adapter.getFriendListPage(offset: 0, count: 10, filterBlack: false))
        await assertThrowsCoreUnavailable(try await adapter.searchFriends(param: OpenIMSearchFriendsParam(keywordList: ["k"])))
        await assertThrowsCoreUnavailable(try await adapter.checkFriend(userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.addFriend(userID: "u1", reqMsg: nil))
        await assertThrowsCoreUnavailable(try await adapter.setFriendRemark(userID: "u1", remark: "r"))
        await assertThrowsCoreUnavailable(try await adapter.deleteFriend(friendUserID: "u1"))
        await assertThrowsCoreUnavailable(try await adapter.getFriendApplicationListAsRecipient())
        await assertThrowsCoreUnavailable(try await adapter.getFriendApplicationListAsApplicant())
        await assertThrowsCoreUnavailable(try await adapter.acceptFriendApplication(userID: "u1", handleMsg: nil))
        await assertThrowsCoreUnavailable(try await adapter.refuseFriendApplication(userID: "u1", handleMsg: nil))
        await assertThrowsCoreUnavailable(try await adapter.addBlack(blackUserID: "u1", ex: nil))
        await assertThrowsCoreUnavailable(try await adapter.removeBlack(blackUserID: "u1"))
        await assertThrowsCoreUnavailable(try await adapter.getBlackList())
        adapter.setFriendshipListener(nil)

        // Group
        let createInfo = OpenIMGroupCreateInfo(groupInfo: OpenIMGroupBaseInfo(groupName: "g"))
        await assertThrowsCoreUnavailable(try await adapter.createGroup(createInfo: createInfo))
        await assertThrowsCoreUnavailable(try await adapter.joinGroup(groupID: "g1", reqMsg: nil, joinSource: .invited, ex: nil))
        await assertThrowsCoreUnavailable(try await adapter.quitGroup(groupID: "g1"))
        await assertThrowsCoreUnavailable(try await adapter.dismissGroup(groupID: "g1"))
        await assertThrowsCoreUnavailable(try await adapter.getJoinedGroupList())
        await assertThrowsCoreUnavailable(try await adapter.getJoinedGroupListPage(offset: 0, count: 10))
        await assertThrowsCoreUnavailable(try await adapter.getSpecifiedGroupsInfo(groupIDs: ["g1"]))
        await assertThrowsCoreUnavailable(try await adapter.searchGroups(param: OpenIMSearchGroupParam(keywordList: ["k"])))
        await assertThrowsCoreUnavailable(try await adapter.setGroupInfo(groupInfo: OpenIMGroupInfo(groupID: "g1")))
        await assertThrowsCoreUnavailable(try await adapter.getGroupMemberList(groupID: "g1", filter: .all, offset: 0, count: 10))
        await assertThrowsCoreUnavailable(try await adapter.getSpecifiedGroupMembersInfo(groupID: "g1", userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.searchGroupMembers(param: OpenIMSearchGroupMembersParam(groupID: "g1", keywordList: ["k"])))
        await assertThrowsCoreUnavailable(try await adapter.setGroupMemberRoleLevel(groupID: "g1", userID: "u1", roleLevel: .member))
        await assertThrowsCoreUnavailable(try await adapter.changeGroupMute(groupID: "g1", isMute: true))
        await assertThrowsCoreUnavailable(try await adapter.changeGroupMemberMute(groupID: "g1", userID: "u1", mutedSeconds: 100))
        await assertThrowsCoreUnavailable(try await adapter.setGroupMemberNickname(groupID: "g1", userID: "u1", nickname: "nick"))
        await assertThrowsCoreUnavailable(try await adapter.kickGroupMember(groupID: "g1", reason: nil, userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.inviteUserToGroup(groupID: "g1", reason: nil, userIDs: ["u1"]))
        await assertThrowsCoreUnavailable(try await adapter.getGroupApplicationListAsRecipient())
        await assertThrowsCoreUnavailable(try await adapter.getGroupApplicationListAsApplicant())
        await assertThrowsCoreUnavailable(try await adapter.acceptGroupApplication(groupID: "g1", fromUserID: "u1", handleMsg: nil))
        await assertThrowsCoreUnavailable(try await adapter.refuseGroupApplication(groupID: "g1", fromUserID: "u1", handleMsg: nil))
        adapter.setGroupListener(nil)

        // Conversation
        await assertThrowsCoreUnavailable(try await adapter.getAllConversationList())
        await assertThrowsCoreUnavailable(try await adapter.getConversationListSplit(offset: 0, count: 10))
        await assertThrowsCoreUnavailable(try await adapter.getOneConversation(sessionType: .c2c, sourceID: "u1"))
        await assertThrowsCoreUnavailable(try await adapter.getMultipleConversation(conversationIDs: ["c1"]))
        await assertThrowsCoreUnavailable(try await adapter.setConversation(conversationID: "c1", req: OpenIMConversationReq()))
        await assertThrowsCoreUnavailable(try await adapter.hideConversation(conversationID: "c1"))
        await assertThrowsCoreUnavailable(try await adapter.setConversationDraft(conversationID: "c1", draftText: "t"))
        await assertThrowsCoreUnavailable(try await adapter.setConversationPinned(conversationID: "c1", isPinned: true))
        await assertThrowsCoreUnavailable(try await adapter.setConversationRecvMessageOpt(conversationIDs: ["c1"], status: .receive))
        await assertThrowsCoreUnavailable(try await adapter.markConversationMessageAsRead(conversationID: "c1"))
        await assertThrowsCoreUnavailable(try await adapter.getTotalUnreadMsgCount())
        await assertThrowsCoreUnavailable(try await adapter.deleteConversationAndDeleteAllMsg(conversationID: "c1"))
        await assertThrowsCoreUnavailable(try await adapter.clearConversationAndDeleteAllMsg(conversationID: "c1"))
        adapter.setConversationListener(nil)

        // Message
        let msg = OpenIMMessageInfo(clientMsgID: "m1")
        assertThrowsCoreUnavailableSync(try adapter.createTextMessage(text: "t"))
        assertThrowsCoreUnavailableSync(try adapter.createTextAtMessage(text: "t", atUserIDs: [], atUsersInfo: [], quoteMessage: nil))
        assertThrowsCoreUnavailableSync(try adapter.createImageMessage(imagePath: "p"))
        assertThrowsCoreUnavailableSync(try adapter.createSoundMessage(soundPath: "p", duration: 1))
        assertThrowsCoreUnavailableSync(try adapter.createVideoMessage(videoPath: "p", videoType: "mp4", duration: 1, snapshotPath: "s"))
        assertThrowsCoreUnavailableSync(try adapter.createFileMessage(filePath: "p", fileName: "f"))
        assertThrowsCoreUnavailableSync(try adapter.createLocationMessage(description: "d", longitude: 0, latitude: 0))
        assertThrowsCoreUnavailableSync(try adapter.createCustomMessage(data: "d", extension: nil, description: nil))
        assertThrowsCoreUnavailableSync(try adapter.createQuoteMessage(text: "t", message: msg))
        assertThrowsCoreUnavailableSync(try adapter.createCardMessage(cardInfo: OpenIMCardElem()))
        assertThrowsCoreUnavailableSync(try adapter.createFaceMessage(index: 1, data: "d"))
        assertThrowsCoreUnavailableSync(try adapter.createMergerMessage(messageList: [], title: "t", summaryList: []))
        assertThrowsCoreUnavailableSync(try adapter.createForwardMessage(message: msg))
        await assertThrowsCoreUnavailable(try await adapter.sendMessage(message: msg, recvID: nil, groupID: nil, offlinePushInfo: nil, isOnlineOnly: false, onProgress: nil))
        await assertThrowsCoreUnavailable(try await adapter.getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions()))
        await assertThrowsCoreUnavailable(try await adapter.revokeMessage(conversationID: "c1", clientMsgID: "m1"))
        await assertThrowsCoreUnavailable(try await adapter.typingStatusUpdate(recvID: "u1", msgTip: "t"))
        await assertThrowsCoreUnavailable(try await adapter.markMessagesAsReadByMsgID(conversationID: "c1", clientMsgIDs: ["m1"]))
        await assertThrowsCoreUnavailable(try await adapter.deleteMessage(conversationID: "c1", clientMsgID: "m1"))
        await assertThrowsCoreUnavailable(try await adapter.deleteMessageFromLocalStorage(conversationID: "c1", clientMsgID: "m1"))
        await assertThrowsCoreUnavailable(try await adapter.deleteAllMsgFromLocal())
        await assertThrowsCoreUnavailable(try await adapter.deleteAllMsgFromLocalAndSvr())
        await assertThrowsCoreUnavailable(try await adapter.searchLocalMessages(param: OpenIMSearchParam()))
        adapter.setAdvancedMsgListener(nil)
    }

    func testUnavailableOpenIMCoreAdapter() async {
        let unavailable = UnavailableOpenIMCoreAdapter()
        let config = OpenIMConfiguration(apiAddress: "a", websocketAddress: "w")

        XCTAssertThrowsError(try unavailable.initialize(configuration: config, eventHandler: { _ in })) { error in
            XCTAssertEqual(error as? OpenIMError, .coreUnavailable)
        }

        do {
            try await unavailable.login(userID: "u", token: "t")
            XCTFail("Expected coreUnavailable")
        } catch let error as OpenIMError {
            XCTAssertEqual(error, .coreUnavailable)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        do {
            try await unavailable.logout()
            XCTFail("Expected coreUnavailable")
        } catch let error as OpenIMError {
            XCTAssertEqual(error, .coreUnavailable)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        unavailable.uninitialize()
    }
}
