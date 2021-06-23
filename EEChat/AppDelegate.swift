//
//  AppDelegate.swift
//  EEChat
//
//  Created by Snow on 2021/6/10.
//

import UIKit
import RxSwift
import OpenIM
import OpenIMUI
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow()
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        return window
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Logger.debugMode = .verbose
        
        OUIKit.shared.initSDK()
        OUIKit.shared.messageDelegate = MessageModule.shared
        configKeyboard()
        
        UIViewController.initHook()
        
        _ = Observable.merge(
            NotificationCenter.default.rx.notification(AccountManager.loginNotification),
            NotificationCenter.default.rx.notification(AccountManager.logoutNotification)
        )
        .map { (_) -> Bool in
            return AccountManager.shared.isLogin()
        }
        .startWith(AccountManager.shared.isLogin())
        .subscribe(onNext: { (isLogin) in
            let vc = isLogin ? MainTabBarController() : LoginVC.vc()
            self.window?.rootViewController = UINavigationController(rootViewController: vc)
        })
        
        checkUpdate()
        
        return true
    }

}

extension AppDelegate {
    private func configKeyboard() {
        let keyboardManager = IQKeyboardManager.shared
        
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.keyboardDistanceFromTextField = 64

        keyboardManager.enableAutoToolbar = false
        keyboardManager.toolbarManageBehaviour = .byPosition
        keyboardManager.shouldShowToolbarPlaceholder = true

        let classes: [UIViewController.Type] = [
            EEChatVC.self,
            IMConversationViewController.self,
            IMInputViewController.self,
            IMMessageViewController.self,
        ]
        keyboardManager.disabledDistanceHandlingClasses.append(contentsOf: classes)
        keyboardManager.disabledToolbarClasses.append(contentsOf: classes)
        keyboardManager.disabledTouchResignedClasses.append(contentsOf: classes)
    }
    
    func checkUpdate() {
        #if BETA // DEBUG || BETA
        PgyUpdateManager.sharedPgy().start(withAppId: "6d8bd7f759ad3a7b92ea3288fe8e8e4c")
        DispatchQueue.main.async {
            PgyUpdateManager.sharedPgy().checkUpdate()
        }
        #endif
    }
}
