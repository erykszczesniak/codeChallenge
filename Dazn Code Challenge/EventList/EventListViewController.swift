//
//  EventListViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
        
    private var viewModel = DecodableViewModel<Events>(eventType: ApiRequests.events)
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
}

extension EventListViewController {
    
    private func updateLayout() {
        self.collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        //register cells
        collectionView.register(UINib(nibName: EventCell.nibName, bundle: nil), forCellWithReuseIdentifier: EventCell.nibName)
    }
}

extension EventListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let videoPlayerViewController = UIStoryboard(name: "VideoPlayer", bundle: nil).instantiateInitialViewController() as? VideoPlayerViewController else { print("FATAL"); return }
        self.show(videoPlayerViewController, sender: self)
        videoPlayerViewController.model = URL(string: viewModel.model?[indexPath.row].videoURL ?? "")
    }
}

extension EventListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let events = viewModel.model,
        events.count > indexPath.row else {
                fatalError("NO MODEL FOR IT.")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.nibName, for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.model = event
        return cell
    }
}

extension EventListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return EventCell.getCellSize(collectionView)
    }
}

extension EventListViewController: DecodableViewModelDelegate {
    
    func updatedModel() {
        self.collectionView.reloadData()
    }
}
