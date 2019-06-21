//
//  AlbumTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AlbumViewController: UITableViewController {
    
    var viewModel:AlbumViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.register(AlbumTrackCell.self, forCellReuseIdentifier: cellTrackIdentifier)
        tableView.register(AlbumHeaderCell.self, forCellReuseIdentifier: cellHeaderIdentifier)
        viewModel.start(presenter: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.height(indexPath.row)
    }
    
    private let cellTrackIdentifier: String = "albumTrackCell"
    private let cellHeaderIdentifier: String = "albumHeaderCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.item(indexPath.row)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier, for: indexPath) as! AlbumHeaderCell
            cell.configureCell(item: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTrackIdentifier, for: indexPath) as! AlbumTrackCell
            cell.configureCell(item: item, trackId: self.viewModel.trackId)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectItem(indexPath.row)
        self.navigationController?.popViewController(animated: true);
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return (indexPath == IndexPath(row: 0, section: 0)) ? nil: indexPath
    }
}
