//
//  AccountMenuView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/18.
//

import SwiftUI

struct AccountMenuView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    @State private var showLogoutAlert = false
    var onClose: () -> Void
    
    var body: some View {
        if viewModel.user != nil {
            NavigationStack {
                VStack(spacing: 20) {
        
                    if let urlString = viewModel.user?.profileImageUrl,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text(viewModel.user?.name ?? "")
                            .font(.title)
                            .fontWeight(.medium)
                        
                        Text(viewModel.user?.id ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Button("ログアウト") {
                        showLogoutAlert = true
                    }
                    .foregroundColor(.red)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("戻る") {
                            onClose()
                        }
                        .foregroundColor(.white)
                    }
                }
                .navigationTitle("アカウント")
                .navigationBarTitleDisplayMode(.inline)
                .alert("ログアウトしますか？", isPresented: $showLogoutAlert) {
                    Button("キャンセル", role: .cancel) {}
                    Button("ログアウト", role: .destructive) {
                        viewModel.logout()
                    }
                }
            }
        }
    }
}
