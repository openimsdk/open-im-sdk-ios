//
//  ProgressView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/16.
//

import UIKit

public class ProgressView: UILabel, ProgressListener {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        textColor = .white
        font = UIFont.systemFont(ofSize: 14)
        textAlignment = .center
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isHidden: Bool {
        didSet {
            if isHidden {
                msgID = ""
            }
        }
    }
    
    public var msgID = "" {
        didSet {
            if oldValue != "" {
                MessageProcessor.shared.removeProgress(msgID: msgID, isFinish: false)
            }
            if msgID != "" {
                MessageProcessor.shared.listenProgress(msgID, listener: self)
            }
        }
    }
    
    public func finishProgress() {
        isHidden = true
        msgID = ""
    }
    
    public var progress = 0 {
        didSet {
            text = "\(progress)%"
        }
    }
}
