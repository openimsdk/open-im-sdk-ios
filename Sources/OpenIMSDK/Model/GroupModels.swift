import Foundation

/// Base properties describing a group.
public struct OpenIMGroupBaseInfo: Codable, Equatable, Sendable {
    public var groupType: OpenIMGroupType?
    public var groupName: String?
    public var notification: String?
    public var introduction: String?
    public var faceURL: String?
    public var ex: String?
    public var needVerification: OpenIMGroupVerificationType?
    public var lookMemberInfo: OpenIMAllowType?
    public var applyMemberFriend: OpenIMAllowType?

    public init(
        groupType: OpenIMGroupType? = nil,
        groupName: String? = nil,
        notification: String? = nil,
        introduction: String? = nil,
        faceURL: String? = nil,
        ex: String? = nil,
        needVerification: OpenIMGroupVerificationType? = nil,
        lookMemberInfo: OpenIMAllowType? = nil,
        applyMemberFriend: OpenIMAllowType? = nil
    ) {
        self.groupType = groupType
        self.groupName = groupName
        self.notification = notification
        self.introduction = introduction
        self.faceURL = faceURL
        self.ex = ex
        self.needVerification = needVerification
        self.lookMemberInfo = lookMemberInfo
        self.applyMemberFriend = applyMemberFriend
    }
}

/// Parameters for creating a group.
public struct OpenIMGroupCreateInfo: Codable, Equatable, Sendable {
    public var groupInfo: OpenIMGroupBaseInfo
    public var memberUserIDs: [String]
    public var adminUserIDs: [String]
    public var ownerUserID: String?

    public init(
        groupInfo: OpenIMGroupBaseInfo,
        memberUserIDs: [String] = [],
        adminUserIDs: [String] = [],
        ownerUserID: String? = nil
    ) {
        self.groupInfo = groupInfo
        self.memberUserIDs = memberUserIDs
        self.adminUserIDs = adminUserIDs
        self.ownerUserID = ownerUserID
    }
}

/// Full group information.
public struct OpenIMGroupInfo: Codable, Equatable, Sendable {
    public var groupID: String?
    public var groupName: String?
    public var notification: String?
    public var introduction: String?
    public var faceURL: String?
    public var ownerUserID: String?
    public var createTime: Int64?
    public var memberCount: Int?
    public var status: OpenIMGroupStatus?
    public var creatorUserID: String?
    public var groupType: OpenIMGroupType?
    public var needVerification: OpenIMGroupVerificationType?
    public var lookMemberInfo: OpenIMAllowType?
    public var applyMemberFriend: OpenIMAllowType?
    public var notificationUpdateTime: Int64?
    public var notificationUserID: String?
    public var ex: String?

    public init(
        groupID: String? = nil,
        groupName: String? = nil,
        notification: String? = nil,
        introduction: String? = nil,
        faceURL: String? = nil,
        ownerUserID: String? = nil,
        createTime: Int64? = nil,
        memberCount: Int? = nil,
        status: OpenIMGroupStatus? = nil,
        creatorUserID: String? = nil,
        groupType: OpenIMGroupType? = nil,
        needVerification: OpenIMGroupVerificationType? = nil,
        lookMemberInfo: OpenIMAllowType? = nil,
        applyMemberFriend: OpenIMAllowType? = nil,
        notificationUpdateTime: Int64? = nil,
        notificationUserID: String? = nil,
        ex: String? = nil
    ) {
        self.groupID = groupID
        self.groupName = groupName
        self.notification = notification
        self.introduction = introduction
        self.faceURL = faceURL
        self.ownerUserID = ownerUserID
        self.createTime = createTime
        self.memberCount = memberCount
        self.status = status
        self.creatorUserID = creatorUserID
        self.groupType = groupType
        self.needVerification = needVerification
        self.lookMemberInfo = lookMemberInfo
        self.applyMemberFriend = applyMemberFriend
        self.notificationUpdateTime = notificationUpdateTime
        self.notificationUserID = notificationUserID
        self.ex = ex
    }
}

/// Group member information.
public struct OpenIMGroupMemberInfo: Codable, Equatable, Sendable {
    public var groupID: String?
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var roleLevel: OpenIMGroupMemberRole?
    public var joinTime: Int64?
    public var joinSource: OpenIMJoinType?
    public var inviterUserID: String?
    public var operatorUserID: String?
    public var muteEndTime: TimeInterval?
    public var ex: String?

