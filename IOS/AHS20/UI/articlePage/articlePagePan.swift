//
//  articlePagePan.swift
//  AHS20
//
//  Created by Richard Wei on 12/4/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension articlePageClass{
    internal func transitionDismissal() {
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: nil)
        dismiss(animated: false)
    }
    
    
    @objc internal func gestureAction(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let fingerMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(fingerMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        switch sender.state {
        case .began:
            
            interactor?.hasStarted = true
            dismiss(animated: true)
            
        case .changed:
            
            interactor?.shouldFinish = progress > percentThreshold
            interactor?.update(progress)
            
        case .cancelled:
            
            interactor?.hasStarted = false
            interactor?.cancel()
            
        case .ended:
            
            guard let interactor = interactor else { return }
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
            
        default:
            break
        }
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            return scrollView.contentOffset.x == 0;
        }
        return false
    }
    
}
