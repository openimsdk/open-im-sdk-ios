import Foundation

/// Listener for user profile and status updates.
public protocol OpenIMUserListener: AnyObject, Sendable {
    func onSelfInfoUpdated(_ userInfo: OpenIMUserInfo)
    func onUserStatusChanged(_ statusInfo: OpenIMUserStatusInfo)
}

public extension OpenIMUserListener {
    func onSelfInfoUpdated(_ userInfo: OpenIMUserInfo) {}
    func onUserStatusChanged(_ statusInfo: OpenIMUserStatusInfo) {}
}

/// Listener for friendship and blacklist events.
public protocol OpenIMFriendshipListener: AnyObject, Sendable {
    func onFriendApplicationAdded(_ application: OpenIMFriendApplication)
    func onFriendApplicationDeleted(_ application: OpenIMFriendApplication)
    func onFriendApplicationAccepted(_ application: OpenIMFriendApplication)
    func onFriendApplicationRejected(_ application: OpenIMFriendApplication)
    func onFriendAdded(_ friendInfo: OpenIMFriendInfo)
    func onFriendDeleted(_ friendInfo: OpenIMFriendInfo)
    func onFriendInfoChanged(_ friendInfo: OpenIMFriendInfo)
    func onBlackAdded(_ blackInfo: OpenIMBlackInfo)
    func onBlackDeleted(_ blackInfo: OpenIMBlackInfo)
}

public extension OpenIMFriendshipListener {
    func onFriendApplicationAdded(_ application: OpenIMFriendApplication) {}
    func onFriendApplicationDeleted(_ application: OpenIMFriendApplication) {}
    func onFriendApplicationAccepted(_ application: OpenIMFriendApplication) {}
    func onFriendApplicationRejected(_ application: OpenIMFriendApplication) {}
    func onFriendAdded(_ friendInfo: OpenIMFriendInfo) {}
    func onFriendDeleted(_ friendInfo: OpenIMFriendInfo) {}
    func onFriendInfoChanged(_ friendInfo: OpenIMFriendInfo) {}
    func onBlackAdded(_ blackInfo: OpenIMBlackInfo) {}
    func onBlackDeleted(_ blackInfo: OpenIMBlackInfo) {}
}

/// Listener for group management and member changes.
public protocol OpenIMGroupListener: AnyObject, Sendable {
    func onJoinedGroupAdded(_ groupInfo: OpenIMGroupInfo)
    func onJoinedGroupDismissed(_ groupInfo: OpenIMGroupInfo)
    func onGroupMemberAdded(_ memberInfo: OpenIMGroupMemberInfo)
    func onGroupMemberDeleted(_ memberInfo: OpenIMGroupMemberInfo)
    func onGroupMemberInfoChanged(_ memberInfo: OpenIMGroupMemberInfo)
    func onGroupApplicationAdded(_ application: OpenIMGroupApplicationInfo)
    func onGroupApplicationDeleted(_ application: OpenIMGroupApplicationInfo)
    func onGroupApplicationAccepted(_ application: OpenIMGroupApplicationInfo)
    func onGroupApplicationRejected(_ application: OpenIMGroupApplicationInfo)
    func onGroupInfoChanged(_ groupInfo: OpenIMGroupInfo)
    func onGroupDismissed(_ groupInfo: OpenIMGroupInfo)
}

public extension OpenIMGroupListener {
    func onJoinedGroupAdded(_ groupInfo: OpenIMGroupInfo) {}
    func onJoinedGroupDismissed(_ groupInfo: OpenIMGroupInfo) {}
    func onGroupMemberAdded(_ memberInfo: OpenIMGroupMemberInfo) {}
    func onGroupMemberDeleted(_ memberInfo: OpenIMGroupMemberInfo) {}
    func onGroupMemberInfoChanged(_ memberInfo: OpenIMGroupMemberInfo) {}
    func onGroupApplicationAdded(_ application: OpenIMGroupApplicationInfo) {}
    func onGroupApplicationDeleted(_ application: OpenIMGroupApplicationInfo) {}
    func onGroupApplicationAccepted(_ application: OpenIMGroupApplicationInfo) {}
    func onGroupApplicationRejected(_ application: OpenIMGroupApplicationInfo) {}
    func onGroupInfoChanged(_ groupInfo: OpenIMGroupInfo) {}
    func onGroupDismissed(_ groupInfo: OpenIMGroupInfo) {}
}

/// Listener for conversation updates and sync status.
public protocol OpenIMConversationListener: AnyObject, Sendable {
    func onSyncServerStart()
    func onSyncServerFinish()
    func onSyncServerProgress(_ progress: Int)
    func onSyncServerFailed()
    func onNewConversation(_ conversations: [OpenIMConversationInfo])
    func onConversationChanged(_ conversations: [OpenIMConversationInfo])
    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int)
}

public extension OpenIMConversationListener {
    func onSyncServerStart() {}
    func onSyncServerFinish() {}
    func onSyncServerProgress(_ progress: Int) {}
    func onSyncServerFailed() {}
    func onNewConversation(_ conversations: [OpenIMConversationInfo]) {}
    func onConversationChanged(_ conversations: [OpenIMConversationInfo]) {}
    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int) {}
}

/// Listener for incoming messages and message status updates.
public protocol OpenIMAdvancedMsgListener: AnyObject, Sendable {
    func onRecvNewMessage(_ message: OpenIMMessageInfo)
    func onRecvC2CReadReceipt(_ receipts: [OpenIMReceiptInfo])
    func onRecvGroupReadReceipt(_ receipts: [OpenIMReceiptInfo])
    func onRecvMessageRevoked(_ revokedInfo: OpenIMMessageRevokedInfo)
}

public extension OpenIMAdvancedMsgListener {
    func onRecvNewMessage(_ message: OpenIMMessageInfo) {}
    func onRecvC2CReadReceipt(_ receipts: [OpenIMReceiptInfo]) {}
    func onRecvGroupReadReceipt(_ receipts: [OpenIMReceiptInfo]) {}
    func onRecvMessageRevoked(_ revokedInfo: OpenIMMessageRevokedInfo) {}
}
