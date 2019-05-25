//
//  SearchViewModel.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 25/05/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel: iTunesSearchDelegate {
    var list = DataManager.shared.searchList
    var presenter : SearchViewController?
    var message : MessageView = MessageView()
    
    
    func start (presenter : SearchViewController) {
        list.delegate = self
        list.beginSearch(searchString: "")
        self.presenter = presenter
    }
    
    func search (_ text : String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.list.beginSearch(searchString: text)
        }
    }
    
    // MARK: - iTunesSearchDelegate
    
    func showMessageList(_ message:String) {
        self.message.message = message
        self.presenter?.reload(delegate: self.message)
    }
    
    func showList () {
        self.presenter?.reload(delegate: self.presenter!)
    }
    
    func height() -> CGFloat {
        return SearchCell.height()
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
    
}

// Показывает пустой список с сообщениями.
class MessageView:NSObject, UITableViewDelegate, UITableViewDataSource {
    var message:String!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private let notFoundCellIdentifier: String = "NotFoundCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notFoundCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.message
        return cell
    }
}
