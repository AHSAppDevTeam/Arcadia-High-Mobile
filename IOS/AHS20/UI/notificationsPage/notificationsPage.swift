//
//  notificationsPage.swift
//  AHS20
//
//  Created by Richard Wei on 4/24/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import Firebase
import FirebaseDatabase

class notificationsClass: UIViewController, UIScrollViewDelegate, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    
    
    @IBOutlet weak var notificationScrollView: UIScrollView!
    
    @IBOutlet weak var noNotificationLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    
    var articleDictionary = [String: articleData]();
    
    var articleContentInSegue: articleData?;
    
    static public var totalNotificationList = [notificationData]();
    static public var notificationReadDict = [String : Bool](); // Message ID : Read = true
    //var notificationList = [[notificationData]](repeating: [notificationData](), count: 2);
    
    // notification setting
    
    @IBOutlet var gestureRecognizer: UIPanGestureRecognizer!
    
    private var articleTransitionDelegate : transitionDelegate!;
    
    @objc func openArticle(_ sender: notificationUIButton) {
        if (sender.alreadyRead == false){
            notificationsClass.notificationReadDict[sender.notificationCompleteData.messageID ?? ""] = true;
            notificationFuncClass.saveNotifPref(filter: true);
            notificationFuncClass.unreadNotifCount = notificationFuncClass.numOfUnreadInArray(arr: notificationFuncClass.filterThroughSelectedNotifcations());
            UIApplication.shared.applicationIconBadgeNumber = notificationFuncClass.unreadNotifCount;
        }
        if (articleDictionary[sender.notificationCompleteData.notificationArticleID ?? ""] != nil){
            /*articleContentInSegue = articleDictionary[sender.notificationCompleteData.notificationArticleID ?? ""];
            performSegue(withIdentifier: "notificationToArticle", sender: nil);*/
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "articlePageController") as? articlePageClass else{
                return;
            };
            //vc.interactor = interactor;
            vc.articleContent = articleDictionary[sender.notificationCompleteData.notificationArticleID ?? ""];
            //transition(to: vc);
            articleTransitionDelegate = transitionDelegate();
            vc.transitioningDelegate = articleTransitionDelegate;
            vc.modalPresentationStyle = .custom;
            self.present(vc, animated: true);
        }
        loadScrollView();
    }
    
    func getLocalNotifications(){
        dataManager.getNotificationData(completion: { (isConnected) in
            if (isConnected){
                self.refreshControl.endRefreshing();
                self.loadingLabel.isHidden = true;
                self.loadScrollView();
            }
            else{
                let infoPopup = UIAlertController(title: "No internet connection detected", message: "No notifications were loaded", preferredStyle: UIAlertController.Style.alert);
                infoPopup.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.refreshControl.endRefreshing();
                    self.loadingLabel.isHidden = true;
                }));
                self.present(infoPopup, animated: true, completion: nil);
            }
        });
        
    }
    
    func setUpArticleDictionary(){
        dataManager.loadAllArticles(completion: { (isConnected, data) in
            if (isConnected){
                self.articleDictionary[data!.articleID ?? ""] = data!;
            }
        });
    }

    

    var notificationFrame = CGRect(x: 0, y: 0, width: 0, height: 0);
    
    var horizontalPadding = CGFloat(10);
    var verticalPadding = CGFloat(10);
    
    let timeStampLength = CGFloat(100);
    
    internal var refreshControl = UIRefreshControl();
    internal var loadingLabel = UILabel();
    
    func loadScrollView(){
        
        // remove prev subviews
        for subview in notificationScrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        var currNotifList = notificationFuncClass.filterThroughSelectedNotifcations();
        currNotifList.sort(by: notificationSort);
        
        if (currNotifList.count > 0){
            
            notificationScrollView.isHidden = false;
            noNotificationLabel.isHidden = true;
            
            notificationFrame.size.width = UIScreen.main.bounds.size.width - (2 * horizontalPadding);
            notificationFrame.size.height = 130;
            
            var yPos = verticalPadding;
            // add notification label at start
            for currNotif in currNotifList{
                notificationFrame.origin.x = horizontalPadding;
                notificationFrame.origin.y = yPos;
                
                let notificationButton = notificationUIButton(frame: notificationFrame);
                let currArticleRead = notificationsClass.notificationReadDict[currNotif.messageID ?? ""] == true ? true : false;
                
                let chevronWidth = CGFloat(22);
                
                let notificationCatagoryLabelHeight = CGFloat(20);
                let notificationCatagoryLabelFrame = CGRect(x: 10, y: 12, width: 65, height: notificationCatagoryLabelHeight);
                let notificationCatagoryLabel = UILabel(frame: notificationCatagoryLabelFrame);
                notificationCatagoryLabel.text = typeIDToString(id: currNotif.notificationCatagory ?? 0);
                notificationCatagoryLabel.textAlignment = .center;
                notificationCatagoryLabel.textColor = UIColor.white;
                notificationCatagoryLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12);
                notificationCatagoryLabel.backgroundColor = currArticleRead ? dull_mainThemeColor : mainThemeColor;
                notificationCatagoryLabel.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 5);
                //SFProText-Bold, SFProDisplay-Regular, SFProDisplay-Semibold, SFProDisplay-Black
                
                if (currArticleRead == false){
                    let readLabelFrame = CGRect(x: 15 + notificationCatagoryLabelFrame.size.width, y: 12, width: 40, height: notificationCatagoryLabelHeight);
                    let readLabel = UILabel(frame: readLabelFrame);
                    readLabel.text = "New";
                    readLabel.backgroundColor = UIColor.systemYellow;
                    readLabel.textAlignment = .center;
                    readLabel.textColor = UIColor.white;
                    readLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 12);
                    readLabel.setRoundedEdge(corners: [.bottomRight, .bottomLeft, .topRight, .topLeft], radius: 5);
                    notificationButton.addSubview(readLabel);
                }
                
                let notificationTitleFrame = CGRect(x: 10, y: notificationCatagoryLabelHeight + 15, width: notificationFrame.size.width - chevronWidth - timeStampLength, height: 30);
                let notificationTitle = UILabel(frame: notificationTitleFrame);
                notificationTitle.text = currNotif.notificationTitle;
                notificationTitle.font = currArticleRead ? UIFont(name: "SFProDisplay-Semibold",size: 18) : UIFont(name:"SFProText-Bold",size: 18);
                notificationTitle.textColor = currArticleRead ? BackgroundGrayColor : InverseBackgroundColor;
                notificationTitle.adjustsFontSizeToFitWidth = true;
                notificationTitle.minimumScaleFactor = 0.2;
                
                let bodyVerticalPadding = CGFloat(10);
                
                let notificationBodyWidth = CGFloat(notificationFrame.size.width  - chevronWidth - 27);
                let notificationBodyFrame = CGRect(x: 10, y: notificationTitleFrame.size.height + 10 + notificationCatagoryLabelFrame.size.height + bodyVerticalPadding, width: notificationBodyWidth, height: currNotif.notificationBody?.getHeight(withConstrainedWidth: notificationBodyWidth, font: UIFont(name:"SFProDisplay-Regular",size: 14)!) ?? 0);
                let notificationBodyText = UILabel(frame: notificationBodyFrame);
                notificationBodyText.text = currNotif.notificationBody;
                notificationBodyText.numberOfLines = 0;
                notificationBodyText.font = UIFont(name:"SFProDisplay-Regular",size: 14);
                notificationBodyText.textColor = currArticleRead ? BackgroundGrayColor : InverseBackgroundColor;
                
                let timeStampFrame = CGRect(x: notificationFrame.size.width - chevronWidth - timeStampLength + 10, y: 5, width: timeStampLength, height: 30);
                let timeStamp = UILabel(frame: timeStampFrame);
                timeStamp.text = epochClass.epochToString(epoch: currNotif.notificationUnixEpoch ?? -1);
                timeStamp.font = UIFont(name:"SFProDisplay-Regular",size: 12);
                timeStamp.textAlignment = .right;
                timeStamp.textColor = InverseBackgroundColor;
                
                if (self.traitCollection.userInterfaceStyle == .dark){
                    notificationButton.backgroundColor = currArticleRead ? BackgroundColor : dull_BackgroundColor;
                }
                else{
                    notificationButton.backgroundColor = currArticleRead ? dull_BackgroundColor : BackgroundColor;
                }
                
                notificationButton.layer.shadowColor = InverseBackgroundColor.cgColor;
                notificationButton.layer.shadowOpacity = 0.2;
                notificationButton.layer.shadowRadius = 5;
                notificationButton.layer.shadowOffset = CGSize(width: 0 , height: self.traitCollection.userInterfaceStyle == .dark ? 0 : 3);
                notificationButton.layer.borderWidth = 0.15;
                notificationButton.layer.borderColor = BackgroundGrayColor.cgColor;
                
                notificationButton.notificationCompleteData = currNotif;
            
                notificationButton.addSubview(notificationCatagoryLabel);
                notificationButton.addSubview(notificationTitle);
                notificationButton.addSubview(notificationBodyText);
                notificationButton.addSubview(timeStamp);
                
                notificationButton.frame.size.height = notificationBodyText.frame.maxY + bodyVerticalPadding + 10;
                
                if (currNotif.notificationArticleID != nil && articleDictionary[currNotif.notificationArticleID ?? ""] != nil){
                    let chevronFrame = CGRect(x: notificationButton.frame.size.width-chevronWidth-15, y: (notificationButton.frame.size.height/2)-(chevronWidth/2), width: chevronWidth-5, height: chevronWidth);
                    let chevronImage = UIImageView(frame: chevronFrame);
                    chevronImage.image = UIImage(systemName: "chevron.right");
                    chevronImage.tintColor = BackgroundGrayColor;
                    notificationButton.addSubview(chevronImage);
                }
                
                yPos += notificationButton.frame.size.height + verticalPadding;
                
                notificationButton.addTarget(self, action: #selector(openArticle), for: .touchUpInside);
                notificationButton.tag = 1;
                notificationScrollView.addSubview(notificationButton);
            }
            notificationScrollView.contentSize = CGSize(width: notificationFrame.size.width, height: yPos + verticalPadding);
            notificationScrollView.delegate = self;
        }
        else{
            notificationScrollView.isHidden = true;
            noNotificationLabel.isHidden = false;
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // set iphone x or above color below the safe area
        notificationScrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 1).isActive = true;
        
        shadowView.layer.shadowColor = InverseBackgroundColor.cgColor;
        shadowView.layer.shadowOpacity = 0.05;
        shadowView.layer.shadowOffset = CGSize(width: 0 , height: 5);
        
        notificationsClass.totalNotificationList = [notificationData]();
        
        let loadingLabelText = "Loading...";
        let loadingLabelFont = UIFont(name:"SFProText-Bold",size: 18)!;
        let loadingLabelWidth = loadingLabelText.getWidth(withConstrainedHeight: .greatestFiniteMagnitude, font: loadingLabelFont);
        let loadingLabelFrame = CGRect(x: (UIScreen.main.bounds.width / 2) - (loadingLabelWidth / 2), y: 30, width: loadingLabelWidth, height: 30);
        loadingLabel = UILabel(frame: loadingLabelFrame);
        loadingLabel.text = loadingLabelText;
        loadingLabel.font = loadingLabelFont;
        
        notificationScrollView.addSubview(loadingLabel);
        
        gestureRecognizer.addTarget(self, action: #selector(handlePan));
        
        refreshControl.addTarget(self, action: #selector(refreshNotifications), for: UIControl.Event.valueChanged);
        //notificationScrollView.addSubview(refreshControl);
        notificationScrollView.refreshControl = refreshControl;
        notificationScrollView.isScrollEnabled = true;
        notificationScrollView.alwaysBounceVertical = true;
        
        //refreshControl.beginRefreshing();
        setUpArticleDictionary();
        notificationFuncClass.loadNotifPref();
        getLocalNotifications();
        
    }
    
    
}
