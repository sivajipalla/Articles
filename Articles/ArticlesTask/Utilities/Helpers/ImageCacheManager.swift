//
//  ImageCacheManager.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Get the local directory for storing images
    private func localFileURL(for url: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        // Use the image URL string as a unique file name
        let fileName = url.replacingOccurrences(of: "/", with: "_")
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    // Save image to the file system
    private func saveImageToDisk(_ image: UIImage, for url: String) {
        guard let fileURL = localFileURL(for: url) else { return }
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL)
        }
    }
    
    // Load image from disk
    private func loadImageFromDisk(for url: String) -> UIImage? {
        guard let fileURL = localFileURL(for: url) else { return nil }
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // Load image with caching mechanism
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // First check if the image is in the cache
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // Then check if the image exists in local storage (when offline)
        if let diskImage = loadImageFromDisk(for: urlString) {
            completion(diskImage)
            cache.setObject(diskImage, forKey: urlString as NSString)
            return
        }
        
        // If online, download the image and save it locally
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                // Save to cache and local storage
                self.cache.setObject(image, forKey: urlString as NSString)
                self.saveImageToDisk(image, for: urlString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}

