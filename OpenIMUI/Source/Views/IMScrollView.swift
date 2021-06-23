//
//  IMScrollView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/17.
//

import UIKit

open class IMScrollView: UIScrollView {
    
    private var initialImageFrame = CGRect.null
    
    public private(set) lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToZoom(_:)))
        tap.numberOfTouchesRequired = 2
        return tap
    }()

    public var imageView: MessageImageView? {
        didSet {
            if oldValue?.superview == self {
                imageView?.removeGestureRecognizer(tap)
                imageView?.removeFromSuperview()
            }
            if let imageView = imageView {
                imageView.frame = .null
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tap)
                self.addSubview(imageView)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
    }
    
    @objc
    func tapToZoom(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let imageView = self.imageView else {
            return
        }
        if self.zoomScale > self.minimumZoomScale {
            self.setZoomScale(self.minimumZoomScale, animated: true)
        } else {
            let tapLocation = gestureRecognizer.location(in: self.imageView)
            let zoomRectWidth = imageView.frame.width / self.maximumZoomScale
            let zoomRectHeight = imageView.frame.height / self.maximumZoomScale
            let zoomRectX = tapLocation.x - zoomRectWidth * 0.5
            let zoomRectY = tapLocation.y - zoomRectHeight * 0.5
            self.zoom(to: CGRect(x: zoomRectX, y: zoomRectY, width: zoomRectWidth, height: zoomRectHeight), animated: true)
        }
    }
    
    public var imageAspectRatio: CGFloat {
        if let image = imageView?.image {
            return image.size.width / image.size.height
        }
        return 1
    }
    
    public func rectSizeFor(aspectRatio: CGFloat, thatFits size: CGSize) -> CGSize {
        let containerWidth = size.width
        let containerHeight = size.height
        var resultWidth: CGFloat = 0
        var resultHeight: CGFloat = 0
        
        if aspectRatio <= 0 || containerHeight <= 0 {
            return size
        }
        
        if containerWidth / containerHeight >= aspectRatio {
            resultHeight = containerHeight;
            resultWidth = containerHeight * aspectRatio
        } else {
            resultWidth = containerWidth;
            resultHeight = containerWidth / aspectRatio
        }
        
        return CGSize(width: resultWidth, height: resultHeight)
    }
    
    func scaleImageForScrollViewTransitionFromBounds(_ oldBounds: CGRect, newBounds: CGRect) {
        let oldContentOffset = oldBounds.origin
        let oldSize = oldBounds.size
        let newSize = newBounds.size
        
        var containedImageSizeOld = rectSizeFor(aspectRatio: imageAspectRatio, thatFits: oldSize)
        let containedImageSizeNew = rectSizeFor(aspectRatio: imageAspectRatio, thatFits: newSize)
        
        if containedImageSizeOld.height <= 0 {
            containedImageSizeOld = containedImageSizeNew
        }
        
        let orientationRatio = containedImageSizeNew.height / containedImageSizeOld.height
        
        let t = CGAffineTransform().scaledBy(x: orientationRatio, y: orientationRatio)
        
        if let imageView = self.imageView {
            imageView.frame = imageView.frame.applying(t)
            self.contentSize = imageView.frame.size
        }
        
        var xOffset = (oldContentOffset.x + oldSize.width * 0.5) * orientationRatio - newSize.width * 0.5
        var yOffset = (oldContentOffset.y + oldSize.height * 0.5) * orientationRatio - newSize.height * 0.5
        
        xOffset -= max(xOffset + newSize.width - self.contentSize.width, 0)
        yOffset -= max(yOffset + newSize.height - self.contentSize.height, 0)
        xOffset += max(-xOffset, 0)
        yOffset += max(-yOffset, 0)
        
        self.contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
    
    private func setupInitialImageFrame() {
        if let imageView = imageView,
           imageView.image != nil,
           initialImageFrame == .null {
            let imageViewSize = rectSizeFor(aspectRatio: self.imageAspectRatio, thatFits: self.bounds.size)
            self.initialImageFrame = CGRect(origin: .zero, size: imageViewSize)
            self.imageView?.frame = self.initialImageFrame
            self.contentSize = self.initialImageFrame.size
        }
    }
    
    open override var contentOffset: CGPoint {
        didSet {
            let contentSize = self.contentSize
            let scrollViewSize = self.bounds.size
            
            var offset = contentOffset
            if contentSize.width < scrollViewSize.width {
                offset.x = -(scrollViewSize.width - contentSize.width) * 0.5
            }
            
            if contentSize.height < scrollViewSize.height {
                offset.y = -(scrollViewSize.height - contentSize.height) * 0.5
            }
            super.contentOffset = offset
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupInitialImageFrame()
    }
    
}
