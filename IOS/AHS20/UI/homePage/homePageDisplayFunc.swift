//
//  homePageDisplayFunc.swift
//  AHS20
//
//  Created by Richard Wei on 12/8/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension homeClass{
    internal func updateViews(with index: Int){
        switch index {
        case 0:
            setUpGeneralInfo();
            break;
        case 1:
            setUpDistrict();
            break;
        case 2:
            setUpASB();
            break;
        default:
            print("ERROR, INVALID INDEX CALLED IN parseData");
            break;
        }
        setUpFeatured();
        refreshControl.endRefreshing();
    }
    
    private func setUpFeatured(){
        if (homeClass.featuredArticles.count > 0){
            featuredLabel.text = "Featured";
            featuredSize = homeClass.featuredArticles.count;
            
            for view in featuredScrollView.subviews{
                if (view.tag == 1){
                    view.removeFromSuperview();
                }
            }
            
            // Featured News ----- NOTE - article is not created by smallArticle() func
            
            homeClass.featuredArticles.sort(by: sortArticlesByTime);
            
            featuredScrollView.flashScrollIndicators();
            featuredMissingLabel.isHidden = true;
            featuredScrollView.isHidden = false;
            featuredFrame.size = featuredScrollView.frame.size;
            featuredFrame.size.height -= 15;
            featuredFrame.size.width = UIScreen.main.bounds.size.width;
            featuredScrollView.contentSize = CGSize(width: (featuredFrame.size.width * CGFloat(featuredSize)), height: featuredScrollView.frame.size.height);
            for aIndex in 0..<featuredSize{
                featuredFrame.origin.x = (featuredFrame.size.width * CGFloat(aIndex));
                
                let currArticle = homeClass.featuredArticles[aIndex];
                
                let outerContentView = CustomUIButton(frame: featuredFrame);
                
                let innerContentViewContraint = CGFloat(20);
                let contentViewFrame = CGRect(x: innerContentViewContraint, y: 0, width: featuredFrame.size.width - (2*innerContentViewContraint), height: featuredFrame.size.height);
                let contentView = CustomUIButton(frame: contentViewFrame);
                
                
                let articleCatagorytext = (currArticle.articleCatagory ?? "No Cata.") + (currArticle.articleCatagory == "General Info" ? "" : " News");
                let articleCatagoryFrame = CGRect(x: 0, y: contentViewFrame.size.height - 20, width: articleCatagorytext.getWidth(withConstrainedHeight: 20, font: UIFont(name: "SFProText-Bold", size: 12)!) + 12, height: 20);
                let articleCatagory = UILabel(frame: articleCatagoryFrame);
                articleCatagory.text = articleCatagorytext;
                articleCatagory.textAlignment = .center;
                articleCatagory.textColor = .white;
                articleCatagory.backgroundColor = mainThemeColor;
                articleCatagory.font = UIFont(name: "SFProText-Bold", size: 12);
                articleCatagory.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 5);
                
                let timeStampFrame = CGRect(x: articleCatagoryFrame.size.width, y: contentViewFrame.size.height - 20, width: 120, height: 20);
                let timeStamp = UILabel(frame: timeStampFrame);
                timeStamp.text = "   ∙   " + epochClass.epochToString(epoch: currArticle.articleUnixEpoch ?? -1);
                timeStamp.textAlignment = .left;
                timeStamp.textColor = UIColor.lightGray;
                timeStamp.font = UIFont(name: "SFProDisplay-Semibold", size: 12);
                
                let title = currArticle.articleTitle ?? "";
                let height = min(53, title.getHeight(withConstrainedWidth: contentViewFrame.size.width, font: UIFont(name: "SFProDisplay-Semibold", size: 22)!))+5;
                let titleLabelFrame = CGRect(x: 0, y: contentViewFrame.size.height-20-height, width: contentViewFrame.size.width, height: height);
                let titleLabel = UILabel(frame: titleLabelFrame);
                titleLabel.text = title;
                titleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 22);
                titleLabel.textAlignment = .left;
                titleLabel.textColor = InverseBackgroundColor;
                titleLabel.numberOfLines = 2;
                //SFProText-Bold, SFProDisplay-Regular, SFProDisplay-Semibold, SFProDisplay-Black
                
                let imageViewFrame = CGRect(x: 0, y: 0, width: contentViewFrame.size.width, height: titleLabelFrame.minY);
                let imageView = UIImageView(frame: imageViewFrame);
                imageView.imgFromURL(sURL: currArticle.articleImages?[0] ?? "");
                imageView.contentMode = .scaleAspectFill;
                imageView.setRoundedEdge(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radius: 5);
                imageView.clipsToBounds = true;
                imageView.layer.borderColor = UIColor.gray.cgColor;
                imageView.layer.borderWidth = 0.5;
                imageView.layer.cornerRadius = 5;
                imageView.backgroundColor = BackgroundColor;
                
                contentView.addSubview(timeStamp);
                contentView.addSubview(articleCatagory);
                contentView.addSubview(titleLabel);
                contentView.addSubview(imageView);
                
                outerContentView.articleCompleteData = currArticle;
                contentView.articleCompleteData = currArticle;
                
                contentView.addTarget(self, action: #selector(openArticle), for: .touchUpInside);
                
                
                outerContentView.addSubview(contentView);
                
                outerContentView.addTarget(self, action: #selector(openArticle), for: .touchUpInside);
                
                outerContentView.tag = 1;
                
                self.featuredScrollView.addSubview(outerContentView);
            }
            // change horizontal size of scrollview
            featuredScrollView.delegate = self;
            featuredScrollView.showsHorizontalScrollIndicator = true;
            featuredScrollView.backgroundColor = BackgroundColor;
        }
        else{
            featuredMissingLabel.isHidden = false;
            featuredScrollView.isHidden = true;
        }
    }
    
    private func setUpGeneralInfo(){
        let rawData = dataManager.homeArticleList[0];
        if (rawData.count > 0){
            loadingGeneralView.isHidden = true;
            generalLabel.text = "General Info";
            let data = arrayToPairs(a: rawData);
            
            generalInfoSize = data.count;
            
            for view in generalInfoScrollView.subviews{
                view.removeFromSuperview();
            }
            
            generalInfoPageControl.numberOfPages = generalInfoSize;
            generalInfoFrame.size = generalInfoScrollView.frame.size;
            generalInfoFrame.size.width = UIScreen.main.bounds.size.width - scrollViewHorizontalConstraints;
            for aIndex in 0..<generalInfoSize{
                generalInfoFrame.origin.x = (generalInfoFrame.size.width * CGFloat(aIndex));
                
                self.generalInfoScrollView.addSubview(createStackView(frame: generalInfoFrame, data: data[aIndex]));
            }
            // change horizontal size of scrollview
            generalInfoScrollView.contentSize = CGSize(width: (generalInfoFrame.size.width * CGFloat(generalInfoSize)), height: generalInfoScrollView.frame.size.height);
            generalInfoScrollView.delegate = self;
            generalInfoScrollView.isUserInteractionEnabled = true;
        }
    }
    
    private func setUpDistrict(){
        let rawData = dataManager.homeArticleList[1];
        if (rawData.count > 0){
            loadingDistrictView.isHidden = true;
            districtLabel.text = "District News";
            let data = arrayToPairs(a: rawData);
            
            districtNewsSize = data.count;
            
            for view in districtNewsScrollView.subviews{
                view.removeFromSuperview();
            }
            
            // District News -----
            districtNewsPageControl.numberOfPages = districtNewsSize;
            districtNewsFrame.size = districtNewsScrollView.frame.size;
            districtNewsFrame.size.width = UIScreen.main.bounds.size.width - scrollViewHorizontalConstraints;
            for aIndex in 0..<districtNewsSize{
                districtNewsFrame.origin.x = (districtNewsFrame.size.width * CGFloat(aIndex));
                
                self.districtNewsScrollView.addSubview(createStackView(frame: districtNewsFrame, data: data[aIndex]));
            }
            // change horizontal size of scrollview
            districtNewsScrollView.contentSize = CGSize(width: (districtNewsFrame.size.width * CGFloat(districtNewsSize)), height: districtNewsScrollView.frame.size.height);
            districtNewsScrollView.delegate = self;
            districtNewsScrollView.isUserInteractionEnabled = true;
        }
    }
    
    private func setUpASB(){
        let rawData = dataManager.homeArticleList[2];
        if (rawData.count > 0){
            loadingASBView.isHidden = true;
            asbLabel.text = "ASB News";
            let data = arrayToPairs(a: rawData);
            
            asbNewsSize = data.count;
            
            for view in asbNewsScrollView.subviews{
                view.removeFromSuperview();
            }
            
            // ASB News -----
            asbNewsPageControl.numberOfPages = asbNewsSize;
            asbNewsFrame.size = asbNewsScrollView.frame.size;
            asbNewsFrame.size.width = UIScreen.main.bounds.width - scrollViewHorizontalConstraints;
            for aIndex in 0..<asbNewsSize{
                asbNewsFrame.origin.x = (asbNewsFrame.size.width * CGFloat(aIndex));
                
                self.asbNewsScrollView.addSubview(createStackView(frame: asbNewsFrame, data: data[aIndex]));
            }
            // change horizontal size of scrollview
            asbNewsScrollView.contentSize = CGSize(width: (asbNewsFrame.size.width * CGFloat(asbNewsSize)) , height: asbNewsScrollView.frame.size.height);
            asbNewsScrollView.delegate = self;
            asbNewsScrollView.isUserInteractionEnabled = true;
        }
    }
    
    private func createStackView(frame: CGRect, data: [articleData]) -> UIView{
        // create content in scrollview
        let contentView = UIView(frame: frame); // wrapper for article
        contentView.addSubview(smallArticle(x: 0, y: 0, width: frame.size.width, height: 120, articleSingle: data[0]));
        
        if (data.count == 2){
            // B button
            contentView.addSubview(smallArticle(x: 0, y: 120, width: frame.size.width, height: 120, articleSingle: data[1]));
        }
        
        return contentView;
    }
    
    private func smallArticle(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, articleSingle: articleData) -> CustomUIButton{//TODO: find out a way to separate article from top and bottom
        
        let mainArticleFrame = CGRect(x: x, y: y, width: width, height: height);
        let mainArticleView = CustomUIButton(frame: mainArticleFrame);
        
        
        let articleTextWidth = (width/2) + 10;
        
        
        let articleImageViewFrame = CGRect(x: 0, y: 5, width: width - articleTextWidth, height: height - 10);
        let articleImageView = UIImageView(frame: articleImageViewFrame);
        if (articleSingle.articleImages?.count ?? 0 >= 1){
            articleImageView.imgFromURL(sURL: articleSingle.articleImages?[0] ?? "");
            articleImageView.contentMode = .scaleAspectFill;
        }
        articleImageView.backgroundColor = BackgroundColor;
        //articleImageView.setRoundedEdge(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10);
        articleImageView.layer.borderColor = BackgroundGrayColor.cgColor;
        articleImageView.layer.borderWidth = 0.5;
        articleImageView.layer.cornerRadius = 7;
        articleImageView.clipsToBounds = true;
        
        let spacing = CGFloat(10);
        
        let articleTitleFrame = CGRect(x: articleImageViewFrame.size.width + spacing, y: 0, width: articleTextWidth-spacing, height: min(articleSingle.articleTitle?.getHeight(withConstrainedWidth: articleTextWidth-spacing, font: UIFont(name: "SFProDisplay-Semibold", size: 18)!) ?? 50, 50));
        let articleTitle = UILabel(frame: articleTitleFrame);
        articleTitle.text = articleSingle.articleTitle ?? "";
        articleTitle.textAlignment = .left;
        articleTitle.font = UIFont(name: "SFProDisplay-Semibold", size: 18);
        articleTitle.numberOfLines = 0;
        articleTitle.textColor = InverseBackgroundColor;
        
        var text = "";
        if (articleSingle.hasHTML){
            text = parseHTML(s: articleSingle.articleBody ?? "").string;
        }
        else{
            text = (articleSingle.articleBody ?? "");
        }
        let articleBodyFrame = CGRect(x: articleImageViewFrame.size.width + spacing, y: articleTitleFrame.maxY, width: articleTextWidth-spacing, height: mainArticleView.frame.height - articleTitleFrame.maxY - 5);
        let articleBody = UITextView(frame: articleBodyFrame);
        articleBody.text = text;
        articleBody.textAlignment = .left;
        articleBody.font = UIFont(name: "SFProDisplay-Regular", size: 14);
        articleBody.isEditable = false;
        articleBody.isSelectable = false;
        articleBody.isUserInteractionEnabled = false;
        articleBody.isScrollEnabled = false;
        articleBody.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0);
        articleBody.textContainer.lineBreakMode = .byTruncatingTail;
        articleBody.textColor = InverseBackgroundColor;
        
        
        let timeStampText = epochClass.epochToString(epoch: articleSingle.articleUnixEpoch ?? -1);
        let timeStampFrame = CGRect(x: 7, y: height - 25, width: timeStampText.getWidth(withConstrainedHeight: 15, font: UIFont(name: "SFProDisplay-Semibold", size: 8)!) + 10, height: 15);
        let timeStamp = UILabel(frame: timeStampFrame);
        timeStamp.text = timeStampText;
        //timeStamp.text = "12 months ago";
        timeStamp.textAlignment = .center;
        timeStamp.textColor = UIColor.gray;
        timeStamp.font = UIFont(name: "SFProDisplay-Semibold", size: 8);
        timeStamp.backgroundColor = UIColor.white;
        //timeStamp.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 3);
        timeStamp.layer.borderColor = UIColor.gray.cgColor;
        timeStamp.layer.borderWidth = 0.5;
        timeStamp.layer.cornerRadius = 3;
        timeStamp.clipsToBounds = true;
        timeStamp.textColor = InverseBackgroundColor;
        timeStamp.backgroundColor = BackgroundColor;
        
        
        mainArticleView.addSubview(articleImageView);
        mainArticleView.addSubview(articleTitle);
        mainArticleView.addSubview(articleBody);
        mainArticleView.addSubview(timeStamp);
        
        //articleImageView.layer.cornerRadius = 10;
        mainArticleView.addTarget(self, action: #selector(self.openArticle), for: .touchUpInside);
        
        //mainArticleView.backgroundColor = UIColor.lightGray;
        mainArticleView.articleCompleteData = articleSingle;
        
        return mainArticleView;
    }
    
}

