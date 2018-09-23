//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 23.09.2018.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

protocol iTunesSearchDelegate: AnyObject {
    func showClearList(_ message:String)
    func showList()
}

protocol iTunesAlbumDelegate: AnyObject {
    func albumDidLoad()
}

class iTunesList: Codable {
    
    var resultCount:Int
    var results: [iTunesItem]
    
    init() {
        resultCount = 0
        results = []
    }
    
    func load(_ list:iTunesList) {
        resultCount = list.resultCount
        results = list.results
    }
    
    subscript(index: Int) -> iTunesItem {
        let item = results[index]
        return item
    }
    
    var count:Int {
        return results.count
    }
}

class SearchList : iTunesList {
    weak var delegate:iTunesSearchDelegate?
    var lastSearchString:String = ""
}

class AlbumList : iTunesList {
    weak var delegate:iTunesAlbumDelegate?
    var albumID: Int!
}
