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


let mainThemeColor = UIColor(named: "mainThemeColor")!;
let InverseBackgroundColor = UIColor(named: "InverseBackgroundColor")!;
let BackgroundGrayColor = UIColor(named: "BackgroundGrayColor")!;
let BackgroundColor = UIColor(named: "BackgroundColor")!;
let dull_mainThemeColor = UIColor(named: "dull_mainThemeColor")!;
let dull_BackgroundColor = UIColor(named: "dull_BackgroundColor")!;

var fontSize = 20;
