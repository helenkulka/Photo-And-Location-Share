//
//  customImageView.swift
//  PhotoAndLocationShare
//
//  Created by Helen Kulka on 8/15/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit


//var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
   
    func loadImage(urlString: String) {
        
        lastURLUsedToLoadImage = urlString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image: ", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
