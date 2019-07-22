//
//  ImageManager.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 06/06/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    private static let shared: NSCache = { () -> NSCache<NSString, UIImage> in
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        cache.countLimit = 100 // Максимальное количество изображений в памяти - 100
        cache.totalCostLimit = 10*1024*1024 // Максимальный объем памяти 10 Мб
        return cache
    }()
    
    class func costFor(image: UIImage) -> Int {
        guard let imageRef = image.cgImage else {
            return 0
        }
        return imageRef.bytesPerRow * imageRef.height // Cost in bytes
    }
    
    class func imageForKey(_ path: NSString) -> UIImage! {
        if let imageFromCache = ImageCache.shared.object(forKey: path as NSString) {
            return imageFromCache
        }
        return nil
    }
    
    class func addImageForKey(_ path: NSString, image: UIImage) {
        ImageCache.shared.setObject(image, forKey: path as NSString, cost:self.costFor(image: image))
    }
}


class ImageManager: NSObject{
    
    static let shared = ImageManager()

    lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    static let noArtworkImage = UIImage(named:"noArtwork")
    
    class func download(path:String?, block:@escaping (_ image:UIImage?) -> ()) {
        
        guard let downloadPath = path else {
            print("Ошибка URL: Путь к изображению отсутсвует")
            return
        }
        
        guard let url = URL(string:downloadPath) else {
            print("Ошибка URL: Путь к изображению не явлется валидным URL")
            return
        }
        
        //проверяем есть ли закешированное изображение, если есть - возвращаем его
        if let imageFromCache = ImageCache.imageForKey(downloadPath as NSString) {
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
            ImageCache.addImageForKey(downloadPath as NSString, image: image)
            
            DispatchQueue.main.async {
                block(image)
            }
            
        })
        
        downloadRequest.resume()
    }
    
}
