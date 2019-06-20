//
//  AlbumTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class AlbumViewModel {
    
    var list = [iTunesItem]()
    var trackId: Int
    var presenter: AlbumViewController!
    var backClosure: ((_ item:iTunesItem)  -> ())?
    
    init(_ list: [iTunesItem], track: Int?) {
        self.list = list
        self.trackId = track ?? 0
    }
    
    func start(presenter : AlbumViewController) {
        self.presenter = presenter
        self.presenter.title = albumName
    }
    
    var albumName: String {
        let first = list[0]
        return String(describing:"Альбом: \(first.collectionName!)")
    }
    
    func height(_ index : Int) -> CGFloat {
        return index == 0 ? AlbumHeaderCell.height() : AlbumTrackCell.height()
    }
    
    func sections () -> Int {
        return 1
    }
    
    func count () -> Int {
        return list.count
    }
    
    func item(_ index : Int) -> iTunesItem {
        return list[index]
    }
    
    func selectItem(_ index : Int) {
        let item = list[index]
        self.backClosure!(item)
    }
}

class AlbumViewController: UITableViewController {
    
    var viewModel:AlbumViewModel!
    
    private let cellTrackIdentifier: String = "albumTrackCell"
    private let cellHeaderIdentifier: String = "albumHeaderCell"
    
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
     //   DataManager.loadPreview(item: list[indexPath.row])
        self.viewModel.selectItem(indexPath.row)
        self.navigationController?.popViewController(animated: true);
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return (indexPath == IndexPath(row: 0, section: 0)) ? nil: indexPath
    }
}
