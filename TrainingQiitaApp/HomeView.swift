//
//  HomeView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var searchText = ""
    
    @State private var dummyArticles = [
        "テスト1",
        "テスト2",
        "テスト3",
        "テスト4",
        "テスト5",
        "テスト6",
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("記事を検索", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                List(dummyArticles, id: \.self) { article in
                    Text(article)
                }
                .listStyle(.plain)

                Spacer()
                
                Button("ログアウト") {
                    viewModel.loginStatus = .idle
                    viewModel.accessToken = ""
                    viewModel.user = nil
                }
            }
            .padding()
            .navigationTitle("Qiita")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let urlString = viewModel.user?.profileImageUrl,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: LoginViewModel())
}
