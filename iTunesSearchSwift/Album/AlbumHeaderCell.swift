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
    
    var artworkImageView: UIImageView = UIImageView(frame: CGRect.zero)
    var stackView: UIStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addImageView(&artworkImageView)
        self.addStackView(stack: &stackView)
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
    
    func addStackView(stack:inout UIStackView) {
        stack.axis  = NSLayoutConstraint.Axis.vertical
        stack.distribution  = UIStackView.Distribution.fillProportionally
        stack.alignment = UIStackView.Alignment.leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        stack.leftAnchor.constraint(equalTo: artworkImageView.rightAnchor, constant: 15).isActive = true
        stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        contentView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8).isActive = true
    }
    
    
    func titleLabel(name:String, string:String!) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false;
        let text = Utils.twoWord(name:name, string:string)
        label.attributedText = text
        return label
    }
    
    func configureCell(item: iTunesItem!) {
        
        stackView.addArrangedSubview(titleLabel(name:"Альбом:", string:item.collectionName!))
        stackView.addArrangedSubview(titleLabel(name:"Артист:", string:item.artistName!))
        stackView.addArrangedSubview(titleLabel(name:"Жанр:", string:item.genreName!))
        stackView.addArrangedSubview(titleLabel(name:"Страна:", string:item.country!))
        stackView.addArrangedSubview(titleLabel(name:"Год:", string:item.year))
        
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
