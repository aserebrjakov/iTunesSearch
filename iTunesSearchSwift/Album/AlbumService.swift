//
//  AlbumList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 10/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

class AlbumService {

    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    private let mainURL = "https://itunes.apple.com/"
    
    private func albumRequest (collectionID: Int) -> URLRequest! {
        let collection = String(collectionID)
        let path = String(format:"\(mainURL)lookup?id=\(collection)&entity=song")
        let url = URL(string:path)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        return request
    }
    
    func albumPreload(_ collectionId:Int!, completion:@escaping (_ list: [iTunesItem]?) -> ()) {
        guard let collectId = collectionId else {return}
        
        Utils.runNetworkActivity()
        
        guard let request = albumRequest(collectionID: collectId) else {
            return
        }
        
        let albumDataTask = self.session.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let rdata = data else {
                print("Ошибка: пустой ответ")
                return
            }
            
            var list: iTunesList = iTunesList()
            
            do {
                list = try JSONDecoder().decode(iTunesList.self, from: rdata)
            } catch (let error){
                print("Ошибка: \(error.localizedDescription)")
            }
            
            Utils.stopNetworkActivity(true)
            print("В альбоме получено \(list.resultCount - 1) треков")
            
            completion(list.results)
        })
        
        albumDataTask.resume()
    }
}
