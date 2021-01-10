//
//  articlePageMisc.swift
//  AHS20
//
//  Created by Richard Wei on 12/4/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit

extension articlePageClass{
    @IBAction internal func saveArticle(sender: CustomUIButton){
        if (sender.articleCompleteData.articleID != nil){
            if (sender.isSelected == false){
                savedArticleClass.saveCurrArticle(articleID: sender.articleCompleteData.articleID!, article: sender.articleCompleteData);
            }
            else{
                savedArticleClass.removeCurrArticle(articleID: sender.articleCompleteData.articleID!);
            }
            sender.isSelected = !sender.isSelected;
            setBookmarkColor();
            //resetUpArticles = true;
        }
    }
    
    @IBAction internal func exitArticle(_ sender: UIButton){
        // imageAvgColors = [Int:UIColor]();
        //transitionDismissal();
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "savedpage_reloadSavedArticles"), object: nil, userInfo: nil);
        self.dismiss(animated: true);
        //print("pressed")
        //self.view.frame = CGRect(x: self.view.frame.width/2, y: 0, width: self.view.frame.width, height: self.view.frame.height);
    }
    
    @IBAction internal func handlePan(_ gestureRecognizer: UIPanGestureRecognizer){
       //print("got pan")
        popTransition.handlePan(gestureRecognizer, fromViewController: self);
    }
    
    internal func setBookmarkColor(){
        if (articleContent?.articleID != nil && savedArticleClass.isSavedCurrentArticle(articleID: (articleContent?.articleID)!)){
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal);
            
            bookmarkButton.isSelected = true;
        }
        else{
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal);
            bookmarkButton.isSelected = false;
        }
    }
    
    
    override internal func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openImageZoomPage"){
            let vc = segue.destination as! zoomableImageViewController;
            vc.image = passImageToZoomSegue;
        }
    }
    
    @objc internal func toggleZoom(sender: UIButton){
        if (sender.imageView?.image != nil){
            UIImpactFeedbackGenerator(style: .light).impactOccurred();
            passImageToZoomSegue = sender.imageView?.image;
            performSegue(withIdentifier: "openImageZoomPage", sender: nil);
        }
    }
}
