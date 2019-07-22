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
    func createList(_ search:String, list:[iTunesItem])
    func updateList(_ search:String, list:[iTunesItem])
    func updateEnd()
}

class SearchService {
    
    private var lastSearch: String = ""
    weak var delegate: iTunesSearchDelegate?

    private lazy var session:URLSession = {
        return URLSession(configuration: .default)
    }()
    
    private let mainURL = "https://itunes.apple.com/"
    
    private func searchRequest(search: String, offset: Int = 0) -> URLRequest! {
        let limit = 35
        let params = search.replacingOccurrences(of:" ", with: "+")
        let escaped = params.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let path = String(format:"\(mainURL)search?term=%@&limit=\(limit)&offset=%d", escaped!, offset)
        let url = URL(string:path)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        return request
    }
    
    private func load(_ search:String, list:[iTunesItem]) {
        print("По запросу '\(search)' получено \(list.count) треков")
        
        if (search == self.lastSearch) {
            Utils.stopNetworkActivity(true)
        }
        
        self.delegate?.createList(search, list: list)
    }
    
    private func update(_ search:String, list:[iTunesItem], offset:Int) {
        print("По запросу '\(search)' добавлено \(list.count) треков со сдвигом \(offset)")
        
        Utils.stopNetworkActivity(true)
        
        delegate?.updateList(search, list: list)
    }
    
    
    private func searchError(_ message:String) {
        
        Utils.stopNetworkActivity(true)
        
        delegate?.showMessageList(message)
    }
    
    private func updateError(_ message:String) {
        print(message)
        
        Utils.stopNetworkActivity(true)
        
        delegate?.updateEnd()
    }
    
    func beginSearch(search:String) {
        lastSearch = search
        
        guard let request = searchRequest(search: search) else {
            searchError("Ошибка: неправильный запрос")
            return
        }
        
        Utils.runNetworkActivity()
        
        let searchDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if let requestError = error {
                self.searchError("Ошибка: \(requestError.localizedDescription)")
                return
            }
            
            guard let rdata = data else {
                self.searchError("Ошибка:  Пустой ответ")
                return
            }
            
            var list: iTunesList = iTunesList()
            
            do {
                list = try JSONDecoder().decode(iTunesList.self, from: rdata)
            } catch (let decodeError){
                self.searchError("Ошибка: \(decodeError.localizedDescription)")
            }
            
            if list.resultCount == 0 {
                self.searchError("По запросу'\(search)' ничего не найдено")
                return
            }
            
            self.load(search, list: list.results)
        })
        
        searchDataTask.resume()
    }
    
    func updateSearch (offset:Int) {
        
        guard let request = searchRequest(search: lastSearch, offset: offset) else {
            self.updateError("Ошибка: Неправильный запрос")
            return
        }
        
        Utils.runNetworkActivity()
        
        let searchDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard let rdata = data else {
                self.updateError("Ошибка: Пустой ответ")
                return
            }
            
            var list: iTunesList = iTunesList()
            
            do {
                list = try JSONDecoder().decode(iTunesList.self, from: rdata)
            } catch (let error) {
                self.updateError("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if list.resultCount == 0 {
                self.updateError("Ошибка: количество новых элементов равно нулю")
                return
            }
            
            self.update(self.lastSearch ,list: list.results, offset: offset)
            
        })
        
        searchDataTask.resume()
        
    }
    
}
