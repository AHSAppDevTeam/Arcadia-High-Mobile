//
//  dataManager_homeandbulletin.swift
//  AHS20
//
//  Created by Richard Wei on 12/15/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import Firebase

extension dataManager{
    static public func loadAllArticles(completion: @escaping (Bool, articleData?) -> Void){
        setUpConnection();
        if (internetConnected){
            
            //homeClass.featuredArticles = [articleData]();
            homeArticleList = [[articleData]](repeating: [articleData](), count: 3);
            
            for index in 0...2{
                
                var s: String; // path inside homepage
                switch index {
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
                        singleArticle.articleCatagory = index == 0 ? "General Info" : s;
                        temp.append(singleArticle);
                        completion(true, singleArticle);
                    }
                    homeArticleList[index] = temp;
                    
                };
                
            }
            
            /// MARK: SEPARATION BETWEEN HOME AND BULLETIN
            
            
            bulletinArticleList = [[bulletinArticleData]](repeating: [bulletinArticleData](), count: 5);
            
            for index in 0...4{
                
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
                        
                        completion(true, dataManager.bulletinDataToarticleData(data: singleArticle));
                        
                    }
                    bulletinArticleList[index] = temp;
                };
                
            }
            
        }
        else{
            completion(false, nil);
        }
    }
}
