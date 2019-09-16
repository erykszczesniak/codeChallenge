//
//  ScheduleViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    private var events: Events? {
        didSet {
            DispatchQueue.main.async {
                self.updateLayout()
            }
        }
    }
    
    private var refreshTimer: Timer?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    weak var emptyInfoLabel: EmptyScheduleView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRefreshTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshTimer?.invalidate()
    }
    
    private func startRefreshTimer() {
        refreshTimer = Timer(timeInterval: Statics.scheduleRefreshInterval, repeats: true, block: { [weak self] timer in
            guard let self = self,
                self.isViewLoaded,
                !self.collectionView.isDragging else {
                    timer.invalidate()
                    return
            }
            
            DispatchQueue.main.async {
                self.updateLayout()
            }
        })
        
    }
    
    private func updateLayout() {
        if events?.count ?? 0 > 0 {
            emptyInfoLabel?.removeFromSuperview()
            self.collectionView.reloadData()
        } else {
            showEmptyInfoLabel()
        }
    }
    
    private func showEmptyInfoLabel() {
        collectionView.alpha = 0
        let label = EmptyScheduleView()
        view.addSubview(label)
        emptyInfoLabel = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        //register cells
        collectionView.register(UINib(nibName: EventCell.nibName, bundle: nil), forCellWithReuseIdentifier: EventCell.nibName)
    }
}

//MARK: UICollectionViewDelegate
extension ScheduleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

//MARK: UICollectionViewDataSource
extension ScheduleViewController: UICollectionViewDataSource {
    
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
extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return EventCell.getCellSize(collectionView)
    }
}
