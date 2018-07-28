//
//  iTunesItem.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class iTunesItem {
    
    let sourceDict : Dictionary<String, Any>
    
    let artistName:String?
    let collectionName:String?
    let trackName:String?
    
    let trackCount:Int?
    let trackNumber:Int?
    let trackTimeMillis:Int?
    let discCount:Int?
    let discNumber:Int?
    
    let country:String?
    let releaseDate:String?
    
    let artworkUrl100:String?
    let previewUrl:String?
    let longDescription:String?
    

    let primaryGenreName:String?
    let collectionId:Int?
    let trackId:Int?
    
//    let artistId:Int?
//    let wrapperType:String?
//    let kind:String?

    init(dict:Dictionary<String, Any>) {
        
        self.sourceDict = dict
    
        collectionId = self.sourceDict["collectionId"]  as! Int?
        trackId = self.sourceDict["trackId"]  as! Int?
        primaryGenreName = self.sourceDict["primaryGenreName"] as! String?
        
        artistName = self.sourceDict["artistName"] as! String?
        collectionName = self.sourceDict["collectionCensoredName"] as! String?
        trackName  = self.sourceDict["trackCensoredName"] as! String?
        
        trackCount = self.sourceDict["trackCount"] as! Int?
        trackNumber = self.sourceDict["trackNumber"]  as! Int?
        trackTimeMillis = self.sourceDict["trackTimeMillis"] as! Int?
        discCount = self.sourceDict["discCount"] as! Int?
        discNumber = self.sourceDict["discNumber"] as! Int?
        
        country = self.sourceDict["country"] as! String?
        releaseDate = self.sourceDict["releaseDate"] as! String?
        
        artworkUrl100 = self.sourceDict["artworkUrl100"] as! String?
        previewUrl = self.sourceDict["previewUrl"] as! String?
        
        //описание для фильмов
        longDescription = self.sourceDict["longDescription"] as! String?
        
    //   wrapperType = self.sourceDict["wrapperType"] as! String?
    //   kind = self.sourceDict["kind"] as! String?
    //   artistId = self.sourceDict["artistId"]  as! Int?
        
    }
    
    //возвращает время в виде строки формата Ч:ММ:CC либо пустую строку
    func trackLenght() -> String {
    
        guard trackTimeMillis != nil else {
            return ""
        }
        
        let lenght:Int = trackTimeMillis!/1000
        let seconds:Int = lenght % 60;
        let minutes:Int = (lenght / 60) % 60;
        let hours:Int = lenght / 3600;
    
        if hours > 0 {
            return String(format:"%d:%02d:%02d",hours, minutes, seconds);
        } else {
            return String(format:"%d:%02d", minutes, seconds);
        }
    }
    
    //в случае если в коллекции больше одного диска воззвращает номер трека вместе с номером диска
    func fullTrackNumber() -> String {
        
        guard let number = self.trackNumber else {
            return ""
        }
        
        let dcount = self.discCount ?? 1
        let dnumber = self.discNumber ?? 1
        
        if dcount == 1 {
            return String(describing:"\(number)")
        } else {
            return String(describing:"\(dnumber).\(number)")
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
