//
//  SearchList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 05/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

protocol iTunesSearchDelegate: AnyObject {
    func showMessageList(_ message:String)
    func updateError(_ message:String)
    func showList()
}

typealias iTunesData = iTunesList<iTunesItem>

class SearchList<T> {
    
    var items: [T] = []
    var lastSearch: String = ""
    var isUpdate: Bool = false
    weak var delegate: iTunesSearchDelegate?
    
    subscript(index: Int) -> T {
        let item = items[index]
        return item
    }
    
    var count:Int {
        return items.count
    }
    
    private lazy var session:URLSession = {
        return URLSession(configuration: .default)
    }()
    
    let mainURL = "https://itunes.apple.com/"
    
    func searchURL(search: String, offset: Int = 0) -> URL! {
        let limit = 35
        let params = search.replacingOccurrences(of:" ", with: "+")
        let escaped = params.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let path = String(format:"\(mainURL)search?term=%@&limit=\(limit)&offset=%d", escaped!, offset)
        let url = URL(string:path)
        return url
    }
    
    private func load(_ search:String, list:[T]) {
        print("По запросу '\(search)' получено \(list.count) треков")
        items = []
        list.forEach { item in
            items.append(item)
        }
        
        if (search == self.lastSearch) {
            Utils.stopNetworkActivity(true)
        }
        
        delegate?.showList()
    }
    
    private func update(_ search:String, list:[T]) {
        print("По запросу '\(search)' добавлено \(list.count) треков со сдвигом \(items.count)")
        list.forEach { (item) in
            items.append(item)
        }
        
        Utils.stopNetworkActivity(true)
        
        isUpdate = false
        delegate?.showList()
    }
    
    func clean() {
        items = []
    }
    
    func beginSearch(search:String) {
        
        lastSearch = search
        Utils.runNetworkActivity()
        let url = searchURL(search: search)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        
        let searchRequest = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard let rdata = data else {
                self.delegate?.showMessageList("Ошибка: пустой ответ")
                return
            }
            
            var list: iTunesData = iTunesData()
            
            
            do {
                list = try JSONDecoder().decode(iTunesData.self, from: rdata)
            } catch (let error){
                self.delegate?.showMessageList("Ошибка: \(error.localizedDescription)")
            }
            
            if list.resultCount == 0 {
                self.delegate?.showMessageList("По запросу'\(search)' ничего не найдено")
            } else {
                self.load(search ,list: list.results as! [T])
            }
            
        })
        searchRequest.resume()
    }
    
    func updateSearch () {
        if isUpdate {return}
        
        isUpdate = true
        
        Utils.runNetworkActivity()
        let url = searchURL(search: lastSearch, offset: items.count)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        
        let searchRequest = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard let rdata = data else {
                self.delegate?.updateError("Ошибка: пустой ответ")
                return
            }
            
            var list: iTunesData = iTunesData()
            
            do {
                list = try JSONDecoder().decode(iTunesData.self, from: rdata)
            } catch (let error) {
                self.delegate?.updateError("Ошибка: \(error.localizedDescription)")
            }
            
            if list.resultCount > 0 {
                self.update(self.lastSearch ,list: list.results as! [T])
            } else {
                self.delegate?.updateError("Ошибка: количество новых элементов равно нулю")
            }
            
        })
        searchRequest.resume()
        
    }
    
}
