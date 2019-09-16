//
//  ImageDownloader.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

extension UIImageView {
    
    //kingFisher, alamofire, etc...
    func downloadImage(imageUrl: String) {
        self.image = nil
        guard let url = URL(string: imageUrl) else { return }
        
        DispatchQueue.main.async {
            do {
                let imageData = try Data(contentsOf: url)
                guard let image = UIImage(data: imageData) else {
                    return
                }
                
                self.image = image
            } catch {}
        }
    }
}
