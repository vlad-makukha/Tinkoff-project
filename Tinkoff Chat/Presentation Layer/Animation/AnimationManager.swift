//
//  AnimationManager.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 02.12.2021.
//

import UIKit

class AnimationManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: Double
    var originFrame = CGRect.zero
    
    init(duration: Double) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let toView = transitionContext.view(forKey: .to)
            else { transitionContext.completeTransition(false)
                return }
        
        let finalFrame = toView.frame
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        toView.transform = scaleTransform
        toView.center = CGPoint(
            x: originFrame.midX,
            y: originFrame.midY)
        toView.clipsToBounds = true
        toView.layer.cornerRadius = 20.0
        toView.layer.masksToBounds = true
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            animations: {
                toView.transform = .identity
                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                toView.layer.cornerRadius = 20.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}
