//
//  TrackDownloader.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 26/05/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

class TrackDownloader: NSObject, URLSessionDownloadDelegate {
    
    lazy var session: URLSession = {
        return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }()
    
    typealias Completion = (_ url: URL) -> ()
    typealias Progress = (_ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> ()
    
    var completionHandler: Completion = {url in }
    var progressUpdate: Progress = {written, expected in }
    
    func download (previewURL:String, completion:@escaping Completion, progress:@escaping Progress) {
        let url = URL(string:previewURL)
        let request = URLRequest(url:url!)
        
        completionHandler = completion
        progressUpdate = progress
        
        let downloadTask = self.session.downloadTask(with: request)
        downloadTask.resume()
    }
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Файл успешно скачан")
        completionHandler(location)
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if (error != nil) {
            print("Ошибка закачки файла:" + (error?.localizedDescription)!)
        } else {
            print("Выполнено")
        }
    }
    
    internal func urlSession( _ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressUpdate(totalBytesWritten, totalBytesExpectedToWrite)
    }
    
}
