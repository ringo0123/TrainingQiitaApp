//
//  LoginView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    @State private var showAlert = false
    
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
            .disabled(viewModel.loginStatus != .idle)
            .background(viewModel.loginStatus == .idle ? .green : .gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .padding()
        .onChange(of: viewModel.loginStatus) {
            showAlert = viewModel.loginStatus == .failure
        }
        .alert("エラー", isPresented: $showAlert) {
            Button("OK") {
                viewModel.loginStatusReset()
            }
        } message: {
            Text(viewModel.errorMessage ?? "エラーが発生しました")
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
