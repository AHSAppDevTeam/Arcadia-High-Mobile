//
//  dataManager_notification.swift
//  AHS20
//
//  Created by Richard Wei on 12/15/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import Firebase

extension dataManager{
    static internal func getNotificationDataBranch(completion: @escaping (notificationData) -> Void){ // this assumes that setUpConnection has already been done
        
        ref.child("notifications").observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children;
            while let article = enumerator.nextObject() as? DataSnapshot{ // each article
                let enumerator = article.children;
                var singleNotification = notificationData();
                singleNotification.messageID = article.key;
                while let notificationContent = enumerator.nextObject() as? DataSnapshot{ // data inside article
                    
                    if (notificationContent.key == "notificationArticleID"){
                        singleNotification.notificationArticleID  = notificationContent.value as? String;
                    }
                    else if (notificationContent.key == "notificationBody"){
                        singleNotification.notificationBody  = notificationContent.value as? String;
                    }
                    else if (notificationContent.key == "notificationTitle"){
                        singleNotification.notificationTitle  = notificationContent.value as? String;
                    }
                    else if (notificationContent.key == "notificationUnixEpoch"){
                        singleNotification.notificationUnixEpoch  = notificationContent.value as? Int64;
                    }
                    else if (notificationContent.key == "notificationCategory"){
                        singleNotification.notificationCatagory = notificationContent.value as? Int;
                    }
                }
                completion(singleNotification);
            }
        };
        
    }
    
    static public func getNotificationData(completion: @escaping (Bool) -> Void){
        
        dataManager.setUpConnection();
        if (dataManager.internetConnected){
            //homeClass.featuredArticles = [articleData]();
            //homeArticleList = [[articleData]](repeating: [articleData](), count: 3);
            notificationsClass.totalNotificationList = [notificationData]();
            
            getNotificationDataBranch(completion: { (data) in
                notificationsClass.totalNotificationList.append(data);
                completion(true);
            });
        }
        else{
            completion(false);
        }
        
    }
    
}
