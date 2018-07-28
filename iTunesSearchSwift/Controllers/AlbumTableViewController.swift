//
//  AlbumTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController, iTunesAlbumDelegate {
    let model = DataManager.shared.model
    var collectionID:Int?
    var trackID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.albumDelegate = self
    }

    // MARK: - Model delegate
    
    func albumDidLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  indexPath.row == 0 ? AlbumHeaderCell.height() : AlbumTrackCell.height()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.albumItemsCount()
    }

    private let cellTrackIdentifier: String = "albumTrackCell"
    private let cellHeaderIdentifier: String = "albumHeaderCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = model.albumItem(indexPath: indexPath)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier, for: indexPath) as! AlbumHeaderCell
            cell.configureCell(item: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTrackIdentifier, for: indexPath) as! AlbumTrackCell
            cell.configureCell(item: item)
            cell.checkTrack(self.trackID == item.trackId)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model.albumItem(indexPath: indexPath)
        self.model.previewItem = item
        self.navigationController?.popViewController(animated: true);
    }
}
