//
//  AlbumViewModel.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 21/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class AlbumViewModel {
    
    var list = [iTunesItem]()
    var trackId: Int
    var presenter: AlbumViewController!
    var backClosure: ((_ item:iTunesItem)  -> ())?
    
    init(_ list: [iTunesItem], track: Int?) {
        self.list = list
        self.trackId = track ?? 0
    }
    
    func start(presenter : AlbumViewController) {
        self.presenter = presenter
        self.presenter.title = albumName
    }
    
    var albumName: String {
        let first = list[0]
        return String(describing:"Альбом: \(first.collectionName!)")
    }
    
    func height(_ index : Int) -> CGFloat {
        return index == 0 ? AlbumHeaderCell.height() : AlbumTrackCell.height()
    }
    
    func sections () -> Int {
        return 1
    }
    
    func count () -> Int {
        return list.count
    }
    
    func item(_ index : Int) -> iTunesItem {
        return list[index]
    }
    
    func selectItem(_ index : Int) {
        let item = list[index]
        backClosure!(item)
    }
}