/*
 
 private func setUpAllViews(){
     
     setUpConnection();
     if (internetConnected && (homeArticleList[0].count > 0 || homeArticleList[1].count > 0 || homeArticleList[2].count > 0)){
         
         featuredLabel.text = "Featured";
         asbLabel.text = "ASB News";
         generalLabel.text = "General Info";
         districtLabel.text = "District News";
   
         
         let generalInfoArticlePairs = arrayToPairs(a: homeArticleList[0]);
         let districtArticlePairs = arrayToPairs(a: homeArticleList[1]);
         let asbArticlePairs = arrayToPairs(a: homeArticleList[2]);
         featuredSize = featuredArticles.count;
         asbNewsSize = asbArticlePairs.count;
         generalInfoSize = generalInfoArticlePairs.count;
         districtNewsSize = districtArticlePairs.count;
         
         // scrollview variables
         let scrollViewHorizontalConstraints = CGFloat(38);
         
         for view in featuredScrollView.subviews{
             if (view.tag == 1){
                 view.removeFromSuperview();
             }
         }
         for view in asbNewsScrollView.subviews{
             view.removeFromSuperview();
         }
         for view in generalInfoScrollView.subviews{
             view.removeFromSuperview();
         }
         for view in districtNewsScrollView.subviews{
             view.removeFromSuperview();
         }
         
         if (featuredSize > 0){
             // Featured News ----- NOTE - article is not created by smallArticle() func
             
             featuredArticles.sort(by: sortArticlesByTime);
             
             featuredScrollView.flashScrollIndicators();
             featuredMissingLabel.isHidden = true;
             featuredScrollView.isHidden = false;
             featuredFrame.size = featuredScrollView.frame.size;
             featuredFrame.size.height -= 15;
             featuredFrame.size.width = UIScreen.main.bounds.size.width;
             featuredScrollView.contentSize = CGSize(width: (featuredFrame.size.width * CGFloat(featuredSize)), height: featuredScrollView.frame.size.height);
             for aIndex in 0..<featuredSize{
                 featuredFrame.origin.x = (featuredFrame.size.width * CGFloat(aIndex));
                 
                 let currArticle = featuredArticles[aIndex];
                 
                 let outerContentView = CustomUIButton(frame: featuredFrame);
                 
                 let innerContentViewContraint = CGFloat(20);
                 let contentViewFrame = CGRect(x: innerContentViewContraint, y: 0, width: featuredFrame.size.width - (2*innerContentViewContraint), height: featuredFrame.size.height);
                 let contentView = CustomUIButton(frame: contentViewFrame);
                 
                 
                 let articleCatagorytext = (currArticle.articleCatagory ?? "No Cata.") + (currArticle.articleCatagory == "General Info" ? "" : " News");
                 let articleCatagoryFrame = CGRect(x: 0, y: contentViewFrame.size.height - 20, width: articleCatagorytext.getWidth(withConstrainedHeight: 20, font: UIFont(name: "SFProText-Bold", size: 12)!) + 12, height: 20);
                 let articleCatagory = UILabel(frame: articleCatagoryFrame);
                 articleCatagory.text = articleCatagorytext;
                 articleCatagory.textAlignment = .center;
                 articleCatagory.textColor = .white;
                 articleCatagory.backgroundColor = mainThemeColor;
                 articleCatagory.font = UIFont(name: "SFProText-Bold", size: 12);
                 articleCatagory.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 5);
                 
                 let timeStampFrame = CGRect(x: articleCatagoryFrame.size.width, y: contentViewFrame.size.height - 20, width: 120, height: 20);
                 let timeStamp = UILabel(frame: timeStampFrame);
                 timeStamp.text = "   ∙   " + epochClass.epochToString(epoch: currArticle.articleUnixEpoch ?? -1);
                 timeStamp.textAlignment = .left;
                 timeStamp.textColor = UIColor.lightGray;
                 timeStamp.font = UIFont(name: "SFProDisplay-Semibold", size: 12);
                 
                 let title = currArticle.articleTitle ?? "";
                 let height = min(53, title.getHeight(withConstrainedWidth: contentViewFrame.size.width, font: UIFont(name: "SFProDisplay-Semibold", size: 22)!))+5;
                 let titleLabelFrame = CGRect(x: 0, y: contentViewFrame.size.height-20-height, width: contentViewFrame.size.width, height: height);
                 let titleLabel = UILabel(frame: titleLabelFrame);
                 titleLabel.text = title;
                 titleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 22);
                 titleLabel.textAlignment = .left;
                 titleLabel.textColor = InverseBackgroundColor;
                 titleLabel.numberOfLines = 2;
                 //SFProText-Bold, SFProDisplay-Regular, SFProDisplay-Semibold, SFProDisplay-Black
                 
                 let imageViewFrame = CGRect(x: 0, y: 0, width: contentViewFrame.size.width, height: titleLabelFrame.minY);
                 let imageView = UIImageView(frame: imageViewFrame);
                 imageView.imgFromURL(sURL: currArticle.articleImages?[0] ?? "");
                 imageView.contentMode = .scaleAspectFill;
                 imageView.setRoundedEdge(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radius: 5);
                 imageView.clipsToBounds = true;
                 imageView.layer.borderColor = UIColor.gray.cgColor;
                 imageView.layer.borderWidth = 0.5;
                 imageView.layer.cornerRadius = 5;
                 imageView.backgroundColor = BackgroundColor;
                 
                 contentView.addSubview(timeStamp);
                 contentView.addSubview(articleCatagory);
                 contentView.addSubview(titleLabel);
                 contentView.addSubview(imageView);
                 
                 outerContentView.articleCompleteData = currArticle;
                 contentView.articleCompleteData = currArticle;
                 
                 contentView.addTarget(self, action: #selector(openArticle), for: .touchUpInside);
                 
                 
                 outerContentView.addSubview(contentView);
                 
                 outerContentView.addTarget(self, action: #selector(openArticle), for: .touchUpInside);
                 
                 outerContentView.tag = 1;
                 
                 self.featuredScrollView.addSubview(outerContentView);
             }
             // change horizontal size of scrollview
             featuredScrollView.delegate = self;
             featuredScrollView.showsHorizontalScrollIndicator = true;
             featuredScrollView.backgroundColor = BackgroundColor;
             
         }
         else{
             featuredMissingLabel.isHidden = false;
             featuredScrollView.isHidden = true;
         }
         
         
         // Sports News -----
         generalInfoPageControl.numberOfPages = generalInfoSize;
         generalInfoFrame.size = generalInfoScrollView.frame.size;
         generalInfoFrame.size.width = UIScreen.main.bounds.size.width - scrollViewHorizontalConstraints;
         for aIndex in 0..<generalInfoSize{
             generalInfoFrame.origin.x = (generalInfoFrame.size.width * CGFloat(aIndex));
             
             
             
             // create content in scrollview
             let contentView = UIView(frame: generalInfoFrame); // wrapper for article
             
             contentView.addSubview(smallArticle(x: 0, y: 0, width: generalInfoFrame.size.width, height: 120, articleSingle: generalInfoArticlePairs[aIndex][0]));
             
             if (generalInfoArticlePairs[aIndex].count == 2){
                 // B button
                 contentView.addSubview(smallArticle(x: 0, y: 120, width: generalInfoFrame.size.width, height: 120, articleSingle: generalInfoArticlePairs[aIndex][1]));
             }
             
             self.generalInfoScrollView.addSubview(contentView);
         }
         // change horizontal size of scrollview
         generalInfoScrollView.contentSize = CGSize(width: (generalInfoFrame.size.width * CGFloat(generalInfoSize)), height: generalInfoScrollView.frame.size.height);
         generalInfoScrollView.delegate = self;
         
         
         // District News -----
         districtNewsPageControl.numberOfPages = districtNewsSize;
         districtNewsFrame.size = districtNewsScrollView.frame.size;
         districtNewsFrame.size.width = UIScreen.main.bounds.size.width - scrollViewHorizontalConstraints;
         for aIndex in 0..<districtNewsSize{
             districtNewsFrame.origin.x = (districtNewsFrame.size.width * CGFloat(aIndex));
             
             // create content in scrollview
             let contentView = UIView(frame: districtNewsFrame); // wrapper for article
             contentView.addSubview(smallArticle(x: 0, y: 0, width: districtNewsFrame.size.width, height: 120, articleSingle: districtArticlePairs[aIndex][0]));
             
             if (districtArticlePairs[aIndex].count == 2){
                 // B button
                 contentView.addSubview(smallArticle(x: 0, y: 120, width: districtNewsFrame.size.width, height: 120, articleSingle: districtArticlePairs[aIndex][1]));
             }
             
             self.districtNewsScrollView.addSubview(contentView);
         }
         // change horizontal size of scrollview
         districtNewsScrollView.contentSize = CGSize(width: (districtNewsFrame.size.width * CGFloat(districtNewsSize)), height: districtNewsScrollView.frame.size.height);
         districtNewsScrollView.delegate = self;
         
         // ASB News -----
         asbNewsPageControl.numberOfPages = asbNewsSize;
         asbNewsFrame.size = asbNewsScrollView.frame.size;
         asbNewsFrame.size.width = UIScreen.main.bounds.width - scrollViewHorizontalConstraints;
         for aIndex in 0..<asbNewsSize{
             asbNewsFrame.origin.x = (asbNewsFrame.size.width * CGFloat(aIndex));
             
             
             // create content in scrollview
             let contentView = UIView(frame: asbNewsFrame); // wrapper for article
             //contentView.backgroundColor = UIColor.gray;
             
             contentView.addSubview(smallArticle(x: 0, y: 0, width: asbNewsFrame.size.width, height: 120, articleSingle: asbArticlePairs[aIndex][0]));
             if (asbArticlePairs[aIndex].count == 2){
                 // B button
                 contentView.addSubview(smallArticle(x: 0, y: 120, width: asbNewsFrame.size.width, height: 120, articleSingle: asbArticlePairs[aIndex][1]));
             }
             
             self.asbNewsScrollView.addSubview(contentView);
         }
         // change horizontal size of scrollview
         asbNewsScrollView.contentSize = CGSize(width: (asbNewsFrame.size.width * CGFloat(asbNewsSize)) , height: asbNewsScrollView.frame.size.height);
         asbNewsScrollView.delegate = self;
         
     }
 }
 
 */
