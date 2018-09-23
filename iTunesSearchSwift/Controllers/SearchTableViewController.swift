//
//  SearchTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// Контроллер который показывает пустой список с сообщениями.
class ClearListTableViewController: UITableViewController {
    var message:String!
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private let notFoundCellIdentifier: String = "NotFoundCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notFoundCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.message
        return cell
    }
}

class SearchTableViewController: UITableViewController, UISearchBarDelegate, iTunesSearchDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var clearListTableViewController:ClearListTableViewController = ClearListTableViewController()
    let model = iTunesModel.model
    var list = iTunesModel.model.searchList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearListTableViewController.loadView()
        self.searchBar.becomeFirstResponder()
        list.delegate = self;
        model.beginSearch(searchString: "")
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchCell.height()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    private let cellReuseIdentifier: String = "SearchCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SearchCell
        let item = list[indexPath.row]
        cell.configureCell(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        self.model.previewItem = list[indexPath.row]
        performSegue(withIdentifier: "iTunesSegue", sender: self)
    }
    
    // MARK: - SearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.model.beginSearch(searchString: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - iTunesSearchDelegate
    
    func showClearList(_ message:String) {
        DispatchQueue.main.async {
            self.tableView.dataSource = self.clearListTableViewController
            self.tableView.delegate = self.clearListTableViewController
            self.clearListTableViewController.message = message
            self.tableView.reloadData()
        }
    }
    
    func showList () {
        DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    
}
