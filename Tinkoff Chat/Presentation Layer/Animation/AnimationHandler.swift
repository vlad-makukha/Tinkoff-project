//
//  AnimationHandler.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 02.12.2021.
//

import Foundation
import UIKit

final class AnimationHandler: NSObject, UIGestureRecognizerDelegate {
    
    private lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.fillMode = .removed
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 5
        emitterCell.velocity = 10
        emitterCell.velocityRange = 10
        emitterCell.alphaSpeed = -0.5
        emitterCell.lifetime = 0.5
        emitterCell.scale = 0.1
        emitterCell.emissionRange = CGFloat.pi
        let emblem = #imageLiteral(resourceName: "emblem")
        emitterCell.contents = emblem.cgImage
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }()
    
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Public
    
    func setupTapGesture() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(recognizer:)))
        gestureRecognizer.minimumPressDuration = 0.001
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        self.window?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        guard let window = self.window else {
            assertionFailure("Try to use hande without window")
            return
        }
        
        switch recognizer.state {
        case .began:
            self.emitterLayer.emitterPosition = recognizer.location(in: window)
            window.layer.addSublayer(self.emitterLayer)
        case .changed:
            self.emitterLayer.emitterPosition = recognizer.location(in: window)
        case .ended:
            self.emitterLayer.removeFromSuperlayer()
            self.emitterLayer.removeAllAnimations()
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
