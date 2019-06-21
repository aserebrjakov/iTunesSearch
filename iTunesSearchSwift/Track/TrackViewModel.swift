//
//  TrackViewModel.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 21/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class TrackViewModel : iTunesAlbumDelegate {
    var list = AlbumList<iTunesList<iTunesItem>>()
    var previewItem: iTunesItem
    var previewAudio: TrackPreviewAudio!
    var presenter: TrackViewController!
    
    // MARK: - Initilalization -
    
    init(item: iTunesItem) {
        self.previewItem = item
    }
    
    func start(presenter : TrackViewController) {
        self.presenter = presenter
        list.delegate = self
        list.albumSearchPreload(previewItem.collectionId)
    }
    
    func update() {
        presenter.updateView(previewItem)
        previewAudio = TrackPreviewAudio(url: previewItem.previewUrl, delegate: presenter.trackPlayerView!)
        
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
    
    // MARK: - Model delegate
    
    func albumDidLoad() {
        DispatchQueue.main.async {
            if self.list.count == 0 {return}
            self.presenter.navigationItem.rightBarButtonItem = self.presenter.rightButton
        }
    }
    
    func albumViewModel() -> AlbumViewModel {
        let vm = AlbumViewModel(list.items, track:previewItem.trackId)
        vm.backClosure =  { (item: iTunesItem) -> () in
            self.previewItem = item
        }
        return vm
    }
}
