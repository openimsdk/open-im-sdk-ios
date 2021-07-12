//
//  OIMManager+Group.swift
//  OpenIM
//
//  Created by Snow on 2021/7/5.
//

import Foundation
import OpenIMCore

public protocol OIMGroupListener: AnyObject {
    func onApplicationProcessed(_ groupId: String, opUser: OIMGroupMember, agreeOrReject AgreeOrReject: Int32, opReason: String)
    func onGroupCreated(_ groupId: String)
    func onGroupInfoChanged(_ groupId: String, groupInfo: OIMGroupInfo)
    func onMemberEnter(_ groupId: String, memberList: [OIMGroupMember])
    func onMemberInvited(_ groupId: String, opUser: OIMGroupMember, memberList: [OIMGroupMember])
    func onMemberKicked(_ groupId: String, opUser: OIMGroupMember, memberList: [OIMGroupMember])
    func onMemberLeave(_ groupId: String, member:OIMGroupMember)
    func onReceiveJoinApplication(_ groupId: String, member: OIMGroupMember, opReason: String)
}

public struct OIMGroupInfoParam: Encodable {
    public let groupID: String?
    public let groupName: String
    public let notification: String
    public let introduction: String
    public let faceUrl: String
    public init(groupInfo: OIMGroupInfo? = nil,
                groupID: String? = nil,
                groupName: String? = nil,
                notification: String? = nil,
                introduction: String? = nil,
                faceUrl: String? = nil) {
        self.groupID = groupID ?? groupInfo?.groupID
        self.groupName = groupName ?? groupInfo?.groupName ?? ""
        self.notification = notification ?? groupInfo?.notification ?? ""
        self.introduction = introduction ?? groupInfo?.introduction ?? ""
        self.faceUrl = faceUrl ?? groupInfo?.faceUrl ?? ""
    }
}

public struct OIMGroupInfo: Decodable {
    public let groupID: String
    public var groupName: String
    public var notification: String
    public var introduction: String
    public var faceUrl: String
    public let ownerId: String
    public let createTime: TimeInterval
    public let memberCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case groupID, groupName, notification, introduction, faceUrl, ownerId, createTime, memberCount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        groupID = try container.decode(String.self, forKey: .groupID)
        groupName = try container.decode(String.self, forKey: .groupName)
        notification = try container.decode(String.self, forKey: .notification)
        introduction = try container.decode(String.self, forKey: .introduction)
        faceUrl = try container.decode(String.self, forKey: .faceUrl)
        ownerId = (try? container.decode(String.self, forKey: .ownerId)) ?? ""
        createTime = (try? container.decode(TimeInterval.self, forKey: .createTime)) ?? 0
        memberCount = (try? container.decode(Int.self, forKey: .memberCount)) ?? 0
    }
}

public struct OIMGroupMember: Decodable, Equatable {
    public let groupID: String
    public let userId: String
    public let role: OIMGroupRole
    public let joinTime: TimeInterval
    public let nickName: String
    public let faceUrl: String
    
    public func getName() -> String {
        return nickName.isEmpty ? userId : nickName
    }
    
    public static func == (lhs: OIMGroupMember, rhs: OIMGroupMember) -> Bool {
        return lhs.groupID == rhs.groupID && lhs.userId == rhs.userId
    }
}

public enum OIMGroupRole: Int32, Codable {
    case general = 0
    case owner = 1
    case admin = 2
}

public class OIMGroupApplication: Codable {
    public enum `Type`: Int, Codable {
        case application = 0,
             invite = 1
    }
    
    public enum Flag: Int, Codable {
        case none = 0,
             agree = 1,
             refuse = -1
    }
    
    public var id: String
    public var groupID: String
    public var fromUserID: String
    public var toUserID: String
    public var flag: Flag
    public var reqMsg: String
    public var handledMsg: String
    public var createTime: TimeInterval
    public var fromUserNickName: String
    public var toUserNickName: String
    public var fromUserFaceURL: String
    public var toUserFaceURL: String
    public var handledUser: String
    public var type: `Type`
    public var handleStatus: Int
    public var handleResult: Int
}

extension OIMManager {
    
    public static func joinGroup(gid: String, reason: String, uids: [String], callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkInviteUserToGroup(gid, reason, uids.toJson(), CallbackProxy(callback))
    }
    
    public static func inviteUserToGroup(gid: String, reason: String, uids: [String], callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkInviteUserToGroup(gid, reason, uids.toJson(), CallbackProxy(callback))
    }
    
    public static func kickGroupMember(gid: String, reason: String, uids: [String], callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkKickGroupMember(gid, reason, uids.toJson(), CallbackProxy(callback))
    }
    
    public static func getGroupMembersInfo(gid: String, uids: [String], callback: @escaping (Result<[OIMGroupMember], Error>) -> Void) {
        Open_im_sdkGetGroupMembersInfo(gid, uids.toJson(), CallbackArgsProxy(callback))
    }
    
    public enum GroupFilter: Int32 {
        case all = 0
        case owner = 1
        case administrator = 2
    }
    
    public struct GroupMemberListResult: Decodable {
        public let nextSeq: Int
        public let data: [OIMGroupMember]
    }
    
