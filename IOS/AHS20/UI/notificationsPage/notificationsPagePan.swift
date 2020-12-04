//
//  notificationsPagePan.swift
//  AHS20
//
//  Created by Richard Wei on 12/4/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension notificationsClass{
    internal func transition(to controller: UIViewController) {
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
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
