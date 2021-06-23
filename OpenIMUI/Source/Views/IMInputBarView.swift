//
//  IMInputBarView.swift
//  MessageKit
//
//  Created by Snow on 2021/6/4.
//

import UIKit

public protocol IMInputBarViewDelegate: AnyObject {
    func inputBarViewDidTouchMore(_ inputBarView: IMInputBarView)
    func inputBarViewDidTouchVoice(_ inputBarView: IMInputBarView)
    func inputBarViewDidTouchKeyboard(_ inputBarView: IMInputBarView)
    
    func inputBarView(_ inputBarView: IMInputBarView, didChangeInputHeight offset: CGFloat)
    func inputBarView(_ inputBarView: IMInputBarView, didSendText text: String, at uids: [String])
    func inputBarView(_ inputBarView: IMInputBarView, didSendVoice url: URL)
    
    func inputBarView(_ inputBarView: IMInputBarView, didInputAt completionHandler: @escaping (_ name: String, _ uid: String) -> Void)
}

open class IMInputBarView: UIView {
    
    public weak var delegate: IMInputBarViewDelegate?
    
    open lazy var textView: IMTextView = {
        let textView = IMTextView()
        addSubview(textView)
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        textView.layer.cornerRadius = 4
        textView.delegate = self
        textView.returnKeyType = .send
        textView.enablesReturnKeyAutomatically = true
        textView.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    public var textViewMargin: CGFloat = 11
    public var buttonSize = CGSize(width: 42, height: 55)
    
    public lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(voiceAction), for: .touchUpInside)
        button.setImage(ImageCache.named("openim_icon_input_voice"), for: .normal)
        addSubview(button)
        return button
    }()
    
    public lazy var moreButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        button.setImage(ImageCache.named("openim_icon_input_more"), for: .normal)
        addSubview(button)
        return button
    }()
    
    public lazy var keyboardButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(keyboardAction), for: .touchUpInside)
        button.setImage(ImageCache.named("openim_icon_input_keyboard"), for: .normal)
        button.isHidden = true
        addSubview(button)
        return button
    }()
    
    public lazy var recordView: IMRecordView = {
        let recordView = IMRecordView()
        recordView.delegate = self
        addSubview(recordView)
        recordView.isHidden = true
        return recordView
    }()
    
    private var contentWidth: CGFloat {
        return bounds.width - (buttonSize.width + 2) * 2
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentWidth = self.contentWidth
        let contentHeight: CGFloat = {
            if textView.isHidden {
                recordView.frame.size.width = contentWidth
                return recordView.frame.height
            }
            textView.frame.origin = CGPoint(x: buttonSize.width + 2, y: textViewMargin)
            textView.frame.size = CGSize(width: contentWidth, height: textView.heightThatFits(contentWidth))
            if textView.text == "" {
                recordView.frame = textView.frame
            }
            return textView.frame.height
        }()

        frame.size.height = contentHeight + textViewMargin * 2
        
        let originY = frame.height - buttonSize.height
        
        voiceButton.frame = CGRect(origin: CGPoint(x: 2, y: originY), size: buttonSize)
        
        moreButton.frame = CGRect(origin: CGPoint(x: bounds.width - buttonSize.width - 2, y: originY), size: buttonSize)
        
        switch true {
        case voiceButton.isHidden:
            keyboardButton.frame = voiceButton.frame
        case moreButton.isHidden:
            keyboardButton.frame = moreButton.frame
        default:
            break
        }
    }
    
    private func layoutContent(_ height: CGFloat) {
        
        switch false {
        case textView.isHidden:
            textView.frame.size = CGSize(width: contentWidth, height: height)
        case recordView.isHidden:
            recordView.frame.size = CGSize(width: contentWidth, height: recordView.frame.height)
        default:
            break
        }
        
        let newHeight = height + self.textViewMargin * 2
        let offset = newHeight - bounds.height
        
        frame.size.height = newHeight
        
        if offset != 0 {
            delegate?.inputBarView(self, didChangeInputHeight: offset)
        }
    }
    
    @objc
    private func voiceAction() {
        voiceButton.isHidden = true
        moreButton.isHidden = false
        keyboardButton.isHidden = false
        keyboardButton.frame.origin.x = voiceButton.frame.origin.x
        recordView.isHidden = false
        
        textView.isHidden = true
        textView.resignFirstResponder()
        keyboardButton.frame = voiceButton.frame
        layoutContent(recordView.bounds.height)
        delegate?.inputBarViewDidTouchVoice(self)
    }
    
    @objc
    private func moreAction() {
        voiceButton.isHidden = false
        moreButton.isHidden = true
        keyboardButton.isHidden = false
        keyboardButton.frame.origin.x = moreButton.frame.origin.x
        recordView.isHidden = true
        
        textView.isHidden = false
        textView.resignFirstResponder()
        keyboardButton.frame = moreButton.frame
        layoutContent(textView.heightThatFits(contentWidth))
        delegate?.inputBarViewDidTouchMore(self)
    }
    
    @objc
    private func keyboardAction() {
        recordView.isHidden = true
        textView.isHidden = false
        textView.becomeFirstResponder()
    }
    
    public func clearTextView() {
        textView.text = ""
        textViewDidChange(textView)
    }
    
    public func resign(status: InputStatus) {
        switch status {
        case .more:
            moreButton.isHidden = false
            keyboardButton.isHidden = true
        case .keyboard:
            textView.resignFirstResponder()
        default:
            break
        }
    }
}

