//
//  OIMManager+Conversation.swift
//  OpenIM
//
//  Created by Snow on 2021/6/15.
//

import Foundation
import OpenIMCore

public protocol OIMConversationListener: AnyObject {
    func onConversationChanged(_ conversations: [OIMConversation])
    func onNewConversation(_ conversations: [OIMConversation])
    func onSyncServerFailed()
    func onSyncServerFinish()
    func onSyncServerStart()
    func onTotalUnreadMessageCountChanged(_ count: Int32)
}

public class OIMConversation: Codable, Hashable {
    
    public let conversationID: String
    public let conversationType: OIMConversationType
    public let userID: String
    public let groupID: String
    public var showName: String = ""
    public var faceUrl: String = ""
    public var recvMsgOpt: Int = 0
    public var unreadCount: Int = 0
    public var latestMsg: OIMMessage?
    public var latestMsgSendTime: TimeInterval = .zero
    public var draftText: String = ""
    public var draftTimestamp: TimeInterval = .zero
    public var isPinned = false
    
    private enum CodingKeys: String, CodingKey {
         case conversationID, conversationType, userID,
              groupID, showName, faceUrl, recvMsgOpt,
              unreadCount, latestMsg, latestMsgSendTime, draftText,
              draftTimestamp, isPinned
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversationID = try container.decode(String.self, forKey: .conversationID)
        conversationType = try container.decode(OIMConversationType.self, forKey: .conversationType)
        userID = try container.decode(String.self, forKey: .userID)
        groupID = try container.decode(String.self, forKey: .groupID)
        showName = try container.decode(String.self, forKey: .showName)
        faceUrl = try container.decode(String.self, forKey: .faceUrl)
        recvMsgOpt = try container.decode(Int.self, forKey: .recvMsgOpt)
        unreadCount = try container.decode(Int.self, forKey: .unreadCount)
        
        let str = try container.decode(String.self, forKey: .latestMsg)
        let data = str.data(using: .utf8)!
        latestMsg = try? JSONDecoder().decode(OIMMessage.self, from: data)
        
        latestMsgSendTime = try container.decode(TimeInterval.self, forKey: .latestMsgSendTime)
        draftText = try container.decode(String.self, forKey: .draftText)
        draftTimestamp = try container.decode(TimeInterval.self, forKey: .draftTimestamp)
        
        isPinned = (try container.decode(Int.self, forKey: .isPinned)) != 0
    }
    
    public func hash(into hasher: inout Hasher) {
        conversationID.hash(into: &hasher)
        userID.hash(into: &hasher)
        groupID.hash(into: &hasher)
    }
    
    public static func == (lhs: OIMConversation, rhs: OIMConversation) -> Bool {
        return lhs.userID == rhs.userID && lhs.groupID == rhs.groupID
    }
}

extension OIMManager {
    public static func getConversation(type: OIMConversationType,
                                       id: String,
                                       callback: @escaping (Result<OIMConversation, Error>) -> Void) {
        Open_im_sdkGetOneConversation(id, type.rawValue, CallbackArgsProxy(callback));
    }
    
    
    public static func getConversation(type: OIMConversationType,
                                       id: String) -> String {
        return Open_im_sdkGetConversationIDBySessionType(id, type.rawValue)
    }
    
    public static func getConversationList(callback: @escaping (Result<[OIMConversation], Error>) -> Void) {
        Open_im_sdkGetAllConversationList(CallbackArgsProxy(callback))
    }
    
    public static func pinConversation(_ conversationID: String, isPinned: Bool, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkPinConversation(conversationID, isPinned, CallbackProxy(callback))
    }
    
    public static func deleteConversation(_ conversationID: String, callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkDeleteConversation(conversationID, CallbackProxy(callback))
    }
    
    public static func getTotalUnreadMsgCount(callback: @escaping (Result<Int, Error>) -> Void) {
        Open_im_sdkGetTotalUnreadMsgCount(CallbackArgsProxy(callback))
    }
    
    public static func setConversationDraft(_ conversationID: String, draftText: String, callback: ((Result<Void, Error>) -> Void)? = nil) {
        Open_im_sdkSetConversationDraft(conversationID, draftText, CallbackProxy(callback))
    }
    
}

extension OIMManager {
    public static func setConversationListener(_ listener: OIMConversationListener) {
        shared.conversationListener = listener
    }
}

extension OIMManager: Open_im_sdkOnConversationListenerProtocol {
    public func onConversationChanged(_ str: String?) {
        if let array: [OIMConversation] = decodeModel(str) {
            conversationListener?.onConversationChanged(array)
        }
    }
    
    public func onNewConversation(_ str: String?) {
        if let array: [OIMConversation] = decodeModel(str) {
            conversationListener?.onNewConversation(array)
        }
    }
    
    public func onSyncServerFailed() {
        conversationListener?.onSyncServerFailed()
    }
    
    public func onSyncServerFinish() {
        conversationListener?.onSyncServerFinish()
    }
    
    public func onSyncServerStart() {
        conversationListener?.onSyncServerStart()
    }
    
    public func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int32) {
        conversationListener?.onTotalUnreadMessageCountChanged(totalUnreadCount)
    }
}
