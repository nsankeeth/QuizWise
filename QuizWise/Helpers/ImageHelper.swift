//
//  ImageHelper.swift
//  QuizWise
//
//  Created by Sankeeth Naguleswaran on 2022-08-10.
//

import Foundation
import UIKit

class ImageHelper {
    static func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func loadImageOrPlaceholder(from url: String, target imageView: UIImageView,  placeholder name: String) {
        if (url.isEmpty) {
            imageView.image = UIImage(named: name)
        } else {
            let url = URL(string: url)
            
            getImageData(from: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() { [imageView] in
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