extension IMInputBarView: IMRecordViewDelegate {
    public func recordView(_ recordView: IMRecordView, finish url: URL) {
        delegate?.inputBarView(self, didSendVoice: url)
    }
}

extension NSAttributedString.Key {
    static let atValue = NSAttributedString.Key(rawValue: "atValue")
}

extension IMInputBarView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        voiceButton.isHidden = false
        moreButton.isHidden = false
        keyboardButton.isHidden = true
        
        layoutContent(self.textView.heightThatFits(contentWidth))
        delegate?.inputBarViewDidTouchKeyboard(self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let oldHeight = textView.bounds.height
        let newHeight = self.textView.heightThatFits(contentWidth)
        
        if newHeight == oldHeight {
            return
        }
        
        layoutContent(newHeight)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textView = self.textView
        
        func atValue(location: Int, attributedText: NSAttributedString? = nil) -> String? {
            let attributedText = attributedText ?? textView.attributedText!
            let value = attributedText.attribute(.atValue,
                                                 at: location,
                                                 longestEffectiveRange: nil,
                                                 in: NSRange(location: location, length: 1))
            return value as? String
        }
        
        // 清除 location 所在的 atValue
        @discardableResult
        func deleteAtValue(location: Int, max: Int, attributedText: NSMutableAttributedString) -> Bool {
            var hasAt = false
            var index = location
            while index < max {
                if let value = atValue(location: index, attributedText: attributedText) {
                    hasAt = true
                    if index == location {
                        var start = 0
                        for index in (0..<index).reversed() {
                            if value != atValue(location: index) {
                                start = index + 1
                                break
                            }
                        }
                        attributedText.removeAttribute(.atValue, range: NSRange(location: start, length: index - start))
                    }
                    
                    var end = attributedText.string.count
                    for index in index+1..<end {
                        if value != atValue(location: index, attributedText: attributedText) {
                            end = index
                            break
                        }
                    }
                    
                    attributedText.removeAttribute(.atValue, range: NSRange(location: index, length: end - index))
                    index = end
                } else {
                    index += 1
                }
            }
            
            return hasAt
        }
        
        switch text {
        case "\n":
            var uids: Set<String> = []
            let text = textView.text!
            if !text.isEmpty {
                textView.attributedText.enumerateAttribute(.atValue,
                                                           in: NSRange(location: 0, length: text.count),
                                                           options: [])
                { value, _, _ in
                    if let uid = value as? String {
                        uids.insert(uid)
                    }
                }
                delegate?.inputBarView(self, didSendText: text, at: Array(uids))
                clearTextView()
            }
            return false
        case "":
            let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
            let hasAt = deleteAtValue(location: range.location, max: range.upperBound, attributedText: attributedText)
            
            if hasAt {
                attributedText.deleteCharacters(in: range)
                textView.attributedText = attributedText
                textView.selectedRange = NSRange(location: range.location, length: 0)
                return false
            }
            
            if range.location > 1 {
                if range.length > 1 {
                    // 多选删除时保留 @ 后边跟随的空格
                    let index = textView.text.index(text.startIndex, offsetBy: range.location - 1)
                    if textView.text[index] == " ",
                       atValue(location: range.location - 2) != nil {
                        attributedText.deleteCharacters(in: range)
                        textView.attributedText = attributedText
                        textViewDidChange(textView)
                        textView.selectedRange = NSRange(location: range.location, length: 0)
                        return false
                    }
                } else {
                    let index = textView.text.index(text.startIndex, offsetBy: range.location)
                    if textView.text[index] == " " {
                        // 删除 空格时，同时空格前面的 at 数据
                        if atValue(location: range.location - 1) != nil {
                            for location in (0..<range.location).reversed() {
                                let index = textView.text.index(text.startIndex, offsetBy: location)
                                if textView.text[index] == "@" {
                                    attributedText.deleteCharacters(in: NSRange(location: location, length: range.location - location + 1))
                                    textView.attributedText = attributedText
                                    textViewDidChange(textView)
                                    textView.selectedRange = NSRange(location: location, length: 0)
                                    return false
                                }
                            }
                        }
                    }
                }
            }
        case "@":
            // 未选择 at 对象时 需要清除 location 所在的 atValue
            let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
            if range.location - 1 >= 0 {
                deleteAtValue(location: range.location - 1, max: range.location, attributedText: attributedText)
            }
            let maxCount = attributedText.string.count
            if range.location + 1 < maxCount {
                deleteAtValue(location: range.location + 1, max: min(range.upperBound + 1, maxCount), attributedText: attributedText)
            }
            
            textView.attributedText = attributedText
            textView.selectedRange = range
            
            delegate?.inputBarView(self, didInputAt: { [weak self] (name, uid) in
                guard let self = self else {
                    return
                }
                
                let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
                let attributes: [NSAttributedString.Key : Any] = [
                    .font: textView.font as Any,
                    .foregroundColor: textView.textColor as Any,
                    .atValue: uid,
                ]
                
                attributedText.setAttributes(attributes,
                                             range: NSRange(location: range.location, length: 1))
                
                let newAttributedText = NSMutableAttributedString(string: name, attributes: attributes)
                newAttributedText.append(NSAttributedString(string: " ",
                                                            attributes: [
                                                                .font: textView.font as Any,
                                                                .foregroundColor: textView.textColor as Any,
                                                            ]))
                
                let location = range.location + 1
                attributedText.insert(newAttributedText, at: location)
                
                textView.attributedText = attributedText
                self.textViewDidChange(textView)
                
                textView.selectedRange = NSRange(location: location + newAttributedText.length, length: 0)
            })
        default:
            break
        }
        return true
    }
}
