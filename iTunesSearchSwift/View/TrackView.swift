//
//  TrackView.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension Optional {
    func asStringOrEmpty() -> String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}

@IBDesignable

extension UINavigationItem {
    func previewTitle (name:String?, album:String?) {
        
        let itemName = name ?? ""
        let itemAlbum = album ?? ""
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        switch UIDevice.current.orientation{
            case .landscapeLeft, .landscapeRight: do {
                    label.numberOfLines = 1
                    label.addAttributedString(name: itemName, string: itemAlbum, separate: " - ", fontSize: 13, nameColor: .white, stringColor: .white)
                }
            default: do {
                    label.numberOfLines = 2
                    label.addAttributedString(name: itemName, string: itemAlbum, separate: "\n", fontSize: 16, nameColor: .white, stringColor: .white)
                }
        }
        self.titleView = label
    }
}

class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 3.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

class PlayerButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupButton()
    }
    
    func setupButton() {
        self.addTarget(self, action: #selector(pulsate), for: [.touchUpInside])
    }
    
    func pauseImage () {
        self.setImage(UIImage.init(named:"pause"), for: UIControl.State.normal)
    }
    
    func playImage () {
        self.setImage(UIImage.init(named:"play"), for: UIControl.State.normal)
    }
    
    @objc func pulsate () {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.7
        pulse.toValue = 1.0
        pulse.repeatCount = 0
        layer.add(pulse, forKey: "pulse")
    }
}

class TrackView : UIView, PreviewAudioDelegate {
    
    var item:iTunesItem?
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackInfoLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playerButton: PlayerButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateView(_ item:iTunesItem) {
        self.item = item
        self.trackInfoLabel?.text = "Загрузить фрагмент"
        self.trackNameLabel?.text = item.fullTrackNumber + "  " + item.trackName.asStringOrEmpty()
        self.authorNameLabel?.text = item.artistName
        
        if item.longDescription != nil {
            self.collectionNameLabel?.text = item.longDescription!
            self.collectionNameLabel?.font = UIFont.systemFont(ofSize:16)
        } else {
            self.collectionNameLabel?.text = item.collectionName!
            self.collectionNameLabel?.font = UIFont.systemFont(ofSize:21)
        }
        
        //Загрузка из кэша маленькой картинки
        NetworkManager.downloadImage(path: item.artworkUrl100!) { (image) in
            self.artworkImageView?.image = image
        }
        
        //Загрузка большой картинки
        NetworkManager.downloadImage(path: item.artworkUrl600) { (image) in
            self.artworkImageView?.image = image
            self.artworkImageView?.alpha = 1.0
        }
      //  self.layoutIfNeeded()
    }
    
    // MARK: - PreviewAudioDelegate
    
    func playerBeginDownloadSong() {
        self.trackInfoLabel.text = "Загрузка фрагмента"
    }
    
    func playerBeginPlay() {
        self.playerButton.pauseImage()
    }
    
    func playerStopPlay() {
        self.playerButton.playImage()
        self.playerButton.pulsate()
    }
    
    func playerUpdateData(string:String, float:Float) {
        self.trackInfoLabel.text = string
        self.progressView.progress = float
    }
}
