//
//  MessageModule.swift
//  EEChat
//
//  Created by snow on 2021/3/27.
//

import Foundation
import MBProgressHUD
import OpenIM
import OpenIMUI

public final class MessageModule: NSObject, OUIKitMessageDelegate {
    @objc public static let shared = MessageModule()
    private override init() {
        super.init()
    }
    
    // MARK: - HUD
    
    public var keyWindow: UIWindow {
        return NavigationModule.shared.keyWindow
    }

    private weak var globalHud: MBProgressHUD?
    public func showHUD(text: String) {
        self.keyWindow.becomeFirstResponder()
        var hud = globalHud
        if hud == nil {
            let view = self.keyWindow
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            globalHud = hud
        }
        hud!.label.text = text
        hud!.show(animated: true)
    }

    public static func showHUD(text: String? = nil) {
        shared.showHUD(text: text ?? LocalizedString("Requesting..."))
    }
    
    public func hideHUD(animated: Bool = true) {
        if animated {
            globalHud?.hide(animated: animated, afterDelay: 0.1)
        } else {
            globalHud?.hide(animated: animated)
        }
    }

    public static func hideHUD(animated: Bool = true) {
        shared.hideHUD(animated: animated)
    }
    
    public func showMessage(_ text: String) {
        let view = keyWindow
        view.makeToast(text, duration: 1, position: NSValue(cgPoint: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)))
    }
    
    public func showError(_ text: String) {
        showMessage(text)
    }
    
    public func showError(_ error: Error) {
        showMessage(error.localizedDescription)
    }

    public static func showMessage(text: String) {
        shared.showMessage(text)
    }
    
    public static func showMessage(error: Error) {
        shared.showError(error)
    }
}
