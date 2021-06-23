//
//  IMRecordView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/12.
//

import UIKit
import AVFoundation

public protocol IMRecordViewDelegate: AnyObject {
    func recordView(_ recordView: IMRecordView, finish url: URL)
}

open class IMRecordView: UIView {
    
    enum State {
        case begin
        case preCancel
        case preDone
        case cancel
        case done
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        recordAnimationView.removeFromSuperview()
    }
    
    public weak var delegate: IMRecordViewDelegate?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 0.11, green: 0.45, blue: 0.93, alpha: 1)
        
        addSubview(label)
        let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = label.centerYAnchor.constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate([centerX, centerY])
        
        return label
    }()
    
    lazy var recordAnimationView = IMRecordAnimationView()
    
    private func setupAnimationView() {
        let view = recordAnimationView
        guard view.superview == nil else {
            return
        }
        
        var vc: UIViewController?
        var superview = self.superview
        while superview != nil, vc == nil {
            vc = superview?.next as? IMConversationViewController
            superview = superview?.superview
        }
        
        guard let vc = vc else {
            return
        }
        
        vc.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = view.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor)
        let centerY = view.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: -50)
        NSLayoutConstraint.activate([centerX, centerY])
    }
    
    private func setupView() {
        layer.cornerRadius = 4
        
        backgroundColor = .white
        label.text = LocalizedString("Hold to Talk")
    }
    
    var state = State.done {
        didSet {
            if state == oldValue {
                return
            }
            
            switch state {
            case .begin:
                setupAnimationView()
                backgroundColor = UIColor(red: 0xE3 / 255, green: 0xE3 / 255, blue: 0xE3 / 255, alpha: 1)
                label.text = LocalizedString("Release to send")
                recordAnimationView.isHidden = false
                recordAnimationView.label.text = LocalizedString("Swipe up cancel")
                recordAnimationView.waverView.setWaverLevel { [weak self] (waverView) in
                    guard let recorder = self?.recorder else {
                        return
                    }
                    recorder.updateMeters()
                    let normalizedValue = pow(10, recorder.averagePower(forChannel: 0) / 40)
                    waverView.level = CGFloat(normalizedValue)
                }
                record()
            case .preCancel:
                label.text = LocalizedString("Release to cancel")
                recordAnimationView.label.text = LocalizedString("Swipe down to send")
            case .preDone:
                label.text = LocalizedString("Release to send")
                recordAnimationView.label.text = LocalizedString("Swipe up to cancel")
            case .cancel, .done:
                backgroundColor = .white
                label.text = LocalizedString("Hold to Talk")
                recorder?.stop()
                recordAnimationView.isHidden = true
                recordAnimationView.waverView.invalidate()
            }
        }
    }
    
    // MARK: - Override
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .begin
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .cancel || state == .done {
            return
        }
        
        if touches.count == 1, let touch = touches.first {
            let point = touch.location(in: self)
            if point.y < -50 {
                state = .preCancel
            } else {
                state = .preDone
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .done
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .cancel
    }
    
    // MARK: - Recorder
    private var recorder: AVAudioRecorder?
    public var maxDuration: TimeInterval? = 60
}

extension IMRecordView {
    func record() {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                self._record()
            } else {
                self.state = .cancel
            }
        }
    }
    
    private func _record() {
        let filePath = NSTemporaryDirectory().appending("/IM/record/" + NSUUID().uuidString + ".wav")
        let url = URL(fileURLWithPath: filePath)

        let fileManager = FileManager.default
        let dir = url.deletingLastPathComponent().path
        if !fileManager.fileExists(atPath: dir) {
            try? fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
        }

        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true)
        } catch {
            Logger.error(error, type: Self.self)
        }

        let setting: [String: Any] = [
            AVSampleRateKey: NSNumber(value: 8000),
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
            AVLinearPCMBitDepthKey: NSNumber(value: 32), // 8、16、24、32
            AVNumberOfChannelsKey: NSNumber(value: 1),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue),
        ]

        do {
            let recorder = try AVAudioRecorder(url: url, settings: setting)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            if let duration = maxDuration {
                recorder.record(forDuration: duration)
            } else {
                recorder.record()
            }
            self.recorder = recorder
        } catch {
            Logger.error(error, type: Self.self)
        }
    }
}

extension IMRecordView: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        switch state {
        case .preCancel:
            state = .cancel
        case .preDone:
            state = .done
            fallthrough
        case .done:
            if flag {
                delegate?.recordView(self, finish: recorder.url)
            }
        default:
            break
        }
    }

    public func audioRecorderEncodeErrorDidOccur(_: AVAudioRecorder, error: Error?) {
        self.state = .cancel
        Logger.error(error as Any, type: Self.self)
    }
}
