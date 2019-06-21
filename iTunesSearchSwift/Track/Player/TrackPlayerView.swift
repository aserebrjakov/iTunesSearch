//
//  TrackPlayerView.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 20/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class TrackPlayerView: UIView, PreviewAudioDelegate {
    
    let kCONTENT_XIB_NAME = "TrackPlayerView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var trackInfoLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playerButton: TrackPlayerButton!
    
    var viewModel : TrackViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: kCONTENT_XIB_NAME, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func didTapPlayerButton(_ sender: TrackPlayerButton) {
        self.viewModel.previewAudio.didTapButton()
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 3.0 {
        didSet {
            layer.borderWidth = borderWidth
            clipsToBounds = borderWidth > 0
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - PreviewAudioDelegate
    
    func playerBeginDownloadSong() {
        trackInfoLabel.text = "Загрузка фрагмента"
    }
    
    func playerBeginPlay() {
        playerButton.pauseImage()
    }
    
    func playerStopPlay() {
        playerButton.playImage()
        playerButton.pulsate()
    }
    
    func playerUpdateData(string:String, float:Float) {
        trackInfoLabel.text = string
        progressView.progress = float
    }
    
}
