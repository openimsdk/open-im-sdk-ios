//
//  OIMManager+Group.swift
//  OpenIM
//
//  Created by Snow on 2021/7/5.
//

import Foundation
import OpenIMCore

public struct OIMGroupInfoParam: Encodable {
    public let groupID: String?
    public let groupName: String
    public let notification: String
    public let introduction: String
    public let faceUrl: String
    public init(groupID: String? = nil, groupName: String, notification: String, introduction: String, faceUrl: String) {
        self.groupID = groupID
        self.groupName = groupName
        self.notification = notification
        self.introduction = introduction
        self.faceUrl = faceUrl
    }
}

public struct OIMGroupInfo: Decodable {
    public let groupID: String
    public let groupName: String
    public let notification: String
    public let introduction: String
    public let faceUrl: String
    public let ownerId: String
    public let createTime: TimeInterval
    public let memberCount: Int
}

public struct OIMGroupMember: Decodable {
    public let groupID: String
    public let userId: String
    public let role: OIMGroupRole
    public let joinTime: TimeInterval
    public let nickName: String
    public let faceUrl: String
}

public enum OIMGroupRole: Int32, Codable {
    case none = 0
    case owner = 1
    case administrator = 2
}

extension OIMManager {
    
    public static func joinGroup(gid: String, reason: String, uids: [String], callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkInviteUserToGroup(gid, reason, uids.toString(), CallbackProxy(callback))
    }
    
    public static func kickGroupMember(gid: String, reason: String, uids: [String], callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkKickGroupMember(gid, reason, uids.toString(), CallbackProxy(callback))
    }
    
    public static func getGroupMembersInfo(gid: String, uids: [String], callback: @escaping (Result<[OIMGroupMember], Error>) -> Void) {
        Open_im_sdkGetGroupsInfo(uids.toString(), CallbackArgsProxy(callback))
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
        
        let roles = uids.map{ MemberRole(uid: $0, setRole: .none) }
        Open_im_sdkCreateGroup(groupInfo.toString(), roles.toString(), CallbackProxy(callback))
    }
    
    public static func setGroupInfo(_ groupInfo: OIMGroupInfoParam, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkSetGroupInfo(groupInfo.toString(), CallbackProxy(callback))
    }
    
    public static func getGroupsInfo(gids: [String], callback: @escaping (Result<[OIMGroupInfo], Error>) -> Void) {
        Open_im_sdkGetGroupsInfo(gids.toString(), CallbackArgsProxy(callback))
    }
    
    public static func joinGroup(gid: String, message: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkJoinGroup(gid, message, CallbackProxy(callback))
    }
    
    public static func quitGroup(gid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkQuitGroup(gid.toString(), CallbackProxy(callback))
    }
    
    public static func transferGroupOwner(gid: String, uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkTransferGroupOwner(gid, uid, CallbackProxy(callback))
    }
}
