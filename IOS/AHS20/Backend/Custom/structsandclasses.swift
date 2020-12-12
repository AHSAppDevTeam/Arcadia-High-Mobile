//
//  structsandclasses.swift
//  AHS20
//
//  Created by Richard Wei on 12/10/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit


class CustomUIButton: UIButton{
    var articleIndex = -1;
    var articleCompleteData = articleData();
}

class notificationUIButton: CustomUIButton{
    var alreadyRead = false;
    var notificationCompleteData = notificationData();
}

struct bulletinArticleData: Codable {
    var articleID: String?;
    var articleTitle: String?;
    var articleUnixEpoch: Int64?; // unix epoch time stamp
    var articleBody: String?;
    var articleCatagory: String?;
    var articleType = -1;
    var hasHTML = false;
}

struct articleData: Codable {
    var articleID: String?;
    var articleTitle: String?;
    var articleUnixEpoch: Int64?; // unix epoch time stamp
    var articleBody: String?;
    var articleAuthor: String?;
    var articleImages: [String]?; // list of image urls
    var articleVideoIDs: [String]?;
    var articleCatagory: String?;
    var isFeatured = false;
    var hasHTML = false;
}

struct notificationData: Codable{
    var messageID: String?;
    var notificationTitle: String?;
    var notificationBody: String?;
    var notificationUnixEpoch: Int64?;
    var notificationArticleID: String?; // articleID pointer
    var notificationCatagory: Int?; // 0 - 3 : 0 is sports 1 is asb 2 is district 3 is bulletin
}
