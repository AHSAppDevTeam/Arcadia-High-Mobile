//
//  popTransition.swift
//  AHS20
//
//  Created by Richard Wei on 12/10/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

open class popTransition: NSObject, UIViewControllerAnimatedTransitioning{
    
    private let duration: TimeInterval;
    
    public init(duration: TimeInterval = 0.25) {
        self.duration = duration;
        super.init();
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration;
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return;
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred();
        
        /*if self.type == .navigation, let toViewController = transitionContext.viewController(forKey: .to) {
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }*/

        //print("pop")
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height);
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
