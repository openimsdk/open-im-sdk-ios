//
//  FileProcessor.swift
//  MessageKit
//
//  Created by Snow on 2021/6/9.
//

import UIKit
import AVKit
import OpenIM

public protocol ProgressListener: AnyObject {
    var progress: Int { get set }
    func finishProgress()
}

public final class MessageProcessor: NSObject {
    public static let shared = MessageProcessor()
    private override init() {
        self.path = OIMManager.cachePath
        super.init()
        
        try? FileManager.default.createDirectory(atPath: path + "image/", withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(atPath: path + "audio/", withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(atPath: path + "video/", withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(atPath: path + "file/", withIntermediateDirectories: true, attributes: nil)
    }
    
    private var progressValues: [String: Int] = [:]
    private var progressListeners: [String: ProgressListener] = [:]
    
    public func hookProgress(msgID: String) -> (Int) -> Void {
        return { (value: Int) in
            func execute() {
                self.progressValues[msgID] = value
                if let listener = self.progressListeners[msgID] {
                    listener.progress = value
                }
            }
            if Thread.isMainThread {
                execute()
            } else {
                DispatchQueue.main.async(execute: execute)
            }
        }
    }
    
    public func removeProgress(msgID: String, isFinish: Bool) {
        if isFinish {
            progressValues.removeValue(forKey: msgID)
        }
        if let listener = progressListeners.removeValue(forKey: msgID), isFinish {
            listener.finishProgress()
        }
    }
    
    public func listenProgress(_ msgID: String, listener: ProgressListener) {
        listener.progress = progressValues[msgID] ?? 0
        self.progressListeners[msgID] = listener
    }
    
    public let path: String
    
    public func image(_ image: UIImage, url: URL?) -> OIMMessage {
        var image = image
        let path: String
        if let url = url {
            assert(url.isFileURL)
            path = self.path + "image/" + UUID().uuidString + "." + url.pathExtension
            try? FileManager.default.copyItem(atPath: url.relativePath, toPath: path)
        } else {
            path = self.path + "image/" + UUID().uuidString + ".jpg"
            autoreleasepool {
                if image.imageOrientation != .up {
                    let aspectRatio = min(1920 / image.size.width, 1920 / image.size.height)
                    let width = image.size.width * aspectRatio
                    let height = image.size.height * aspectRatio
                    
                    UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                    image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                    if let value = UIGraphicsGetImageFromCurrentImageContext() {
                        image = value
                    }
                    UIGraphicsEndImageContext()
                }
                let data = image.jpegData(compressionQuality: 0.75)
                FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            }
        }
        
        return OIMManager.createImageMessage(path)
    }
    
    public func audio(_ url: URL) throws -> OIMMessage {
        assert(url.isFileURL)
        let player = try? AVAudioPlayer(contentsOf: url)
        let duration = player?.duration ?? 0
        guard duration >= 1 else {
            throw OUIError.recordTimeshort
        }
        let path = path + "audio/" + UUID().uuidString + ".wav"
        try? FileManager.default.copyItem(atPath: url.relativePath, toPath: path)
        return OIMManager.createSoundMessage(path, duration: Int(ceil(duration)))
    }
    
    public func video(_ url: URL, callback: @escaping (OIMMessage?) -> Void ) {
        assert(url.isFileURL)
        func onCallback(url: URL) {
            do {
                let opts: [String: Any] = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
                let asset = AVURLAsset(url: url, options: opts)
                let duration = Float(asset.duration.value) / Float(asset.duration.timescale)
                
                let generator = AVAssetImageGenerator(asset: asset)
                generator.appliesPreferredTrackTransform = true
                generator.maximumSize = CGSize(width: 192, height: 192)
                
                let time = CMTime(seconds: 0, preferredTimescale: 10)
                let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                let data = image.jpegData(compressionQuality: 0.75)
                let snapshotPath = path.replacingOccurrences(of: ".mp4", with: ".jpg")
                FileManager.default.createFile(atPath: snapshotPath, contents: data, attributes: nil)
                let message = OIMManager.createVideoMessage(url.relativePath, videoType: "mp4", duration: Int(ceil(duration)), snapshotPath: snapshotPath)
                DispatchQueue.main.async {
                    callback(message)
                }
            } catch {
                DispatchQueue.main.async {
                    callback(nil)
                }
            }
        }
                
        let path = path + "video/" + UUID().uuidString + ".mp4"
        let newURL = URL(fileURLWithPath: path)
        
        if url.pathExtension == "mp4" {
            do {
                try FileManager.default.copyItem(at: url, to: newURL)
                onCallback(url: newURL)
            } catch {
                fatalError()
            }
            return
        }
        
        let asset = AVURLAsset(url: url)
        if let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) {
            session.outputURL = newURL
            session.outputFileType = .mp4
            session.shouldOptimizeForNetworkUse = true
            session.exportAsynchronously {
                switch session.status {
                case .failed:
                    break
                case .cancelled:
                    break
                case .completed:
                    onCallback(url: newURL)
                default:
                    DispatchQueue.main.async {
                        callback(nil)
                    }
                }
            }
        } else {
            fatalError()
        }
        
    }
    
    public func file(_ url: URL) -> OIMMessage {
        let path = self.path + "file/" + url.lastPathComponent
        let newURL = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: newURL)
        try? FileManager.default.copyItem(at: url, to: newURL)
        return OIMManager.createFileMessage(path, filename: url.lastPathComponent)
    }
    
}
