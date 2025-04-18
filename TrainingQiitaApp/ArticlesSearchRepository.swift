//
//  ArticlesSearchRepository.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/15.
//

import Foundation

final class ArticlesSearchRepository: ArticlesSearchRepositoryProtocol {
    func searchArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=20&query=\(encodedQuery)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let articles = try JSONDecoder().decode([Article].self, from: data)
                completion(.success(articles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

protocol ArticlesSearchRepositoryProtocol {
    func searchArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void)
}
