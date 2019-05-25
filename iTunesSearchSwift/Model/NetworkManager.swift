//
//  DataManager.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ImageCache {
    private static let shared: NSCache = { () -> NSCache<NSString, UIImage> in
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 100 // Максимальное количество изображений в памяти - 100
        cache.totalCostLimit = 10*1024*1024 // Максимальный объем памяти 10 Мб 
        return cache
    }()
    
    static func costFor(image: UIImage) -> Int {
        guard let imageRef = image.cgImage else {
            return 0
        }
        return imageRef.bytesPerRow * imageRef.height // Cost in bytes
    }
    
    static func imageForKey(_ path: NSString) -> UIImage! {
        if let imageFromCache = ImageCache.shared.object(forKey: path as NSString) {
            return imageFromCache
        }
        return nil
    }
    
    static func addImageForKey(_ path: NSString, image: UIImage) {
        ImageCache.shared.setObject(image, forKey: path as NSString, cost:self.costFor(image: image))
    }
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    let session:URLSession
    
    override init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    static private let mainURL = "https://itunes.apple.com/"
        
    static func albumSearchRequest(_ collectionID: Int, block:@escaping (_ dataResponse:Data?) -> ()) {
        let collection = String(collectionID)
        let path = String(format:"\(mainURL)lookup?id=\(collection)&entity=song")
        
        self.runNetworkActivityIndicator()
        
        let url = URL(string:path)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        let searchRequest = self.shared.session.dataTask(with: request, completionHandler: {(data, response, error) in
            block(data)
        })
        
        searchRequest.resume()
    }
    
    typealias RequestResult = (_ dataResponse:Data?,_ searchString:String) -> ()
    typealias IsLastString = (_ searchString:String) -> (Bool)
    
    static func iTunesSearchRequest(searchString: String, block:@escaping (RequestResult), last: @escaping(IsLastString)) {
        let params = searchString.replacingOccurrences(of:" ", with: "+")
        let escapedString = params.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let path = String(format:"\(mainURL)search?term=%@&limit=200&offset=%d", escapedString!, 0)
        
        self.runNetworkActivityIndicator()
        
        let url = URL(string:path)
        let request = URLRequest(url:url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        let searchRequest = self.shared.session.dataTask(with: request, completionHandler: {(data, response, error) in
            if last(searchString) {block(data, searchString)}
        })
        searchRequest.resume()
    }
    
    static let noArtworkImage = UIImage(named:"noArtwork")
    
    static func runNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
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
        if let imageFromCache = ImageCache.imageForKey(path as NSString) {
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
            ImageCache.addImageForKey(path as NSString, image: image)
            
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
            
            if let previewURL = StrogateManager.previewURL(response: response) {
                StrogateManager.copyPreviewFile(at: localUrl, to: previewURL)
                block(previewURL)
            }
        }
        
        task.resume()
    }
    
}
