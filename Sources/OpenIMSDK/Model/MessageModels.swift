import Foundation

/// Offline push notification options.
public struct OpenIMOfflinePushInfo: Codable, Equatable, Sendable {
    public var title: String?
    public var desc: String?
    public var iOSPushSound: String?
    public var iOSBadgeCount: Bool?
    public var operatorUserID: String?
    public var ex: String?

    public init(
        title: String? = nil,
        desc: String? = nil,
        iOSPushSound: String? = nil,
        iOSBadgeCount: Bool? = nil,
        operatorUserID: String? = nil,
        ex: String? = nil
    ) {
        self.title = title
        self.desc = desc
        self.iOSPushSound = iOSPushSound
        self.iOSBadgeCount = iOSBadgeCount
        self.operatorUserID = operatorUserID
        self.ex = ex
    }
}

/// Quoted message element.
public struct OpenIMQuoteElem: Codable, Equatable, Sendable {
    public var text: String?
    public var quoteMessage: OpenIMMessageInfo?

    public init(text: String? = nil, quoteMessage: OpenIMMessageInfo? = nil) {
        self.text = text
        self.quoteMessage = quoteMessage
    }
}

/// At mention message element.
public struct OpenIMAtTextElem: Codable, Equatable, Sendable {
    public var text: String?
    public var atUserList: [String]?
    public var atUsersInfo: [OpenIMAtInfo]?
    public var quoteMessage: OpenIMMessageInfo?
    public var isAtSelf: Bool?

    public init(
        text: String? = nil,
        atUserList: [String]? = nil,
        atUsersInfo: [OpenIMAtInfo]? = nil,
        quoteMessage: OpenIMMessageInfo? = nil,
        isAtSelf: Bool? = nil
    ) {
        self.text = text
        self.atUserList = atUserList
        self.atUsersInfo = atUsersInfo
        self.quoteMessage = quoteMessage
        self.isAtSelf = isAtSelf
    }
}

/// Merged message element.
public struct OpenIMMergeElem: Codable, Equatable, Sendable {
    public var title: String?
    public var abstractList: [String]?
    public var multiMessage: [OpenIMMessageInfo]?
    public var messageEntityList: [OpenIMMessageEntity]?

    public init(
        title: String? = nil,
        abstractList: [String]? = nil,
        multiMessage: [OpenIMMessageInfo]? = nil,
        messageEntityList: [OpenIMMessageEntity]? = nil
    ) {
        self.title = title
        self.abstractList = abstractList
        self.multiMessage = multiMessage
        self.messageEntityList = messageEntityList
    }
}

/// Full Message entity model.
public final class OpenIMMessageInfo: Codable, Equatable, @unchecked Sendable {
    public var clientMsgID: String?
    public var serverMsgID: String?
    public var createTime: Int64?
    public var sendTime: Int64?
    public var sessionType: OpenIMConversationType?
    public var sendID: String?
    public var recvID: String?
    public var handleMsg: String?
    public var msgFrom: OpenIMMessageLevel?
    public var contentType: OpenIMMessageContentType?
    public var senderPlatformID: OpenIMPlatform?
    public var senderNickname: String?
    public var senderFaceUrl: String?
    public var groupID: String?
    public var content: String?
    public var seq: Int64?
    public var isRead: Bool?
    public var status: OpenIMMessageStatus?
    public var attachedInfo: String?
    public var localEx: String?
    public var ex: String?
    public var offlinePush: OpenIMOfflinePushInfo?

    // Elements
    public var textElem: OpenIMTextElem?
    public var cardElem: OpenIMCardElem?
    public var pictureElem: OpenIMPictureElem?
    public var soundElem: OpenIMSoundElem?
    public var videoElem: OpenIMVideoElem?
    public var fileElem: OpenIMFileElem?
    public var mergeElem: OpenIMMergeElem?
    public var atTextElem: OpenIMAtTextElem?
    public var locationElem: OpenIMLocationElem?
    public var customElem: OpenIMCustomElem?
    public var quoteElem: OpenIMQuoteElem?
    public var faceElem: OpenIMFaceElem?
    public var advancedTextElem: OpenIMAdvancedTextElem?
    public var typingElem: OpenIMTypingElem?

