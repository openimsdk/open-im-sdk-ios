//
//  PushManager.swift
//  EEChat
//
//  Created by Snow on 2021/4/20.
//

import Foundation
import OpenIM

final class PushManager: NSObject {
    static let shared = PushManager()
    private override init() {
        super.init()
        XGPush.defaultManager().startXG(withAccessID: 1600018281, accessKey: "IIT515FEY4NC", delegate: self)
        register()
    }
    
    func register() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (isFinish, error) in
            
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func launchOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        XGPush.defaultManager().launchOptions = launchOptions as? NSMutableDictionary
    }
    
    func clear() {
        XGPush.defaultManager().clearTPNSCache()
        XGPushTokenManager.default().clearAccounts()
        XGPushTokenManager.default().clearTags()
        XGPush.defaultManager().setBadge(0)
    }
    
    func setBadge(_ badgeNumber: Int) {
        XGPush.defaultManager().setBadge(badgeNumber)
        UIApplication.shared.applicationIconBadgeNumber = badgeNumber
    }
    
    func setAlias(_ alias: String...) {
        let dict = alias.enumerated().reduce(into: [NSNumber: String]()) { (result, iter) in
            result[NSNumber(value: iter.offset)] = iter.element
        }
        XGPushTokenManager.default().upsertAccounts(byDict: dict)
    }
    
    func clearAlias() {
        XGPushTokenManager.default().clearAccounts()
    }
    
    func setTags(_ tags: [String]) {
        clearTags()
        XGPushTokenManager.default().appendTags(tags)
    }
    
    func clearTags() {
        XGPushTokenManager.default().clearTags()
    }
}

extension PushManager: XGPushDelegate {
    func xgPushDidRegisteredDeviceToken(_ deviceToken: String?, xgToken: String?, error: Error?) {
        
    }
    
    // Receive
    func xgPushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)? = nil) {
        switch notification {
//        case let notification as UNNotification:
//            handle(notification: notification, isJump: false)
        default:
            break
        }
        
        let options = UNNotificationPresentationOptions(arrayLiteral: [])
        completionHandler?(options.rawValue)
    }
    
    // Click
    func xgPushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response {
//        case let response as UNNotificationResponse:
//            handle(notification: response.notification, isJump: true)
        default:
            break
        }
        completionHandler()
    }
    
//    private func handle(notification: UNNotification, isJump: Bool) {
//        if isJump, let sessionType = getParams(notification: notification) {
//            if AccountManager.shared.isLogin() {
//                DispatchQueue.main.async {
//                    let navigationController = NavigationModule.shared.navigationControllers.first!
//                    var viewControllers = navigationController.viewControllers
//                    if let index = viewControllers.firstIndex(where: { $0.isMember(of: ChatVC.self) }) {
//                        let vc = viewControllers[index] as! ChatVC
//                        if vc.sessionType == sessionType {
//                            return
//                        }
//                        viewControllers.removeLast(viewControllers.count - index)
//                    } else {
//                        viewControllers = [viewControllers[0]]
//                    }
//                    
//                    let vc = ChatVC.vc(sessionType)
//                    viewControllers.append(vc)
//                    navigationController.viewControllers = viewControllers     
//                }
//            }
//        }
//    }
//    
//    func clear(_ sessionType: SessionType) {
//        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
//            let identifiers = notifications.compactMap { (notification) -> String? in
//                if self.getParams(notification: notification) == sessionType  {
//                    return notification.request.identifier
//                }
//                return nil
//            }
//            
//            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
//        }
//    }
//    
//    private func getParams(notification: UNNotification) -> SessionType? {
//        let userInfo = notification.request.content.userInfo
//        if let custom = userInfo["custom"] as? String,
//              let data = custom.data(using: .utf8),
//              let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
//            if let type = dict["chatType"] as? Int,
//               let from = dict["from"] as? String,
//               let _ = dict["to"] as? String {
//               return SessionType(type: type, id: from)
//            }
//        }
//        
//        return nil
//    }
    
}
