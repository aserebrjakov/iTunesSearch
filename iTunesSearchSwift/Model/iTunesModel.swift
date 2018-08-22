//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 14.08.2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

protocol iTunesSearchDelegate: AnyObject {
    func showClearList(_ message:String)
    func showList()
}

protocol iTunesAlbumDelegate: AnyObject {
    func albumDidLoad()
}

enum responceEnum {
    case complete (iTunesList)
    case error (String)
}

class iTunesModel: NSObject {
    
    static let model = iTunesModel()
    
    private var searchList: iTunesList = iTunesList()
    private var albumList: iTunesList = iTunesList()
    private var albumID: Int!
    weak var searchDelegate:iTunesSearchDelegate?
    weak var albumDelegate:iTunesAlbumDelegate?
    
    var lastSearchString:String = ""
    
    var previewItem: iTunesItem!
    
    func searchItem (indexPath:IndexPath) -> iTunesItem? {
        guard indexPath.row < self.searchList.results.count else {
            return nil
        }
        
        let item = self.searchList.results[indexPath.row]
        
        return item
    }
    
    func albumItem (indexPath:IndexPath) -> iTunesItem {
        let item = self.albumList.results[indexPath.row]
        return item
    }
    
    func searchItemsCount() -> Int {
        return self.searchList.results.count
    }
    
    func albumItemsCount() -> Int {
        return self.albumList.results.count
    }
    
    func albumSearch(collectionID:Int) {
        
        if let albID = self.albumID, albID == collectionID {return}
        
        NetworkManager.albumSearchRequest(collectionID:collectionID) { (responseData) in
        
            NetworkManager.stopNetworkActivityIndicator(true)

            //print(String(data: responseData! as Data, encoding: String.Encoding.utf8) ?? "")
            
            let responce:responceEnum = iTunesModel.data2iTunesList(responseData: responseData)
            switch responce {
            case let .error (message):
                print("Ошибка парсера: \(message)")
                break
            case .complete(let list):
                self.albumID = collectionID
                self.albumList = list
                self.albumDelegate?.albumDidLoad()
            }
        }
    }
    
    func beginSearch(searchString:String) {
        
        if searchString.count == 0 {
            searchDelegate?.showClearList("Введите ключевые слова в строке поиска")
            return
        } else if searchString.count < 5 {
            searchDelegate?.showClearList("В запросе должно быть не менее 5 символов")
            return
        }
        
        self.lastSearchString = searchString        
        NetworkManager.iTunesSearchRequest(searchString:searchString) { (responseData, searchString) in
            
            if (searchString == self.lastSearchString) {
                NetworkManager.stopNetworkActivityIndicator(searchString == self.lastSearchString)
                
                let responce:responceEnum = iTunesModel.data2iTunesList(responseData: responseData)
                
                switch responce {
                    case let .error (message):
                        self.searchDelegate?.showClearList(message as String)
                        break
                    case .complete(let list):
                        if list.resultCount == 0 {
                            self.searchDelegate?.showClearList("По запросу'\(searchString)' ничего не найдено")
                        } else {
                            print("По запросу '\(searchString)' получено \(list.resultCount) треков")
                            self.searchList = list
                            self.searchDelegate?.showList()
                        }
                }
            }
        }
    }
    
    //универсальный парсер из Data в массив элементов iTunesItem
    static func data2iTunesList(responseData:Data?) -> responceEnum {
        
        guard let data = responseData else {
            return responceEnum.error("Ошибка: пустой ответ")
        }
        
        do {
            //парсим Data в Codable объект
            let list: iTunesList = try JSONDecoder().decode(iTunesList.self, from: data)
            return responceEnum.complete(list)
        } catch {
            return responceEnum.error("Ошибка: полученные данные не являются JSON")
        }
    }
}
