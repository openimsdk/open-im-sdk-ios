//
//  ApiUser.swift
//  EEChat
//
//  Created by Snow on 2021/5/18.
//

import Foundation
import OpenIM
import web3swift
import OpenIM

public enum Gender: Int, Codable {
    case unknown = 0
    case male = 1
    case female = 2
}

public class UserInfo: Codable, Hashable {
    public var uid = ""
    public var name = ""
    public var icon: URL?
    public var gender = Gender.unknown
    public var mobile = ""
    public var birth = ""
    public var email = ""
    public var ex = ""
    public var comment = ""
    
    public init() {}
    
    private enum CodingKeys: String, CodingKey {
        case uid, name, icon, gender, mobile, birth, email, ex, comment
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        icon = try? container.decode(URL.self, forKey: .icon)
        gender = try container.decode(Gender.self, forKey: .gender)
        mobile = try container.decode(String.self, forKey: .mobile)
        birth = try container.decode(String.self, forKey: .birth)
        email = try container.decode(String.self, forKey: .email)
        ex = try container.decode(String.self, forKey: .ex)
        if let value = try? container.decode(String.self, forKey: .comment) {
            comment = value
        }
    }
    
    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    public func getName() -> String {
        return comment.isEmpty ? name : comment
    }
}

public struct AuthModel: Codable {
    public var uid = ""
    public var token = ""
    public var expiredTime = TimeInterval.zero
    
    public init() {}
}

struct ApiUserLogin: ApiType {
    let apiTarget: ApiTarget = ApiInfo(path: "user/login")
    
    var param = Param()
    
    init() {}
    
    struct Param: Encodable {
        let platform = 1
        let operationID = OperationID()
        var account = ""
        var password = ""
    }
    
    struct ToeknModel: Codable {
        var accessToken = ""
        var expiredTime = TimeInterval.zero
    }
    
    struct Model: Codable {
        var userInfo = UserInfo()
        var openImToken = AuthModel()
        var token = ToeknModel()
        
        init() {}
        
        private enum CodingKeys: String, CodingKey {
            case userInfo,
                 openImToken,
                 token
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let value = try? container.decode(UserInfo.self, forKey: .userInfo) {
                userInfo = value
            } else {
                userInfo = try UserInfo(from: decoder)
            }
            
            openImToken = try container.decode(AuthModel.self, forKey: .openImToken)
            token = try container.decode(ToeknModel.self, forKey: .token)
        }
    }
    
    static func login(mnemonic: String) {
        MessageModule.showHUD(text: LocalizedString("Generating..."))
        DispatchQueue.global().async {
            let keystore = try? BIP32Keystore(
                    mnemonics: mnemonic,
                    password: "web3swift",
                    mnemonicsPassword: "",
                    language: .english)
            
            DispatchQueue.main.async {
                MessageModule.hideHUD()
                guard let address = keystore?.addresses?.first?.address else {
                    MessageModule.showMessage(LocalizedString("Mnemonic word error."))
                    return
                }
                
                var api = ApiUserLogin()
                api.param.account = address
                api.param.password = "123456"
                _ = api.request(showLoading: true)
                    .map(type: ApiUserLogin.Model.self)
                    .subscribe(onSuccess: { model in
                        _ = rxRequest(showLoading: true,
                                  action: { OIMManager.login(uid: model.openImToken.uid,
                                                               token: model.openImToken.token,
                                                               callback: $0) })
                            .subscribe(onSuccess: { _ in
                                DBModule.shared.set(key: LoginVC.cacheKey, value: mnemonic)
                                AccountManager.shared.login(model: model)
                            })
                    })
            }
        }
    }
    
}
