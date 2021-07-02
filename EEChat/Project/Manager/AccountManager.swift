//
//  AccountManager.swift
//  EEChat
//
//  Created by Snow on 2021/5/18.
//

import Foundation
import OpenIM

extension AccountManager {
    static let loginNotification = Notification.Name("AccountManager.loginNotification")
    static let logoutNotification = Notification.Name("AccountManager.logoutNotification")
}

public final class AccountManager {
    static let shared = AccountManager()
    private init() {
        if let model: ApiUserLogin.Model = DBModule.shared.get(key: userModelKey) {
            if model.userInfo.uid != "" {
                self.login(model: model)
            } else {
                self.logout()
            }
        }
    }
    
    private let userModelKey = "AccountService.model"
    var model = ApiUserLogin.Model() {
        didSet {
            DBModule.shared.set(key: userModelKey, value: model)
        }
    }
    
    func isLogin() -> Bool {
        return !model.userInfo.uid.isEmpty
    }
    
    func login(model: ApiUserLogin.Model) {
        self.model = model
        PushManager.shared.setAlias(model.userInfo.uid)
        NotificationCenter.default.post(name: AccountManager.loginNotification, object: nil)
        OIMManager.login(uid: model.openImToken.uid, token: model.openImToken.token) { result in
            if case .failure = result {
                self.logout()
            }
        }
    }
    
    func logout() {
        model = ApiUserLogin.Model()
        OIMManager.logout()
        PushManager.shared.clear()
        NotificationCenter.default.post(name: AccountManager.logoutNotification, object: nil)
    }
}
