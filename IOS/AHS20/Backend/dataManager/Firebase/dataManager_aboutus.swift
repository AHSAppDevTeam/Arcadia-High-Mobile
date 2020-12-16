//
//  dataManager_credits.swift
//  AHS20
//
//  Created by Richard Wei on 12/15/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension dataManager{
    static internal func getAboutUsDataBranch(with_branch index: Int, completion: @escaping () -> Void){ // this assumes that setUpConnection has already been done
        
        ref.child("aboutus").child(aboutUsPage.nameTitleArray[index]).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children;
            
            var currentString : String = "";
            
            while let currentName = enumerator.nextObject() as? DataSnapshot{ // each article
                
                currentString += (currentName.value as? String ?? "") + "\n";
                
            };
            
            aboutUsPage.names[index] = currentString;
            //print("current - \(currentString)");
            //self.firebaseWaitListNum -= 1;
            completion();
        }
        
    }
    
    static public func getAboutUsData(completion: @escaping (Bool) -> Void){
        
        setUpConnection();
        if (internetConnected){
            
            for index in 0..<aboutUsPage.nameTitleArray.count{
                aboutUsPage.names[index] = "";
                getAboutUsDataBranch(with_branch: index, completion: { () in
                    completion(true);
                });
            }
        }
        else{
            completion(false);
        }
        
    }
    
}
