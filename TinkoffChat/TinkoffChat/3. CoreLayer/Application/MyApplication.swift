//
//  MyApplication.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 25.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

@objc(MyApplication) class MyApplication: UIApplication {
    var logoSpreader = LogoSpreader()
    
    override func sendEvent(_ event: UIEvent) {
        
        if event.type != .touches {
            super.sendEvent(event)
            return
        }
        
        var restartTimer = true
        var touch: UITouch?
        
        if let touches = event.allTouches {
            
            if let first = touches.first {
                touch = first
            }
            for touch in touches.enumerated() {
                if touch.element.phase != .cancelled && touch.element.phase != .ended {
                    restartTimer = false
                    break
                }
            }
        }
        
        if restartTimer {
            if let _ = touch {
                logoSpreader.stopSpreadingLogos()
            }
        } else {
            if let touch = touch {
                logoSpreader.startSpreadingLogos(with: touch)
            }
        }
        super.sendEvent(event)
    }
    
}
