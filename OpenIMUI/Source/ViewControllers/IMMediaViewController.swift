//
//  IMMediaViewController.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/21.
//

import UIKit

open class IMMediaViewController: UIViewController {
    
    public let url: URL
    
    public init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var saveBackgroundImage: UIImage?
    private var saveShadowImage: UIImage?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBackgroundImage = navigationController?.navigationBar.backgroundImage(for: .default)
        saveShadowImage = navigationController?.navigationBar.shadowImage
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.setBackgroundImage(saveBackgroundImage, for: .default)
            navigationController?.navigationBar.shadowImage = saveShadowImage
        }
    }

}
