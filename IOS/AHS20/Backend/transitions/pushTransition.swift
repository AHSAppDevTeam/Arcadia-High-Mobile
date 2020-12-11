//
//  pushTransition.swift
//  AHS20
//
//  Created by Richard Wei on 12/10/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

open class pushTransition: NSObject, UIViewControllerAnimatedTransitioning{
    private let duration: TimeInterval;
    
    public init(duration: TimeInterval = 0.2) {
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
        
        //transitionContext.containerView.insertSubview(, belowSubview: <#T##UIView#>)
        
        //print("push")
        //toViewController.view.alpha = 1;
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        //toViewController.view.alpha = 0;
        toViewController.view.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height);
        
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.frame = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height);
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
