//
//  LogoSpreader.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 25.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class LogoSpreader {
    
    var logos: [UIImageView]?
    var timer: Timer?
    var touched = false
    var view: UIView?
    var window: UIWindow?
    
    func randomGeneratorForPosition(value: Float) -> Float {
        let invert: Bool = arc4random_uniform(2) == 1
        return value * (invert ? 0.9 : 1.9)
    }
    
    func animateImageOpacityAndPosition(view: UIView) {
        let positionAnimate = CABasicAnimation(keyPath: "position")
        let opacityAnimate = CABasicAnimation(keyPath: "opacity")
        let newPosition = CGPoint(x: CGFloat(randomGeneratorForPosition(value: Float(view.layer.position.x))), y: CGFloat(randomGeneratorForPosition(value: Float(view.layer.position.y))))
        
        positionAnimate.fromValue = view.layer.position
        positionAnimate.toValue = newPosition
        positionAnimate.duration = 4.0
        view.layer.position = newPosition
        
        opacityAnimate.fromValue = view.layer.opacity
        opacityAnimate.toValue = 0
        opacityAnimate.duration = 4.0
        view.layer.opacity = 0
        
        view.layer.add(positionAnimate, forKey: "fading")
        view.layer.add(opacityAnimate, forKey: "invisible")
    }
    
    func startSpreadingLogos(with touch: UITouch) {
        if logos == nil {
            logos = []
        }
        if timer == nil {
            self.view = touch.view
            self.window = touch.window
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                
                if var view = self.view {
                    guard let window = view.window else {
                        assertionFailure()
                        return
                    }
                    view = window.subviews[0]
                    let logo = UIImageView(frame: CGRect(origin: touch.location(in: view), size: CGSize(width: 60, height: 60)))
                    logo.image = UIImage(named: "TinLogo")
                    self.logos?.append(logo)
                    view.addSubview(logo)
                    self.animateImageOpacityAndPosition(view: logo)
                }
            })
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func stopSpreadingLogos() {
        stopTimer()
        deleteLogos()
    }
    
    func deleteLogos() {
        for logo in logos ?? [] {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute:  {
                logo.removeFromSuperview()
            })
            
        }
    }
}
