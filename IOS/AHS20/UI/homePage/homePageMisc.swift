//
//  homePageMiscFunc.swift
//  AHS20
//
//  Created by Richard Wei on 12/2/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension homeClass{
    internal func arrayToPairs(a: [articleData]) -> [[articleData]]{
        let b = a.sorted(by: sortArticlesByTime);
        var ans = [[articleData]]();
        var temp = [articleData](); // pairs
        for i in b{
            temp.append(i);
            if (temp.count == 2){
                ans.append(temp);
                temp = [articleData]();
            }
        }
        if (temp.count > 0){
            ans.append(temp);
        }
        return ans;
    }
    
    @objc internal func refreshAllArticles(){
        featuredLabel.text = loading;
        asbLabel.text = loading;
        generalLabel.text = loading;
        districtLabel.text = loading;
        getHomeArticleData();
    }
    
    @objc internal func openArticle(sender: CustomUIButton){
        let articleDataDict: [String: articleData] = ["articleContent" : sender.articleCompleteData];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
    }
}
