//
//  PreviewAudio.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import AudioToolbox
import AVFoundation

protocol PreviewAudioDelegate: AnyObject {
    func playerBeginDownloadSong()
    func playerBeginPlay()
    func playerStopPlay()
    func playerUpdateData(string:String, float:Float)
}

class PreviewAudio: NSObject, AVAudioPlayerDelegate  {
    private var audioPlayer:AVAudioPlayer!
    private var previewFileURL:URL!
    private var playerTimer:Timer!
    private var previewUrl:String?
    weak var delegate:PreviewAudioDelegate?
    
    init(url:String!, delegate:PreviewAudioDelegate?) {
        self.previewUrl = url
        self.delegate = delegate
    }
    
    func startAudioPlayer(previewFileURL: URL!) {
        do {
            self.previewFileURL = previewFileURL
            try self.audioPlayer = AVAudioPlayer.init(contentsOf: self.previewFileURL)
            self.audioPlayer.delegate = self
        } catch let error as NSError {
            print("Ошибка инициализации плеера:", error.localizedDescription)
            return
        }
        
        self.audioPlayer.prepareToPlay()
        
        DispatchQueue.main.async {
            self.stopPlay()
        }
    }
    
    func didTapButton() {
        if (self.audioPlayer == nil) {
            self.beginDownload()
        } else if (self.audioPlayer.isPlaying) {
            self.stopPlay()
        } else {
            self.beginPlay()
        }
    }
    
    func beginDownload() {
        self.delegate?.playerBeginDownloadSong()
        DataManager.downloadPrewiewSong(previewURL: self.previewUrl!) { (url) in
            self.startAudioPlayer(previewFileURL:url)
        }
    }
    
    func stopPlay() {
        self.audioPlayer.stop()
        self.delegate?.playerStopPlay()
        self.playerTimer?.invalidate()
        self.updateTime()
    }
    
    func beginPlay() {
        self.audioPlayer.play()
        self.delegate?.playerBeginPlay()
        self.playerTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self,  selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let str = String(format:"%.1f / %.1f", self.audioPlayer.currentTime, self.audioPlayer.duration)
        let flt = Float(self.audioPlayer.currentTime/self.audioPlayer.duration)
        self.delegate?.playerUpdateData(string: str, float: flt)
    }
    
    func audioDisappear () {
        self.audioPlayer?.stop()
        self.playerTimer?.invalidate()
      //  DataManager.removePreviewFile(previewFileURL: self.previewFileURL)
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlay()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
