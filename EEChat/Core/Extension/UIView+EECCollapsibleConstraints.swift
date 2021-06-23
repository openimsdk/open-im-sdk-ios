//
//  UIView+EECCollapsibleConstraints.swift
//  test
//
//  Created by snow on 2018/7/21.
//  Copyright © 2018 snow. All rights reserved.
//  https://github.com/forkingdog/UIView-FDCollapsibleConstraints

import UIKit

private var AssociatedKey: UInt8 = 0
private var AutoCollapseAssociatedKey: UInt8 = 0

extension UIView {
    fileprivate class InternalData {
        var collapsed = false
        var collapsibleConstraints = [NSLayoutConstraint]()
        var newCollapsibleConstraints = [NSLayoutConstraint]()
        weak var collapsedAnimationView: UIView?
        var clipViews: [WeakBox<UIView>] = []
    }

    fileprivate var data: InternalData {
        var value = objc_getAssociatedObject(self, &AssociatedKey)
        if value == nil {
            value = InternalData()
            objc_setAssociatedObject(self, &AssociatedKey, value!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return value! as! InternalData
    }
}

extension UIView {
    private static let _initialize: () = {
        method_exchangeImplementations(
            class_getInstanceMethod(UIView.self, #selector(updateConstraints))!,
            class_getInstanceMethod(UIView.self, #selector(eec_updateConstraints))!
        )
        
        method_exchangeImplementations(
            class_getInstanceMethod(UIView.self, #selector(setValue(_:forKey:)))!,
            class_getInstanceMethod(UIView.self, #selector(eec_setValue(_:forKey:)))!
        )
    }()

    @objc private func eec_setValue(_ value: Any?, forKey key: String) {
        let injectedKey = String(cString: sel_getName(#selector(eec_updateConstraints)))
        if key == injectedKey {
            eec_collapsibleConstraints = value as! [NSLayoutConstraint]
        } else {
            eec_setValue(value, forKey: key)
        }
    }

    @IBOutlet public var eec_collapsibleConstraints: [NSLayoutConstraint] {
        get {
            return data.collapsibleConstraints
        }
        set {
            UIView._initialize
            data.collapsibleConstraints = newValue
        }
    }

    @IBOutlet public var eec_collapsedAnimationView: UIView? {
        get {
            return data.collapsedAnimationView
        }
        set {
            data.collapsedAnimationView = newValue
        }
    }

    @objc public var eec_collapsed: Bool {
        get {
            return data.collapsed
        }
        set {
            eec_setCollapsed(newValue, animationView: data.collapsedAnimationView)
        }
    }

    @IBInspectable public var autoCollapse: Bool {
        get {
            fatalError()
        }
        set {
            eec_autoCollapse = newValue
        }
    }

    @objc public var eec_autoCollapse: Bool {
        get {
            return objc_getAssociatedObject(self, &AutoCollapseAssociatedKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AutoCollapseAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    // 当 animationView 为 nil 时 没有动画效果
    private func eec_setCollapsed(_ collapsed: Bool, animationView: UIView?) {
        if data.collapsed == collapsed {
            return
        }
        data.collapsed = collapsed
        if collapsed {
            var clipViews: [UIView] = []
            if data.collapsibleConstraints.count != data.newCollapsibleConstraints.count {
                data.newCollapsibleConstraints = data.collapsibleConstraints.map { (constraint) -> NSLayoutConstraint? in
                    guard let firstItem = constraint.firstItem as? UIView else {
                        return nil
                    }

                    let newConstraint = NSLayoutConstraint(item: firstItem,
                                                           attribute: constraint.firstAttribute,
                                                           relatedBy: .equal,
                                                           toItem: constraint.secondItem,
                                                           attribute: constraint.secondAttribute,
                                                           multiplier: 1,
                                                           constant: 0)

                    // 判断当前view是否限制自己 限制自己则是折叠自身 需要剪裁
                    if constraint.secondItem == nil {
                        clipViews.append(firstItem)
                    }
                    return newConstraint
                }.filter { $0 != nil } as! [NSLayoutConstraint]

                data.clipViews = Array.from(value: clipViews)
            }

            NSLayoutConstraint.deactivate(data.collapsibleConstraints)
            NSLayoutConstraint.activate(data.newCollapsibleConstraints)
            data.clipViews.forEach { weak in
                weak.unbox?.isHidden = true
            }
        } else {
            NSLayoutConstraint.deactivate(data.newCollapsibleConstraints)
            NSLayoutConstraint.activate(data.collapsibleConstraints)
            data.clipViews.forEach { weak in
                weak.unbox?.isHidden = false
            }
        }

        if animationView != nil {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                animationView!.layoutIfNeeded()
            }
        }
    }

    @objc private func eec_updateConstraints() {
        eec_updateConstraints()

        if eec_autoCollapse, eec_collapsibleConstraints.count > 0 {
            let contentSize = intrinsicContentSize
            let collapsed = contentSize.width <= 0 || contentSize.height <= 0
            eec_setCollapsed(collapsed, animationView: nil)
        }
    }
}

