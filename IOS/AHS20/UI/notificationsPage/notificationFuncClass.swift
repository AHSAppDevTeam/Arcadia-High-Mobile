//
//  notificationFunc.swift
//  AHS20
//
//  Created by Richard Wei on 6/20/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import SystemConfiguration
import FirebaseDatabase
import SDWebImage


class notificationFuncClass{
    // NOTIFICATION START
    //var resetUpArticles = false;
    static public var unreadNotifCount = 0;
    
    static public var selectedNotifications = [Bool](repeating: false, count: 5); // true or false 0 - 4 0 is general
    
    static public func loadNotifPref(){
        if let data = UserDefaults.standard.data(forKey: "notificationReadDict"){
            do{
                let decoder = JSONDecoder();
                notificationsClass.notificationReadDict = try decoder.decode([String:Bool].self, from: data);
            }catch{
                print("error decoding")
            }
        }
    }
    
    static public func saveNotifPref(filter: Bool){
        do{
            let encoder = JSONEncoder();
            let data = try encoder.encode(filter ? filterReadDictionary() : notificationsClass.notificationReadDict);
            UserDefaults.standard.set(data, forKey: "notificationReadDict");
        } catch{
            print("error encoding object to save");
        }
    }
    
    static private func filterReadDictionary() -> [String : Bool]{
        var currDict = [String: Bool]();
        for i in notificationsClass.totalNotificationList{
            currDict[i.messageID ?? ""] = true;
        }
        var save = [String: Bool](); // messageid
        for i in notificationsClass.notificationReadDict{
            if (currDict[i.key] == true){
                save[i.key] = true;
            }
        }
        return save;
    }
    
    static public func filterThroughSelectedNotifcations() -> [notificationData]{
        notificationFuncClass.selectedNotifications = UserDefaults.standard.array(forKey: "selectedNotifications") as? [Bool] ?? [true, false, false, false, false];
        dataManager.updateSubscriptionNotifs();
        var output = [notificationData]();
        for i in notificationsClass.totalNotificationList{
            if (notificationFuncClass.selectedNotifications[0] == true || notificationFuncClass.selectedNotifications[i.notificationCatagory ?? 0] == true || i.notificationCatagory == 0){
                output.append(i);
            }
        }
        return output;
    }
    
    static public func numOfUnreadInArray(arr: [notificationData]) -> Int{
        loadNotifPref();
        notificationFuncClass.selectedNotifications = UserDefaults.standard.array(forKey: "selectedNotifications") as? [Bool] ?? [true, false, false, false, false];
        dataManager.updateSubscriptionNotifs();
        var count = 0;
        for singleNotification in arr{
            if ((notificationFuncClass.selectedNotifications[0] == true || notificationFuncClass.selectedNotifications[singleNotification.notificationCatagory ?? 0] == true || singleNotification.notificationCatagory == 0) && notificationsClass.notificationReadDict[singleNotification.messageID ?? ""] != true){
                count += 1;
            }
        }
        return count;
    }
    
    // NOTIFICATION END
}
