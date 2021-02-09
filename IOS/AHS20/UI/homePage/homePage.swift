//
//  ViewController.swift
//  AHS20
//
//  Created by Richard Wei on 3/14/20.
//  Copyright © 2020 AHS. All rights reserved.
//


// ----- READ: Hello whomever might be reading this. I have many custom features added to this code that you won't find on stock swift projects. This is why I have included some notes that you might want to read below:
/*
- sharedFunc.swift includes the shared functions/classes between all swift files. You can access any of theses functions from any swift file
- CustomUIButton is a custom class that I created that is an extension of the regular UIButton class. The main different to this class is that there are extra data types that allow you allow you to pass data to a ".addTarget" @objc function that you normally wouldn't be able to do. The data types can be found in sharedFunc.swift
*/

//SFProText-Bold, SFProDisplay-Regular, SFProDisplay-Semibold, SFProDisplay-Black

import UIKit
import AudioToolbox
import Firebase
import FirebaseDatabase

class homeClass: UIViewController, UIScrollViewDelegate, UITabBarControllerDelegate {
	
	// link UI elements to swift via outlets
	
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	@IBOutlet weak var featuredLabel: UILabel!
	@IBOutlet weak var featuredScrollView: UIScrollView!
	
	@IBOutlet weak var generalLabel: UILabel!
	@IBOutlet weak var generalInfoScrollView: UIScrollView!
	@IBOutlet weak var generalInfoPageControl: UIPageControl!
	@IBOutlet weak var loadingGeneralView: UIView!

	@IBOutlet weak var districtLabel: UILabel!
	@IBOutlet weak var districtNewsScrollView: UIScrollView!
	@IBOutlet weak var districtNewsPageControl: UIPageControl!
	@IBOutlet weak var loadingDistrictView: UIView!
	
	@IBOutlet weak var asbLabel: UILabel!
	@IBOutlet weak var asbNewsScrollView: UIScrollView!
	@IBOutlet weak var asbNewsPageControl: UIPageControl!
	@IBOutlet weak var loadingASBView: UIView!
	
	
	@IBOutlet weak var featuredMissingLabel: UILabel!
	
	let loading = "Loading...";
	
	let bookmarkImageVerticalInset = CGFloat(5);
	let bookmarkImageHorizontalInset = CGFloat(7);
	
	let bookmarkImageUI = UIImage(named: "invertedbookmark");
	let scrollViewHorizontalConstraints = CGFloat(38);
	//let bookmarkImageUI = UIImage(systemName: "bookmark");
	
	var refreshControl = UIRefreshControl();
	static var featuredArticles = [articleData]();
	
	var featuredSize = 6;
	var featuredFrame = CGRect(x:0,y:0,width:0,height:0);
	var asbNewsSize = 1;
	var asbNewsFrame = CGRect(x:0,y:0,width:0,height:0);
	var	generalInfoSize = 1;
	var generalInfoFrame = CGRect(x:0,y:0,width:0,height:0);
	var districtNewsSize = 1;
	var districtNewsFrame = CGRect(x:0,y:0,width:0,height:0);
	
	internal func getHomeArticleData(){
		
		dataManager.getHomepageData(completion: { (isConnected, index) in
			if (isConnected){
				self.updateViews(with: index);
			}
			else{
				self.featuredLabel.text = "No Connection";
				let infoPopup = UIAlertController(title: "No internet connection detected", message: "No articles were loaded", preferredStyle: UIAlertController.Style.alert);
				infoPopup.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
					self.refreshControl.endRefreshing();
				}));
				self.present(infoPopup, animated: true, completion: nil);
			}
		})
		
	}
	
	private func getScrollViewFromPageControl(with tag: Int) -> UIScrollView{
		switch tag {
		case 0:
			return generalInfoScrollView;
		case 1:
			return districtNewsScrollView;
		case 2:
			return asbNewsScrollView;
		default:
			return UIScrollView();
		}
	}
	
	@IBAction internal func pageControlSelectionAction(_ sender: UIPageControl){
		let page = sender.currentPage;
		let scrollview = getScrollViewFromPageControl(with: sender.tag);
		var frame = scrollview.frame;
		frame.origin.x = frame.size.width * CGFloat(page);
		frame.origin.y = 0;
		scrollview.scrollRectToVisible(frame, animated: true);
	}
	
	override func viewDidLoad() { // setup function
		super.viewDidLoad();
		
		featuredLabel.text = loading;
		asbLabel.text = loading;
		generalLabel.text = loading;
		districtLabel.text = loading;
		
		mainScrollView.alwaysBounceVertical = true;
		getHomeArticleData();
		refreshControl.addTarget(self, action: #selector(refreshAllArticles), for: UIControl.Event.valueChanged);
		mainScrollView.addSubview(refreshControl);
		mainScrollView.delegate = self;
	}
	
	override func viewDidAppear(_ animated: Bool) {
		refreshControl.didMoveToSuperview();
	}
	
	internal func  scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard (scrollView.tag != -1 && asbNewsFrame.size.width != 0 && generalInfoFrame.size.width != 0 && districtNewsFrame.size.width != 0) else{
			return;
		}
		asbNewsPageControl.currentPage = Int(round(asbNewsScrollView.contentOffset.x / asbNewsFrame.size.width));
		
		generalInfoPageControl.currentPage = Int(round(generalInfoScrollView.contentOffset.x / generalInfoFrame.size.width));
		
		districtNewsPageControl.currentPage = Int(round(districtNewsScrollView.contentOffset.x / districtNewsFrame.size.width));
	}
	
	
}

