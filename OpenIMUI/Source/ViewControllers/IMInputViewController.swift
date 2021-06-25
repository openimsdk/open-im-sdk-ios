//
//  IMInputViewController.swift
//  MessageKit
//
//  Created by Snow on 2021/6/4.
//

import UIKit

public protocol IMInputViewControllerDelegate: AnyObject {
    func inputViewController(_ inputViewController: IMInputViewController, didChange height: CGFloat)
    func inputViewController(_ inputViewController: IMInputViewController, didSendText text: String, at uids: [String])
    func inputViewController(_ inputViewController: IMInputViewController, didSendVoice url: URL)
    func inputViewController(_ inputViewController: IMInputViewController, didSelectMore index: Int)
    func inputViewController(_ inputViewController: IMInputViewController, didInputAt completionHandler: @escaping (_ name: String, _ uid: String) -> Void)
}

public struct InputStatus: Equatable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let none = InputStatus(rawValue: 0)
    public static let more = InputStatus(rawValue: 1)
    public static let keyboard = InputStatus(rawValue: 2)
    public static let voice = InputStatus(rawValue: 3)
}

open class IMInputViewController: UIViewController {
    
    public weak var delegate: IMInputViewControllerDelegate?
    
    public lazy var inputBarView: IMInputBarView = {
        let inputBarView = IMInputBarView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0))
        inputBarView.autoresizingMask = .flexibleWidth
        inputBarView.delegate = self
        return inputBarView
    }()
    
    public lazy var moreView: IMInputMoreView = {
        let moreView = IMInputMoreView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        moreView.autoresizingMask = .flexibleWidth
        moreView.delegate = self
        return moreView
    }()
    
    private var status: InputStatus = .none
    
    // MARK: - Methods [Override]

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputBarView)
        
        view.autoresizingMask = .flexibleWidth
        
        view.backgroundColor = UIColor(red: 0xE8 / 255.0, green: 0xF2 / 255.0, blue: 0xFF / 255.0, alpha: 1)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reset),
                                               name: MessagesCollectionView.resignAllResponderNotification,
                                               object: nil)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let gestureRecognizers = view.window?.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                gestureRecognizer.delaysTouchesBegan = false
            }
        }
        navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let height: CGFloat
        switch status {
        case .more:
            height = inputBarView.bounds.height + moreView.bounds.height + view.safeAreaInsets.bottom
        default:
            height = inputBarView.bounds.height + view.safeAreaInsets.bottom
        }
        if view.bounds.height < height {
            view.frame.size.height = height
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods [Private]
    
    @objc
    private func reset() {
        switch status {
        case .more:
            hideMoreView()
            let newHeight = inputBarView.bounds.height + view.safeAreaInsets.bottom
            delegate?.inputViewController(self, didChange: newHeight)
        default:
            break
        }
        inputBarView.resign(status: status)
        status = .none
    }
    
    private func showMoreView() {
        view.addSubview(moreView)
        moreView.isHidden = false
        moreView.layoutIfNeeded()
        
        moreView.frame = {
            var frame = moreView.frame
            frame.origin.y = inputBarView.frame.maxY
            frame.size.width = view.bounds.width
            return frame
        }()
    }
    
    private func hideMoreView() {
        guard status == .more else {
            return
        }
        moreView.isHidden = false
        moreView.alpha = 1
        
        UIView.animate(withDuration: CATransaction.animationDuration(),
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            self?.moreView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.moreView.isHidden = true
            self.moreView.alpha = 1
            self.moreView.removeFromSuperview()
        }
        
    }
    
    // MARK: - Methods
    
    // MARK: - Methods [Notification]
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        hideMoreView()
        status = .keyboard
    }
    
    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let newHeight = keyboardFrame.height + inputBarView.bounds.height
        delegate?.inputViewController(self, didChange: newHeight)
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        let newHeight = view.safeAreaInsets.bottom + inputBarView.bounds.height
        delegate?.inputViewController(self, didChange: newHeight)
    }
    
}

extension IMInputViewController: IMInputBarViewDelegate {
    
    public func inputBarViewDidTouchMore(_ inputBarView: IMInputBarView) {
        showMoreView()
        status = .more
        let newHeight = inputBarView.bounds.height + moreView.bounds.height + view.safeAreaInsets.bottom
        delegate?.inputViewController(self, didChange: newHeight)
    }
    
    public func inputBarViewDidTouchVoice(_ inputBarView: IMInputBarView) {
        hideMoreView()
        status = .voice
        let newHeight = inputBarView.bounds.height + view.safeAreaInsets.bottom
        delegate?.inputViewController(self, didChange: newHeight)
    }
    
    public func inputBarViewDidTouchKeyboard(_ inputBarView: IMInputBarView) {
        
    }
    
    public func inputBarView(_ inputBarView: IMInputBarView, didChangeInputHeight offset: CGFloat) {
        delegate?.inputViewController(self, didChange: view.bounds.height + offset)
    }
    
    public func inputBarView(_ inputBarView: IMInputBarView, didSendText text: String, at uids: [String]) {
        delegate?.inputViewController(self, didSendText: text, at: uids)
    }
    
    public func inputBarView(_ inputBarView: IMInputBarView, didSendVoice url: URL) {
        delegate?.inputViewController(self, didSendVoice: url)
    }
    
    public func inputBarView(_ inputBarView: IMInputBarView, didInputAt completionHandler: @escaping (String, String) -> Void) {
        delegate?.inputViewController(self, didInputAt: completionHandler)
    }
    
}

extension IMInputViewController: IMInputMoreViewDelegate {
    public func inputMoreView(_ inputMoreView: IMInputMoreView, didSelectMore item: IMInputMoreItem, index: Int) {
        delegate?.inputViewController(self, didSelectMore: index)
    }
}
