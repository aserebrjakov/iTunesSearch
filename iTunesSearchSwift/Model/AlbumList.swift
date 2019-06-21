//
//  AlbumList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 10/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

protocol iTunesAlbumDelegate: AnyObject {
    func albumDidLoad()
}

class AlbumList<T> {
    
    var items: [iTunesItem] = []
    weak var delegate:iTunesAlbumDelegate?
    var albumID: Int!
    
    subscript(index: Int) -> iTunesItem {
        let item = items[index]
        return item
    }
    
    var count:Int {
        return items.count
    }
    
    private func load(list:[iTunesItem]) {
        print("В альбоме получено \(list.count - 1) треков")
        
        if list.count == 0 {
            return
        }
        
        items = []
        list.forEach { item in
            items.append(item)
        }
        
        Utils.stopNetworkActivity(true)
        
        self.delegate?.albumDidLoad()
    }
    
    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    private let mainURL = "https://itunes.apple.com/"
    
    func collectionURL(collectionID: Int) -> URL! {
        let collection = String(collectionID)
        let path = String(format:"\(mainURL)lookup?id=\(collection)&entity=song")
        let url = URL(string:path)
        return url
    }
    
    func albumSearchPreload(_ collectionId:Int!) {
        guard let collectId = collectionId else {return}
        
        Utils.runNetworkActivity()
        
        let url = self.collectionURL(collectionID: collectId)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        
        let searchRequest = self.session.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let rdata = data else {
                print("Ошибка: пустой ответ")
                return
            }
            
            var list: iTunesData = iTunesData()
            
            do {
                list = try JSONDecoder().decode(iTunesData.self, from: rdata)
            } catch (let error){
                print("Ошибка: \(error.localizedDescription)")
            }
            
            self.load(list: list.results)
        })
        
        searchRequest.resume()
    }
}
