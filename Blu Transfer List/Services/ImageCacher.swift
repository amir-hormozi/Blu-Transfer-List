//
//  ImageCacher.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

import UIKit
import CryptoKit

class ImageCacher {
    
    static let shared = ImageCacher()
    
    private let memoryCache = NSCache<NSURL, UIImage>()
    
    private let diskCachePath: URL
    private let fileManager = FileManager.default
    private var loadingResponses = [URL: [(UIImage?) -> Void]]()
    private let accessQueue = DispatchQueue(label: "com.Behtis.imageCacherQueue")
    
    private init() {
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Can't find caches directory.")
        }
        diskCachePath = cacheDirectory.appendingPathComponent("ImageCache")
        if !fileManager.fileExists(atPath: diskCachePath.path) {
            try? fileManager.createDirectory(at: diskCachePath, withIntermediateDirectories: true, attributes: nil)
        }
    }
        
    func loadImage(from url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            loadImage(from: url) { image in
                continuation.resume(returning: image)
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = memoryCache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        accessQueue.async {
            if self.loadingResponses[url] != nil {
                self.loadingResponses[url]?.append(completion)
                return
            }
            self.loadingResponses[url] = [completion]
            
            if let diskImage = self.checkDiskCache(for: url) {
                self.memoryCache.setObject(diskImage, forKey: url as NSURL)
                self.callCompletions(for: url, with: diskImage)
                return
            }
            
            self.downloadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                
                if let image = image {
                    self.memoryCache.setObject(image, forKey: url as NSURL)
                    self.saveToDiskCache(image, for: url)
                }
                
                self.callCompletions(for: url, with: image)
            }
        }
    }
        
    private func checkDiskCache(for url: URL) -> UIImage? {
        let filePath = self.path(for: url)
        guard fileManager.fileExists(atPath: filePath.path),
              let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    private func saveToDiskCache(_ image: UIImage, for url: URL) {
        let filePath = self.path(for: url)
        guard let data = image.pngData() else { return }
        try? data.write(to: filePath)
    }
    
    // MARK: - شبکه
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                #if DEBUG
                print("Error downloading image: \(error.localizedDescription)")
                #endif
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
    
    private func callCompletions(for url: URL, with image: UIImage?) {
        guard let completions = self.loadingResponses.removeValue(forKey: url) else {
            return
        }
        
        for completion in completions {
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func path(for url: URL) -> URL {
        let data = Data(url.absoluteString.utf8)
        let hashed = SHA256.hash(data: data)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return diskCachePath.appendingPathComponent(hashString)
    }
}
