//
//  AlbumTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    let list = iTunesModel.model.albumList
    let	model = iTunesModel.model

    private let cellTrackIdentifier: String = "albumTrackCell"
    private let cellHeaderIdentifier: String = "albumHeaderCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.register(AlbumTrackCell.self, forCellReuseIdentifier: cellTrackIdentifier)
        tableView.register(AlbumHeaderCell.self, forCellReuseIdentifier: cellHeaderIdentifier)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  indexPath.row == 0 ? AlbumHeaderCell.height() : AlbumTrackCell.height()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = list[indexPath.row]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier, for: indexPath) as! AlbumHeaderCell
            cell.configureCell(item: item)
            self.title = String(describing:"Альбом: \(item.collectionName!)")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTrackIdentifier, for: indexPath) as! AlbumTrackCell
            cell.configureCell(item: item)
            cell.checkTrack(model.previewItem?.trackId == item.trackId)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = list[indexPath.row]
        model.previewItem = item
        self.navigationController?.popViewController(animated: true);
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath == IndexPath(row: 0, section: 0) {
            return nil
        } else {
            return indexPath
        }
    }
}
