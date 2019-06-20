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
    
    var list: SearchList = SearchList<iTunesItem>()
    var presenter : SearchViewController?
    var messageView : MessageView = MessageView()
    
    func start (presenter : SearchViewController) {
        list.delegate = self
        self.presenter = presenter
        search("")
    }
    
    func search (_ text : String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            if text.count == 0 {
                self.showMessageList("Введите ключевые слова в строке поиска")
                return
            } else if text.count < 5 {
                self.showMessageList("В запросе должно быть не менее 5 символов")
                return
            }
            
            self.list.beginSearch(search: text)
        }
    }
    
    // MARK: - iTunesSearchDelegate
    
    func showMessageList(_ message:String) {
        self.messageView.message = message
        self.presenter?.reload(delegate: self.messageView)
        Utils.stopNetworkActivity(true)
    }
    
    func showList () {
        self.presenter?.reload(delegate: self.presenter!)
        Utils.stopNetworkActivity(true)
    }
    
    func updateError(_ message: String) {
        print(message)
        list.isUpdate = false
        Utils.stopNetworkActivity(true)
    }
    
    // MARK: -
    
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
    
    func checkLast (_ index : Int) {
        if index == count() - 1 {
            self.list.updateSearch()
        }
    }
    
}

// MARK: -

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
