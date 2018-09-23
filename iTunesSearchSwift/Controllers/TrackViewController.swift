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

    @objc func didTapAlbumButton() {
        let albumView = AlbumTableViewController()
        self.navigationController?.pushViewController(albumView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.albumList.delegate = self
        model.albumSearchPreload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.view as! TrackView).updateView(model.previewItem!)
        self.previewAudio = PreviewAudio(url: model.previewItem?.previewUrl, delegate: self.view as? PreviewAudioDelegate)
        self.updateNavigationBar()
    }
    
    func updateNavigationBar() {
        if let collectionName = model.previewItem!.collectionName {
            if model.albumList.count > 0 {
                let rightSideOptionButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapAlbumButton))
                self.navigationItem.rightBarButtonItem = rightSideOptionButton
            }
            self.navigationItem.previewTitle(name:self.model.previewItem.trackName , album: collectionName)
        } else {
            self.title = model.previewItem!.trackName
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
