//
//  Events.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import Foundation

// MARK: - Event
struct Event: Codable {
    let id, title, subtitle, date: String
    let imageURL: String
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, date
        case imageURL = "imageUrl"
        case videoURL = "videoUrl"
    }
}

// MARK: - Events
typealias Events = [Event]
