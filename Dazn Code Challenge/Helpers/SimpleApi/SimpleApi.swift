//
//  SimpleApi.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import Foundation

class SimpleApi {
        
    static let shared = SimpleApi()
    
    private init () {} // singleton
    
    func getModel<T: Decodable>(url: URL, decodeTo: T.Type, _ completion: @escaping (Result<T, ApiErrors>) -> (Void)) {
        DispatchQueue.main.async {
            let urlSession = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard error == nil else {
                    completion(Result.failure(ApiErrors.requestError(error)))
                    return
                }
                
                guard let data = data else {
                    completion(Result.failure(ApiErrors.noDataReturned))
                    return
                }
                
                do {
                    completion(Result.success(try JSONDecoder().decode(T.self, from: data)))
                } catch {
                    completion(Result.failure(ApiErrors.decodinError(error)))
                }
            })
            urlSession.resume()
        }
    }
}
