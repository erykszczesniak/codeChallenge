//
//  EventCell.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    static let nibName = "EventCell"
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var hourLabel: UILabel?
    
    var model: Event? {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateView()
    }
    
    private func updateView() {
        guard let model = model else { resetView(); return }
        
        imageView?.downloadImage(imageUrl: model.imageURL)
        titleLabel?.text = model.title + "\n" + model.subtitle
        hourLabel?.text = model.date
    }
    
    private func resetView() {
        imageView?.image = nil
        titleLabel?.text = nil
        hourLabel?.text = nil
    }
}

extension EventCell {
    
    static func getCellSize(_ collectionView: UICollectionView) -> CGSize {
        let width = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        let height: CGFloat = 100// example value
        return CGSize(width: width, height: height)
    }
}
