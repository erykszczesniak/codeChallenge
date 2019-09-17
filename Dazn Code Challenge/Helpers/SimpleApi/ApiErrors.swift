//
//  ApiErrors.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import Foundation

enum ApiErrors: Error {
    case requestError(Error?)
    case noDataReturned
    case decodinError(Error)
}
