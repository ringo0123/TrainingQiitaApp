//
//  QiitaRepository.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import Foundation
import Combine

final class QiitaRepository {
    
    func fetchAuthenticatedUser(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "https://qiita.com/api/v2/authenticated_user")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let apiError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "APIレスポンスが不正です"])
                    completion(.failure(apiError))
                    return
                }
                
                guard let data = data else {
                    let noDataError = NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "データが空です"])
                    completion(.failure(noDataError))
                    return
                }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
