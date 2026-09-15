//
//  Untitled.swift
//  MVVM+Login+Feed List+Scroll
//
//  Created by Akhil Gupta on 9/14/26.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()

    func loadImage(imageURL: URL) async -> UIImage? {
        if let cachedImage = ImageCache.shared.getImage(url: imageURL) {
            return cachedImage
        }
        do {
            let (data, resp) = try await URLSession.shared.data(from: imageURL)
            if let resp = resp as? HTTPURLResponse, !(200...299).contains(resp.statusCode) {
                return nil
            }
            let uiImage = UIImage(data: data)
            if let uiImage {
                ImageCache.shared.saveImage(url: imageURL, uiImage: uiImage)
            }
            return uiImage
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

class ImageCache {
    static let shared = ImageCache()

    private let cache: NSCache<NSString, UIImage> = {
        let c = NSCache<NSString, UIImage>()
        c.countLimit = 200
        return c
    }()

    func getImage(url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func saveImage(url: URL, uiImage: UIImage) {
        cache.setObject(uiImage, forKey: url.absoluteString as NSString)
    }
}
