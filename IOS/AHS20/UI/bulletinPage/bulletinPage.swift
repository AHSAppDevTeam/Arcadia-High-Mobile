//
//  bulletinPage.swift
//  AHS20
//
//  Created by Richard Wei on 4/5/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import Firebase
import FirebaseDatabase

class bulletinClass: UIViewController, UIScrollViewDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var filterScrollView: UIScrollView!
    @IBOutlet weak var bulletinScrollView: UIScrollView!
    @IBOutlet var mainView: UIView!
    
    
    @IBOutlet weak var filterScrollViewHeightContraint: NSLayoutConstraint!
    
    let refreshControl = UIRefreshControl();
    
    // padding variables
    let articleHorizontalPadding = CGFloat(12);
    let articleVerticalPadding = CGFloat(12);
    let articleVerticalSize = CGFloat(130);
    
    
    let filterSize = 5;
    var filterFrame = CGRect(x:0,y:0,width: 0, height: 0);
    
    let filterName = ["Academics", "Athletics", "Clubs", "Colleges", "Reference"];
    
    var selectedFilters: [Bool] = [false, false, false, false, false]; // selected types in this order - seniors, colleges, events, athletics, reference, and others
    
    var currentArticles = [bulletinArticleData]();
    
    // icon stuff
    var iconViewFrame: CGRect?;
    var filterScrollViewMaxHeight: CGFloat?;
    var filterScrollViewMinHeight: CGFloat?;
    
    func getBulletinArticleData() {
        
        dataManager.getBulletinData(completion: { (isConnected, index) in
            
            if (isConnected){
                self.refreshControl.endRefreshing();
                self.generateBulletin();
            }
            else{
                let infoPopup = UIAlertController(title: "No internet connection detected", message: "No articles were loaded", preferredStyle: UIAlertController.Style.alert);
                infoPopup.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.refreshControl.endRefreshing();
                }));
                self.present(infoPopup, animated: true, completion: nil);
            }
            
        });
        
    }


    
    internal func generateBulletin(){
        
        if (dataManager.bulletinArrayHasData()){
            totalArticles = [bulletinArticleData]();
            for i in 0...4{
                for c in dataManager.bulletinArticleList[i]{
                    totalArticles.append(c);
                }
            }
            totalArticles.sort(by: sortArticlesByTime);
            currentArticles = filterArticles();
            loadBullPref();
            var bulletinFrame = CGRect(x:0, y:0, width: 0, height: 0);
            
            for subview in bulletinScrollView.subviews{
                if (subview != refreshControl && subview.tag == 1){
                    subview.removeFromSuperview();
                }
            }
            
            bulletinFrame.size.height = articleVerticalSize;
            bulletinFrame.size.width = UIScreen.main.bounds.size.width - (2*articleHorizontalPadding);
            
            let catagoryFrameWidth = CGFloat(70);
            var currY = articleVerticalPadding;

            
            if (currentArticles.count > 0){
                for article in currentArticles{
                    bulletinFrame.origin.x = articleHorizontalPadding;
                    bulletinFrame.origin.y = currY;
                    currY += bulletinFrame.size.height + articleVerticalPadding;
                    let articleButton = CustomUIButton(frame: bulletinFrame);
                    let currArticleRead = bulletinReadDict[article.articleID ?? ""] == true ? true : false;
                    
                    // content inside button
                    let mainViewFrame = CGRect(x: 10, y: 10, width: bulletinFrame.size.width - (2*articleHorizontalPadding), height: bulletinFrame.size.height - 10);
                    let mainView = UIView(frame: mainViewFrame);
                    mainView.isUserInteractionEnabled = false;
                    
                    let articleTitleFrame = CGRect(x: 0, y : 17, width: UIScreen.main.bounds.size.width - articleHorizontalPadding - 55, height: 34);
                    let articleTitleText = UILabel(frame: articleTitleFrame);
                    articleTitleText.text = article.articleTitle;
                    articleTitleText.font = currArticleRead ? UIFont(name: "SFProDisplay-Semibold",size: 16) : UIFont(name: "SFProText-Bold",size: 16);
                    articleTitleText.textColor = currArticleRead ? BackgroundGrayColor : InverseBackgroundColor;
                    articleTitleText.numberOfLines = 1;
                    articleTitleText.tag = 2;
                    articleTitleText.isUserInteractionEnabled = false;
                    
                    let articleBodyFrame = CGRect(x: 0, y: 44, width: mainViewFrame.size.width, height: mainViewFrame.size.height - 50);
                    let articleBodyText = UILabel(frame: articleBodyFrame);
                    if (article.hasHTML == true){
                        articleBodyText.text = parseHTML(s: article.articleBody ?? "").string;
                    }
                    else{
                        articleBodyText.text = (article.articleBody ?? "");
                    }
                    articleBodyText.numberOfLines = 4;
                    articleBodyText.font = UIFont(name: "SFProDisplay-Regular", size: 15);
                    articleBodyText.textColor = currArticleRead ? BackgroundGrayColor : InverseBackgroundColor;
                    articleBodyText.tag = 3;
                    articleBodyText.isUserInteractionEnabled = false;
                    
                    mainView.addSubview(articleTitleText);
                    mainView.addSubview(articleBodyText);
                    
                    mainView.tag = -1; // NOTE - DIFFERENT usage FROM articleButton tag. This tag is used in makeCustomButtonRead function
                    
                    let dateTextFrame = CGRect(x: bulletinFrame.size.width - (2*articleHorizontalPadding) - 95, y : 5, width: 100, height: 25);
                    let dateText = UILabel(frame: dateTextFrame);
                    dateText.text = epochClass.epochToString(epoch: article.articleUnixEpoch ?? -1); // insert date here -------- temporary
                    dateText.textColor = mainThemeColor;
                    dateText.textAlignment = .right;
                    dateText.font = UIFont(name: "SFProDisplay-Regular", size: 12);
                    dateText.isUserInteractionEnabled = false;
                    
                    let catagoryFrame = CGRect(x: 8, y: 12, width: catagoryFrameWidth, height: 20);
                    let catagory = UILabel(frame: catagoryFrame);
                    catagory.text = article.articleCatagory ?? "No Cata.";
                    catagory.backgroundColor = currArticleRead ? dull_mainThemeColor : mainThemeColor;
                    catagory.textAlignment = .center;
                    catagory.textColor = UIColor.white;
                    catagory.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 5);
                    catagory.font = UIFont(name: "SFProDisplay-Semibold", size: 12);
                    catagory.tag = 4;
                    catagory.isUserInteractionEnabled = false;
                    
                    if (currArticleRead == false){
                        let readLabelFrame = CGRect(x: 15 + catagoryFrame.size.width, y: 12, width: 40, height: 20);
                        let readLabel = UILabel(frame: readLabelFrame);
                        readLabel.text = "New";
                        readLabel.backgroundColor = UIColor.systemYellow;
                        readLabel.textAlignment = .center;
                        readLabel.textColor = UIColor.white;
                        readLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12);
                        readLabel.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 5);
                        readLabel.tag = 5;
                        readLabel.isUserInteractionEnabled = false;
                        articleButton.addSubview(readLabel);
                    }
                    
                    articleButton.addSubview(dateText);
                    articleButton.addSubview(mainView);
                    articleButton.addSubview(catagory);
                    
                    articleButton.layer.shadowColor = InverseBackgroundColor.cgColor;
                    articleButton.layer.shadowOpacity = 0.2;
                    articleButton.layer.shadowRadius = 5;
                    articleButton.layer.shadowOffset = CGSize(width: 0 , height: self.traitCollection.userInterfaceStyle == .dark ? 0 : 3);
                    articleButton.layer.borderWidth = 0.15;
                    articleButton.layer.borderColor = BackgroundGrayColor.cgColor;
                    
                    if (self.traitCollection.userInterfaceStyle == .dark){
                        articleButton.backgroundColor = currArticleRead ? BackgroundColor : dull_BackgroundColor;
                    }
                    else{
                        articleButton.backgroundColor = currArticleRead ? dull_BackgroundColor : BackgroundColor;
                    }
                    
                    articleButton.articleCompleteData = dataManager.bulletinDataToarticleData(data: article);
                    
                    articleButton.addTarget(self, action: #selector(self.openArticle), for: .touchUpInside);
                    articleButton.tag = 1;
                    self.bulletinScrollView.addSubview(articleButton);
                }
            }
            else{
                let labelHeight = CGFloat(100);
                let noArticlesLabel = UILabel(frame: CGRect(x: articleHorizontalPadding, y: currY, width: UIScreen.main.bounds.width - 2*articleHorizontalPadding, height: labelHeight));
                noArticlesLabel.text = "No articles found";
                noArticlesLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 20);
                noArticlesLabel.backgroundColor = BackgroundColor;
                noArticlesLabel.textColor = InverseBackgroundColor;
                noArticlesLabel.textAlignment = .center;
                noArticlesLabel.layer.shadowColor = InverseBackgroundColor.cgColor;
                noArticlesLabel.layer.shadowOpacity = 0.2;
                noArticlesLabel.layer.shadowRadius = 5;
                noArticlesLabel.layer.shadowOffset = CGSize(width: 0 , height:3);
                noArticlesLabel.tag = 1;
                bulletinScrollView.addSubview(noArticlesLabel);
                currY += labelHeight;
            }
            bulletinScrollView.contentSize = CGSize(width: bulletinFrame.size.width, height: CGFloat(currY));
            bulletinScrollView.delegate = self;
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad();
        refreshControl.addTarget(self, action: #selector(refreshBulletin), for: UIControl.Event.valueChanged);
        bulletinScrollView.addSubview(refreshControl);
        bulletinScrollView.isScrollEnabled = true;
        bulletinScrollView.alwaysBounceVertical = true;
        refreshControl.beginRefreshing();
        
        setUpFilters();
        getBulletinArticleData();
        
    }
    
}
