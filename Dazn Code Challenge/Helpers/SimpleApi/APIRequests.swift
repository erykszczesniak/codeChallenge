//
//  APIRequests.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 17/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import Foundation

enum ApiRequests: String {
    case events = "https://us-central1-dazn-sandbox.cloudfunctions.net/getEvents"
    case schedule = "https://us-central1-dazn-sandbox.cloudfunctions.net/getSchedule"
    // separate https://us-central1-dazn-sandbox.cloudfunctions.net to environments... but there are only two requests
}
