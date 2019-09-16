//
//  ScheduleViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    let getScheduleEventListURL = URL(string: "https://us-central1-dazn-sandbox.cloudfunctions.net/getSchedule")!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateModel()
        startRefreshTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        
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
            
            DispatchQueue.main.async {
                self.updateModel()
            }
        })
    }
    
    private func updateLayout() {
        self.collectionView.reloadData()
    }
    
    private func updateModel() {
        SimpleApi<Events>().getModel(url: getScheduleEventListURL) { [weak self] result in
        
            switch result {
            case .failure(let failure):
                print(failure) // todo: error handling
            case .success(let success):
                self?.events = success
            }
        }
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
