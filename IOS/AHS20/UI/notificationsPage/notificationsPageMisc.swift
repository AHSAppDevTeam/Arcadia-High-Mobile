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
        notificationFuncClass.loadNotifPref();
        getLocalNotifications();
        
    }
    
    @IBAction internal func handlePan(_ gestureRecognizer: UIPanGestureRecognizer){
       //print("got pan")
        popTransition.handlePan(gestureRecognizer, fromViewController: self);
    }
    
    @IBAction internal func exitPopup(_ sender: UIButton) {
        dismiss(animated: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated);
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateNotifDot"), object: nil);
    }
    
}
