//
//  ScheduleViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
        
    private var viewModel = DecodableViewModel<Events>(eventType: ApiRequests.schedule)
    
    private var refreshTimer: Timer?
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateModel()
        startRefreshTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshTimer?.invalidate()
    }
}

extension ScheduleViewController {
    
    private func startRefreshTimer() {
        refreshTimer = Timer(timeInterval: Statics.scheduleRefreshInterval, repeats: true, block: { [weak self] timer in
            guard let self = self,
                self.isViewLoaded,
                !self.collectionView.isDragging else {
                    timer.invalidate()
                    return
            }
            self.viewModel.updateModel({ [weak self] _ in
                self?.collectionView.reloadData()
            })
        })
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

//MARK: UICollectionViewDataSource
extension ScheduleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let events = viewModel.model,
            events.count > indexPath.row else {
                fatalError()
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
