import Foundation

/// Personal user information.
public struct OpenIMUserInfo: Codable, Equatable, Sendable {
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var createTime: Int64?
    public var ex: String?
    public var attachedInfo: String?
    public var globalRecvMsgOpt: OpenIMReceiveMessageOpt?

    public init(
        userID: String? = nil,
        nickname: String? = nil,
        faceURL: String? = nil,
        createTime: Int64? = nil,
        ex: String? = nil,
        attachedInfo: String? = nil,
        globalRecvMsgOpt: OpenIMReceiveMessageOpt? = nil
    ) {
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.createTime = createTime
        self.ex = ex
        self.attachedInfo = attachedInfo
        self.globalRecvMsgOpt = globalRecvMsgOpt
    }
}

/// Public user information, excluding private fields.
public struct OpenIMPublicUserInfo: Codable, Equatable, Sendable {
    public var userID: String?
    public var nickname: String?
    public var faceURL: String?
    public var ex: String?

    public init(
        userID: String? = nil,
        nickname: String? = nil,
        faceURL: String? = nil,
        ex: String? = nil
    ) {
        self.userID = userID
        self.nickname = nickname
        self.faceURL = faceURL
        self.ex = ex
    }
}

/// User online status information.
public struct OpenIMUserStatusInfo: Codable, Equatable, Sendable {
    public var userID: String?
    public var platformIDs: [Int]?
    public var status: Int?

    public init(
        userID: String? = nil,
        platformIDs: [Int]? = nil,
        status: Int? = nil
    ) {
        self.userID = userID
        self.platformIDs = platformIDs
        self.status = status
    }
}