    public init(
        groupID: String? = nil,
        userID: String? = nil,
        nickname: String? = nil,
        faceURL: String? = nil,
        roleLevel: OpenIMGroupMemberRole? = nil,
        joinTime: Int64? = nil,
        joinSource: OpenIMJoinType? = nil,
        inviterUserID: String? = nil,
        operatorUserID: String? = nil,
        muteEndTime: TimeInterval? = nil,
        ex: String? = nil
    ) {
        self.groupID = groupID
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.roleLevel = roleLevel
        self.joinTime = joinTime
        self.joinSource = joinSource
        self.inviterUserID = inviterUserID
        self.operatorUserID = operatorUserID
        self.muteEndTime = muteEndTime
        self.ex = ex
    }
}

/// Group application request details.
public struct OpenIMGroupApplicationInfo: Codable, Equatable, Sendable {
    public var groupID: String?
    public var groupName: String?
    public var notification: String?
    public var introduction: String?
    public var groupFaceURL: String?
    public var createTime: Int64?
    public var status: Int?
    public var creatorUserID: String?
    public var groupType: Int?
    public var ownerUserID: String?
    public var memberCount: Int?
    public var userID: String?
    public var nickname: String?
    public var userFaceURL: String?
    public var handleResult: OpenIMApplicationStatus?
    public var reqMsg: String?
    public var handledMsg: String?
    public var reqTime: Int64?
    public var handleUserID: String?
    public var handledTime: Int64?
    public var ex: String?
    public var inviterUserID: String?
    public var joinSource: OpenIMJoinType?

    public init(
        groupID: String? = nil,
        groupName: String? = nil,
        notification: String? = nil,
        introduction: String? = nil,
        groupFaceURL: String? = nil,
        createTime: Int64? = nil,
        status: Int? = nil,
        creatorUserID: String? = nil,
        groupType: Int? = nil,
        ownerUserID: String? = nil,
        memberCount: Int? = nil,
        userID: String? = nil,
        nickname: String? = nil,
        userFaceURL: String? = nil,
        handleResult: OpenIMApplicationStatus? = nil,
        reqMsg: String? = nil,
        handledMsg: String? = nil,
        reqTime: Int64? = nil,
        handleUserID: String? = nil,
        handledTime: Int64? = nil,
        ex: String? = nil,
        inviterUserID: String? = nil,
        joinSource: OpenIMJoinType? = nil
    ) {
        self.groupID = groupID
        self.groupName = groupName
        self.notification = notification
        self.introduction = introduction
        self.groupFaceURL = groupFaceURL
        self.createTime = createTime
        self.status = status
        self.creatorUserID = creatorUserID
        self.groupType = groupType
        self.ownerUserID = ownerUserID
        self.memberCount = memberCount
        self.userID = userID
        self.nickname = nickname
        self.userFaceURL = userFaceURL
        self.handleResult = handleResult
        self.reqMsg = reqMsg
        self.handledMsg = handledMsg
        self.reqTime = reqTime
        self.handleUserID = handleUserID
        self.handledTime = handledTime
        self.ex = ex
        self.inviterUserID = inviterUserID
        self.joinSource = joinSource
    }
}

/// Parameters for searching groups.
public struct OpenIMSearchGroupParam: Codable, Equatable, Sendable {
    public var keywordList: [String]
    public var isSearchGroupID: Bool
    public var isSearchGroupName: Bool

    public init(
        keywordList: [String],
        isSearchGroupID: Bool = false,
        isSearchGroupName: Bool = false
    ) {
        self.keywordList = keywordList
        self.isSearchGroupID = isSearchGroupID
        self.isSearchGroupName = isSearchGroupName
    }
}

/// Parameters for searching group members.
public struct OpenIMSearchGroupMembersParam: Codable, Equatable, Sendable {
    public var groupID: String
    public var keywordList: [String]
    public var isSearchUserID: Bool
    public var isSearchMemberNickname: Bool
    public var offset: Int
    public var count: Int

    public init(
        groupID: String,
        keywordList: [String],
        isSearchUserID: Bool = false,
        isSearchMemberNickname: Bool = false,
        offset: Int = 0,
        count: Int = 40
    ) {
        self.groupID = groupID
        self.keywordList = keywordList
        self.isSearchUserID = isSearchUserID
        self.isSearchMemberNickname = isSearchMemberNickname
        self.offset = offset
        self.count = count
    }
}
