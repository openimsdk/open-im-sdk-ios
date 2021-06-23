//
//  IMAudioWaverView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/12.
//

import UIKit

public class IMAudioWaverView: UIView {
    
    private var phase: CGFloat = 0
    var level: CGFloat = 0 {
        didSet {
            phase += phaseShift
            amplitude = max(level, idleAmplitude)
            updateMeters()
        }
    }
    
    var numberOfWaves = 5
    var frequency: CGFloat = 1.2
    var amplitude: CGFloat = 1
    var idleAmplitude: CGFloat = 0.1
    var phaseShift: CGFloat = -0.25
    var density: CGFloat = 1
    var mainWaveWidth: CGFloat = 2
    var decorativeWavesWidth: CGFloat = 1
    
    var waveColor = UIColor.white
    private var waves: [CAShapeLayer] = []
    
    private var displayLink: CADisplayLink?
    private var callback: ((_ waver: IMAudioWaverView) -> Void)?
    func setWaverLevel(callback: @escaping (_ waver: IMAudioWaverView) -> Void) {
        self.callback = callback
        
        invalidate()
        
        displayLink = CADisplayLink(target: self, selector: #selector(invokeWaveCallback))
        displayLink?.add(to: RunLoop.current, forMode: .common)
        
        for index in 0..<numberOfWaves {
            let waveline = CAShapeLayer()
            waveline.lineCap = .butt
            waveline.lineJoin = .round
            waveline.strokeColor = UIColor.clear.cgColor
            waveline.fillColor = UIColor.clear.cgColor
            waveline.lineWidth = index == 0 ? self.mainWaveWidth : self.decorativeWavesWidth
            let progress = 1 - CGFloat(index) / CGFloat(self.numberOfWaves)
            let multiplier = min(1, progress / 3 * 2 + 1.0 / 3)
            let color = self.waveColor.withAlphaComponent(index == 0 ? 1 : 1 * multiplier * 0.4)
            waveline.strokeColor = color.cgColor
            self.layer.addSublayer(waveline)
            self.waves.append(waveline)
        }
    }

    private func updateMeters() {
        let waveHeight = bounds.height
        let waveWidth = bounds.width
        let waveMid = waveWidth / 2
        let maxAmplitude = waveHeight - 4
        
        UIGraphicsBeginImageContext(self.frame.size)
        for index in 0..<numberOfWaves {
            let wavelinePath = UIBezierPath()
            
            let progress = 1 - CGFloat(index) / CGFloat(self.numberOfWaves)
            let normedAmplitude = (1.5 * progress - 0.5) * self.amplitude
            
            var x: CGFloat = 0
            while x < waveWidth + self.density {
                let scaling: CGFloat = -pow(x / waveMid  - 1, 2) + 1
                
                let y = scaling * maxAmplitude * normedAmplitude * sin(2 * CGFloat.pi * (x / waveWidth) * self.frequency + self.phase) + waveHeight * 0.5
                
                if x == 0 {
                    wavelinePath.move(to: CGPoint(x: x, y: y))
                } else {
                    wavelinePath.addLine(to: CGPoint(x: x, y: y))
                }
                
                x += self.density
            }
            
            let waveline = self.waves[index]
            waveline.path = wavelinePath.cgPath
        }
        
        UIGraphicsEndImageContext()
    }
    
    @objc private func invokeWaveCallback() {
        callback?(self)
    }
    
    func invalidate() {
        displayLink?.invalidate()
        displayLink = nil
        
        waves.forEach { (shapeLayer) in
            shapeLayer.removeFromSuperlayer()
        }
        waves.removeAll()
    }
    
    deinit {
        invalidate()
    }

}
