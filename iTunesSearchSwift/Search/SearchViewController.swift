//
//  SearchListViewController.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 20/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class SearchCounterLabel: UILabel {
    var viewModel:SearchViewModel!
    
    func update() {
        let count = self.viewModel.count()
        self.text = String(count)
        if count == 0 {
            self.textColor = UIColor.clear
        } else {
            self.textColor = UIColor.darkGray
        }
    }
}

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var counter: SearchCounterLabel!
    
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(presenter: self)
        counter.viewModel = viewModel
        searchBar.becomeFirstResponder()
    }
    
    private let identifier = "iTunesSegue"
    
    func segue(item : iTunesItem) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: identifier, sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
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
            self.counter?.update()
        }
    }

}
