//
//  EECResuableCustomView.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit

public protocol ResuableProtocol: AnyObject{
    func fromNib() -> Void
}

public extension ResuableProtocol where Self: UIView {
    func fromNib() {
        if let view = _loadViewFromNib() {
            backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            let top = view.topAnchor.constraint(equalTo: topAnchor)
            let bottom = view.bottomAnchor.constraint(equalTo: bottomAnchor)
            let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
            let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, leading, trailing])
        }
    }

    private func _loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = "\(type(of: self))"
        if bundle.path(forResource: nibName, ofType: "nib") == nil {
            return nil
        }
        let nib = UINib(nibName: nibName, bundle: bundle)
        let array = nib.instantiate(withOwner: self, options: nil)

        assert(array.first != nil, "xib中没有view")
        return array.first as? UIView
    }
}

open class CustomView: UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = true
        didLoad()
    }

    open func didLoad() {}
}

open class ResuableCustomView: CustomView, ResuableProtocol {
    open override func didLoad() {
        fromNib()
        super.didLoad()
    }
}
