//
//  NotificationSettingVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/25.
//

import UIKit

class NotificationSettingVC: BaseViewController {

    @IBOutlet var notificationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForegroundNotification),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshUI()
    }
    
    private func refreshUI() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let isAuthorized = settings.authorizationStatus == .authorized
            DispatchQueue.main.async {
                self.notificationSwitch.isOn = isAuthorized
            }
        }
    }
    
    @objc
    func willEnterForegroundNotification() {
        self.refreshUI()
    }
    
    @IBAction func jumpSettingAction() {
        UIAlertController.show(title: "跳转设置中心?",
                               message: nil,
                               buttons: ["跳转"],
                               cancel: "取消")
        { (index) in
            if index == 1 {
                self.jumpToSetting()
            }
        }
    }
    
    private func jumpToSetting() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier,
           let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
