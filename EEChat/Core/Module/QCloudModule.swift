//
//  QCloudModule.swift
//  EEChat
//
//  Created by Snow on 2021/4/1.
//

import Foundation
import QCloudCOSXML
import QCloudCore
import Photos
import RxSwift
import CoreServices
import OpenIM


private struct Credentials: Decodable {
    var tmpSecretId = ""
    var tmpSecretKey = ""
    var token = ""
    
    private enum CodingKeys: String, CodingKey {
        case tmpSecretId = "TmpSecretId",
             tmpSecretKey = "TmpSecretKey",
             token = "Token"
    }
}

private struct Model: Decodable {
    var bucket = ""
    var region = ""
    var credentials = Credentials()
    var expiredTime = TimeInterval.zero
    var startTime = TimeInterval.zero
    
    private enum CodingKeys: String, CodingKey {
        case credentials = "Credentials",
             expiredTime = "ExpiredTime",
             startTime = "StartTime"
    }
}

class QCloudModule: NSObject {
    static let shared = QCloudModule()
    private override init() {
        super.init()
        
        let config = QCloudServiceConfiguration()
        config.signatureProvider = self
        config.isCloseShareLog = true
        config.appID = "1302656840"
        
        let endpoint = QCloudCOSXMLEndPoint()
        endpoint.regionName = "ap-chengdu"
        endpoint.useHTTPS = true
        config.endpoint = endpoint
        
        QCloudCOSXMLService.registerDefaultCOSXML(with: config)
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config)
        
        let credentailFenceQueue = QCloudCredentailFenceQueue()
        credentailFenceQueue.delegate = self
        self.credentailFenceQueue = credentailFenceQueue
    }
    
    private var credentailFenceQueue: QCloudCredentailFenceQueue!
    private var model = Model()
    
    public var uniqueId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private let regExp = try! NSRegularExpression(pattern: "http(s?)://([^/]*)/", options: [])
    private let group = DispatchGroup()
    // max width or height
    public var maxPixel = Int(1000)
    
    func upload(prefix: String, files: [Any], suffix: String = "jpeg") -> Single<[String]> {
        var suffix = suffix
        
        let queue = DispatchQueue(label: "com.sxb.cargod.uploadaliyun")
        let timeInterval = Int64(NSDate().timeIntervalSince1970)
        var keys: [String] = Array(repeating: "", count: files.count)
        var err: Error?
        
        for i in files.indices {
            let index = i
            var any = files[index]
            let group = DispatchGroup()
            var url: URL?
            switch any {
            case is Data:
                break
            case is String, is URL:
                let text: String = {
                    if let text = any as? String {
                        return text
                    }
                    if let url = any as? URL {
                        return url.isFileURL ? url.relativePath : url.relativeString
                    }
                    fatalError()
                }()
                let value = regExp.stringByReplacingMatches(in: text,
                                                            options: .anchored,
                                                            range: NSRange(location: 0, length: text.count),
                                                            withTemplate: "")
                suffix = (text as NSString).pathExtension
                if value.starts(with: "http") {
                    keys[index] = text
                    continue
                } else {
                    any = URL(fileURLWithPath: value)
                }

            // MARK: UIImage
            case let image as UIImage:
                any = image

            // MARK: PHAsset
            case let asset as PHAsset:
                let manager = PHCachingImageManager.default()
                switch asset.mediaType {
                case .unknown:
                    continue
                case .image:
                    var targetSize: CGSize?
                    if asset.pixelWidth > maxPixel || asset.pixelHeight > maxPixel {
                        var ratio = CGFloat(1)
                        if asset.pixelWidth > asset.pixelHeight {
                            ratio = CGFloat(maxPixel) / CGFloat(asset.pixelWidth)
                        } else {
                            ratio = CGFloat(maxPixel) / CGFloat(asset.pixelHeight)
                        }
                        targetSize = CGSize(width: CGFloat(asset.pixelWidth) * ratio,
                                            height: CGFloat(asset.pixelHeight) * ratio)
                    }

                    let options = PHImageRequestOptions()
                    options.resizeMode = PHImageRequestOptionsResizeMode.fast
                    options.isNetworkAccessAllowed = true
                    options.isSynchronous = true
                    manager.requestImage(for: asset,
                                         targetSize: targetSize ?? PHImageManagerMaximumSize,
                                         contentMode: PHImageContentMode.aspectFill,
                                         options: options,
                                         resultHandler: { image, info in
                                             if targetSize == nil,
                                                 asset.mediaSubtypes == PHAssetMediaSubtype.photoScreenshot {
                                                 url = info!["PHImageFileURLKey"] as? URL
                                             } else {
                                                 any = image!
                                             }
                    })
                case .video:
                    let options = PHVideoRequestOptions()
                    options.version = .original
                    group.enter()
                    manager.requestAVAsset(forVideo: asset,
                                           options: options,
                                           resultHandler: { asset, _, _ in
                                               let urlAsset = asset! as! AVURLAsset
                                               url = urlAsset.url
                                               group.leave()
                    })
                case .audio:
                    continue
                @unknown default:
                    fatalError()
                }
            default:
                continue
            }
            
            self.group.enter()
            group.notify(queue: queue) {
                if url != nil {
                    suffix = (url!.relativeString as NSString).pathExtension
                }
                let key = String(format: "%@/iOS-%@-%ld-%d.%@", prefix, self.uniqueId, timeInterval, index, suffix)
                keys[index] = key

                self.upload(name: key, any: any) { (result) in
                    switch result {
                    case .success(let result):
                        keys[index] = result.location
                    case .failure(let error):
                        err = error
                    }
                    self.group.leave()
                }
            }
        }
        
        MessageModule.showHUD(text: "上传中...")
        return Single.create { (observer) -> Disposable in
            self.group.notify(queue: DispatchQueue.main) {
                MessageModule.hideHUD()
                if let err = err {
                    observer(.failure(err))
                    MessageModule.showMessage(err)
                } else {
                    observer(.success(keys))
                }
            }
            return Disposables.create {
                
            }
        }
    }
    
    func upload(name: String,
                any: Any,
                progress: ((Float) -> Void)? = nil,
                complete: @escaping (Result<QCloudUploadObjectResult, Error>) -> Void) {
        let uploadRequest = self.newRequest(key: name, any: any)
        
        uploadRequest.setFinish { (result, error) in
            if let result = result {
                complete(.success(result))
            } else {
                complete(.failure(error!))
            }
        }
        
        if let progress = progress {
            uploadRequest.sendProcessBlock = { (_ bytesSent , totalBytesSent , totalBytes) in
                let value = Float(totalBytesSent) / Float(totalBytes)
                progress(value)
            }
        }
        
        QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(uploadRequest)
    }
    
    private func newRequest(key: String, any: Any) -> QCloudCOSXMLUploadObjectRequest<AnyObject> {
        let request = QCloudCOSXMLUploadObjectRequest<AnyObject>()
        request.object = key
        request.bucket = "echat-1302656840"
        
        let suffix = (key as NSString).pathExtension.lowercased()
        
        func mimeTypeFor(`extension`: String) -> String {
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, `extension` as NSString, nil)?.takeRetainedValue() {
                if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                    return mimetype as String
                }
            }
            return "application/octet-stream"
        }
        
        request.contentType = mimeTypeFor(extension: suffix)

        request.body = {
            switch any {
            case let url as URL:
                return url as AnyObject
            case let data as Data:
                return data as AnyObject
            case let image as UIImage:
                return image.jpegData(compressionQuality: 0.8)! as AnyObject
            default:
                fatalError("")
            }
        }()
        return request
    }
}