    public init(
        clientMsgID: String? = nil,
        serverMsgID: String? = nil,
        createTime: Int64? = nil,
        sendTime: Int64? = nil,
        sessionType: OpenIMConversationType? = nil,
        sendID: String? = nil,
        recvID: String? = nil,
        handleMsg: String? = nil,
        msgFrom: OpenIMMessageLevel? = nil,
        contentType: OpenIMMessageContentType? = nil,
        senderPlatformID: OpenIMPlatform? = nil,
        senderNickname: String? = nil,
        senderFaceUrl: String? = nil,
        groupID: String? = nil,
        content: String? = nil,
        seq: Int64? = nil,
        isRead: Bool? = nil,
        status: OpenIMMessageStatus? = nil,
        attachedInfo: String? = nil,
        localEx: String? = nil,
        ex: String? = nil,
        offlinePush: OpenIMOfflinePushInfo? = nil,
        textElem: OpenIMTextElem? = nil,
        cardElem: OpenIMCardElem? = nil,
        pictureElem: OpenIMPictureElem? = nil,
        soundElem: OpenIMSoundElem? = nil,
        videoElem: OpenIMVideoElem? = nil,
        fileElem: OpenIMFileElem? = nil,
        mergeElem: OpenIMMergeElem? = nil,
        atTextElem: OpenIMAtTextElem? = nil,
        locationElem: OpenIMLocationElem? = nil,
        customElem: OpenIMCustomElem? = nil,
        quoteElem: OpenIMQuoteElem? = nil,
        faceElem: OpenIMFaceElem? = nil,
        advancedTextElem: OpenIMAdvancedTextElem? = nil,
        typingElem: OpenIMTypingElem? = nil
    ) {
        self.clientMsgID = clientMsgID
        self.serverMsgID = serverMsgID
        self.createTime = createTime
        self.sendTime = sendTime
        self.sessionType = sessionType
        self.sendID = sendID
        self.recvID = recvID
        self.handleMsg = handleMsg
        self.msgFrom = msgFrom
        self.contentType = contentType
        self.senderPlatformID = senderPlatformID
        self.senderNickname = senderNickname
        self.senderFaceUrl = senderFaceUrl
        self.groupID = groupID
        self.content = content
        self.seq = seq
        self.isRead = isRead
        self.status = status
        self.attachedInfo = attachedInfo
        self.localEx = localEx
        self.ex = ex
        self.offlinePush = offlinePush
        self.textElem = textElem
        self.cardElem = cardElem
        self.pictureElem = pictureElem
        self.soundElem = soundElem
        self.videoElem = videoElem
        self.fileElem = fileElem
        self.mergeElem = mergeElem
        self.atTextElem = atTextElem
        self.locationElem = locationElem
        self.customElem = customElem
        self.quoteElem = quoteElem
        self.faceElem = faceElem
        self.advancedTextElem = advancedTextElem
        self.typingElem = typingElem
    }

    public static func == (lhs: OpenIMMessageInfo, rhs: OpenIMMessageInfo) -> Bool {
        if let lID = lhs.clientMsgID, let rID = rhs.clientMsgID, !lID.isEmpty, !rID.isEmpty {
            return lID == rID
        }
        return lhs.serverMsgID == rhs.serverMsgID
            && lhs.sendID == rhs.sendID
            && lhs.recvID == rhs.recvID
            && lhs.content == rhs.content
            && lhs.contentType == rhs.contentType
            && lhs.status == rhs.status
    }
}

/// Options for fetching history messages.
public struct OpenIMGetMessageOptions: Codable, Equatable, Sendable {
    public var userID: String?
    public var groupID: String?
    public var conversationID: String?
    public var startClientMsgID: String?
    public var count: Int

    public init(
        userID: String? = nil,
        groupID: String? = nil,
        conversationID: String? = nil,
        startClientMsgID: String? = nil,
        count: Int = 20
    ) {
        self.userID = userID
        self.groupID = groupID
        self.conversationID = conversationID
        self.startClientMsgID = startClientMsgID
        self.count = count
    }
}

/// Result returned when fetching advanced history messages.
public struct OpenIMGetAdvancedHistoryMessageListInfo: Codable, Equatable, Sendable {
    public var isEnd: Bool?
    public var lastMinSeq: Int64?
    public var errCode: Int?
    public var errMsg: String?
    public var messageList: [OpenIMMessageInfo]?

    public init(
        isEnd: Bool? = nil,
        lastMinSeq: Int64? = nil,
        errCode: Int? = nil,
        errMsg: String? = nil,
        messageList: [OpenIMMessageInfo]? = nil
    ) {
        self.isEnd = isEnd
        self.lastMinSeq = lastMinSeq
        self.errCode = errCode
        self.errMsg = errMsg
        self.messageList = messageList
    }
}

