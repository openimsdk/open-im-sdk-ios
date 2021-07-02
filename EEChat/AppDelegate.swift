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
import Bugly

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
        configBugly()
        configKeyboard()
        configQMUIKit()
        
        UIViewController.initHook()
        
        PushManager.shared.launchOptions(launchOptions)
        
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
    
    private func configQMUIKit() {
        guard let instance = QMUIConfiguration.sharedInstance() else {
            return
        }
        instance.sendAnalyticsToQMUITeam = false
        instance.shouldPrintDefaultLog = false
        instance.shouldPrintInfoLog = false
        instance.shouldPrintWarnLog = false
        instance.shouldPrintQMUIWarnLogToConsole = false
        instance.applyInitialTemplate()
    }
    
    func configBugly() {
        Bugly.start(withAppId: "21ae582b11")
    }
    
    func checkUpdate() {
        #if BETA // DEBUG || BETA
        PgyUpdateManager.sharedPgy().start(withAppId: "8823db48e4d89ab039a00b25dc14f9e5")
        DispatchQueue.main.async {
            PgyUpdateManager.sharedPgy().checkUpdate()
        }
        #endif
    }
}
