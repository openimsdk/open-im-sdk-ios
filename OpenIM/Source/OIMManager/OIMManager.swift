//
//  OIMManager.swift
//  OpenIM
//
//  Created by Snow on 2021/6/10.
//

import Foundation
import OpenIMCore

public protocol OIMSDKListener: AnyObject {
    func onConnectFailed(_ error: Error)
    func onConnectSuccess()
    func onConnecting()
    func onKickedOffline()
    func onSelfInfoUpdated(_ userInfo: OIMUserInfo)
    func onUserTokenExpired()
}

public class OIMManager: NSObject {
    static let shared = OIMManager()
    private override init() {
        super.init()
    }
    
    public static var cachePath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/cn.rentsoft.openIM/"
    }
    
    private func initSDK() {
        let dbPath = OIMManager.cachePath
        struct Config: Encodable {
            let platform = 1
            let ipApi = "http://47.112.160.66:10000"
            let ipWs = "47.112.160.66:17778"
            let dbDir: String
        }
        
        try? FileManager.default.createDirectory(atPath: dbPath, withIntermediateDirectories: true, attributes: nil)
        
        let config = Config(dbDir: dbPath)
        Open_im_sdkInitSDK(config.toString(), self)
        Open_im_sdkSetFriendListener(self)
        Open_im_sdkSetConversationListener(self)
        Open_im_sdkAddAdvancedMsgListener(self)
    }
    
    public static func initSDK() {
        shared.initSDK()
    }
    
    struct WeakRef<T: AnyObject> {
        weak var value: T?
    }
    
    internal weak var sdkListener: OIMSDKListener?
    internal weak var friendshipListener: OIMFriendshipListener?
    internal weak var conversationListener: OIMConversationListener?
    internal var advancedMsgListeners: [WeakRef<AnyObject>] = []
    
    internal func decodeModel<ModelType: Decodable>(_ str: String?) -> ModelType {
        let data = (str ?? "").data(using: .utf8)!
        return try! JSONDecoder().decode(ModelType.self, from: data)
    }
    
    internal static func decodeModel<ModelType: Decodable>(_ str: String?) -> ModelType {
        let data = (str ?? "").data(using: .utf8)!
        return try! JSONDecoder().decode(ModelType.self, from: data)
    }
}

// MARK: - Login & Logout

extension OIMManager {
    public private(set) static var uid = ""
    
    public static func login(uid: String, token: String, callback: ((Result<Void, Error>) -> Void)? = nil) {
        if self.uid != "" {
            if self.uid == uid {
                return
            }
            logout()
        }
        Open_im_sdkLogin(uid, token, CallbackProxy<Void>({ result in
            if case .success(_) = result {
                self.uid = uid
            }
            callback?(result)
        }))
    }
    
    public static func logout(_ callback: ((Result<Void, Error>) -> Void)? = nil) {
        self.uid = ""
        Open_im_sdkLogout(CallbackProxy(callback))
    }
}


extension OIMManager {
    public enum InfoKey: String, Decodable {
        case name = "name"
        case icon = "icon"
        case gender = "gender"
        case mobile = "mobile"
        case birth = "birth"
        case email = "email"
        case ex = "ex"
    }
    
    public static func setSelfInfo(_ info: [InfoKey: Any], callback: @escaping (Result<Void, Error>) -> Void) {
        assert(info[.gender] == nil || info[.gender] is OIMGender, "gender Must be Gender")
        let info = info.reduce(into: [String: Any]()) { result, args in
            if let gender = args.value as? OIMGender {
                result[args.key.rawValue] = gender.rawValue
            } else {
                assert(args.value is String, "\(args.key.rawValue) Must be String")
                result[args.key.rawValue] = args.value
            }
        }
        let data = try! JSONSerialization.data(withJSONObject: info, options: [])
        let str = String(data: data, encoding: .utf8)
        Open_im_sdkSetSelfInfo(str, CallbackProxy(callback))
    }
    

}

extension OIMManager {
    
    public static func getUsers(uids: [String], callback: @escaping (Result<[OIMUserInfo], Error>) -> Void) {
        struct Param: Encodable {
            let uidList: [String]
        }
        Open_im_sdkGetUsersInfo(Param(uidList: uids).toString(), CallbackArgsProxy<[OIMUserInfo]>({ result in
            switch result {
            case .success(let users):
                getFriendList { result in
                    if case let .success(friends) = result {
                        users.forEach { model in
                            if let first = friends.first(where: { $0 == model }) {
                                model.isFriend = true
                                model.comment = first.comment
                                model.isInBlackList = first.isInBlackList
                            }
                        }
                    }
                    callback(.success(users))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }))
    }
}

extension OIMManager: Open_im_sdkIMSDKListenerProtocol {
    public func onConnectFailed(_ errCode: Int, errMsg: String?) {
        sdkListener?.onConnectFailed(NSError(domain: "", code: errCode, userInfo: [NSLocalizedDescriptionKey: errMsg ?? ""]))
    }
    
    public func onConnectSuccess() {
        sdkListener?.onConnectSuccess()
    }
    
    public func onConnecting() {
        sdkListener?.onConnecting()
    }
    
    public func onKickedOffline() {
        sdkListener?.onKickedOffline()
    }
    
    public func onSelfInfoUpdated(_ userInfo: String?) {
        let model: OIMUserInfo = decodeModel(userInfo)
        sdkListener?.onSelfInfoUpdated(model)
    }
    
    public func onUserTokenExpired() {
        sdkListener?.onUserTokenExpired()
    }
}
