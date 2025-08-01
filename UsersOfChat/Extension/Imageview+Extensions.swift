//
//  Imageview+Extensions.swift
//  UsersOfChat
//
//  Created by Varshitha VRaj on 01/08/25.
//



import UIKit

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}


import UIKit

extension UIImageView {
    
    func loadImageFromURL(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        if let cached = ImageCacheManager.shared.image(forKey: urlString) {
            self.image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let downloadedImage = UIImage(data: data), error == nil else {
                return
            }

            ImageCacheManager.shared.setImage(downloadedImage, forKey: urlString)

            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
