//
//  tabBarExtensions.swift
//  AHS20
//
//  Created by Richard Wei on 12/2/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit


// pan gesture functions
extension tabBarClass{
    
    internal func transition(to controller: UIViewController) {
        transitionCA.duration = 0.2
        transitionCA.type = CATransitionType.push
        transitionCA.subtype = CATransitionSubtype.fromRight
        view.window?.layer.add(transitionCA, forKey: kCATransition)
        present(controller, animated: false)
    }
    
    internal func animationController(
        forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return DismissAnimator()
    }
    
    internal func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            
            return interactor.hasStarted
                ? interactor
                : nil
    }
}


