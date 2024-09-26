//
//  ArticleViewModel.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import Combine
import CoreData
import Network

import Combine

class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false // For activity indicator
    private var cancellables = Set<AnyCancellable>()

    func fetchArticles() {
        // Check for internet connectivity
        if !NetworkMonitor.shared.isConnectedToInternet {
            print("No internet connect. Fetch Articles from Core Data")
            self.articles = CoreDataManager.shared.fetchArticles()
            return
        }

        // Set loading state
        self.isLoading = true
        
        guard let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM") else {
            self.isLoading = false
            return
        }

        // Fetch articles from the network
        NetworkManager.shared.fetchArticles(url: url)
            .sink(receiveCompletion: { completion in
                self.isLoading = false // Hide loading indicator
                if case .failure(let error) = completion {
                    print("Error fetching articles: \(error)")
                    self.articles = CoreDataManager.shared.fetchArticles() // Fetch from Core Data on error
                }
            }, receiveValue: { (response: ArticleResponseModel) in
                // Sort articles by published date
                self.articles = response.response.docs.sorted {
                    guard let firstDate = $0.publishedDate, let secondDate = $1.publishedDate else { return false }
                    return firstDate > secondDate
                }
                
                // Save articles to Core Data
                CoreDataManager.shared.saveArticles(articles: self.articles)
            })
            .store(in: &cancellables)
    }
}
