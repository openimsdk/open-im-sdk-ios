//
//  DualUserInteractionTests.swift
//  OpenIMSDKTests
//
//  Unit tests verifying bi-directional interactions between two users:
//  User A (6932496926) and User B (4134683436).
//

import XCTest
@testable import OpenIMSDK

final class DualUserInteractionTests: XCTestCase {

    private let userA_ID = "user_a"
    private let userA_Token = "mock_token_user_a"

    private let userB_ID = "user_b"
    private let userB_Token = "mock_token_user_b"

    private var adapterA: MockOpenIMCoreAdapter!
    private var adapterB: MockOpenIMCoreAdapter!
    private var clientA: OpenIMClient!
    private var clientB: OpenIMClient!

    override func setUp() async throws {
        try await super.setUp()
        adapterA = MockOpenIMCoreAdapter()
        adapterB = MockOpenIMCoreAdapter()
        clientA = OpenIMClient(adapter: adapterA)
        clientB = OpenIMClient(adapter: adapterB)

        let configA = OpenIMConfiguration(apiAddress: "https://web.openim.io/api", websocketAddress: "wss://web.openim.io/msg_gateway", platform: .android)
        let configB = OpenIMConfiguration(apiAddress: "https://web.openim.io/api", websocketAddress: "wss://web.openim.io/msg_gateway", platform: .android)

        try clientA.initialize(configuration: configA)
        try clientB.initialize(configuration: configB)

        try await clientA.login(userID: userA_ID, token: userA_Token)
        try await clientB.login(userID: userB_ID, token: userB_Token)
    }

    override func tearDown() async throws {
        if clientA.state != .idle {
            try? await clientA.logout()
            clientA.uninitialize()
        }
        if clientB.state != .idle {
            try? await clientB.logout()
            clientB.uninitialize()
        }
        try await super.tearDown()
    }

    func testUserASendsMessageToUserB() async throws {
        final class UserBMsgListener: OpenIMAdvancedMsgListener, @unchecked Sendable {
            var receivedMessage: OpenIMMessageInfo?
            func onRecvNewMessage(_ message: OpenIMMessageInfo) {
                receivedMessage = message
            }
        }

        let listenerB = UserBMsgListener()
        clientB.setAdvancedMsgListener(listenerB)

        // User A creates and sends a message to User B
        let text = "Hello User B from User A"
        let msg = try clientA.message.createTextMessage(text: text)
        let sentMessage = try await clientA.message.sendMessage(message: msg, recvID: userB_ID, groupID: nil)

        XCTAssertEqual(sentMessage.recvID, userB_ID)
        XCTAssertEqual(adapterA.lastSentMessage?.recvID, userB_ID)

        // Simulate delivery to User B's active listener
        adapterB.advancedMsgListener?.onRecvNewMessage(sentMessage)

        XCTAssertNotNil(listenerB.receivedMessage)
        XCTAssertEqual(listenerB.receivedMessage?.recvID, userB_ID)
        XCTAssertEqual(listenerB.receivedMessage?.textElem?.content, text)
    }

    func testUserARevokesMessageForUserB() async throws {
        final class UserBRevokeListener: OpenIMAdvancedMsgListener, @unchecked Sendable {
            var revokedInfo: OpenIMMessageRevokedInfo?
            func onRecvMessageRevoked(_ revokedInfo: OpenIMMessageRevokedInfo) {
                self.revokedInfo = revokedInfo
            }
        }

        let listenerB = UserBRevokeListener()
        clientB.setAdvancedMsgListener(listenerB)

        let conversationID = "si_\(userA_ID)_\(userB_ID)"
        let clientMsgID = "msg_revoke_test_123"

        // User A revokes the message
        try await clientA.message.revokeMessage(conversationID: conversationID, clientMsgID: clientMsgID)

        XCTAssertEqual(adapterA.lastRevokedMessage?.conversationID, conversationID)
        XCTAssertEqual(adapterA.lastRevokedMessage?.clientMsgID, clientMsgID)

        // Simulate delivery of revoke event to User B
        let revokePayload = OpenIMMessageRevokedInfo(
            revokerID: userA_ID,
            revokerRole: 20,
            clientMsgID: clientMsgID,
            revokeTime: 1700000000,
            sessionType: 1
        )
        adapterB.advancedMsgListener?.onRecvMessageRevoked(revokePayload)

        XCTAssertNotNil(listenerB.revokedInfo)
        XCTAssertEqual(listenerB.revokedInfo?.clientMsgID, clientMsgID)
        XCTAssertEqual(listenerB.revokedInfo?.revokerID, userA_ID)
    }

    func testUserAFriendApplicationAndUserBAcceptance() async throws {
        final class UserBFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {
            var applicationReceived: OpenIMFriendApplication?
            func onFriendApplicationAdded(_ friendApplication: OpenIMFriendApplication) {
                applicationReceived = friendApplication
            }
        }

        final class UserAFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {
            var addedFriend: OpenIMFriendInfo?
            func onFriendAdded(_ friendInfo: OpenIMFriendInfo) {
                addedFriend = friendInfo
            }
        }

        let listenerB = UserBFriendshipListener()
        let listenerA = UserAFriendshipListener()
        clientB.setFriendshipListener(listenerB)
        clientA.setFriendshipListener(listenerA)

        // 1. User A adds User B
        try await clientA.friend.addFriend(userID: userB_ID, reqMsg: "Let's connect!")
        XCTAssertEqual(adapterA.lastAddedFriendID, userB_ID)

        // Simulate application delivered to User B
        let appInfo = OpenIMFriendApplication(
            fromUserID: userA_ID,
            fromNickname: "5234",
            toUserID: userB_ID,
            toNickname: "6234",
            handleResult: .normal,
            reqMsg: "Let's connect!"
        )
        adapterB.friendshipListener?.onFriendApplicationAdded(appInfo)

        XCTAssertNotNil(listenerB.applicationReceived)
        XCTAssertEqual(listenerB.applicationReceived?.fromUserID, userA_ID)

        // 2. User B accepts User A's application
        try await clientB.friend.acceptFriendApplication(userID: userA_ID, handleMsg: "Agreed")
        XCTAssertEqual(adapterB.lastHandledApplication?.userID, userA_ID)
        XCTAssertEqual(adapterB.lastHandledApplication?.accepted, true)

        // Simulate friendAdded delivered to User A
        let friendInfo = OpenIMFriendInfo(
            ownerUserID: userA_ID,
            userID: userB_ID,
            nickname: "6234"
        )
        adapterA.friendshipListener?.onFriendAdded(friendInfo)

        XCTAssertNotNil(listenerA.addedFriend)
        XCTAssertEqual(listenerA.addedFriend?.userID, userB_ID)
        XCTAssertEqual(listenerA.addedFriend?.nickname, "6234")
    }
}
