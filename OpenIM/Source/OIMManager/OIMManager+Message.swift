//
//  OIMManager+Message.swift
//  OpenIM
//
//  Created by Snow on 2021/6/15.
//

import Foundation
import OpenIMCore

public struct OIMPicture: Codable {
    public var uuid: String = ""
    public var type: String = ""
    public var size: Int = 0
    public var width: Int = .zero
    public var height: Int = .zero
    public var url: String = ""
}

public struct OIMPictureElem: Codable {
    public var sourcePath: String = ""
    public var sourcePicture = OIMPicture()
    public var bigPicture = OIMPicture()
    public var snapshotPicture = OIMPicture()
}

public struct OIMSoundElem: Codable {
    public var soundPath: String = ""
    public var sourceUrl: String = ""
    public var duration: Int = .zero
}

public struct OIMVideoElem: Codable {
    public var videoPath: String = ""
    public var videoUUID: String = ""
    public var videoUrl: String = ""
    public var videoType: String = ""
    public var videoSize: Int = 0
    public var duration: TimeInterval = 0
    public var snapshotPath: String = ""
    public var snapshotUUID: String = ""
    public var snapshotSize: Int = 0
    public var snapshotUrl: String = ""
    public var snapshotWidth: Int = .zero
    public var snapshotHeight: Int = .zero
}

public struct OIMFileElem: Codable {
    public var filePath: String = ""
    public var sourceUrl: String = ""
    public var fileName: String = ""
    public var fileSize: Int = 0
}

public struct OIMAtElem: Codable {
    public var text: String = ""
    public var atUserList: [String] = []
    public var isAtSelf: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case text, atUserList, isAtSelf
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        atUserList = (try? container.decode([String].self, forKey: .atUserList)) ?? []
        isAtSelf = try container.decode(Bool.self, forKey: .isAtSelf)
    }
}

public struct OIMSystemElem: Codable {
    public let isDisplay: Int
    public let id: String
    public let text: String
}

public struct OIMMessage: Codable {
    public struct ContentType: OptionSet, Codable {
        public var rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let text = ContentType(rawValue: 101)
        public static let image = ContentType(rawValue: 102)
        public static let audio = ContentType(rawValue: 103)
        public static let video = ContentType(rawValue: 104)
        public static let atText = ContentType(rawValue: 106)
    }
    
    public enum Status: Int, Codable {
        case none = 0
        case sending = 1
        case success = 2
        case failure = 3
    }
    
    public var clientMsgID: String = ""
    public var serverMsgID: String = ""
    public var createTime: TimeInterval = .zero
    public var sendTime: TimeInterval = .zero
    public var sendID: String = ""
    public var recvID: String = ""
    let platformID: Int
    public var msgFrom: Int = 0
    public var contentType: ContentType = .text
    public var content: String = ""
    
    public var forceList: [String]?
    
    public var senderNickName: String = ""
    public var senderFaceUrl: String = ""
    public var groupID: String = ""
    let seq: Int64
    public var isRead = false
    public var status = Status.none
    public var remark: String = ""
    
    public let atElem: OIMAtElem
    public let pictureElem: OIMPictureElem
    public let soundElem: OIMSoundElem
    public let videoElem: OIMVideoElem
    public let fileElem: OIMFileElem
    
    public func getName() -> String {
        if remark != "" {
            return remark
        }
        return senderNickName
    }
}

public protocol OIMAdvancedMsgListener: AnyObject {
    func onRecvNewMessage(_ message: OIMMessage)
}

extension OIMManager: Open_im_sdkOnAdvancedMsgListenerProtocol {
    public func onRecvNewMessage(_ msg: String?) {
        guard let message: OIMMessage = decodeModel(msg) else { return }
        DispatchQueue.main.async {
            self.advancedMsgListeners.forEach { ref in
                if let listener = ref.value as? OIMAdvancedMsgListener {
                    listener.onRecvNewMessage(message)
                }
            }
        }
    }
    
