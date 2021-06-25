//
//  MainTabBarController.swift
//  EEChat
//
//  Created by Snow on 2021/5/18.
//

import UIKit
import OpenIM
import OpenIMUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            SessionListVC.vc(),
            AddressBookVC.vc(),
            UserCenterVC.vc()
        ]
        
        let titles = [
            LocalizedString("Chats"),
            LocalizedString("Contacts"),
            LocalizedString("Me"),
        ]
        for i in 0 ..< (tabBar.items?.count ?? 0) {
            let item = tabBar.items![i]
            item.title = titles[i]
            item.image = UIImage(named: "tabbar_icon_\(i)_0")!.withRenderingMode(.alwaysOriginal)
            item.selectedImage = UIImage(named: "tabbar_icon_\(i)_1")!.withRenderingMode(.alwaysOriginal)
        }
        
        OIMManager.getTotalUnreadMsgCount { result in
            if case let .success(unreadCount) = result {
                self.update(index: 0, count: unreadCount)
            }
        }
        
        OIMManager.getFriendApplicationList { result in
            if case let .success(array) = result {
                let array = array.filter({ $0.flag == .default })
                self.update(index: 1, count: array.count)
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onTotalUnreadMessageCountChanged(_:)),
                                               name: OUIKit.onTotalUnreadMessageCountChangedNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc
    private func onTotalUnreadMessageCountChanged(_ notification: Notification) {
        guard let unreadCount = notification.object as? Int else {
            return
        }
        update(index: 0, count: unreadCount)
        PushManager.shared.setBadge(unreadCount)
    }
    
    private func update(index: Int, count: Int) {
        if let item = self.tabBar.items?[index] {
            item.qmui_shouldShowUpdatesIndicator = count > 0
        }
    }
    
}
