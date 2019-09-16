//
//  EventListViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
    
    private let getEventsListUrlString = URL(string: "https://us-central1-dazn-sandbox.cloudfunctions.net/getEvents")!
    
    private var events: Events? {
        didSet {
            DispatchQueue.main.async {
                self.updateLayout()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SimpleApi<Events>().getModel(url: getEventsListUrlString) { [weak self] result in
            
            switch result {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                self?.events = success
            }
        }
    }
    
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

//MARK: UICollectionViewDelegate
extension EventListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let videoPlayerViewController = UIStoryboard(name: "VideoPlayer", bundle: nil).instantiateInitialViewController() as? VideoPlayerViewController else { print("FATAL"); return }
        self.show(videoPlayerViewController, sender: self)
        videoPlayerViewController.model = URL(string: events?[indexPath.row].videoURL ?? "")
    }
}

//MARK: UICollectionViewDataSource
extension EventListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let events = events,
        events.count > indexPath.row else {
                return UICollectionViewCell() // never ever.
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.nibName, for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.model = event
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension EventListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return EventCell.getCellSize(collectionView)
    }
}
