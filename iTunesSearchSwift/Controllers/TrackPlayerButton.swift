//
//  TrackPlayButton.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 26/05/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class TrackPlayerButton : UIButton {
    
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
