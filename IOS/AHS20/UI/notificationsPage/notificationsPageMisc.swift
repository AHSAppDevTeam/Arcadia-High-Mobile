//
//  notificationsPageMisc.swift
//  AHS20
//
//  Created by Richard Wei on 12/4/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension notificationsClass{
    
    internal func typeIDToString(id: Int) -> String{
        if (id == 0){
            return "Mandatory";
        }
        else if (id == 1){
            return "General";
        }
        else if (id == 2){
            return "ASB";
        }
        else if (id == 3){
            return "District";
        }
        else{
            return "Bulletin";
        }
    }
    
    internal func notificationSort(a: notificationData, b: notificationData)->Bool{
        let currTime = Int64(NSDate().timeIntervalSince1970);
        if (a.notificationUnixEpoch ?? INT64_MAX > currTime && b.notificationUnixEpoch ?? INT64_MAX > currTime){
            return (a.notificationUnixEpoch ?? INT64_MAX) < (b.notificationUnixEpoch ?? INT64_MAX);
        }
        else{
            return (a.notificationUnixEpoch ?? INT64_MAX) > (b.notificationUnixEpoch ?? INT64_MAX);
        }
    }
    
    @objc internal func refreshNotifications(){
        // implement get data
        //  loadNotificationPref();
        loadNotifPref();
        getLocalNotifications();
        
    }
    
    @IBAction internal func handlePan(_ gestureRecognizer: UIPanGestureRecognizer){
       //print("got pan")
        if (gestureRecognizer.state == .began || gestureRecognizer.state == .changed){
            let translation = gestureRecognizer.translation(in: self.view);
            //print("translation - \(translation)")
            
            self.view.frame = CGRect(x: max(self.view.frame.minX + translation.x, 0), y: 0, width: self.view.frame.width, height: self.view.frame.height);
            
            gestureRecognizer.setTranslation(.zero, in: self.view);
        }
        else if (gestureRecognizer.state == .ended){
            let thresholdPercent : CGFloat = 0.25; // if minx > thresholdPercent * uiscreen.main.bounds.width
            if (self.view.frame.minX >= thresholdPercent * UIScreen.main.bounds.width){
                dismiss(animated: true);
            }
            else{
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            }
        }
    }
    
    @IBAction internal func exitPopup(_ sender: UIButton) {
        
        //     unreadNotif = (notificationList[1].count > 0);
        dismiss(animated: true);
    }
    
    
}
