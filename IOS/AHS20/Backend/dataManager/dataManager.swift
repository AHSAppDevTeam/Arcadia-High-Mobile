//
//  dataManager.swift
//  AHS20
//
//  Created by Richard Wei on 12/15/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import Firebase

class dataManager {
    static internal var ref: DatabaseReference!; // database reference
    static public var internetConnected = false;
    
    static public var homeArticleList = [[articleData]](repeating: [articleData](), count: 3); // size of 4 rows, featured, asb, sports, district
    static public var bulletinArticleList = [[bulletinArticleData]](repeating: [bulletinArticleData](), count: 6); // size of 6 rows, seniors, colleges, events, athletics, reference, and others
    
    static public func setUpConnection(){
        if (Reachability.isConnectedToNetwork()){
            internetConnected = true;
            Database.database().goOnline();
            ref = Database.database().reference();
        }
        else{
            internetConnected = false;
            Database.database().goOffline();
            ref = nil;
        }
    }
    
    static public func bulletinDataToarticleData(data: bulletinArticleData) -> articleData{
        var temp = articleData();
        temp.articleAuthor = nil;
        temp.articleBody = data.articleBody;
        temp.articleUnixEpoch = data.articleUnixEpoch;
        temp.articleID = data.articleID;
        temp.articleImages = [];
        temp.articleTitle = data.articleTitle;
        temp.articleCatagory = data.articleCatagory;
        temp.hasHTML = data.hasHTML;
        return temp;
    }
    
    
    static public func updateSubscriptionNotifs(){
        let topics = ["general", "asb", "district", "bulletin"];
        if (notificationFuncClass.selectedNotifications[0] == true){
            for topic in topics{
                Messaging.messaging().subscribe(toTopic: topic);
            }
        }
        else{
            for i in 1...4{
                if (notificationFuncClass.selectedNotifications[i] == true){
                    Messaging.messaging().subscribe(toTopic: topics[i-1]);
                }
                else{
                    Messaging.messaging().unsubscribe(fromTopic: topics[i-1]);
                }
            }
        }
        Messaging.messaging().subscribe(toTopic: "mandatory");
    }

    static public func bulletinArrayHasData() -> Bool{
        for i in bulletinArticleList{
            if (i.count > 0){
                return true;
            }
        }
        return false;
    }
    
}
