import Foundation

/// Friend relationship details.
public struct OpenIMFriendInfo: Codable, Equatable, Sendable {
    public var ownerUserID: String?
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var remark: String?
    public var createTime: Int64?
    public var addSource: Int?
    public var operatorUserID: String?
    public var ex: String?
    public var attachedInfo: String?

    public init(
        ownerUserID: String? = nil,
        userID: String? = nil,
        nickname: String? = nil,
        faceURL: String? = nil,
        remark: String? = nil,
        createTime: Int64? = nil,
        addSource: Int? = nil,
        operatorUserID: String? = nil,
        ex: String? = nil,
        attachedInfo: String? = nil
    ) {
        self.ownerUserID = ownerUserID
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.remark = remark
        self.createTime = createTime
        self.addSource = addSource
        self.operatorUserID = operatorUserID
        self.ex = ex
        self.attachedInfo = attachedInfo
    }
}

/// Blacklist entry info.
public struct OpenIMBlackInfo: Codable, Equatable, Sendable {
    public var ownerUserID: String?
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var createTime: Int64?
    public var addSource: Int?
    public var operatorUserID: String?
    public var ex: String?
    public var attachedInfo: String?

    public init(
        ownerUserID: String? = nil,
        userID: String? = nil,
        nickname: String? = nil,
        faceURL: String? = nil,
        createTime: Int64? = nil,
        addSource: Int? = nil,
        operatorUserID: String? = nil,
        ex: String? = nil,
        attachedInfo: String? = nil
    ) {
        self.ownerUserID = ownerUserID
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.createTime = createTime
        self.addSource = addSource
        self.operatorUserID = operatorUserID
        self.ex = ex
        self.attachedInfo = attachedInfo
    }
}

/// Friend application / request details.
public struct OpenIMFriendApplication: Codable, Equatable, Sendable {
    public var fromUserID: String?
    public var fromNickname: String?
    public var fromFaceURL: String?
    public var toUserID: String?
    public var toNickname: String?
    public var toFaceURL: String?
    public var handleResult: OpenIMApplicationStatus?
    public var reqMsg: String?
    public var createTime: Int64?
    public var handlerUserID: String?
    public var handleMsg: String?
    public var handleTime: Int64?
    public var ex: String?

    public init(
        fromUserID: String? = nil,
        fromNickname: String? = nil,
        fromFaceURL: String? = nil,
        toUserID: String? = nil,
        toNickname: String? = nil,
        toFaceURL: String? = nil,
        handleResult: OpenIMApplicationStatus? = nil,
        reqMsg: String? = nil,
        createTime: Int64? = nil,
        handlerUserID: String? = nil,
        handleMsg: String? = nil,
        handleTime: Int64? = nil,
        ex: String? = nil
    ) {
        self.fromUserID = fromUserID
        self.fromNickname = fromNickname
        self.fromFaceURL = fromFaceURL
        self.toUserID = toUserID
        self.toNickname = toNickname
        self.toFaceURL = toFaceURL
        self.handleResult = handleResult
        self.reqMsg = reqMsg
        self.createTime = createTime
        self.handlerUserID = handlerUserID
        self.handleMsg = handleMsg
        self.handleTime = handleTime
        self.ex = ex
    }
}

/// Search result item for friend searches.
public struct OpenIMSearchFriendsInfo: Codable, Equatable, Sendable {
    public var ownerUserID: String?
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var remark: String?
    public var createTime: Int64?
    public var addSource: Int?
    public var operatorUserID: String?
    public var ex: String?
    public var attachedInfo: String?
    public var relationship: OpenIMRelationship?

    public init(
        ownerUserID: String? = nil,
        userID: String? = nil,
        nickname: String? = nil,
        faceURL: String? = nil,
        remark: String? = nil,
        createTime: Int64? = nil,
        addSource: Int? = nil,
        operatorUserID: String? = nil,
        ex: String? = nil,
        attachedInfo: String? = nil,
        relationship: OpenIMRelationship? = nil
    ) {
        self.ownerUserID = ownerUserID
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.remark = remark
        self.createTime = createTime
        self.addSource = addSource
        self.operatorUserID = operatorUserID
        self.ex = ex
        self.attachedInfo = attachedInfo
        self.relationship = relationship
    }
}

/// Request parameters for searching friends.
public struct OpenIMSearchFriendsParam: Codable, Equatable, Sendable {
    public var keywordList: [String]
    public var isSearchUserID: Bool
    public var isSearchNickname: Bool
    public var isSearchRemark: Bool

    public init(
        keywordList: [String],
        isSearchUserID: Bool = false,
        isSearchNickname: Bool = false,
        isSearchRemark: Bool = false
    ) {
        self.keywordList = keywordList
        self.isSearchUserID = isSearchUserID
        self.isSearchNickname = isSearchNickname
        self.isSearchRemark = isSearchRemark
    }
}

/// Friend check result item.
public struct OpenIMFriendCheckResult: Codable, Equatable, Sendable {
    public var userID: String?
    public var result: Int?

    public init(userID: String? = nil, result: Int? = nil) {
        self.userID = userID
        self.result = result
    }
}
