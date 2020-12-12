//
//  transitionClass.swift
//  AHS20
//
//  Created by Richard Wei on 12/8/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

//https://theswiftdev.com/ios-custom-transition-tutorial-in-swift/

final class transitionDelegate : NSObject, UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pushTransition();
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popTransition();
    }
}
