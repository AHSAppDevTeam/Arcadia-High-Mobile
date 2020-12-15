//
//  extraFunc.swift
//  AHS20
//
//  Created by Richard Wei on 4/21/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import SystemConfiguration
import FirebaseDatabase
import SDWebImage
import Firebase


// swift file with shared functions and extensions between files

func getTitleDateAndMonth() -> String {
    let dateObj = Date();
    let calender = Calendar.current;
    let dayInt = calender.component(.day , from: dateObj);
    
    let monthInt = Calendar.current.dateComponents([.month], from: Date()).month;
    let monthStr = Calendar.current.monthSymbols[monthInt!-1];
    return String(monthStr) + " " + String(dayInt);
}



// func that returns UIcolor from rgb values
func makeColor(r: Float, g: Float, b: Float) -> UIColor{
    return UIColor.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(1.0));
}

func printFontFamilies(){
    for family in UIFont.familyNames {

        let sName: String = family as String
        print("family: \(sName)")
                
        for name in UIFont.fontNames(forFamilyName: sName) {
            print("name: \(name as String)")
        }
    }
}

var utilNeedID: String?;

func findArticleFromIDAndSegue(id: String){ // performs segue as well
    if (id == ""){
        return;
    }
    utilNeedID = id;
    /*if (homeArticleList[0].count == 0 && homeArticleList[1].count == 0 && homeArticleList[2].count == 0){ // load homepage
        setUpConnection();
        if (internetConnected){
            homeArticleList = [[articleData]](repeating: [articleData](), count: 3);
            for i in 0...2{
                var s: String; // path inside homepage
                switch i {
                case 0: // general info
                    s = "General_Info";
                    break;
                case 1: // district
                    s = "District";
                    break;
                case 2: // asb
                    s = "ASB";
                    break;
                default:
                    s = "";
                    break;
                }
                
                ref.child("homepage").child(s).observeSingleEvent(of: .value) { (snapshot) in
                    let enumerator = snapshot.children;
                    var temp = [articleData](); // temporary array
                    while let article = enumerator.nextObject() as? DataSnapshot{ // each article
                        let enumerator = article.children;
                        var singleArticle = articleData();
                        
                        singleArticle.articleID = article.key;
                        
                        while let articleContent = enumerator.nextObject() as? DataSnapshot{ // data inside article
                        
                            
                            if (articleContent.key == "articleAuthor"){
                                singleArticle.articleAuthor = articleContent.value as? String;
                            }
                            else if (articleContent.key == "articleBody"){
                                singleArticle.articleBody = articleContent.value as? String;
                            }
                            else if (articleContent.key == "articleUnixEpoch"){
                                singleArticle.articleUnixEpoch = articleContent.value as? Int64;
                            }
                            else if (articleContent.key == "articleImages"){
                                
                                var tempImage = [String]();
                                let imageIt = articleContent.children;
                                while let image = imageIt.nextObject() as? DataSnapshot{
                                    tempImage.append(image.value as! String);
                                }
                                singleArticle.articleImages = tempImage;
                            }
                            else if (articleContent.key == "articleVideoIDs"){
                                var tempArr = [String]();
                                let idIt = articleContent.children;
                                while let id = idIt.nextObject() as? DataSnapshot{
                                    tempArr.append(id.value as! String);
                                }
                                singleArticle.articleVideoIDs = tempArr;
                            }
                            else if (articleContent.key == "articleTitle"){
                                
                                singleArticle.articleTitle = articleContent.value as? String;
                            }
                            else if (articleContent.key == "isFeatured"){
                                singleArticle.isFeatured = (articleContent.value as? Int == 0 ? false : true);
                            }
                            else if (articleContent.key == "hasHTML"){
                                singleArticle.hasHTML = (articleContent.value as? Int == 0 ? false : true);
                            }
                            
                            
                        }
                        singleArticle.articleCatagory = i == 0 ? "General Info" : s;
                        temp.append(singleArticle);
                        if (utilNeedID == singleArticle.articleID){
                            let articleDataDict: [String: articleData] = ["articleContent" : singleArticle];
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
                        }
                    }
                    homeArticleList[i] = temp;
                };
            }
        }
    }
    else{
        for j in homeArticleList{
            for i in j{
                if (id == i.articleID){
                    let articleDataDict: [String: articleData] = ["articleContent" : i];
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
                    return;
                }
            }
        }
    }
    if (bulletinArticleList[0].count == 0 && bulletinArticleList[1].count == 0 && bulletinArticleList[2].count == 0 && bulletinArticleList[3].count == 0 && bulletinArticleList[4].count == 0 && bulletinArticleList[5].count == 0){ // load bulletin
        setUpConnection();
        if (internetConnected){
            bulletinArticleList = [[bulletinArticleData]](repeating: [bulletinArticleData](), count: 6);
            
            for i in 0...4{
                var s: String; // path inside homepage
                switch i {
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
                        singleArticle.articleType = i;
                        temp.append(singleArticle);
                        if (utilNeedID == singleArticle.articleID){
                            let articleDataDict: [String: articleData] = ["articleContent" : bulletinDataToarticleData(data: singleArticle)];
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
                        }
                    }
                    bulletinArticleList[i] = temp;
                };
                
            }
        }
    }
    else{
        for j in bulletinArticleList{
            for i in j{
                if (id == i.articleID){
                    let articleDataDict: [String: articleData] = ["articleContent" : bulletinDataToarticleData(data: i)];
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "article"), object: nil, userInfo: articleDataDict);
                    return;
                }
            }
        }
    }*/
}
//let mainThemeColor = makeColor(r: 159, g: 12, b: 12);

let mainThemeColor = UIColor(named: "mainThemeColor")!;
let InverseBackgroundColor = UIColor(named: "InverseBackgroundColor")!;
let BackgroundGrayColor = UIColor(named: "BackgroundGrayColor")!;
let BackgroundColor = UIColor(named: "BackgroundColor")!;
let dull_mainThemeColor = UIColor(named: "dull_mainThemeColor")!;
let dull_BackgroundColor = UIColor(named: "dull_BackgroundColor")!;

var fontSize = 20;
