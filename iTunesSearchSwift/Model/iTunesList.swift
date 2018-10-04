//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 23.09.2018.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

protocol iTunesSearchDelegate: AnyObject {
    func showMessageList(_ message:String)
    func showList()
}

protocol iTunesAlbumDelegate: AnyObject {
    func albumDidLoad()
}

class iTunesList: Codable {
    
    var resultCount:Int
    var results: [iTunesItem]
    
    init() {
        resultCount = 0
        results = []
    }
        
    subscript(index: Int) -> iTunesItem {
        let item = results[index]
        return item
    }
    
    var count:Int {
        return results.count
    }
}

class SearchList : iTunesList {
    weak var delegate:iTunesSearchDelegate?
    var lastSearchString:String = ""
    
    func load(_ searchString:String, list:iTunesList) {
        print("По запросу '\(searchString)' получено \(list.resultCount) треков")
        resultCount = list.resultCount
        results = list.results
        delegate?.showList()
    }
    
    func beginSearch(searchString:String) {
        
        if searchString.count == 0 {
            self.delegate?.showMessageList("Введите ключевые слова в строке поиска")
            return
        } else if searchString.count < 5 {
            self.delegate?.showMessageList("В запросе должно быть не менее 5 символов")
            return
        }
        
        self.lastSearchString = searchString
        
        NetworkManager.iTunesSearchRequest(searchString: searchString, block: { (responseData, searchString) in
            let responce:responceEnum = DataManager.data2iTunesList(responseData: responseData)
            switch responce {
            case .error (let message):
                self.delegate?.showMessageList(message)
                break
            case .complete(let list):
                if list.resultCount == 0 {
                    self.delegate?.showMessageList("По запросу'\(searchString)' ничего не найдено")
                } else {
                    self.load(searchString ,list: list)
                }
                break
            }
        }) {(searchString) -> (Bool) in
            if (searchString == self.lastSearchString) {
                NetworkManager.stopNetworkActivityIndicator(true)
                return true
            } else {
                return false
            }
        }
    }
}

class AlbumList : iTunesList {
    weak var delegate:iTunesAlbumDelegate?
    var albumID: Int!
    
    var albumName: String {
        if self.count > 0 {
            return String(describing:"Альбом: \(self[0].collectionName!)")
        }
        return ""
    }
    
    var trackId: Int? {
        return DataManager.shared.previewItem.trackId
    }
    
    func load(_ list:iTunesList) {
        resultCount = list.resultCount
        results = list.results
        self.delegate?.albumDidLoad()
    }
    
    func albumSearchPreload(_ collectionId:Int!) {
        guard let collectId = collectionId else {return}
        NetworkManager.albumSearchRequest(collectId) { (responseData) in
            let responce:responceEnum = DataManager.data2iTunesList(responseData: responseData)
            switch responce {
            case .error (let message):
                print("Ошибка парсера: \(message)")
                break
            case .complete(let list):
                self.load(list)
                break
            }
        }
    }
}
