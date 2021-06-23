//
//  IMImageViewController.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/17.
//

import UIKit

public class IMImageViewController: IMMediaViewController, UIScrollViewDelegate {
    
    public lazy var imageView = MessageImageView()
    
    public lazy var scrollView: IMScrollView = {
        let scrollView = IMScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return scrollView
    }()
    
    public lazy var progressView: ProgressView = {
        let progressView = ProgressView()
        progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return progressView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        scrollView.backgroundColor = .black
        
        scrollView.imageView = imageView
        scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        
        progressView.frame = view.bounds
        view.addSubview(progressView)
        
        imageView.setImage(with: url) { [weak self] progress in
            self?.progressView.progress = progress
        } completionHandler: { [weak self] image in
            guard let self = self else { return }
            if image != nil {
                self.scrollView.setNeedsLayout()
            } else {
                
            }
            self.progressView.isHidden = true
        }

    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