    public static func getGroupMemberList(gid: String, filter: GroupFilter, next: Int32, callback: @escaping (Result<GroupMemberListResult, Error>) -> Void) {
        Open_im_sdkGetGroupMemberList(gid, filter.rawValue, next, CallbackArgsProxy(callback))
    }
    
    public static func getJoinedGroupList(callback: @escaping (Result<[OIMGroupInfo], Error>) -> Void) {
        Open_im_sdkGetJoinedGroupList(CallbackArgsProxy(callback))
    }
    
    public static func createGroup(_ groupInfo: OIMGroupInfoParam, uids: [String], callback: @escaping (Result<String, Error>) -> Void) {
        struct MemberRole: Encodable {
            let uid: String
            let setRole: OIMGroupRole
        }
        
        let roles = uids.map{ MemberRole(uid: $0, setRole: .general) }
        Open_im_sdkCreateGroup(groupInfo.toJson(), roles.toJson(), CallbackProxy(callback))
    }
    
    public static func setGroupInfo(_ groupInfo: OIMGroupInfoParam, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkSetGroupInfo(groupInfo.toJson(), CallbackProxy(callback))
    }
    
    public static func getGroupsInfo(gids: [String], callback: @escaping (Result<[OIMGroupInfo], Error>) -> Void) {
        Open_im_sdkGetGroupsInfo(gids.toJson(), CallbackArgsProxy(callback))
    }
    
    public static func joinGroup(gid: String, message: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkJoinGroup(gid, message, CallbackProxy(callback))
    }
    
    public static func quitGroup(gid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkQuitGroup(gid, CallbackProxy(callback))
    }
    
    public static func transferGroupOwner(gid: String, uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkTransferGroupOwner(gid, uid, CallbackProxy(callback))
    }
    
    public static func getGroupApplicationList(callback: @escaping (Result<[OIMGroupApplication], Error>) -> Void) {
        struct Result: Decodable {
            let count: Int
            let user: [OIMGroupApplication]
        }
        Open_im_sdkGetGroupApplicationList(CallbackArgsProxy<Result>({ result in
            switch result {
            case .success(let result):
                callback(.success(result.user))
            case .failure(let err):
                callback(.failure(err))
            }
        }))
    }
    
    public static func acceptGroupApplication(_ application: OIMGroupApplication, reason: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkAcceptGroupApplication(application.toJson(), reason, CallbackProxy(callback))
    }
    
    public static func refuseGroupApplication(_ application: OIMGroupApplication, reason: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkRefuseGroupApplication(application.toJson(), reason, CallbackProxy(callback))
    }
}


// MARK: - Open_im_sdkOnGroupListenerProtocol

extension OIMManager: Open_im_sdkOnGroupListenerProtocol {
    public func onApplicationProcessed(_ groupId: String?, opUser: String?, agreeOrReject AgreeOrReject: Int32, opReason: String?) {
        guard let groupId = groupId,
              let user: OIMGroupMember = decodeModel(opUser) else {
            return
        }
        groupListener?.onApplicationProcessed(groupId, opUser: user, agreeOrReject: AgreeOrReject, opReason: opReason ?? "")
    }
    
    public func onGroupCreated(_ groupId: String?) {
        guard let groupId = groupId else {
            return
        }
        groupListener?.onGroupCreated(groupId)
    }
    
    public func onGroupInfoChanged(_ groupId: String?, groupInfo: String?) {
        guard let groupId = groupId,
              let groupInfo: OIMGroupInfo = decodeModel(groupInfo) else {
            return
        }
        groupListener?.onGroupInfoChanged(groupId, groupInfo: groupInfo)
    }
    
    public func onMemberEnter(_ groupId: String?, memberList: String?) {
        guard let groupId = groupId,
              let members: [OIMGroupMember] = decodeModel(memberList) else {
            return
        }
        groupListener?.onMemberEnter(groupId, memberList: members)
    }
    
    public func onMemberInvited(_ groupId: String?, opUser: String?, memberList: String?) {
        guard let groupId = groupId,
              let user: OIMGroupMember = decodeModel(opUser),
              let members: [OIMGroupMember] = decodeModel(memberList) else {
            return
        }
        groupListener?.onMemberInvited(groupId, opUser: user, memberList: members)
    }
    
    public func onMemberKicked(_ groupId: String?, opUser: String?, memberList: String?) {
        guard let groupId = groupId,
              let user: OIMGroupMember = decodeModel(opUser),
              let members: [OIMGroupMember] = decodeModel(memberList) else {
            return
        }
        groupListener?.onMemberKicked(groupId, opUser: user, memberList: members)
    }
    
    public func onMemberLeave(_ groupId: String?, member: String?) {
        guard let groupId = groupId,
              let member: OIMGroupMember = decodeModel(member) else {
            return
        }
        groupListener?.onMemberLeave(groupId, member: member)
    }
    
    public func onReceiveJoinApplication(_ groupId: String?, member: String?, opReason: String?) {
        guard let groupId = groupId,
              let member: OIMGroupMember = decodeModel(member) else {
            return
        }
        groupListener?.onReceiveJoinApplication(groupId, member: member, opReason: opReason ?? "")
    }
}
