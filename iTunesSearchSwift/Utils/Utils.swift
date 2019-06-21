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

extension Optional {
    func asStringOrEmpty() -> String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}


extension UINavigationItem {
    func previewTitle (name:String?, album:String?) {
        
        let itemName = name ?? ""
        let itemAlbum = album ?? ""
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight: do {
            let attr = Utils.twoWord(name: itemName, string: itemAlbum, separate: " - ", fontSize: 13, nameColor: .white, stringColor: .white)
            label.numberOfLines = 1
            label.attributedText = attr
            }
        default: do {
            label.numberOfLines = 2
            let attr = Utils.twoWord(name: itemName, string: itemAlbum, separate: "\n", fontSize: 16, nameColor: .white, stringColor: .white)
            label.attributedText = attr
            }
        }
        self.titleView = label
    }
}
