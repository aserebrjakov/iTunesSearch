//
//  iTunesItem.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 14.08.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension KeyedDecodingContainer {
    func decodeForString(forKey key: KeyedDecodingContainer.Key) throws -> String {
        do {
            return try self.decode(String.self, forKey: key)
        } catch DecodingError.typeMismatch {
            let value = try self.decode(Int.self, forKey: key)
            return String(describing: value)
        }
    }
}

struct iTunesItem: Codable {
    
    var type, wrapperType, kind: String?
    var genreName, country, releaseDate :String?
    var description, longDescription: String?
    var artistName, collectionName, trackName, artistId:String?
    var collectionId, trackId :Int?
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
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try? container.decode(String.self, forKey: .type)
        self.wrapperType = try? container.decode(String.self, forKey: .wrapperType)
        self.kind = try? container.decode(String.self, forKey: .kind)
            
        self.genreName = try? container.decode(String.self, forKey: .genreName)
        self.country = try? container.decode(String.self, forKey: .country)
        self.releaseDate = try? container.decode(String.self, forKey: .releaseDate)
        self.description = try? container.decode(String.self, forKey: .description)
        self.longDescription = try? container.decode(String.self, forKey: .longDescription)
        self.artistName = try? container.decode(String.self, forKey: .artistName)
        self.collectionName = try? container.decode(String.self, forKey: .collectionName)
        self.trackName = try? container.decode(String.self, forKey: .trackName)
        self.artistId = try? container.decodeForString(forKey: .artistId)
        
        self.artworkUrl100 = try? container.decode(String.self, forKey: .artworkUrl100)
        self.previewUrl = try? container.decode(String.self, forKey: .previewUrl)

        self.collectionId = try? container.decode(Int.self, forKey: .collectionId)
        self.trackId = try? container.decode(Int.self, forKey: .trackId)
        self.trackTimeMillis = try? container.decode(Int.self, forKey: .trackTimeMillis)
        self.trackCount = try? container.decode(Int.self, forKey: .trackCount)
        self.trackNumber = try? container.decode(Int.self, forKey: .trackNumber)
        self.discCount = try? container.decode(Int.self, forKey: .discCount)
        self.discNumber = try? container.decode(Int.self, forKey: .discNumber)
    }
}

extension iTunesItem {
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
