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
    
    var items: [iTunesItem] = []
    var isUpdate: Bool = false
    
    var service : SearchService = SearchService()
    var presenter : SearchViewController?
    var messageView : MessageViewMediator = MessageViewMediator()
    var mediator : SearchViewMediator!
    
    func start (presenter : SearchViewController) {
        service.delegate = self
        self.presenter = presenter
        self.mediator = SearchViewMediator(viewModel: self)
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
            
            self.service.beginSearch(search: text)
        }
    }
    
    func updateLast() {
        if isUpdate {return}
        isUpdate = true
        
        service.updateSearch(offset: items.count)
    }
    
    func cleanList() {
        items = []
    }
    
    // MARK: - iTunesSearchDelegate
    
    
    func createList(_ search:String, list:[iTunesItem]) {
        cleanList()
        list.forEach { item in
            items.append(item)
        }

        self.presenter?.reload(delegate: self.mediator)
    }
    
    func updateList(_ search:String, list:[iTunesItem]) {
        
        list.forEach { (item) in
            items.append(item)
        }
        
        isUpdate = false

        self.presenter?.reload(delegate: self.mediator)
    }
    
    func updateEnd() {
        isUpdate = false
    }
    
    func showMessageList(_ message:String) {
        cleanList()
        self.messageView.message = message
        
        self.presenter?.reload(delegate: self.messageView)
    }
    
    
    // MARK: -
    
    func height() -> CGFloat {
        return SearchCell.height()
    }
    
    func sections () -> Int {
        return 1
    }
    
    func count () -> Int {
        return items.count
    }
    
    func item(_ index : Int) -> iTunesItem {
        return items[index]
    }
    
    func model(_ index : Int) -> SearchCellViewModel {
        let item = items[index]
        return SearchCellViewModel(item)
    }
    
    func checkLast (_ index : Int) {
        if index == count() - 1 {
            updateLast()
        }
    }
    
    func selectItem (index: Int) {
        let item = self.item(index)
        presenter?.segue(item: item)
    }
}


