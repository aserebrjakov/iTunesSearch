//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

protocol iTunesSearchDelegate: AnyObject {
    func showClearList(message:String)
    func showList()
}

protocol iTunesAlbumDelegate: AnyObject {
    func albumDidLoad()
}

class iTunesList: NSObject {
    private var searchList: Array<iTunesItem> = []
    private var albumList: Array<iTunesItem> = []
    weak var searchDelegate:iTunesSearchDelegate?
    weak var albumDelegate:iTunesAlbumDelegate?
    
    var lastSearchString:String = ""
    
    var previewItem: iTunesItem!
    
    func searchItem (indexPath:IndexPath) -> iTunesItem? {
        guard indexPath.row < self.searchList.count else {
            return nil
        }
        
        let item = self.searchList[indexPath.row]
        
        return item
    }
    
    func albumItem (indexPath:IndexPath) -> iTunesItem {
        let item = self.albumList[indexPath.row]
        return item
    }
    
    func searchItemsCount() -> Int {
        return self.searchList.count
    }
    
    func albumItemsCount() -> Int {
        return self.albumList.count
    }
    
    func albumSearch(collectionID:Int) {
        DataManager.albumSearchRequest(collectionID:collectionID) { (responseData) in
            
            guard let list = iTunesList.data2iTunesList(responseData: responseData, errorBlock: { (message) in
                print("Ошибка парсера: \(message)")
            }) else {
                return
            }
            self.albumList = list
            self.albumDelegate?.albumDidLoad()
        }
    }
    
    func beginSearch(searchString:String) {
        
        if searchString.count == 0 {
            searchDelegate?.showClearList(message:"Введите ключевые слова в строке поиска")
            return
        } else if searchString.count < 5 {
            searchDelegate?.showClearList(message:"В запросе должно быть не менее 5 символов")
            return
        }
        
        self.lastSearchString = searchString        
        DataManager.iTunesSearchRequest(searchString:searchString) { (responseData, searchString) in
            
            DataManager.stopNetworkActivityIndicator(searchString == self.lastSearchString)
            
            guard let list = iTunesList.data2iTunesList(responseData: responseData, errorBlock: { (message) in
                self.searchDelegate?.showClearList(message:message)
            }) else {
                return
            }
            
            if list.count == 0 {
                self.searchDelegate?.showClearList(message:"По запросу'\(searchString)' ничего не найдено")
            } else {
                print("По запросу '\(searchString)' получено \(list.count) треков")
                self.searchList = list
                self.searchDelegate?.showList()
            }
        }
        
    }
    
    //универсальный парсер из Data в массив элементов iTunesItem
    static func data2iTunesList(responseData:Data?, errorBlock:@escaping (_ message:String) -> () ) -> Array<iTunesItem>? {
        
        guard let data = responseData else {
            errorBlock("Ошибка: пустой ответ")
            return nil
        }
        
        do {
            //парсим Data в словарь
            let json:Dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
            
            //в валидном ответе мы должны получить два поля: "results" с массивом элементов и "resultCount" с количеством этих элементов
            guard let results = json["results"] else {
                errorBlock("Ошибка: полученные данные не являются данными iTunes")
                return nil
            }
            
            //формируем временный массив, который наполняем объектами
            var cacheArr:Array<iTunesItem> = []
            
            for itemDict in results as! Array<Any> {
                let item = iTunesItem(dict:itemDict as! Dictionary<String, Any>)
                cacheArr.append(item)
            }
            
            return cacheArr
            
        } catch {
            errorBlock("Ошибка: полученные данные не являются JSON")
            return nil
        }
    }
}
