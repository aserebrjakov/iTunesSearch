//
//  SearchCell.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

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
    
    static func height() -> CGFloat {
        return 65
    }
    
    func configureCell(_ item: iTunesItem!) {
        
        guard let item = item else { return }
        
        self.songNameLabel?.text = item.trackName
        self.songAuthorLabel?.text = item.artistName
        self.songTimeLabel?.text = item.trackLenght()

        self.artworkImageView?.image = NetworkManager.noArtworkImage;
        NetworkManager.downloadImage(path: item.artworkUrl100!) { (image) in
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
