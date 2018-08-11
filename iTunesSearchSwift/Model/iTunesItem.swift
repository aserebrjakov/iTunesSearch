//
//  iTunesItem.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

typealias iTunesDict = Dictionary<String, Any>

struct Disk {
    var trackCount:Int = 1
    var trackNumber:Int = 1
    var discCount:Int = 1
    var discNumber:Int = 1
    
    init(dict:iTunesDict) {
        if let tcount = dict["trackCount"] {trackCount = tcount as! Int}
        if let tnumber = dict["trackNumber"] {trackNumber = tnumber as! Int}
        if let dcount = dict["discCount"] {discCount = dcount as! Int}
        if let dnumber = dict["discNumber"] {discNumber = dnumber as! Int}
    }
    
    func fullTrackNumber() -> String {
        if trackNumber == 1 && trackCount == 1 {
          return ""
        } else if discCount == 1 {
            return String(describing:"\(trackNumber)")
        } else {
            return String(describing:"\(discNumber).\(trackNumber)")
        }
    }
}

struct Info {
    let genreName:String?
    let country:String?
    let releaseDate:String?
    let wrapperType:String?
    let kind:String?
    let longDescription:String?
    
    init(dict:iTunesDict) {
        genreName = dict["primaryGenreName"] as! String?
        country = dict["country"] as! String?
        releaseDate = dict["releaseDate"] as! String?
        longDescription = dict["longDescription"] as! String?
        wrapperType = dict["wrapperType"] as! String?
        kind = dict["kind"] as! String?
    }
}

class iTunesItem {
    
    let sourceDict : Dictionary<String, Any>
    let disk : Disk
    let info : Info
    
    let artistName:String?
    let collectionName:String?
    let trackName:String?
    
    let trackTimeMillis:Int?
    
    let artworkUrl100:String?
    let previewUrl:String?
    
    let collectionId:Int?
    let trackId:Int?
    let artistId:Int?

    init(dict:Dictionary<String, Any>) {
        
        self.sourceDict = dict
    
        collectionId = self.sourceDict["collectionId"]  as! Int?
        trackId = self.sourceDict["trackId"]  as! Int?
        artistId = self.sourceDict["artistId"]  as! Int?
        
        artistName = self.sourceDict["artistName"] as! String?
        collectionName = self.sourceDict["collectionCensoredName"] as! String?
        trackName  = self.sourceDict["trackCensoredName"] as! String?
        
        disk = Disk(dict: self.sourceDict)
        info = Info(dict: self.sourceDict)
        
        trackTimeMillis = self.sourceDict["trackTimeMillis"] as! Int?
        
        artworkUrl100 = self.sourceDict["artworkUrl100"] as! String?
        previewUrl = self.sourceDict["previewUrl"] as! String?
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
    
    //в случае если в коллекции больше одного диска возвращает номер трека вместе с номером диска
    var fullTrackNumber:String {
        return disk.fullTrackNumber()
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
        
        if let date = dateFormatterGet.date(from: self.info.releaseDate!){
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
    
}
