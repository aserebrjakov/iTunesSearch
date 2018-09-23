//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 14.08.2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

enum responceEnum {
    case complete (iTunesList)
    case error (String)
}

class iTunesModel: NSObject {
    
    static let model = iTunesModel()
    var searchList: SearchList = SearchList()
    var albumList: AlbumList = AlbumList()
    var previewItem: iTunesItem!
    
    func albumSearch(collectionID:Int) {
        
        if let albID = albumList.albumID, albID == collectionID {return}
        
        NetworkManager.albumSearchRequest(collectionID) { (responseData) in
        
            NetworkManager.stopNetworkActivityIndicator(true)

            //print(String(data: responseData! as Data, encoding: String.Encoding.utf8) ?? "")
            
            let responce:responceEnum = iTunesModel.data2iTunesList(responseData: responseData)
            switch responce {
            case let .error (message):
                print("Ошибка парсера: \(message)")
                break
            case .complete(let list):
                self.albumList.albumID = collectionID
                self.albumList.load(list)
                self.albumList.delegate?.albumDidLoad()
            }
        }
    }
    
    func albumSearchPreload() {
        guard let collectionID = self.previewItem.collectionId else {
            return
        }
        self.albumSearch(collectionID: collectionID)
    }
    
    func beginSearch(searchString:String) {
        
        if searchString.count == 0 {
            searchList.delegate?.showClearList("Введите ключевые слова в строке поиска")
            return
        } else if searchString.count < 5 {
            searchList.delegate?.showClearList("В запросе должно быть не менее 5 символов")
            return
        }
        
        self.searchList.lastSearchString = searchString
        NetworkManager.iTunesSearchRequest(searchString:searchString) { (responseData, searchString) in
            
            if (searchString == self.searchList.lastSearchString) {
                NetworkManager.stopNetworkActivityIndicator(searchString == self.searchList.lastSearchString)
                
                let responce:responceEnum = iTunesModel.data2iTunesList(responseData: responseData)
                
                switch responce {
                    case let .error (message):
                        self.searchList.delegate?.showClearList(message as String)
                        break
                    case .complete(let list):
                        if list.resultCount == 0 {
                            self.searchList.delegate?.showClearList("По запросу'\(searchString)' ничего не найдено")
                        } else {
                            print("По запросу '\(searchString)' получено \(list.resultCount) треков")
                            self.searchList.load(list)
                            self.searchList.delegate?.showList()
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