    public func onRecvC2CReadReceipt(_ msgReceiptList: String?) {
        
    }
    
    public func onRecvMessageRevoked(_ msgId: String?) {
        
    }
    
    public static func addAdvancedMsgListener(_ listener: OIMAdvancedMsgListener) {
        shared.advancedMsgListeners.append(WeakRef(value: listener))
    }
    
    public static func removeAdvancedMsgListener(_ listener: OIMAdvancedMsgListener) {
        shared.advancedMsgListeners.removeAll { ref in
            return ref.value == nil || ref.value === listener
        }
    }
}

extension OIMManager {
    public static func deleteMessageFromLocalStorage(_ messages: [OIMMessage], callback: @escaping (Result<Void, Error>) -> Void) {
        Open_im_sdkDeleteMessageFromLocalStorage(CallbackProxy(callback), messages.toJson())
    }
    
    public static func createTextMessage(_ text: String, at uids: [String] = []) -> OIMMessage {
        let str = uids.isEmpty
            ? Open_im_sdkCreateTextMessage(text)
            : Open_im_sdkCreateTextAtMessage(text, uids.toJson())
        
        let message: OIMMessage = decodeModel(str)
        return message
    }
    
    public static func createImageMessage(_ path: String) -> OIMMessage {
        let path = path.replacingOccurrences(of: OIMManager.cachePath, with: "")
        let str = Open_im_sdkCreateImageMessage(path)
        let message: OIMMessage = decodeModel(str)
        return message
    }
    
    public static func createSoundMessage(_ path: String, duration: Int) -> OIMMessage {
        let path = path.replacingOccurrences(of: OIMManager.cachePath, with: "")
        let str = Open_im_sdkCreateSoundMessage(path, Int64(duration))
        let message: OIMMessage = decodeModel(str)
        return message
    }
    
    public static func createVideoMessage(_ videoPath: String,
                                          videoType: String,
                                          duration: Int,
                                          snapshotPath: String) -> OIMMessage {
        let str = Open_im_sdkCreateVideoMessage(
            videoPath.replacingOccurrences(of: OIMManager.cachePath, with: ""),
            videoType,
            Int64(duration),
            snapshotPath.replacingOccurrences(of: OIMManager.cachePath, with: "")
        )
        let message: OIMMessage = decodeModel(str)
        return message
    }
    
    public static func createFileMessage(_ path: String, filename: String) -> OIMMessage {
        let path = path.replacingOccurrences(of: OIMManager.cachePath, with: "")
        let str = Open_im_sdkCreateFileMessage(path, filename)
        let message: OIMMessage = decodeModel(str)
        return message
    }
    
    public static func sendMessage(_ message: OIMMessage,
                                   receiver: String? = nil,
                                   groupID: String? = nil,
                                   onlineUserOnly: Bool = false,
                                   progress: @escaping (Int) -> Void,
                                   callback: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            Open_im_sdkSendMessage(ProgressCallbackProxy(progress, callback: callback),
                                   message.toJson(),
                                   receiver,
                                   groupID,
                                   onlineUserOnly)
        }
    }
    
    public static func getHistoryMessageList(uid: String = "",
                                             groupID: String = "",
                                             firstMsg: OIMMessage?,
                                             count: Int = 50,
                                             callback: @escaping (Result<[OIMMessage], Error>) -> Void) {
        struct Param: Encodable {
            let userID: String
            let groupID: String
            let startMsg: OIMMessage?
            let count: Int
        }
        let param = Param(userID: uid, groupID: groupID, startMsg: firstMsg, count: count)
        Open_im_sdkGetHistoryMessageList(CallbackArgsProxy(callback), param.toJson())
    }
    
    public static func markMessageHasRead(uid: String = "", gid: String = "", callback: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        if gid.isEmpty {
            Open_im_sdkMarkSingleMessageHasRead(CallbackProxy(callback), uid)
        } else {
            Open_im_sdkMarkGroupMessageHasRead(CallbackProxy(callback), gid)
        }
    }

}
