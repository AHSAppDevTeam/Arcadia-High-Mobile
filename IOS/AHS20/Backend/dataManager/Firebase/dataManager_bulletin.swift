//
//  dataManager_bulletin.swift
//  AHS20
//
//  Created by Richard Wei on 12/15/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension dataManager{
    static internal func getBulletinDataBranch(with_branch index: Int, completion: @escaping (Int) -> Void){ // this assumes that setUpConnection has already been done
        
        var s: String; // path inside homepage
        switch index {
        case 0: // seniors
            s = "Academics";
            break;
        case 1: // colleges
            s = "Athletics";
            break;
        case 2: // events
            s = "Clubs";
            break;
        case 3: // athletics
            s = "Colleges";
            break;
        case 4: // reference
            s = "Reference";
            break;
        default:
            s = "";
            break;
        }
        
        ref.child("bulletin").child(s).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children;
            var temp = [bulletinArticleData](); // temporary array
            while let article = enumerator.nextObject() as? DataSnapshot{ // each article
                let enumerator = article.children;
                var singleArticle = bulletinArticleData();
                
                singleArticle.articleID = article.key;
                
                while let articleContent = enumerator.nextObject() as? DataSnapshot{ // data inside article
                    if (articleContent.key == "articleBody"){
                        singleArticle.articleBody = articleContent.value as? String;
                    }
                    else if (articleContent.key == "articleUnixEpoch"){
                        singleArticle.articleUnixEpoch = articleContent.value as? Int64;
                    }
                        
                    else if (articleContent.key == "articleTitle"){
                        singleArticle.articleTitle = articleContent.value as? String;
                    }
                    else if (articleContent.key == "hasHTML"){
                        singleArticle.hasHTML = (articleContent.value as? Int == 0 ? false : true);
                    }
                }
                singleArticle.articleCatagory = s;
                singleArticle.articleType = index;
                temp.append(singleArticle);
            }
            bulletinArticleList[index] = temp;
            completion(index);
        };
        
    }
    
    static public func getBulletinData(completion: @escaping (Bool, Int) -> Void){
        
        setUpConnection();
        if (internetConnected){
            bulletinArticleList = [[bulletinArticleData]](repeating: [bulletinArticleData](), count: 5);
            
            for i in 0...4{
                getBulletinDataBranch(with_branch: i, completion: { (index) in
                    completion(true, index);
                });
            }
        
        }
        else{
            completion(false, -1);
        }
        
    }
}
