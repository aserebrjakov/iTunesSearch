//
//  AlbumHeaderCell.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension UILabel {
    
    func addAttributedString (name:String, string:String!, separate:String = " ", fontSize:CGFloat = 15, nameColor:UIColor = .black, stringColor:UIColor = .darkGray)  {
        
        guard let addString = string else { return }
        
        let nameAttributes = [
            NSAttributedStringKey.foregroundColor: nameColor,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)]
    
        let attrString = NSMutableAttributedString (string:name, attributes:nameAttributes)
        
        attrString.append(NSAttributedString(string:separate, attributes:nameAttributes))
        
        let addAttributes = [
            NSAttributedStringKey.foregroundColor: stringColor /*UIColor.darkGray*/,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]
        
        attrString.append(NSAttributedString(string:addString, attributes:addAttributes))
        self.attributedText = attrString
    }
}

class AlbumHeaderCell: UITableViewCell {
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    func configureCell(item: iTunesItem!) {
        
        self.collectionNameLabel.addAttributedString(name:"Альбом:", string:item.collectionName!)
        self.artistNameLabel.addAttributedString(name:"Артист:", string:item.artistName!)
        self.genreLabel.addAttributedString(name:"Жанр:", string:item.info.genreName!)
        self.countryLabel.addAttributedString(name:"Страна:", string:item.info.country!)
        self.releaseDateLabel.addAttributedString(name:"Год:", string:item.year)
        
        self.artworkImageView?.image = UIImage(named:"noArtwork")
        NetworkManager.downloadImage(path: item.artworkUrl600) { (image) in
            self.artworkImageView.image = image
            self.layoutIfNeeded()
        }
    }
    
    static func height() -> CGFloat {
        return 137
    }
}

class AlbumTrackCell : UITableViewCell {
    
    func configureCell(item: iTunesItem!) {
        self.textLabel!.text = String("\(item.fullTrackNumber)  \(item.trackName!)")
        self.detailTextLabel!.text = item.trackLenght()
    }
    
    func checkTrack(_ equal:Bool) {
        if equal {
            let font = UIFont.systemFont(ofSize: (self.textLabel?.font.pointSize)! , weight: .bold)
            self.textLabel?.font = font
            self.detailTextLabel?.font = font
        } else {
            let font = UIFont.systemFont(ofSize: (self.textLabel?.font.pointSize)!)
            self.textLabel?.font = font
            self.detailTextLabel?.font = font
        }
    }
    
    override func prepareForReuse() {
        let font = UIFont.systemFont(ofSize: (self.textLabel?.font.pointSize)!)
        self.textLabel?.font = font
        self.detailTextLabel?.font = font
        super.prepareForReuse()
    }
    
    static func height() -> CGFloat {
        return 44
    }
}
