//
//  NetworkManager.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchArticles<T: Codable>(url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
