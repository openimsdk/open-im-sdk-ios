//
//  OIMManager+Friendship.swift
//  OpenIM
//
//  Created by Snow on 2021/6/15.
//

import Foundation
import OpenIMCore

public protocol OIMFriendshipListener: AnyObject {
    func onFriendApplicationListAdded(_ user: OIMUser)
    func onFriendApplicationListDeleted(_ uid: String)
    func onFriendApplicationListRead()
    func onFriendApplicationListReject(_ uid: String)
    func onFriendApplicationListAccept(_ user: OIMUser)
    func onFriendListAdded()
    func onFriendListDeleted(_ uid: String)
    func onBlackListAdded(_ user: OIMUser)
    func onBlackListDeleted(_ uid: String)
    func onFriendProfileChanged(_ user: OIMUser)
}

extension OIMManager {
    
    public static func setFriendListener(_ listener: OIMFriendshipListener) {
        shared.friendshipListener = listener
    }
    
    // MARK: - Friend
    
    public static func checkFriend(uids: [String], callback: @escaping (Result<[OIMCheckFriend], Error>) -> Void) {
        Open_im_sdkCheckFriend(CallbackArgsProxy(callback), uids.toJson())
    }
    
    public static func getFriendList(_ callback: @escaping (Result<[OIMUser], Error>) -> Void) {
        Open_im_sdkGetFriendList(CallbackArgsProxy(callback))
    }
    
    public static func getFriendsInfo(_ uids: [String], callback: @escaping (Result<[OIMUser], Error>) -> Void) {
        Open_im_sdkGetFriendsInfo(CallbackArgsProxy(callback), uids.toJson())
    }
    
    public static func setFriendInfo(_ uid: String, comment: String, callback: @escaping (Result<Void, Error>) -> Void) {
        struct Param: Encodable {
            let uid: String
            let comment: String
        }
        Open_im_sdkSetFriendInfo(Param(uid: uid, comment: comment).toJson(), CallbackProxy(callback))
    }
    
    public static func addFriend(_ param: OIMFriendAddApplication, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkAddFriend(CallbackProxy(callback), param.toJson())
    }
    
    public static func deleteFromFriendList(_ uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkDeleteFromFriendList(uid.toJson(), CallbackProxy(callback))
    }
     
    // MARK: - FriendApplication
    
    public static func getFriendApplicationList(_ callback: @escaping (Result<[OIMFriendApplicationModel], Error>) -> Void) {
        Open_im_sdkGetFriendApplicationList(CallbackArgsProxy(callback))
    }
    
    public static func acceptFriendApplication(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkAcceptFriendApplication(CallbackProxy(callback), uid.toJson())
    }
    
    public static func refuseFriendApplication(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkRefuseFriendApplication(CallbackProxy(callback), uid.toJson())
    }
    
    // deleteFriendApplication
    // setFriendApplicationRead
    
    // MARK: - BlackList
    
    public static func getBlackList(_ callback: @escaping (Result<[OIMUser], Error>) -> Void) {
        Open_im_sdkGetBlackList(CallbackArgsProxy(callback))
    }
    
    public static func addToBlackList(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkAddToBlackList(CallbackProxy(callback), uid.toJson())
    }
    
    public static func deleteFromBlackList(uid: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkDeleteFromBlackList(CallbackProxy(callback), uid.toJson())
    }
    
}

public class OIMFriendAddApplication: NSObject, Encodable {
    public var uid: String
    public var reqMessage: String
    
    public init(uid: String, reqMessage: String) {
        self.uid = uid
        self.reqMessage = reqMessage
        super.init()
    }
}

// MARK: - Open_im_sdkOnFriendshipListenerProtocol

extension OIMManager: Open_im_sdkOnFriendshipListenerProtocol {
    
    public func onBlackListAdd(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onBlackListAdded(model)
        }
    }
    
    public func onBlackListDeleted(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onBlackListDeleted(model.uid)
        }
    }
    
    public func onFriendApplicationListAccept(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onFriendApplicationListAccept(model)
        }
    }
    
    public func onFriendApplicationListAdded(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onFriendApplicationListAdded(model)
        }
    }
    
    public func onFriendApplicationListDeleted(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onFriendApplicationListDeleted(model.uid)
        }
    }
    
    public func onFriendApplicationListReject(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onFriendApplicationListReject(model.uid)
        }
    }
    
    public func onFriendListAdded(_ info: String?) {
        self.friendshipListener?.onFriendListAdded()
    }
    
    public func onFriendInfoChanged(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onFriendProfileChanged(model)
        }
    }
    
    public func onFriendListAdded() {
        self.friendshipListener?.onFriendListAdded()
    }
    
    public func onFriendListDeleted(_ info: String?) {
        if let model: OIMUser = decodeModel(info) {
            self.friendshipListener?.onFriendListDeleted(model.uid)
        }
    }
}
