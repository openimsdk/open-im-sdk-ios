//
//  MessageLabelDelegate.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import Foundation

public protocol MessageLabelDelegate: AnyObject {
    
    func didSelectAddress(_ addressComponents: [String: String])
    
    func didSelectDate(_ date: Date)
    
    func didSelectPhoneNumber(_ phoneNumber: String)
    
    func didSelectURL(_ url: URL)
    
    func didSelectTransitInformation(_ transitInformation: [String: String])
    
    func didSelectMention(_ mention: String)
    
    func didSelectHashtag(_ hashtag: String)
    
    func didSelectCustom(_ pattern: String, match: String?)

}

public extension MessageLabelDelegate {

    func didSelectAddress(_ addressComponents: [String: String]) {}

    func didSelectDate(_ date: Date) {}

    func didSelectPhoneNumber(_ phoneNumber: String) {}

    func didSelectURL(_ url: URL) {}
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {}

    func didSelectMention(_ mention: String) {}

    func didSelectHashtag(_ hashtag: String) {}

    func didSelectCustom(_ pattern: String, match: String?) {}

}