extension QCloudModule {
    func thumbnail(url: String, max: Int = 300) -> String {
        return url + "?imageView2/2/w/\(max)/h/\(max)"
    }
}

// MARK: - QCloudSignatureProvider
extension QCloudModule: QCloudSignatureProvider {
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        
        self.credentailFenceQueue.performAction { (creator, error) in
            let signature = creator?.signature(forData: urlRequst)
            continueBlock(signature, error)
        }
        
    }
}

// MARK: - QCloudCredentailFenceQueueDelegate
extension QCloudModule: QCloudCredentailFenceQueueDelegate {
    func fenceQueue(_ queue: QCloudCredentailFenceQueue!, requestCreatorWithContinue continueBlock: QCloudCredentailFenceQueueContinue!) {
        reqCredential(continueBlock: continueBlock)
    }
}

extension QCloudModule {

    fileprivate var credential: QCloudAuthentationV5Creator {
        let credential = QCloudCredential()
        credential.secretID = model.credentials.tmpSecretId
        credential.secretKey = model.credentials.tmpSecretKey
        credential.token = model.credentials.token
        credential.startDate = Date(timeIntervalSince1970: model.startTime)
        credential.experationDate = Date(timeIntervalSince1970: model.expiredTime - 600)
        
        let creator = QCloudAuthentationV5Creator(credential: credential)!
        return creator
    }
    
    fileprivate func reqCredential(continueBlock: @escaping QCloudCredentailFenceQueueContinue) {
        OIMManager.getTencentOssCredentials { result in
            switch result {
            case .success(let str):
                struct Internal: Decodable {
                    var bucket = ""
                    var region = ""
                    var data = Model()
                }
                let model = try! JSONDecoder().decode(Internal.self, from: str.data(using: .utf8)!)
                self.model = model.data
                continueBlock(self.credential, nil)
            case .failure(let err):
                continueBlock(nil, err)
            }
        }
    }
    
}
