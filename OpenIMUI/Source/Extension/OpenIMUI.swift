//
//  OpenIMUI.swift
//  OpenIMUI
//
//  Created by Snow on 2021/7/7.
//

import Foundation

extension NSAttributedString {
    public func toHtmlString() -> String {
        let documentAttributes: [NSAttributedString.DocumentAttributeKey : Any] = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        do {
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes: documentAttributes)
            if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
                print(htmlString)
                return htmlString
            }
        } catch {
            
        }
        return ""
    }

    public func toData() -> Data {
        if #available(iOS 11.0, *) {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            if data != nil {
                return data!
            }
        }
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    public func toBase64String() -> String {
        return toData().base64EncodedString()
    }

    public static func from(data: Data) -> NSAttributedString? {
        if #available(iOS 11.0, *) {
            let attribute = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)
            if attribute != nil {
                return attribute!
            }
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSAttributedString
    }
    
    public static func from(base64Encoded base64String: String) -> NSAttributedString? {
        if let data = Data(base64Encoded: base64String) {
            return self.from(data: data)
        }
        return nil
    }
}
