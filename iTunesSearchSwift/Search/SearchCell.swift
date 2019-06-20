//
//  SearchCell.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

struct SearchCellViewModel {
    let trackName : String?
    let artistName : String?
    let trackLenght : String?
    let artworkUrl : String?
    
    init(_ item:iTunesItem) {
        trackName = item.trackName
        artistName = item.artistName
        trackLenght = item.trackLenght()
        artworkUrl = item.artworkUrl100
    }
}

class SearchCell: UITableViewCell {
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var songAuthorLabel: UILabel!
    @IBOutlet var songTimeLabel: UILabel!
    
    private func setupRoundCorner() {
        self.artworkImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.artworkImageView.layer.borderWidth = 1.0
        self.artworkImageView.layer.cornerRadius = 7
        self.artworkImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupRoundCorner()
    }
    
    class func height() -> CGFloat {
        return 65
    }
    
    func configureCell(_ cellModel: SearchCellViewModel) {
        
        self.songNameLabel?.text = cellModel.trackName
        self.songAuthorLabel?.text = cellModel.artistName
        self.songTimeLabel?.text = cellModel.trackLenght
        
        self.artworkImageView?.image = ImageManager.noArtworkImage;
        ImageManager.download(path: cellModel.artworkUrl) { (image) in
            self.artworkImageView.image = image
            self.layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        self.artworkImageView?.image = nil;
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
