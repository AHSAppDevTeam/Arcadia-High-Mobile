//
//  CustomUITabController.swift
//  AHS20
//
//  Created by Richard Wei on 4/5/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AudioToolbox

class tabBarClass: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tabBarView: UIView!
    
    
    @IBOutlet weak var notificationDot: UIView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var topBarHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarPageName: UILabel!
    @IBOutlet weak var homeTopBarContent: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var featherImage: UIImageView!
    
    var homeViewController: UIViewController!
    var bulletinViewController: UIViewController!
    var savedViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = 0;
    
    //    let homeTopCornerRadius = CGFloat(15);
    
    let iconImagePath = ["home", "bulletin", "saved", "settings"];
    let selectedColor = makeColor(r: 243, g: 149, b: 143);
    
    var articleContentInSegue: articleData?;
    
    private var transitionDelegateVar : transitionDelegate!;
    
    @IBAction func openNotifications(_ sender: UIButton) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "notificationPageController") as? notificationsClass else{
            return;
        };
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        self.present(vc, animated: true);
    }
    
    @objc private func articleSelector(notification: NSNotification){ // instigate transition
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "articlePageController") as? articlePageClass else{
            return;
        };
        vc.articleContent = notification.userInfo?["articleContent"] as? articleData;
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        self.present(vc, animated: true);
    }
    
    internal func setUpNotifDot(){
        notificationFuncClass.loadNotifPref();
        notificationFuncClass.selectedNotifications = UserDefaults.standard.array(forKey: "selectedNotifications") as? [Bool] ?? [true, false, false, false, false];
        dataManager.updateSubscriptionNotifs();
        notificationFuncClass.unreadNotifCount = 0;
       
        dataManager.getNotificationDataDot(completion: { (isConnected) in
            self.notificationDot.isHidden = notificationFuncClass.unreadNotifCount == 0;
            UIApplication.shared.applicationIconBadgeNumber = notificationFuncClass.unreadNotifCount;
        });
    }
    
    @objc func updateNotifDot(notification: NSNotification){
        //print("called update")
        self.notificationDot.isHidden = notificationFuncClass.unreadNotifCount == 0;
        UIApplication.shared.applicationIconBadgeNumber = notificationFuncClass.unreadNotifCount;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        dataManager.setUpConnection();
        setUpNotifDot();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.articleSelector), name:NSNotification.Name(rawValue: "article"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotifDot), name:NSNotification.Name(rawValue: "updateNotifDot"), object: nil);
        
        // getSavedArticles(); // load default saved articles
        savedArticleClass.getArticleDictionary();
        
        fontSize = UserDefaults.standard.integer(forKey: "fontSize") != 0 ? UserDefaults.standard.integer(forKey: "fontSize") : 20;
        
        // set up buttons
        for index in 0..<buttons.count{
            let image = UIImage(named: iconImagePath[index]);
            buttons[index].setImage(image, for: .normal);
            buttons[index].tintColor = BackgroundGrayColor;
            buttons[index].imageView?.contentMode = .scaleAspectFit;
            buttons[index].contentVerticalAlignment = .fill;
            buttons[index].contentHorizontalAlignment = .fill;
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        homeViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! homeClass;
        bulletinViewController = storyboard.instantiateViewController(withIdentifier: "bulletinViewController") as! bulletinClass;
        savedViewController = storyboard.instantiateViewController(withIdentifier: "savedViewController") as! savedClass;
        settingsViewController = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! settingClass;
        viewControllers = [homeViewController, bulletinViewController, savedViewController, settingsViewController];

        let vc = viewControllers[selectedIndex];
        addChild(vc);
        vc.view.frame = contentView.bounds;
        contentView.addSubview(vc.view);
        vc.didMove(toParent: self);
        topBar.layer.shadowColor = BackgroundGrayColor.cgColor;
        topBar.layer.shadowOpacity = 0.08;
        topBar.layer.shadowRadius = 5;
        topBar.layer.shadowOffset = CGSize(width: 0 , height:10);
        tabBarView.layer.shadowColor = BackgroundGrayColor.cgColor;
        tabBarView.layer.shadowOpacity = 0.07;
        tabBarView.layer.shadowRadius = 5;
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: -10);
        buttons[0].tintColor = InverseBackgroundColor;
        dateLabel.text = getTitleDateAndMonth();
    }
    

    @IBAction func didPressTab(_ sender: UIButton) {
        let prevIndex = selectedIndex;
        selectedIndex = sender.tag;
        if (prevIndex == sender.tag){
            if (sender.tag == 0){
                // add code here
                if let page  = viewControllers[0] as? homeClass{
                    page.mainScrollView.setContentOffset(.zero, animated: true);
                }
                
            }
            if (sender.tag == 2){
                if let page = viewControllers[sender.tag] as? savedClass{
                    page.mainScrollView.setContentOffset(.zero, animated: true);
                }
            }
            if (sender.tag == 1){
                if let page = viewControllers[sender.tag] as? bulletinClass{
                    page.bulletinScrollView.setContentOffset(.zero, animated: true);
                }
            }
        }
        else{
            // remove prev view controller
            buttons[prevIndex].tintColor = BackgroundGrayColor;
            
            let prevVC = viewControllers[prevIndex];
            prevVC.willMove(toParent: nil);
            prevVC.view.removeFromSuperview();
            prevVC.removeFromParent();
            
            // add current view controller
            sender.tintColor = InverseBackgroundColor;
            let vc = viewControllers[selectedIndex];
            addChild(vc);
            vc.view.frame = contentView.bounds;
            contentView.addSubview(vc.view);
            vc.didMove(toParent: self);
            
            
            if (sender.tag == 0){
                topBarHeightContraint.constant = 62;
                topBar.layer.shadowColor = BackgroundGrayColor.cgColor;
                homeTopBarContent.isHidden = false;
                topBarPageName.isHidden = true;
            }
            else{
                topBar.layer.cornerRadius = 0;
                topBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner];
                topBarHeightContraint.constant = 60;
                homeTopBarContent.isHidden = true;
                topBarPageName.isHidden = false;
                if (sender.tag == 1){
                    topBarPageName.text = "Student Bulletin";
                    topBar.layer.shadowColor = UIColor.clear.cgColor;
                }
                else if (sender.tag == 2){
                    topBarPageName.text = "Saved";
                    topBar.layer.shadowColor = BackgroundGrayColor.cgColor;
                }
                else if (sender.tag == 3){
                    topBarPageName.text = "Settings";
                    topBar.layer.shadowColor = BackgroundGrayColor.cgColor;
                }
            }
            
        }
        
    }
    
    
}


