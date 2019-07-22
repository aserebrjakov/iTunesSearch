//
//  TrackViewViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var trackPlayerView : TrackPlayerView!
    
    var viewModel : TrackViewModel!
    
    lazy var rightButton = UIBarButtonItem(
        barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapAlbumButton)
    )
    
    @objc func didTapAlbumButton() {
        let albumView = AlbumViewController()
        albumView.viewModel = viewModel.albumViewModel()
        self.navigationController?.pushViewController(albumView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(presenter: self)
        trackPlayerView.viewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.update()
        updateNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disappear()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.updateNavigationBar()
    }
    
    func updateNavigationBar() {
        let item = viewModel.previewItem
        
        if let collectionName = item.collectionName {
            self.navigationItem.previewTitle(name:item.trackName , album: collectionName)
        } else {
            self.title = item.trackName
        }
    }
    
    func updateView(_ item:iTunesItem) {
        trackPlayerView?.trackInfoLabel?.text = "Загрузить фрагмент"
        trackNameLabel?.text = item.fullTrackNumber + "  " + item.trackName.asStringOrEmpty()
        authorNameLabel?.text = item.artistName
        
        if item.longDescription != nil {
            collectionNameLabel?.text = item.longDescription!
            collectionNameLabel?.font = UIFont.systemFont(ofSize:16)
        } else {
            collectionNameLabel?.text = item.collectionName!
            collectionNameLabel?.font = UIFont.systemFont(ofSize:21)
        }
    }
    
    func showRightButton() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = self.rightButton
        }
    }
}
