//
//  IMRecordAnimationView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/12.
//

import UIKit

public class IMRecordAnimationView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var waverView: IMAudioWaverView = {
        let view = IMAudioWaverView()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.widthAnchor.constraint(equalToConstant: 120),
            view.heightAnchor.constraint(equalToConstant: 80),
        ])
        return view
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0xC3 / 255.0, green: 0xC3 / 255.0, blue: 0xC3 / 255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: waverView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
        ])
        return label
    }()

    private func setupView() {
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 190)
        ])
    }

}
