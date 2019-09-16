//
//  EventListViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
    
    private var events: Events? {
        didSet {
            updateLayout()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    private func updateLayout() {
        self.collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        collectionView.
        
    }
}

extension EventListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

extension EventListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let events = events,
        events.count > indexPath.row else {
                return UICollectionViewCell() // never ever.
        }
        
        let event = events[indexPath.row]
        
        
        
    }
}

