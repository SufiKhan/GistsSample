
import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String) {
        let url = URL(string: urlString)
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        guard let imageURL = url else {return}

        // if not, download image from url
        URLSession.shared.dataTask(with: imageURL, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let imageData = data else {return}
            DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: imageData) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.image = image
                }
            }

        }).resume()
    }
}
