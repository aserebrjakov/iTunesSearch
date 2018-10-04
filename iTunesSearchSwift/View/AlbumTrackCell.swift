//
//  AlbumListViewCell.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 23.09.2018.
//  Copyright © 2018 iMac. All rights reserved.
//

import UIKit

class AlbumTrackCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(item: iTunesItem!, trackId:Int?) {
        self.textLabel?.text = String("\(item.fullTrackNumber)  \(item.trackName!)")
        self.detailTextLabel?.text = item.trackLenght()
        self.checkTrack(item.trackId == trackId)
    }
    
    func checkTrack(_ equal:Bool) {
        let size = self.textLabel?.font.pointSize
        let font = equal ? UIFont.systemFont(ofSize: size! , weight: .bold) : UIFont.systemFont(ofSize: size!)
        self.textLabel?.font = font
        self.detailTextLabel?.font = font
    }
    
//    func configureCell(item: iTunesItem!) {
//        self.textLabel?.text = String("\(item.fullTrackNumber)  \(item.trackName!)")
//        self.detailTextLabel?.text = item.trackLenght()
//    }
//
//    func checkTrack(_ equal:Bool) {
//        if equal {
//            let font = UIFont.systemFont(ofSize: (self.textLabel?.font.pointSize)! , weight: .bold)
//            self.textLabel?.font = font
//            self.detailTextLabel?.font = font
//        } else {
//            let font = UIFont.systemFont(ofSize: (self.textLabel?.font.pointSize)!)
//            self.textLabel?.font = font
//            self.detailTextLabel?.font = font
//        }
//    }
//
    override func prepareForReuse() {
        let font = UIFont.systemFont(ofSize: (self.textLabel?.font.pointSize)!)
        self.textLabel?.font = font
        self.detailTextLabel?.font = font
        super.prepareForReuse()
    }
    
    static func height() -> CGFloat {
        return 44
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
