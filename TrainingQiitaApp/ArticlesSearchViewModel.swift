//
//  QiitaSearchViewModel.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/15.
//

import Foundation
import Combine

final class ArticlesSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var hasSearched = false
    @Published var errorMessage: String?
    
    private let repository: ArticlesSearchRepositoryProtocol
    
    init(repository: ArticlesSearchRepositoryProtocol = ArticlesSearchRepository()) {
        self.repository = repository
    }
    
    func searchArticles() {
        let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            self.errorMessage = "検索ワードを入力してください"
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        repository.searchArticles(query: trimmedQuery) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.hasSearched = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
