import Foundation

/// Supported client platform types.
public enum OpenIMPlatform: Int, Codable, Sendable, CaseIterable {
    case iPhone = 1
    case android = 2
    case windows = 3
    case macOS = 4
    case web = 5
    case miniWeb = 6
    case linux = 7
    case androidPad = 8
    case iPad = 9
}

/// Message content types matching OpenIM core protocol.
public enum OpenIMMessageContentType: Int, Codable, Sendable {
    case text = 101
    case image = 102
    case audio = 103
    case video = 104
    case file = 105
    case at = 106
    case merge = 107
    case card = 108
    case location = 109
    case custom = 110
    case typing = 113
    case quote = 114
    case face = 115
    case advancedText = 117
    case customMsgNotTriggerConversation = 119
    case customMsgOnlineOnly = 120

    // Notification message types
    case friendAppApproved = 1201
    case friendAppRejected = 1202
    case friendApplication = 1203
    case friendAdded = 1204
    case friendDeleted = 1205
    case friendRemarkSet = 1206
    case blackAdded = 1207
    case blackDeleted = 1208

    case conversationOptChange = 1300
    case userInfoUpdated = 1303
    case oaNotification = 1400

    case groupCreated = 1501
    case groupInfoSet = 1502
    case joinGroupApplication = 1503
    case memberQuit = 1504
    case groupAppAccepted = 1505
    case groupAppRejected = 1506
    case groupOwnerTransferred = 1507
    case memberKicked = 1508
    case memberInvited = 1509
    case memberEnter = 1510
    case dismissGroup = 1511
    case groupMemberMuted = 1512
    case groupMemberCancelMuted = 1513
    case groupMuted = 1514
    case groupCancelMuted = 1515
    case groupMemberInfoSet = 1516
    case groupMemberSetToAdmin = 1517
    case groupMemberSetToOrdinaryUser = 1518
    case groupAnnouncement = 1519
    case groupSetName = 1520

    case isPrivateMessage = 1701
    case business = 2001
    case revoke = 2101
    case hasReadReceipt = 2150
    case groupHasReadReceipt = 2155
}

/// Status of a sent or received message.
public enum OpenIMMessageStatus: Int, Codable, Sendable {
    case undefined = 0
    case sending = 1
    case sendSuccess = 2
    case sendFailure = 3
    case revoked = 4
}

/// Conversation type.
public enum OpenIMConversationType: Int, Codable, Sendable {
    case undefined = 0
    case c2c = 1
    case group = 2
    case superGroup = 3
    case notification = 4
}

/// Message level.
public enum OpenIMMessageLevel: Int, Codable, Sendable {
    case user = 100
    case system = 200
}

/// Message receive option.
public enum OpenIMReceiveMessageOpt: Int, Codable, Sendable {
    case receive = 0
    case notReceive = 1
    case notNotify = 2
}

/// Group member filter option for queries.
public enum OpenIMGroupMemberFilter: Int, Codable, Sendable {
    case all = 0
    case owner = 1
    case admin = 2
    case member = 3
    case adminAndMember = 4
    case superAndAdmin = 5
}

/// Role of a group member.
public enum OpenIMGroupMemberRole: Int, Codable, Sendable {
    case member = 20
    case admin = 60
    case owner = 100
}

/// Application handling status for friends and groups.
public enum OpenIMApplicationStatus: Int, Codable, Sendable {
    case decline = -1
    case normal = 0
    case accept = 1
}

/// Relationship status between users.
public enum OpenIMRelationship: Int, Codable, Sendable {
    case black = 0
    case friend = 1
}

/// At mention flag in group messages.
public enum OpenIMGroupAtType: Int, Codable, Sendable {
    case normal = 0
    case atMe = 1
    case atAll = 2
    case atAllAtMe = 3
    case groupNotification = 4
}

/// Group verification requirements for new members.
public enum OpenIMGroupVerificationType: Int, Codable, Sendable {
    case applyNeedVerificationInviteDirectly = 0
    case allNeedVerification = 1
    case directly = 2
}

/// Group classification type.
public enum OpenIMGroupType: Int, Codable, Sendable {
    case normal = 0
    case superGroup = 1
    case working = 2
}

/// Status of a group.
public enum OpenIMGroupStatus: Int, Codable, Sendable {
    case ok = 0
    case banChat = 1
    case dismissed = 2
    case muted = 3
}

/// Source method for joining a group.
public enum OpenIMJoinType: Int, Codable, Sendable {
    case invited = 2
    case search = 3
    case qrCode = 4
}

/// General permission / allow switch.
public enum OpenIMAllowType: Int, Codable, Sendable {
    case allowed = 0
    case notAllowed = 1
}

/// User login status reported by core SDK.
public enum OpenIMLoginStatus: Int, Codable, Sendable {
    case logout = 1
    case logging = 2
    case logged = 3
}

/// History view query mode.
public enum OpenIMGetHistoryViewType: Int, Codable, Sendable {
    case history = 0
    case search = 1
}
