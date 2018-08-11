//
//  DataManager.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared: NSCache = { () -> NSCache<NSString, UIImage> in
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 100 // Максимальное количество изображений в памяти - 100
        cache.totalCostLimit = 10*1024*1024 // Максимальный объем памяти 10 Мб 
        return cache
    }()
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    let session:URLSession
    
    override init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    private static func removePreviewFile (previewFileURL: URL!) {
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
    
    private static func fileSize(url:URL) -> String {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return String(format:"%@ размер: %d байт", url.lastPathComponent, attr[FileAttributeKey.size] as! UInt64)
        } catch {
            return "Файл не найден"
        }
    }
    
    static func copyPreviewFile (at: URL, to: URL) {
        do {
            self.removePreviewFile(previewFileURL: to)
            try FileManager.default.copyItem(at: at, to: to)
            print("Сохранён:", fileSize(url: to))
        } catch let fileError as NSError {
            print("Ошибка записи файла:", fileError.localizedDescription)
            return
        }
    }
    
    static private let mainURL = "https://itunes.apple.com/"
    
    static func albumSearchRequest(collectionID: Int, block:@escaping (_ dataResponse:Data?) -> ()) {
        let collection = String(collectionID)
        let path = String(format:"\(mainURL)lookup?id=\(collection)&entity=song")
        let url = URL(string:path)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        let searchRequest = self.shared.session.dataTask(with: request, completionHandler: {(data, response, error) in
            block(data)
        })
        
        searchRequest.resume()
    }
    
    static func iTunesSearchRequest(searchString: String, block:@escaping (_ dataResponse:Data?,_ searchString:String) -> ()) {
        let params = searchString.replacingOccurrences(of:" ", with: "+")
        let escapedString = params.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let path = String(format:"\(mainURL)search?term=%@&limit=200&offset=%d", escapedString!, 0)
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let url = URL(string:path)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        let searchRequest = self.shared.session.dataTask(with: request, completionHandler: {(data, response, error) in
            block(data, searchString)
        })
        searchRequest.resume()
    }
    
    static func stopNetworkActivityIndicator(_ equal:Bool) {
        if equal {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    static func downloadImage(path:String, block:@escaping (_ image:UIImage?) -> ()) {
        
        guard let url = URL(string:path) else {
            print("Ошибка URL: Путь к изображению не явлется валидным URL")
            return
        }
        
        //проверяем есть ли закешированное изображение, если есть - возвращаем его
        if let imageFromCache = ImageCache.shared.object(forKey: path as NSString) {
            DispatchQueue.main.async {
                block(imageFromCache)
            }
            return
        }
        
        //если нет - грузим
        let request = URLRequest(url:url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        let downloadRequest = self.shared.session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard let responseData = data, error == nil else {
                print("Ошибка загрузки: " + (error?.localizedDescription)!)
                return
            }
            
            guard let image = UIImage(data: responseData) else {
                print("Ошибка: Загруженные данные не являются изображением")
                return
            }
            
            //добавляем закачанное и распарсенное изоображение в кэш
            ImageCache.shared.setObject(image, forKey: path as NSString, cost:responseData.count)
            
            DispatchQueue.main.async {
                block(image)
            }

        })
        
        downloadRequest.resume()
    }
    
    static func downloadPrewiewSong (previewURL:String, block:@escaping (_ url: URL) -> ()) {
        let url = URL(string:previewURL)
        let request = URLRequest(url:url!)
        
        let task = self.shared.session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            
            guard let localUrl = tempLocalUrl, error == nil else {
                print("Ошибка закачки файла:" + (error?.localizedDescription)!)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Файл успешно скачан: \(statusCode)")
            }
            
            let docDirectory = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let previewURL = docDirectory.appendingPathComponent((response?.suggestedFilename)!)
            self.copyPreviewFile(at: localUrl, to:previewURL)
            block(previewURL)
            
        }
        
        task.resume()
    }
    
}
