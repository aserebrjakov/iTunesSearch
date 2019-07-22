//
//  TrackViewModel.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 21/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class TrackViewModel {
    var service = AlbumService()
    var items: [iTunesItem]
    var previewItem: iTunesItem
    var previewAudio: TrackPreviewAudio!
    var presenter: TrackViewController!
    
    // MARK: - Initilalization -
    
    init(item: iTunesItem) {
        self.previewItem = item
        self.items = []
    }
    
    func start(presenter : TrackViewController) {
        self.presenter = presenter
        
        service.albumPreload(previewItem.collectionId, completion:{ (list) in
            
            guard let albumList = list, albumList.count > 0 else {
                return
            }
            
            self.albumDidLoad(list: albumList)
        })
    }
    
    func update() {
        self.presenter.updateView(previewItem)
        self.previewAudio = TrackPreviewAudio(url: previewItem.previewUrl, delegate: presenter.trackPlayerView!)
        
        //Загрузка из кэша маленькой картинки
        ImageManager.download(path: previewItem.artworkUrl100!) { (image) in
            self.presenter.artworkImageView?.image = image
        }
        
        //Загрузка большой картинки
        ImageManager.download(path: previewItem.artworkUrl600) { (image) in
            self.presenter.artworkImageView?.image = image
            self.presenter.artworkImageView?.alpha = 1.0
        }
    }
    
    func disappear () {
        previewAudio.audioDisappear()
    }
    
    // MARK: - Album -
    
    func albumDidLoad(list:[iTunesItem]) {
        list.forEach { item in
            items.append(item)
        }
        presenter.showRightButton()
    }
    
    func albumViewModel() -> AlbumViewModel {
        let vm = AlbumViewModel(items, track:previewItem.trackId)
        vm.backClosure =  { (item: iTunesItem) -> () in
            self.previewItem = item
        }
        return vm
    }
}
