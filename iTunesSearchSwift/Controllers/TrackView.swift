//
//  TrackView.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

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

@IBDesignable

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
