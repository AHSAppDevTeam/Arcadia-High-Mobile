//
//  creditsPage.swift
//  AHS20
//
//  Created by Richard Wei on 5/8/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension aboutUsPage: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentgradient]
            animateGradient()
        }
    }
}

class aboutUsPage: UIViewController {
    
    @IBOutlet var mainView: UIView!
    let gradient = CAGradientLayer();
    
    var gradientSet = [[CGColor]]();
    var currentgradient: Int = 0;
    
    let one = makeColor(r: 0, g: 200, b: 255).cgColor; // light blue
    let two = makeColor(r: 0, g: 128, b: 255).cgColor; // blue
    let three = makeColor(r: 243, g: 0, b: 255).cgColor; // purple
    let four = makeColor(r: 255, g: 0, b: 89).cgColor; // pink
    let five = makeColor(r: 255, g: 162, b: 0).cgColor; // orange
    let six = makeColor(r: 251, g: 255, b: 0).cgColor; // yellow
    let seven  = makeColor(r: 0, g: 255, b: 19).cgColor; // green
    
    let nameTitleArray = ["Programmers", "Graphic Designers", "Content Editors", "Previous Members", "Founders"];
    var names = Array(repeating: "", count: 5);
    
    //internal var firebaseWaitListNum = 0;
    internal var scrollView = UIScrollView();
    
    internal func getNameFromFirebase(){
        /*setUpConnection();
        if (internetConnected){
            
            DispatchQueue.global(qos: .background).async {
                
                for nameIndex in 0..<self.nameTitleArray.count{
                    
                    //self.firebaseWaitListNum += 1;
                    
                    ref.child("aboutus").child(self.nameTitleArray[nameIndex]).observeSingleEvent(of: .value) { (snapshot) in
                        let enumerator = snapshot.children;
                        
                        var currentString : String = "";
                        
                        while let currentName = enumerator.nextObject() as? DataSnapshot{ // each article
                            
                            currentString += (currentName.value as? String ?? "") + "\n";
                            
                        };
                        
                        self.names[nameIndex] = currentString;
                        //print("current - \(currentString)");
                        //self.firebaseWaitListNum -= 1;
                        DispatchQueue.main.async {
                            self.renderViews();
                        }
                    }
                    
                }
                
            }
            
        }*/
    }
    
    internal func renderViews(){
       // scrollView.backgroundColor = UIColor.gray;
 
        for subview in scrollView.subviews{
            subview.removeFromSuperview();
        }
        
        let verticalPadding = CGFloat(40);
        let horizontalPadding = CGFloat(45);
        let cornerRadius = CGFloat(5);
        var nextY = CGFloat(50);
        
        let emailViewFrame = CGRect(x: horizontalPadding, y: nextY, width: UIScreen.main.bounds.width - 2*horizontalPadding, height: CGFloat(100));
        let emailView = UIView(frame: emailViewFrame);
        emailView.backgroundColor = BackgroundColor;
        
        let emailViewTitle = UILabel();
        emailViewTitle.text = "Contact us at:";
        emailViewTitle.textColor = InverseBackgroundColor;
        emailViewTitle.font = UIFont(name: "SFProDisplay-Semibold", size: 20);
        emailViewTitle.sizeToFit();
        emailViewTitle.center = CGPoint(x: emailViewFrame.size.width / 2, y: 25);
        
        let emailClickable = UITextView();
        emailClickable.text = "hsappdev@students.ausd.net";
        //emailClickable.backgroundColor ;
        emailClickable.font = UIFont(name: "SFProDisplay-Semibold", size: 15);
        emailClickable.sizeToFit();
        emailClickable.isEditable = false;
        emailClickable.dataDetectorTypes = UIDataDetectorTypes.link;
        emailClickable.center = CGPoint(x: emailViewFrame.size.width / 2, y: 65);
        emailClickable.tintColor = UIColor.systemBlue;
        
        emailView.addSubview(emailClickable);
        emailView.addSubview(emailViewTitle);
        emailView.layer.cornerRadius = cornerRadius;
        scrollView.addSubview(emailView);
        
        nextY += emailViewFrame.size.height + verticalPadding;
        
        
        for i in 0..<nameTitleArray.count{
            let outerView = UIView(frame: CGRect(x: horizontalPadding, y: nextY, width: UIScreen.main.bounds.width - 2*horizontalPadding, height: CGFloat(100))); // temp height
            outerView.backgroundColor = BackgroundColor;
            outerView.layer.cornerRadius = cornerRadius;
            var currY = CGFloat(0);
            
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: outerView.frame.size.width, height: 20));
            titleLabel.text = nameTitleArray[i];
            titleLabel.font = UIFont(name: "SFProText-Bold", size: 18);
            titleLabel.textColor = InverseBackgroundColor;
         //   titleLabel.backgroundColor = UIColor.gray;
            titleLabel.textAlignment = .center;
            
            outerView.addSubview(titleLabel);
            currY += 30 + 10;
        
            let nameText = "\(names[i].dropLast())";
            let bodyTextWidth = outerView.frame.size.width;
            let bodyTextFont = UIFont(name: "SFProDisplay-Semibold", size: 16)!;
            let bodyTextHeight = nameText.getHeight(withConstrainedWidth: bodyTextWidth, font: bodyTextFont) + 10;
            let bodyText = UILabel(frame: CGRect(x: 0, y: currY, width: bodyTextWidth, height: bodyTextHeight));
            bodyText.text = nameText;
            bodyText.font = bodyTextFont;
            bodyText.textColor = BackgroundGrayColor;
            bodyText.textAlignment = .center;
            bodyText.numberOfLines = 0;
            
            currY += bodyText.frame.size.height + 10;
            
            outerView.addSubview(bodyText);
            outerView.frame.size.height = currY;
            
            scrollView.addSubview(outerView);
            nextY += outerView.frame.size.height + verticalPadding;
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: nextY);
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let scrollViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        scrollView = UIScrollView(frame: scrollViewFrame);
        mainView.insertSubview(scrollView, at: 0);
        
        getNameFromFirebase();
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradientSet.append([one, two])
        gradientSet.append([two, three])
        gradientSet.append([three, four])
        gradientSet.append([four, five]);
        gradientSet.append([five, six]);
        gradientSet.append([six, seven]);
        gradientSet.append([seven, one]);
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentgradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        mainView.layer.insertSublayer(gradient, at: 0);
        
        animateGradient()
    }
    
    func animateGradient() {
        if currentgradient < gradientSet.count - 1 {
            currentgradient += 1
        } else {
            currentgradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors");
        gradientChangeAnimation.duration = 2.0;
        gradientChangeAnimation.toValue = gradientSet[currentgradient];
        gradientChangeAnimation.fillMode = .forwards;
        gradientChangeAnimation.isRemovedOnCompletion = false;
        gradientChangeAnimation.delegate = self;
        gradient.add(gradientChangeAnimation, forKey: "colorChange");
    }
    
    @IBAction func exitCredits(_ sender: Any) {
        dismiss(animated: true);
        UIImpactFeedbackGenerator(style: .light).impactOccurred();
    }
    
    
}
