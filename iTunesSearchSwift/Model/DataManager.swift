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

class DataManager: NSObject {
    
    static let shared = DataManager()
    var searchList: SearchList = SearchList()
    var albumList: AlbumList = AlbumList()
    var previewItem: iTunesItem!
    
    static func loadPreview(item:iTunesItem) {
        self.shared.previewItem = item;
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
        } catch (let error){
            return responceEnum.error(error.localizedDescription)
        }
    }
}
