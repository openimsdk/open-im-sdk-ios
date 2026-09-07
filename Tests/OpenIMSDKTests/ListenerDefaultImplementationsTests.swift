import Foundation
@testable import OpenIMSDK
import XCTest

private final class EmptyUserListener: OpenIMUserListener, @unchecked Sendable {}
private final class EmptyFriendshipListener: OpenIMFriendshipListener, @unchecked Sendable {}
private final class EmptyGroupListener: OpenIMGroupListener, @unchecked Sendable {}
private final class EmptyConversationListener: OpenIMConversationListener, @unchecked Sendable {}
private final class EmptyAdvancedMsgListener: OpenIMAdvancedMsgListener, @unchecked Sendable {}

final class ListenerDefaultImplementationsTests: XCTestCase {
    func testUserListenerDefaults() {
        let listener = EmptyUserListener()
        listener.onSelfInfoUpdated(OpenIMUserInfo(userID: "u1"))
        listener.onUserStatusChanged(OpenIMUserStatusInfo(userID: "u1"))
    }

    func testFriendshipListenerDefaults() {
        let listener = EmptyFriendshipListener()
        let app = OpenIMFriendApplication(fromUserID: "u1", toUserID: "u2")
        let friend = OpenIMFriendInfo(userID: "u1")
        let black = OpenIMBlackInfo(userID: "u1")

        listener.onFriendApplicationAdded(app)
        listener.onFriendApplicationDeleted(app)
        listener.onFriendApplicationAccepted(app)
        listener.onFriendApplicationRejected(app)
        listener.onFriendAdded(friend)
        listener.onFriendDeleted(friend)
        listener.onFriendInfoChanged(friend)
        listener.onBlackAdded(black)
        listener.onBlackDeleted(black)
    }

    func testGroupListenerDefaults() {
        let listener = EmptyGroupListener()
        let group = OpenIMGroupInfo(groupID: "g1")
        let member = OpenIMGroupMemberInfo(groupID: "g1", userID: "u1")
        let app = OpenIMGroupApplicationInfo(groupID: "g1", userID: "u1")

        listener.onJoinedGroupAdded(group)
        listener.onJoinedGroupDismissed(group)
        listener.onGroupMemberAdded(member)
        listener.onGroupMemberDeleted(member)
        listener.onGroupMemberInfoChanged(member)
        listener.onGroupApplicationAdded(app)
        listener.onGroupApplicationDeleted(app)
        listener.onGroupApplicationAccepted(app)
        listener.onGroupApplicationRejected(app)
        listener.onGroupInfoChanged(group)
        listener.onGroupDismissed(group)
    }

    func testConversationListenerDefaults() {
        let listener = EmptyConversationListener()
        let conv = OpenIMConversationInfo(conversationID: "c1")

        listener.onSyncServerStart()
        listener.onSyncServerFinish()
        listener.onSyncServerProgress(50)
        listener.onSyncServerFailed()
        listener.onNewConversation([conv])
        listener.onConversationChanged([conv])
        listener.onTotalUnreadMessageCountChanged(10)
    }

    func testAdvancedMsgListenerDefaults() {
        let listener = EmptyAdvancedMsgListener()
        let msg = OpenIMMessageInfo(clientMsgID: "m1")
        let receipt = OpenIMReceiptInfo(userID: "u1")
        let revoked = OpenIMMessageRevokedInfo(clientMsgID: "m1")

        listener.onRecvNewMessage(msg)
        listener.onRecvC2CReadReceipt([receipt])
        listener.onRecvGroupReadReceipt([receipt])
        listener.onRecvMessageRevoked(revoked)
    }
}
