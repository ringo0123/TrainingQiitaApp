//
//  TrainingQiitaAppTests.swift
//  TrainingQiitaAppTests
//
//  Created by  hayato on 2025/04/10.
//

import Testing
@testable import TrainingQiitaApp
import Foundation

struct TrainingQiitaAppTests {

    @Test func testLoginWithEmptyTokenFails() async throws {
        let viewModel = LoginViewModel()
        viewModel.accessToken = ""

        viewModel.login()

        // 少しだけ待つ（非同期でメインスレッドに戻るのを想定）
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.loginStatus == .failure)
        #expect(viewModel.errorMessage == "アクセストークンを入力してください")
    }
    
    @Test func testLoginSuccessWithMockRepository() async throws {
        let viewModel = LoginViewModel(repository: MockSuccessRepository())
        viewModel.accessToken = "valid_token"
        
        viewModel.login()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.loginStatus == .success)
        #expect(viewModel.user?.id == "test_user")
        #expect(viewModel.user?.name == "テスト太郎")
    }
    
    @Test func testLoginFailureWithMockRepository() async throws {
        let viewModel = LoginViewModel(repository: MockFailureRepository())
        viewModel.accessToken = "invalid_token"

        viewModel.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.loginStatus == .failure)
        #expect(viewModel.errorMessage == "ログイン失敗")
        #expect(viewModel.user == nil)
    }
    
}

struct MockSuccessRepository: QiitaRepositoryProtocol {
    func fetchUser(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        let dummyUser = User(id: "test_user", name: "テスト太郎", profileImageUrl: nil)
        completion(.success(dummyUser))
    }
}

struct MockFailureRepository: QiitaRepositoryProtocol {
    func fetchUser(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        let dummyError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "ログイン失敗"])
        completion(.failure(dummyError))
    }
}
