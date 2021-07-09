//
//  NavigationModule.swift
//  EEChat
//
//  Created by snow on 2021/3/27.
//

import UIKit

public struct NavigationModule {
    public static let shared = NavigationModule()
    private init() {}
    
    public var keyWindow: UIWindow {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}[0]
    }
    
    public var rootViewController: UIViewController {
        return self.keyWindow.rootViewController!
    }
    
    public var navigationControllers: [UINavigationController] {
        var navigationController = self.rootViewController as? UINavigationController
        var navigationControllers: [UINavigationController] = []
        
        while navigationController != nil {
            navigationControllers.append(navigationController!)
            navigationController = navigationController!.presentedViewController as? UINavigationController
        }
        
        return navigationControllers
    }
    
    public var navigationController: UINavigationController {
        return self.navigationControllers.last!
    }
    
    public var topViewController: UIViewController {
        return navigationControllers.last!.topViewController!
    }
    
    private func _pushOrPop(_ vc: UIViewController?, popCount: Int, animated: Bool) {
        let navigationControllers = self.navigationControllers
        var navigationController: UINavigationController!

        var count = popCount
        for iter in navigationControllers.reversed() {
            navigationController = iter
            let viewControllers = iter.viewControllers
            if viewControllers.count > count {
                break
            }
            count = count - viewControllers.count
        }

        var viewControllers = navigationController.viewControllers
        if count > 0 {
            viewControllers.removeLast(count)
        }
        if let vc = vc {
            vc.hidesBottomBarWhenPushed = true
            viewControllers.append(vc)
        }
        if !viewControllers.isEmpty {
            navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
            navigationController.setViewControllers(viewControllers, animated: animated)
        } else {
            navigationController.dismiss(animated: animated, completion: nil)
        }
    }
    
    public func pop(animated: Bool = true) {
        self.navigationController.popViewController(animated: animated)
    }
    
    public func pop(popCount: Int, animated: Bool = true) {
        _pushOrPop(nil, popCount: popCount, animated: animated)
    }
    
    public func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func push(_ vc: UIViewController, popCount: Int, animated: Bool) {
        _pushOrPop(vc, popCount: popCount, animated: animated)
    }
    
    public func present(vc vcToPresent: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        var vc = vcToPresent
        let style = vc.modalPresentationStyle
        if style != .popover {
            let isWithout = [
                UIAlertController.self,
                UINavigationController.self,
                UIImagePickerController.self
            ]
                .contains(where: { (cls) -> Bool in
                    vc.isKind(of: cls)
                })
            if !isWithout {
                vc = UINavigationController(rootViewController: vc)
                vc.modalPresentationStyle = vcToPresent.modalPresentationStyle
            }
        }
        self.navigationController.present(vc, animated: animated, completion: completion)
    }
    
    public func presentCustom(_ vcToPresent: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        vcToPresent.modalPresentationStyle = .custom
        present(vc: vcToPresent, animated: animated, completion: completion)
    }
    
    public func presentOver(_ vcToPresent: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        vcToPresent.modalPresentationStyle = .overCurrentContext
        present(vc: vcToPresent, animated: animated, completion: completion)
    }
    
    public func dismiss(animated: Bool = false, completion: (() -> Void)? = nil) {
        let navigationController = self.navigationController
        DispatchQueue.main.async {
            navigationController.dismiss(animated: animated, completion: completion)
        }
    }

    public func dismiss(_ vc: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        let presentingViewController = vc.presentingViewController
        // Asynchronous call avoidance completion push delay
        DispatchQueue.main.async {
            presentingViewController?.dismiss(animated: animated, completion: completion)
        }
    }
}
