//
//  ImageDownloader.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private static let queue = DispatchQueue(label: "com.pl.test.dazn.app", qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: nil)
    
    //kingFisher, alamofire, etc...
    func downloadImage(imageUrl: String) {
        self.image = nil
        guard let url = URL(string: imageUrl) else { return }
        
        UIImageView.queue.async {
            do {
                let imageData = try Data(contentsOf: url)
                guard let image = UIImage(data: imageData) else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch {}
        }
    }
}
