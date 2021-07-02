//
//  OUIKit.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/15.
//

import Foundation
import OpenIM

public protocol OUIKitMessageDelegate: AnyObject {
    func showMessage(_ text: String)
    func showError(_ error: Error)
    func showError(_ text: String)
}

public class OUIKit: NSObject {
    public static let shared = OUIKit()
    private override init() {
        super.init()
    }
    
    public weak var messageDelegate: OUIKitMessageDelegate?
    
    public func initSDK() {
        OIMManager.initSDK()
        OIMManager.setConversationListener(self)
        OIMManager.setFriendListener(self)
    }
    
    private var users: [String: OIMUserInfo] = [:]
    
    internal func update(user: OIMUserInfo) {
        self.users[user.uid] = user
    }
    
    private var requestUids: Set<String> = []
    
    public func hasUser(_ uid: String) -> Bool {
        return users[uid] != nil
    }
    
    @discardableResult
    public func getUser(_ uid: String, isForce: Bool = false, callback: ((OIMUserInfo?) -> Void)? = nil) -> OIMUserInfo? {
        let user = users[uid]
        if !isForce, let user = users[uid] {
            return user
        }
        
        if isForce || !requestUids.contains(uid) {
            requestUids.insert(uid)
            
            OIMManager.getUsers(uids: [uid]) { result in
                self.requestUids.remove(uid)
                if case let .success(array) = result, let user = array.first {
                    self.users[user.uid] = user
                    callback?(user)
                } else {
                    callback?(nil)
                }
            }
        }
        return user
    }
    
    public func getUsers(_ uids: [String], callback: ((Result<[OIMUserInfo], Error>) -> Void)? = nil ) {
        OIMManager.getUsers(uids: uids) { result in
            if case let .success(array) = result {
                array.forEach { user in
                    self.users[user.uid] = user
                }
            }
            callback?(result)
        }
    }
}

extension OUIKit: OIMConversationListener {
    
    public static let onConversationChangedNotification = NSNotification.Name("OUIKit.onConversationChangedNotification")
    
    public func onConversationChanged(_ conversations: [OIMConversation]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onConversationChangedNotification, object: conversations)
        }
    }
    
    public static let onNewConversationNotification = NSNotification.Name("OUIKit.onNewConversationNotification")
    
    public func onNewConversation(_ conversations: [OIMConversation]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onNewConversationNotification, object: conversations)
        }
    }
    
    public static let onSyncServerFailedNotification = NSNotification.Name("OUIKit.onSyncServerFailedNotification")
    
    public func onSyncServerFailed() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onSyncServerFailedNotification, object: nil)
        }
    }
    
    public static let onSyncServerFinishNotification = NSNotification.Name("OUIKit.onSyncServerFinishNotification")
    
    public func onSyncServerFinish() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onSyncServerFinishNotification, object: nil)
        }
    }
    
    public static let onSyncServerStartNotification = NSNotification.Name("OUIKit.onSyncServerStartNotification")
    
    public func onSyncServerStart() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onSyncServerStartNotification, object: nil)
        }
    }
    
    public static let onTotalUnreadMessageCountChangedNotification = NSNotification.Name("OUIKit.onTotalUnreadMessageCountChangedNotification")
    
    public func onTotalUnreadMessageCountChanged(_ count: Int32) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onTotalUnreadMessageCountChangedNotification, object: count)
        }
    }
}

extension OUIKit: OIMFriendshipListener {
    
    public static let onFriendApplicationListAddedNotification = NSNotification.Name("OUIKit.onFriendApplicationListAddedNotification")
    
    public func onFriendApplicationListAdded(_ user: OIMUserInfo) {
        self.update(user: user)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendApplicationListAddedNotification, object: user)
        }
    }
    
    public static let onFriendApplicationListDeletedNotification = NSNotification.Name("OUIKit.onFriendApplicationListDeletedNotification")
    
    public func onFriendApplicationListDeleted(_ uid: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendApplicationListDeletedNotification, object: uid)
        }
    }
    
    public static let onFriendApplicationListReadNotification = NSNotification.Name("OUIKit.onFriendApplicationListReadNotification")
    
    public func onFriendApplicationListRead() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendApplicationListReadNotification, object: nil)
        }
    }
    
    public static let onFriendApplicationListRejectNotification = NSNotification.Name("OUIKit.onFriendApplicationListRejectNotification")
    
    public func onFriendApplicationListReject(_ uid: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendApplicationListReadNotification, object: uid)
        }
    }
    
    public static let onFriendApplicationListAcceptNotification = NSNotification.Name("OUIKit.onFriendApplicationListAcceptNotification")
    
    public func onFriendApplicationListAccept(_ user: OIMUserInfo) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendApplicationListAcceptNotification, object: user)
        }
    }
    
    public static let onFriendListAddedNotification = NSNotification.Name("OUIKit.onFriendListAddedNotification")
    
    public func onFriendListAdded() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendListAddedNotification, object: nil)
        }
    }
    
    public static let onFriendListDeletedNotification = NSNotification.Name("OUIKit.onFriendListDeletedNotification")
    
    public func onFriendListDeleted(_ uid: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendListDeletedNotification, object: uid)
        }
    }
    
    public static let onBlackListAddedNotification = NSNotification.Name("OUIKit.onBlackListAddedNotification")
    
    public func onBlackListAdded(_ user: OIMUserInfo) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onBlackListAddedNotification, object: user)
        }
    }
    
    public static let onBlackListDeletedNotification = NSNotification.Name("OUIKit.onBlackListDeletedNotification")
    
    public func onBlackListDeleted(_ uid: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onBlackListDeletedNotification, object: uid)
        }
    }
    
    public static let onFriendProfileChangedNotification = NSNotification.Name("OUIKit.onFriendProfileChangedNotification")
    
    public func onFriendProfileChanged(_ user: OIMUserInfo) {
        update(user: user)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: OUIKit.onFriendProfileChangedNotification, object: user)
        }
    }
    
    
}
