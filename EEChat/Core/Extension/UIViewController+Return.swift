//
//  UIViewController+Return.swift
//  EEChat
//
//  Created by Snow on 2021/4/9.
//

import UIKit

extension UIViewController {
    public static func initHook() {
        let originalSelector = class_getInstanceMethod(self, #selector(viewDidLoad))!
        let swizzledSelector = class_getInstanceMethod(self, #selector(_viewDidLoadHook))!
        method_exchangeImplementations(originalSelector, swizzledSelector)
    }

    @objc private func _viewDidLoadHook() {
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        _viewDidLoadHook()
        if navigationItem.hidesBackButton {
            return
        }

        if let count = navigationController?.viewControllers.count, count > 1 {
            setBackBarButtonItem()
        }
    }

    func setBackBarButtonItem(image: UIImage? = nil) {
        let image = image ?? UIImage(named: "navigation_icon_back_black")
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(_backToParentAction), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    @objc private func _backToParentAction() {
        NavigationModule.shared.pop()
    }
}
