//
//  AlbumTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    let list = DataManager.shared.albumList
    
    private let cellTrackIdentifier: String = "albumTrackCell"
    private let cellHeaderIdentifier: String = "albumHeaderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.register(AlbumTrackCell.self, forCellReuseIdentifier: cellTrackIdentifier)
        tableView.register(AlbumHeaderCell.self, forCellReuseIdentifier: cellHeaderIdentifier)
        self.title = list.albumName
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
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier, for: indexPath) as! AlbumHeaderCell
            cell.configureCell(item: list[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTrackIdentifier, for: indexPath) as! AlbumTrackCell
            cell.configureCell(item: list[indexPath.row], trackId: list.trackId)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataManager.loadPreview(item: list[indexPath.row])
        self.navigationController?.popViewController(animated: true);
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return (indexPath == IndexPath(row: 0, section: 0)) ? nil: indexPath
    }
}
