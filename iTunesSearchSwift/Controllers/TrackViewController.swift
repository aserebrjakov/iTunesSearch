//
//  TrackViewViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController, iTunesAlbumDelegate {
    
    public let model = iTunesModel.model
    var previewAudio:PreviewAudio!
    
    @IBAction func didTapPlayerButton(_ sender: PlayerButton) {
        self.previewAudio.didTapButton()
    }
    
    // MARK: - Model delegate
    
    func albumDidLoad() {
        DispatchQueue.main.async {
            self.updateNavigationBar()
        }
    }

    func albumSearchPreload() {
        guard let collectionID = self.model.previewItem.collectionId else {
            return
        }
        
        self.model.albumSearch(collectionID: collectionID)
    }
    
    @objc func didTapAlbumButton() {
        let albumView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumTableViewController") as! AlbumTableViewController
        
        self.navigationController?.pushViewController(albumView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.albumDelegate = self
        self.albumSearchPreload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.view as! TrackView).updateView(item: self.model.previewItem!)
        self.previewAudio = PreviewAudio(url: self.model.previewItem?.previewUrl, delegate: self.view as? PreviewAudioDelegate)
        self.updateNavigationBar()
    }
    
    func updateNavigationBar() {
        if let collectionName = self.model.previewItem.collectionName {
            if model.albumItemsCount() > 0 {
                let rightSideOptionButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapAlbumButton))
                self.navigationItem.rightBarButtonItem = rightSideOptionButton
            }
            self.navigationItem.previewTitle(name:self.model.previewItem.trackName , album: collectionName)
        } else {
            self.title = self.model.previewItem.trackName
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
