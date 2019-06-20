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

enum TrackPlayerState: String {
    case none
    case trackDownload
    case trackPlay
    case trackStop
    case error
}

class TrackPreviewAudio: NSObject, AVAudioPlayerDelegate  {
    private var audioPlayer:AVAudioPlayer!
    private var previewFileURL:URL!
    private var playerTimer:Timer!
    private var previewUrl:String?
    private var state:TrackPlayerState
    weak var delegate:PreviewAudioDelegate?
    
    init(url:String!, delegate:PreviewAudioDelegate?) {
        self.previewUrl = url
        self.delegate = delegate
        self.state = .none
    }
    
    func startAudioPlayer(previewFileURL: URL!) {
        do {
            self.previewFileURL = previewFileURL
            try audioPlayer = AVAudioPlayer.init(contentsOf: previewFileURL)
            audioPlayer.delegate = self
            state = .trackDownload
        } catch let error as NSError {
            print("Ошибка инициализации плеера:", error.localizedDescription)
            state = .error
            return
        }
        
        audioPlayer.prepareToPlay()
        
        DispatchQueue.main.async {
            self.stopPlay()
        }
    }
    
    func didTapButton() {
        
        switch state {
            case .none:
                beginDownload()
            case .trackDownload, .trackStop:
                beginPlay()
            case .trackPlay:
                stopPlay()
            default: break
        }
    }
    
    func beginDownload() {
        self.delegate?.playerBeginDownloadSong()
        let downloader = TrackDownloader()
        downloader.download(previewURL: self.previewUrl!, completion: { (url) in
            self.startAudioPlayer(previewFileURL:url)
        }, progress: { (written, expected) in
            DispatchQueue.main.async {
                let flt = Float(written)/Float(expected)
                let str = "Всего: " + String(written) + " / " + String(expected)
                self.delegate?.playerUpdateData(string: str , float: flt)
            }
        }) { (error) in
            DispatchQueue.main.async {
                let err = String(describing: error?.localizedDescription)
                self.delegate?.playerUpdateData(string: "Error: \(err))" , float: 0)
            }
        }
    }
    
    func stopPlay() {
        state = .trackStop
        audioPlayer.stop()
        delegate?.playerStopPlay()
        playerTimer?.invalidate()
        updateTime()
    }
    
    func beginPlay() {
        state = .trackPlay
        audioPlayer.play()
        delegate?.playerBeginPlay()
        playerTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self,  selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let str = String(format:"%.1f / %.1f", self.audioPlayer.currentTime, self.audioPlayer.duration)
        let flt = Float(self.audioPlayer.currentTime/self.audioPlayer.duration)
        delegate?.playerUpdateData(string: str, float: flt)
    }
    
    func audioDisappear () {
        state = .none
        audioPlayer?.stop()
        playerTimer?.invalidate()
      //  DataManager.removePreviewFile(previewFileURL: self.previewFileURL)
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlay()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
