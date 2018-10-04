//
//  TrackViewViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController, iTunesAlbumDelegate {
    
    let list = DataManager.shared.albumList
    var previewItem: iTunesItem {
        return DataManager.shared.previewItem
    }
    var previewAudio:PreviewAudio!
    
    @IBAction func didTapPlayerButton(_ sender: PlayerButton) {
        self.previewAudio.didTapButton()
    }
    
    // MARK: - Model delegate
    
    func albumDidLoad() {
        DispatchQueue.main.async {
            if self.list.count == 0 {return}
            self.navigationItem.rightBarButtonItem = self.rightButton
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        list.delegate = self
        list.albumSearchPreload(previewItem.collectionId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.view as! TrackView).updateView(previewItem)
        self.previewAudio = PreviewAudio(url: previewItem.previewUrl, delegate: self.view as? PreviewAudioDelegate)
        self.updateNavigationBar()
    }
    
    @objc func didTapAlbumButton() {
        let albumView = AlbumTableViewController()
        self.navigationController?.pushViewController(albumView, animated: true)
    }
    
    lazy var rightButton = UIBarButtonItem(
        barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapAlbumButton)
    )
    
    func updateNavigationBar() {
        if let collectionName = previewItem.collectionName {
            self.navigationItem.previewTitle(name:previewItem.trackName , album: collectionName)
        } else {
            self.title = previewItem.trackName
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.previewAudio.audioDisappear()
        super.viewDidDisappear(animated)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.updateNavigationBar()
    }
}
