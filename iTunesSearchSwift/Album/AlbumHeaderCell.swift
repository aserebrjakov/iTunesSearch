//
//  AlbumHeaderCell.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

//extension UILabel {
//
//    func addAttributedString (name:String, string:String!, separate:String = " ", fontSize:CGFloat = 15, nameColor:UIColor = .black, stringColor:UIColor = .darkGray)  {
//
//        guard let addString = string else { return }
//
//        let nameAttributes = [
//            NSAttributedString.Key.foregroundColor: nameColor,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
//        ]
//
//        let attrString = NSMutableAttributedString (string:name, attributes:nameAttributes)
//
//        attrString.append(NSAttributedString(string:separate, attributes:nameAttributes))
//
//        let addAttributes = [
//            NSAttributedString.Key.foregroundColor: stringColor /*UIColor.darkGray*/,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)
//        ]
//
//        attrString.append(NSAttributedString(string:addString, attributes:addAttributes))
//        self.attributedText = attrString
//    }
//}

class AlbumHeaderCell: UITableViewCell {
    
    var collectionNameLabel: UILabel = UILabel(frame: CGRect.zero)
    var artistNameLabel: UILabel = UILabel(frame: CGRect.zero)
    var genreLabel: UILabel = UILabel(frame: CGRect.zero)
    var countryLabel: UILabel = UILabel(frame: CGRect.zero)
    var releaseDateLabel: UILabel = UILabel(frame: CGRect.zero)
    var artworkImageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addImageView(&artworkImageView)
        self.addLabel(label: &collectionNameLabel, highLabel: nil)
        self.addLabel(label: &artistNameLabel, highLabel: collectionNameLabel)
        self.addLabel(label: &genreLabel, highLabel: artistNameLabel)
        self.addLabel(label: &countryLabel, highLabel: genreLabel)
        self.addLabel(label: &releaseDateLabel, highLabel: countryLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addImageView(_ imageView:inout UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func addLabel(label:inout UILabel, highLabel:UILabel!) {
        label.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(label)
        label.leftAnchor.constraint(equalTo: artworkImageView.rightAnchor, constant: 15).isActive = true
        if highLabel != nil {
            label.topAnchor.constraint(equalTo: highLabel.bottomAnchor, constant: 8).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        }
        
    }
    
    func configureCell(item: iTunesItem!) {
        let collection = Utils.twoWord(name:"Альбом:", string:item.collectionName!)
        let artistName = Utils.twoWord(name:"Артист:", string:item.artistName!)
        let genre = Utils.twoWord(name:"Жанр:", string:item.genreName!)
        let country = Utils.twoWord(name:"Страна:", string:item.country!)
        let releaseDate = Utils.twoWord(name:"Год:", string:item.year)
        
        collectionNameLabel.attributedText = collection
        artistNameLabel.attributedText = artistName
        genreLabel.attributedText = genre
        countryLabel.attributedText = country
        releaseDateLabel.attributedText = releaseDate
        
        self.artworkImageView.image = UIImage(named:"noArtwork")
        ImageManager.download(path: item.artworkUrl600) { (image) in
            self.artworkImageView.image = image
            self.layoutIfNeeded()
        }
    }
    
    class func height() -> CGFloat {
        return 137
    }
}
