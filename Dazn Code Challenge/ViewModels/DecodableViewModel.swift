//
//  EventsViewModel.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 17/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import Foundation

protocol DecodableViewModelDelegate: class {
    func updatedModel()
}

class DecodableViewModel<T: Decodable> {
    
    private let type: ApiRequests
    
    var model: T?
    weak var delegate: DecodableViewModelDelegate?
    
    init(eventType: ApiRequests) {
        type = eventType
        updateModel()
    }
    
    func updateModel(_ completion: ((T?) -> (Void))? = nil) {
        guard let url = URL(string: type.rawValue) else { completion?(nil); return }
        
        SimpleApi.shared.getModel(url: url, decodeTo: T.self) { [weak self] result in
            
            switch result {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                self?.model = success
                DispatchQueue.main.async {
                    completion?(success)
                    self?.delegate?.updatedModel()
                }
            }
        }
    }
}
