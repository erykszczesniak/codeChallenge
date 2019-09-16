//
//  EmptyScheduleView.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit

class EmptyScheduleView: UIView {
    
    let noScheduleYetText = "No events today :C"
    
    private weak var infoLabel: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupInfoLabel()
    }
    
    private func setupInfoLabel() {
        guard infoLabel == nil else { return }
        
        let label = UILabel()
        label.text = noScheduleYetText // example, localizable text.. not yet.
        
        addSubview(label)
        self.infoLabel = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
