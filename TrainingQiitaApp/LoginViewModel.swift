//
//  LoginViewModel.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var accessToken: String = ""
    @Published var loginStatus: LoginStatus = .idle
    @Published var errorMessage: String?
    
    @Published var user: User?
    
    private let repository: QiitaRepositoryProtocol

    init(repository: QiitaRepositoryProtocol = QiitaRepository()) {
        self.repository = repository
    }

    enum LoginStatus {
        case idle
        case loading
        case success
        case failure
    }

    func login() {
        guard !accessToken.isEmpty else {
            errorMessage = "アクセストークンを入力してください"
            loginStatus = .failure
            return
        }

        loginStatus = .loading
        errorMessage = nil

        // APIリクエスト（簡易バージョン）
        repository.fetchUser(token: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.loginStatus = .success
                    print("ログイン成功：\(user.name ?? "no name")")
                    dump(user)

                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.loginStatus = .failure
                }
            }
        }
    }
    
    func logout() {
        self.user = nil
        self.accessToken = ""
        self.loginStatus = .idle
    }
    
}
