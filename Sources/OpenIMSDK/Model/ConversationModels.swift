import Foundation

/// Conversation summary and configuration.
public struct OpenIMConversationInfo: Codable, Equatable, Sendable {
    public var conversationID: String?
    public var conversationType: OpenIMConversationType?
    public var userID: String?
    public var groupID: String?
    public var showName: String?
    public var faceURL: String?
    public var recvMsgOpt: OpenIMReceiveMessageOpt?
    public var unreadCount: Int?
    public var groupAtType: OpenIMGroupAtType?
    public var latestMsgSendTime: Int64?
    public var draftText: String?
    public var draftTextTime: Int64?
    public var isPinned: Bool?
    public var isPrivateChat: Bool?
    public var burnDuration: TimeInterval?
    public var isNotInGroup: Bool?
    public var attachedInfo: String?
    public var ex: String?
    public var latestMsg: OpenIMMessageInfo?

    public init(
        conversationID: String? = nil,
        conversationType: OpenIMConversationType? = nil,
        userID: String? = nil,
        groupID: String? = nil,
        showName: String? = nil,
        faceURL: String? = nil,
        recvMsgOpt: OpenIMReceiveMessageOpt? = nil,
        unreadCount: Int? = nil,
        groupAtType: OpenIMGroupAtType? = nil,
        latestMsgSendTime: Int64? = nil,
        draftText: String? = nil,
        draftTextTime: Int64? = nil,
        isPinned: Bool? = nil,
        isPrivateChat: Bool? = nil,
        burnDuration: TimeInterval? = nil,
        isNotInGroup: Bool? = nil,
        attachedInfo: String? = nil,
        ex: String? = nil,
        latestMsg: OpenIMMessageInfo? = nil
    ) {
        self.conversationID = conversationID
        self.conversationType = conversationType
        self.userID = userID
        self.groupID = groupID
        self.showName = showName
        self.faceURL = faceURL
        self.recvMsgOpt = recvMsgOpt
        self.unreadCount = unreadCount
        self.groupAtType = groupAtType
        self.latestMsgSendTime = latestMsgSendTime
        self.draftText = draftText
        self.draftTextTime = draftTextTime
        self.isPinned = isPinned
        self.isPrivateChat = isPrivateChat
        self.burnDuration = burnDuration
        self.isNotInGroup = isNotInGroup
        self.attachedInfo = attachedInfo
        self.ex = ex
        self.latestMsg = latestMsg
    }
}

/// Do not disturb conversation setting info.
public struct OpenIMConversationNotDisturbInfo: Codable, Equatable, Sendable {
    public var conversationID: String?
    public var result: OpenIMReceiveMessageOpt?

    public init(conversationID: String? = nil, result: OpenIMReceiveMessageOpt? = nil) {
        self.conversationID = conversationID
        self.result = result
    }
}

/// Typing / input status changed event data.
public struct OpenIMInputStatusChangedData: Codable, Equatable, Sendable {
    public var conversationID: String
    public var userID: String
    public var platformIDs: [Int]?

    public init(conversationID: String, userID: String, platformIDs: [Int]? = nil) {
        self.conversationID = conversationID
        self.userID = userID
        self.platformIDs = platformIDs
    }
}

/// Parameters for updating a conversation.
public struct OpenIMConversationReq: Codable, Equatable, Sendable {
    public var userID: String?
    public var groupID: String?
    public var recvMsgOpt: OpenIMReceiveMessageOpt?
    public var isPinned: Bool?
    public var groupAtType: OpenIMGroupAtType?
    public var isPrivateChat: Bool?
    public var burnDuration: TimeInterval?
    public var ex: String?

    public init(
        userID: String? = nil,
        groupID: String? = nil,
        recvMsgOpt: OpenIMReceiveMessageOpt? = nil,
        isPinned: Bool? = nil,
        groupAtType: OpenIMGroupAtType? = nil,
        isPrivateChat: Bool? = nil,
        burnDuration: TimeInterval? = nil,
        ex: String? = nil
    ) {
        self.userID = userID
        self.groupID = groupID
        self.recvMsgOpt = recvMsgOpt
        self.isPinned = isPinned
        self.groupAtType = groupAtType
        self.isPrivateChat = isPrivateChat
        self.burnDuration = burnDuration
        self.ex = ex
    }
}
