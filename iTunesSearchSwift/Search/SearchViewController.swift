//
//  SearchViewController.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var counter: UILabel!
    
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(presenter: self)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.height()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }

    private let cellReuseIdentifier: String = "SearchCell"
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.checkLast(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SearchCell
        let item = viewModel.item(indexPath.row)
        cell.configureCell(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let item = viewModel.item(indexPath.row)
        performSegue(withIdentifier: "iTunesSegue", sender: item)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "iTunesSegue" {
            if let destination = segue.destination as? TrackViewController {
                if let item = sender as? iTunesItem {
                    let vm = TrackViewModel(item: item)
                    destination.viewModel = vm
                }
            }
        }
    }
    
    // MARK: - SearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func reload<T : UITableViewDelegate & UITableViewDataSource>(delegate : T) {
        DispatchQueue.main.async {
            self.tableView.dataSource = delegate
            self.tableView.delegate = delegate
            self.tableView.reloadData()
        }
    }
}
