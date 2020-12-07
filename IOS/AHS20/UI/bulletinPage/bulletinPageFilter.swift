//
//  bulletinPageFilter.swift
//  AHS20
//
//  Created by Richard Wei on 12/2/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension bulletinClass{
    @objc internal func addFilter(sender: CustomUIButton){
        sender.isSelected = !sender.isSelected;
        selectedFilters[sender.articleIndex] = sender.isSelected;
        setUpFilters();
        generateBulletin();
        UIImpactFeedbackGenerator(style: .light).impactOccurred();
    }
    
    internal func noFilterSelected() -> Bool{
        for i in selectedFilters{
            if (i){
                return false;
            }
        }
        return true;
    }
    
    internal func filterArticles() -> [bulletinArticleData]{
        var copy = [bulletinArticleData]();
        for i in 0..<totalArticles.count{
            if (selectedFilters[totalArticles[i].articleType] == true){
                copy.append(totalArticles[i]);
            }
        }
        return copy.count == 0 && noFilterSelected() ? totalArticles : copy;
    }
    
    internal func sortArticlesByTime(a: bulletinArticleData, b: bulletinArticleData)->Bool{
        let currTime = Int64(NSDate().timeIntervalSince1970);
        if (a.articleUnixEpoch ?? INT64_MAX > currTime && b.articleUnixEpoch ?? INT64_MAX > currTime){
            return (a.articleUnixEpoch ?? INT64_MAX) < (b.articleUnixEpoch ?? INT64_MAX);
        }
        else{
            return (a.articleUnixEpoch ?? INT64_MAX) > (b.articleUnixEpoch ?? INT64_MAX);
        }
    }
    
    internal func setUpFilters(){
        
        for view in filterScrollView.subviews{
            view.removeFromSuperview();
        }
        
        let buttonFrameWidth = CGFloat(80);
        let filterFrameHorizontalPadding = CGFloat(20);
        
        
        //filterFrame.size = filterScrollView.frame.size;
        filterFrame.size.height = filterScrollView.frame.size.height;
        filterFrame.size.width = buttonFrameWidth; //
        
        var originX = CGFloat(16);
        
        for buttonIndex in 0..<filterSize{
            
            filterFrame.origin.x = originX;
            let filterButton = CustomUIButton(frame: filterFrame);
            filterButton.setTitle(filterName[buttonIndex], for: .normal);
            filterButton.setTitleColor(selectedFilters[buttonIndex] ? InverseBackgroundColor : BackgroundGrayColor, for: .normal);
            filterButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 20);
            filterButton.contentVerticalAlignment = .top;
            filterButton.sizeToFit();
            //SFProText-Bold, SFProDisplay-Regular, SFProDisplay-Semibold, SFProDisplay-Black
            
            filterFrame.size.width = filterButton.frame.size.width;
            let selectedBarHeight = CGFloat(2);
            let selectedBarFrame = CGRect(x: originX, y: filterFrame.size.height-selectedBarHeight, width: filterFrame.size.width, height: selectedBarHeight);
            let selectedBar = UIView(frame: selectedBarFrame);
            selectedBar.backgroundColor = mainThemeColor;
            selectedBar.layer.cornerRadius = 1;
            selectedBar.isHidden = !selectedFilters[buttonIndex];
            
            filterButton.isSelected = selectedFilters[buttonIndex];
            
            filterButton.articleIndex = buttonIndex;
            filterButton.addTarget(self, action: #selector(self.addFilter), for: .touchUpInside);
            
            self.filterScrollView.addSubview(selectedBar);
            self.filterScrollView.addSubview(filterButton);
            originX += filterButton.frame.size.width + filterFrameHorizontalPadding;
        }
        filterScrollView.contentSize = CGSize(width: originX, height: filterScrollView.frame.size.height);
        
        filterScrollView.layer.shadowColor = InverseBackgroundColor.cgColor;
        filterScrollView.layer.shadowOpacity = 0.1;
        filterScrollView.layer.shadowOffset = .zero;
        filterScrollView.layer.shadowRadius = 5;
        filterScrollView.layer.masksToBounds = false;
        
        filterScrollView.delegate = self;
    }
}
