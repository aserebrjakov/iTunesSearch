//
//  SearchTableViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, iTunesSearchDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var messageView:MessageViewTableViewController = MessageViewTableViewController()
    var list = DataManager.shared.searchList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageView.loadView()
        self.searchBar.becomeFirstResponder()
        list.delegate = self;
        list.beginSearch(searchString: "")
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
        cell.configureCell(list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        DataManager.loadPreview(item: list[indexPath.row])
        performSegue(withIdentifier: "iTunesSegue", sender: self)
    }
    
    // MARK: - SearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.list.beginSearch(searchString: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - iTunesSearchDelegate
    
    func showMessageList(_ message:String) {
        DispatchQueue.main.async {
            self.tableView.dataSource = self.messageView
            self.tableView.delegate = self.messageView
            self.messageView.message = message
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

// Контроллер который показывает пустой список с сообщениями.
class MessageViewTableViewController: UITableViewController {
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
