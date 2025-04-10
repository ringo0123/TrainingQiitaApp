//
//  LoginView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

        var body: some View {
            VStack(spacing: 24) {
                Text("Qiitaへログイン")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("アクセストークンを入力", text: $viewModel.accessToken)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button("ログイン") {
                    viewModel.login()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)

                // ログイン状態に応じた表示
                if viewModel.loginStatus == .loading {
                    ProgressView()
                } else if viewModel.loginStatus == .failure {
                    Text(viewModel.errorMessage ?? "エラーが発生しました")
                        .foregroundColor(.red)
                } else if viewModel.loginStatus == .success {
                    Text("ログイン成功！\(viewModel.user?.name ?? "不明")")
                        .foregroundColor(.blue)
                } else {
                    Text(" ")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }}

#Preview {
    LoginView()
}