/// Search message query parameters.
public struct OpenIMSearchParam: Codable, Equatable, Sendable {
    public var conversationID: String?
    public var keywordList: [String]
    public var keywordListMatchType: Int?
    public var senderUserIDList: [String]?
    public var messageTypeList: [Int]?
    public var searchTimePosition: Int64?
    public var searchTimePeriod: Int64?
    public var pageIndex: Int?
    public var count: Int?

    public init(
        conversationID: String? = nil,
        keywordList: [String] = [],
        keywordListMatchType: Int? = nil,
        senderUserIDList: [String]? = nil,
        messageTypeList: [Int]? = nil,
        searchTimePosition: Int64? = nil,
        searchTimePeriod: Int64? = nil,
        pageIndex: Int? = nil,
        count: Int? = nil
    ) {
        self.conversationID = conversationID
        self.keywordList = keywordList
        self.keywordListMatchType = keywordListMatchType
        self.senderUserIDList = senderUserIDList
        self.messageTypeList = messageTypeList
        self.searchTimePosition = searchTimePosition
        self.searchTimePeriod = searchTimePeriod
        self.pageIndex = pageIndex
        self.count = count
    }
}

/// Single item in message search results.
public struct OpenIMSearchResultItemInfo: Codable, Equatable, Sendable {
    public var conversationID: String?
    public var messageCount: Int?
    public var conversationType: OpenIMConversationType?
    public var showName: String?
    public var faceURL: String?
    public var messageList: [OpenIMMessageInfo]?

    public init(
        conversationID: String? = nil,
        messageCount: Int? = nil,
        conversationType: OpenIMConversationType? = nil,
        showName: String? = nil,
        faceURL: String? = nil,
        messageList: [OpenIMMessageInfo]? = nil
    ) {
        self.conversationID = conversationID
        self.messageCount = messageCount
        self.conversationType = conversationType
        self.showName = showName
        self.faceURL = faceURL
        self.messageList = messageList
    }
}

/// Message search results container.
public struct OpenIMSearchResultInfo: Codable, Equatable, Sendable {
    public var totalCount: Int?
    public var searchResultItems: [OpenIMSearchResultItemInfo]?
    public var findResultItems: [OpenIMSearchResultItemInfo]?

    public init(
        totalCount: Int? = nil,
        searchResultItems: [OpenIMSearchResultItemInfo]? = nil,
        findResultItems: [OpenIMSearchResultItemInfo]? = nil
    ) {
        self.totalCount = totalCount
        self.searchResultItems = searchResultItems
        self.findResultItems = findResultItems
    }
}

/// Message revoked notification info.
public struct OpenIMMessageRevokedInfo: Codable, Equatable, Sendable {
    public var revokerID: String?
    public var revokerRole: Int?
    public var revokerNickname: String?
    public var clientMsgID: String?
    public var revokeTime: Int64?
    public var sourceMessageSendTime: Int64?
    public var sourceMessageSendID: String?
    public var sourceMessageSenderNickname: String?
    public var sessionType: Int?

    public init(
        revokerID: String? = nil,
        revokerRole: Int? = nil,
        revokerNickname: String? = nil,
        clientMsgID: String? = nil,
        revokeTime: Int64? = nil,
        sourceMessageSendTime: Int64? = nil,
        sourceMessageSendID: String? = nil,
        sourceMessageSenderNickname: String? = nil,
        sessionType: Int? = nil
    ) {
        self.revokerID = revokerID
        self.revokerRole = revokerRole
        self.revokerNickname = revokerNickname
        self.clientMsgID = clientMsgID
        self.revokeTime = revokeTime
        self.sourceMessageSendTime = sourceMessageSendTime
        self.sourceMessageSendID = sourceMessageSendID
        self.sourceMessageSenderNickname = sourceMessageSenderNickname
        self.sessionType = sessionType
    }
}

/// Receipt info for message read receipts.
public struct OpenIMReceiptInfo: Codable, Equatable, Sendable {
    public var userID: String?
    public var groupID: String?
    public var msgIDList: [String]?
    public var readTime: Int64?
    public var msgFrom: Int?
    public var contentType: Int?
    public var sessionType: Int?

    public init(
        userID: String? = nil,
        groupID: String? = nil,
        msgIDList: [String]? = nil,
        readTime: Int64? = nil,
        msgFrom: Int? = nil,
        contentType: Int? = nil,
        sessionType: Int? = nil
    ) {
        self.userID = userID
        self.groupID = groupID
        self.msgIDList = msgIDList
        self.readTime = readTime
        self.msgFrom = msgFrom
        self.contentType = contentType
        self.sessionType = sessionType
    }
}
