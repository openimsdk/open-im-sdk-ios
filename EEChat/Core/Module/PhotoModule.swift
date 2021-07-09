//
//  PhotoModule.swift
//  EEChat
//
//  Created by Snow on 2021/3/29.
//

import Foundation
import Photos
import TZImagePickerController
import YBImageBrowser
import Kingfisher

private class BrowserVC: UIViewController {
    var array: [YBIBDataProtocol] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let browser = YBImageBrowser()
        browser.defaultToolViewHandler!.topView.operationType = .save
        browser.dataSourceArray = array
        browser.currentPage = index
        browser.show(to: self.view)
        
        _ = browser.rx.sentMessage(#selector(YBImageBrowser.hide))
            .subscribe(onNext: { [weak self] _ in
                if let self = self {
                    NavigationModule.shared.dismiss(self)
                }
            })
    }
    
    static func show(array: [YBIBDataProtocol], index: Int = 0) {
        let vc = BrowserVC()
        vc.array = array
        vc.index = index
        NavigationModule.shared.presentOver(vc)
    }
}

public final class PhotoModule: NSObject {
    @objc public static let shared = PhotoModule()
    private override init() {}
    
    public func showPhoto(_ datas: [Any], index: Int = 0, fromView: UIView? = nil) {
        let array = datas.map { (any) -> YBIBImageData in
            let data = YBIBImageData()
            data.projectiveView = fromView
            switch any {
            case let str as String:
                data.imageURL = URL(string: str)
            case let url as URL:
                data.imageURL = url
            case let image as UIImage:
                data.image = {
                    image
                }
            case let asset as PHAsset:
                data.imagePHAsset = asset
            default:
                fatalError()
            }
            return data
        }

        BrowserVC.show(array: array, index: index)
    }
    
    private var cameraCallback: ((UIImage) -> Void)?
    func showCamera(callback: @escaping (UIImage) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { (hasAccess) in
            DispatchQueue.main.async {
                if hasAccess {
                    self.cameraCallback = callback
                    
                    let vc = UIImagePickerController()
                    vc.delegate = self
                    vc.allowsEditing = false
                    vc.sourceType = .camera
                    NavigationModule.shared.present(vc: vc)
                } else {
                    MessageModule.showMessage(LocalizedString("Permission denied"))
                }
            }
        }
    }

    private func getPicker(type: PHAssetMediaType, maxImagesCount: Int, allowTake: Bool) -> TZImagePickerController {
        let pickerVC = TZImagePickerController(maxImagesCount: maxImagesCount,
                                               columnNumber: 4,
                                               delegate: nil)!

        pickerVC.autoDismiss = true
        pickerVC.showPhotoCannotSelectLayer = true
        pickerVC.allowPickingOriginalPhoto = false

        pickerVC.allowPickingGif = false
        pickerVC.allowPickingImage = false
        pickerVC.allowPickingVideo = false

        switch type {
        case .unknown:
            pickerVC.allowPickingImage = true
            pickerVC.allowPickingVideo = true
            pickerVC.allowTakePicture = allowTake
            pickerVC.allowTakeVideo = allowTake
        case .image:
            pickerVC.allowPickingImage = true
            pickerVC.allowTakePicture = allowTake
        case .video:
            pickerVC.allowPickingVideo = true
            pickerVC.allowTakeVideo = allowTake
            pickerVC.allowPickingOriginalPhoto = true
            pickerVC.videoMaximumDuration = 300
            pickerVC.uiImagePickerControllerSettingBlock = { vc in
                vc?.videoQuality = UIImagePickerController.QualityType.typeMedium
            }
        case .audio:
            break
        @unknown default:
            fatalError()
        }

        return pickerVC
    }

    @objc public func showPicker(type: PHAssetMediaType,
                                 selected: [Any],
                                 maxCount: Int,
                                 allowTake: Bool,
                                 callback: (([Any], [Any]) -> Void)?) {
        let assets = selected.filter { (any) -> Bool in
            any is PHAsset
        }.map { $0 as! PHAsset }

        let pickerVC = getPicker(type: type,
                                 maxImagesCount: maxCount - selected.count + assets.count,
                                 allowTake: allowTake)
        pickerVC.selectedAssets = NSMutableArray(array: assets)

        pickerVC.didFinishPickingPhotosHandle = { _, anys, _ in
            let result = anys! as! [PHAsset]
            let keep = assets.filter { (asset) -> Bool in
                result.contains(asset)
            }
            var allKeep = selected.filter { (any) -> Bool in
                if let asset = any as? PHAsset {
                    return keep.contains(asset)
                }
                return true
            }
            let add = result.filter { (asset) -> Bool in
                !keep.contains(asset)
            }
            if allKeep.count != selected.count || add.count != 0 {
                allKeep.append(contentsOf: add)
                callback?(allKeep, add)
            }
        }

        NavigationModule.shared.presentCustom(pickerVC, animated: true)
    }

    @objc public func showPicker(type: PHAssetMediaType = .image, allowTake: Bool, allowCrop: Bool, cropSize: CGSize, callback: ((UIImage, PHAsset) -> Void)?) {
        let pickerVC = getPicker(type: type, maxImagesCount: 1, allowTake: allowTake)
        pickerVC.allowCrop = allowCrop

        let x = (UIScreen.main.bounds.width - cropSize.width) / 2
        let y = (UIScreen.main.bounds.height - cropSize.height) / 2
        pickerVC.cropRect = CGRect(origin: CGPoint(x: x, y: y), size: cropSize)

        pickerVC.didFinishPickingPhotosHandle = { images, anys, _ in
            let assets = anys! as! [PHAsset]
            callback?(images!.first!, assets.first!)
        }

        NavigationModule.shared.presentCustom(pickerVC, animated: true)
    }
    
    public func batchDownloader(urls: [URL], completionHandler: (([UIImage]) -> Void)? = nil) {
        ImagePrefetcher(urls: urls) { skippedResources, _, completedResources in
            if let completionHandler = completionHandler {
                MessageModule.showHUD(text: LocalizedString("Downloading..."))
                var array: [UIImage] = []

                let group = DispatchGroup()

                var result = skippedResources
                result.append(contentsOf: completedResources)
                for info in result {
                    group.enter()
                    ImageCache.default.retrieveImageInDiskCache(forKey: info.cacheKey, completionHandler: { result in
                        switch result {
                        case let .success(image):
                            if let image = image {
                                array.append(image)
                            }
                        case .failure:
                            break
                        }
                        group.leave()
                    })
                }

                group.notify(queue: DispatchQueue.main, execute: {
                    MessageModule.hideHUD()
                    completionHandler(array)
                })
            }
        }.start()
    }
    
    func writeToSavedPhotosAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

extension PhotoModule: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        let originalImage = info[.originalImage] as! UIImage
        let image = UIImage.fixedOrientation(for: originalImage)
        self.cameraCallback?(image ?? originalImage)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotoModule {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            MessageModule.showMessage(LocalizedString("Save failed"))
        } else {
            MessageModule.showMessage(LocalizedString("Save success"))
        }
    }
}

extension PhotoModule: UINavigationControllerDelegate {}
