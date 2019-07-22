//
//  FileManager.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 25/05/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class StrogateManager: NSObject {
    
    class func copyPreviewFile (at: URL, to: URL) {
        do {
            removePreviewFile(previewFileURL: to)
            try FileManager.default.copyItem(at: at, to: to)
            print("Сохранён:", fileSize(url: to))
        } catch let fileError as NSError {
            print("Ошибка записи файла:", fileError.localizedDescription)
            return
        }
    }
    
    class func previewURL (response : URLResponse?) -> URL? {
        guard let filename = response?.suggestedFilename else {
            return nil
        }
        let docDirectory = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let previewURL = docDirectory.appendingPathComponent(filename)
        return previewURL
    }
    
    private class func removePreviewFile (previewFileURL: URL!) {
        guard (previewFileURL) != nil , FileManager.default.fileExists(atPath: previewFileURL.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at:previewFileURL)
            print("Удалён:", previewFileURL.lastPathComponent)
        } catch let error as NSError {
            print("Ошибка удаления файла:", error.localizedDescription)
        }
    }
    
    private class func fileSize(url:URL) -> String {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return String(format:"%@ размер: %d байт", url.lastPathComponent, attr[FileAttributeKey.size] as! UInt64)
        } catch {
            return "Файл не найден"
        }
    }
    
}
