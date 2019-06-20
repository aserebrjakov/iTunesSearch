//
//  Utils.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 06/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class Utils {

    class func twoWord (name:String, string:String!, separate:String = " ", fontSize:CGFloat = 15, nameColor:UIColor = .black, stringColor:UIColor = .darkGray) -> NSAttributedString! {
        
        guard let addString = string else { return nil }
        
        let nameAttr = [
            NSAttributedString.Key.foregroundColor: nameColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        ]
        
        let addAttr = [
            NSAttributedString.Key.foregroundColor: stringColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)
        ]
        
        let attrString = NSMutableAttributedString (string:name, attributes:nameAttr)
        attrString.append(NSAttributedString(string:separate, attributes:nameAttr))
        attrString.append(NSAttributedString(string:addString, attributes:addAttr))
        
        return attrString
    }

    class func runNetworkActivity() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    class func stopNetworkActivity(_ equal:Bool) {
        if equal {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    
}
