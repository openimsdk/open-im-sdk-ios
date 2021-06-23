//
//  BaseViewController.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit
import RxSwift

public protocol UIViewControllerProtocol: UIViewController {
    
}

extension UIViewControllerProtocol where Self: UIViewController {
    public static func vc() -> Self {
        let typeName = String(describing: self)
        let bundle = Bundle(for: self)
        if bundle.path(forResource: typeName, ofType: "storyboardc") != nil {
            let storyboard = UIStoryboard(name: typeName, bundle: bundle)
            return storyboard.instantiateInitialViewController()! as! Self
        }
        return self.init()
    }
}

open class BaseViewController: UIViewController, UIViewControllerProtocol {
    public typealias Callback = (Any) -> Void
    public private(set) var param: Any?

    public private(set) var callback: Callback?
    public let disposeBag = DisposeBag()
    
    @objc open class func vc(param: Any?, callback: Callback? = nil) -> Self {
        let vc = self.vc()
        vc.param = param
        vc.callback = callback
        return vc
    }

    @objc open class func show(param: Any? = nil, callback: Callback? = nil) {
        let vc = self.vc(param: param, callback: callback)
        NavigationModule.shared.push(vc)
    }
}
