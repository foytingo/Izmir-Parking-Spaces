//
//  NetworkManager.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 12.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import UIKit

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    let baseURL = "https://izum.izmir.bel.tr/v1/workspaces/parking"
    
    func getParksData(completed: @escaping(Result<[ParkData], PSError>) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let endpoint = self.baseURL
            
            guard let url = URL(string: endpoint) else {
                completed(.failure(.invalidURL))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let _ = error {
                    completed(.failure(.unableToComplete))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let parks = try decoder.decode([ParkData].self, from: data)
                    completed(.success(parks))
                } catch {
                    completed(.failure(.invalidData))
                }
            }
            
            task.resume()
        }
    }
    
}
