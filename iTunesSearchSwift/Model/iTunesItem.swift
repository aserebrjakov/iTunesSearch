//
//  iTunesItem.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 14.08.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class iTunesList: Codable {
    
    var resultCount:Int
    var results: [iTunesItem]
    
    init() {
        resultCount = 0
        results = []
    }
}

struct iTunesItem: Codable {
    
    var type, wrapperType, kind: String?
    var genreName, country, releaseDate :String?
    var description, longDescription: String?
    var artistName, collectionName, trackName:String?
    var collectionId, trackId, artistId :Int?
    var trackTimeMillis, trackCount, trackNumber, discCount, discNumber :Int?
    var artworkUrl100, previewUrl :String?
    
    private enum CodingKeys: String, CodingKey {
        case type, wrapperType, kind
        case genreName = "primaryGenreName", country, releaseDate
        case description, longDescription
        case artistName, collectionName = "collectionCensoredName", trackName  = "trackCensoredName"
        case collectionId, trackId, artistId
        case trackTimeMillis, trackCount, trackNumber, discCount, discNumber
        case artworkUrl100, previewUrl
    }
    
    //в случае если в коллекции больше одного диска возвращает номер трека вместе с номером диска
    var fullTrackNumber:String {
        guard let tnumber = trackNumber else {
            return ""
        }
    
        let dnumber = discNumber ?? 1
        let dcount = discCount ?? 1
        
        if dnumber == 1 && dcount == 1 {
            return String(describing:"\(tnumber)")
        } else {
            return String(describing:"\(dnumber).\(tnumber)")
        }
    }
    
    //возвращает время в виде строки формата Ч:ММ:CC либо пустую строку
    func trackLenght() -> String {
        
        guard let timeMillis = trackTimeMillis else {
            return ""
        }
        
        let lenght:Int = timeMillis/1000
        let seconds:Int = lenght % 60;
        let minutes:Int = (lenght / 60) % 60;
        let hours:Int = lenght / 3600;
        
        if hours > 0 {
            return String(format:"%d:%02d:%02d",hours, minutes, seconds);
        } else {
            return String(format:"%d:%02d", minutes, seconds);
        }
    }
    
    //возвращает ссылку на обложку альбома в высоком разрешении
    var artworkUrl600:String {
        return (artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600"))!
    }
    
    //возвращает дату релиза альбома в виде строки (в данном случае только год)
    var year:String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        if let date = dateFormatterGet.date(from: self.releaseDate!){
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
}
