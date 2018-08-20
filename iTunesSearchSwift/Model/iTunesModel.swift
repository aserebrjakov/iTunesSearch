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
            
            guard let list = iTunesModel.data2iTunesList(responseData: responseData, errorBlock: { (message) in
                print("Ошибка парсера: \(message)")
            }) else {
                return
            }
            self.albumID = collectionID
            self.albumList = list
            self.albumDelegate?.albumDidLoad()
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
            
            NetworkManager.stopNetworkActivityIndicator(searchString == self.lastSearchString)
            
            guard let list = iTunesModel.data2iTunesList(responseData: responseData, errorBlock: { (message) in
                self.searchDelegate?.showClearList(message)
            }) else {
                return
            }
            
            if list.resultCount == 0 {
                self.searchDelegate?.showClearList("По запросу'\(searchString)' ничего не найдено")
            } else {
                print("По запросу '\(searchString)' получено \(list.resultCount) треков")
                self.searchList = list
                self.searchDelegate?.showList()
            }
        }
        
    }
    
    //универсальный парсер из Data в массив элементов iTunesItem
    static func data2iTunesList(responseData:Data?, errorBlock:@escaping (_ message:String) -> () ) -> iTunesList? /* Array<iTunesItem> ?*/ {
        
        guard let data = responseData else {
            errorBlock("Ошибка: пустой ответ")
            return nil
        }
        
        do {
            //парсим Data в Codable объект
            let list: iTunesList = try JSONDecoder().decode(iTunesList.self, from: data)
            return list
        } catch {
            errorBlock("Ошибка: полученные данные не являются JSON")
            return nil
        }
    }
}
