//
//  structsandclasses.swift
//  AHS20
//
//  Created by Richard Wei on 12/10/20.
//  Copyright © 2020 AHS. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

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

final class InsetLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
    }
}


final public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0

        return (isReachable && !needsConnection)

    }
}
