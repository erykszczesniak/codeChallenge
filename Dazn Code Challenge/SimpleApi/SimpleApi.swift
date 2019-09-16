//
//  SimpleApi.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import Foundation


struct SimpleApi<T: Decodable> {
    
    private let queue = DispatchQueue(label: "com.dazn.test.app", qos: DispatchQoS.userInitiated, attributes: .concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
    
    func getModel(url: URL, _ completion: @escaping (Result<T, ApiErrors>) -> (Void)) {
        queue.async {
            let urlSession = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard error == nil else {
                    completion(Result.failure(ApiErrors.requestError))
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
