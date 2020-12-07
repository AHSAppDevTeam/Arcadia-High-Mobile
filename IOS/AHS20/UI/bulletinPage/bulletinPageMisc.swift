//
//  bulletinPageMisc.swift
//  AHS20
//
//  Created by Richard Wei on 12/2/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension bulletinClass{
    internal func makeCustomButtonRead(button: CustomUIButton){
        //button.backgroundColor = makeColor(r: 250, g: 250, b: 250);
        button.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? BackgroundColor : dull_BackgroundColor;
        
        
        /*
         TAG LIST for UICustomUIButton:
         Main view  - 1 - subviews title and body text
         Title - 2 - uicolor.gray - UIFont(name: "SFProDisplay-Semibold",size: 16)
         Body - 3 - uicolor.gray
         Catagory - 4 - set background to makeColor(r: 144, g: 75, b: 75)
         ReadLabel - 5 - remove from superview
         */
        
        for view in button.subviews{
            switch view.tag {
            case -1:
                for subview in view.subviews{
                    switch subview.tag {
                    case 2:
                        //print("title label view - \(view)")
                        let titleLabel = subview as! UILabel;
                        titleLabel.textColor = BackgroundGrayColor;
                        titleLabel.font = UIFont(name: "SFProDisplay-Semibold",size: 16);
                    case 3:
                        let bodyText = subview as! UILabel;
                        bodyText.textColor = BackgroundGrayColor;
                    default:
                        print("unknown view tag found in makeCustomButtonRead mainView subviews - \(subview)")
                    }
                }
            case 4:
                let catagory = view as! UILabel;
                catagory.backgroundColor = dull_mainThemeColor;
            case 5:
                view.removeFromSuperview();
            default:
                break;
                //print("unknown view tag found in makeCustomButtonRead - \(view)")
            }
        }
    }
    
    @objc internal func openArticle(sender: CustomUIButton){
        if (bulletinReadDict[sender.articleCompleteData.articleID ?? ""] == nil){
            bulletinReadDict[sender.articleCompleteData.articleID ?? ""] = true;
            saveBullPref();
            //generateBulletin(); -- too resource intensive
            makeCustomButtonRead(button: sender);
        }
        let articleDataDict: [String: articleData] = ["articleContent" : sender.articleCompleteData];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
    }
    
    @objc internal func refreshBulletin(){
        //  print("refresh");
        // add func to load data
        getBulletinArticleData();
    }
    
    
}
