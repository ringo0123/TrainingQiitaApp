//
//  HomeView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: LoginViewModel
    @StateObject private var searchViewModel = ArticlesSearchViewModel()
    
    @State private var isAccountMenuPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("記事を検索", text: $searchViewModel.searchText)
                        .frame(height: 28)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .submitLabel(.search)
                        .onSubmit {
                            searchViewModel.searchArticles()
                        }
                    
                    Button(action: {
                        searchViewModel.searchArticles()
                    }) {
                        Text("検索")
                            .frame(height: 28)
                            .font(.title3)
                            .padding(10)
                            .padding(.horizontal,10)
                            .background(searchViewModel.searchText.isEmpty || searchViewModel.isLoading ? .gray : .green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(searchViewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty || searchViewModel.isLoading)
                }
                
                if searchViewModel.isLoading {
                    ProgressView("読み込み中...")
                        .padding()
                }
                
                else if let error = searchViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                }
                else if searchViewModel.hasSearched && searchViewModel.articles.isEmpty {
                    Text("検索結果が見つかりませんでした。")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(searchViewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(title: article.title,parsedBody: article.parsedBody)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title)
                                    .font(.headline)
                                Text("by \(article.user.id)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)

                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
                
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
                                .onTapGesture {
                                    isAccountMenuPresented = true
                                }
                        } placeholder: {
                            ProgressView()
                                .frame(width: 32, height: 32)
                                .onTapGesture {
                                    isAccountMenuPresented = true
                                }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .onTapGesture {
                                isAccountMenuPresented = true
                            }
                    }
                }
            }
            .fullScreenCover(isPresented: $isAccountMenuPresented) {
                AccountMenuView(viewModel: viewModel){
                    isAccountMenuPresented = false
                }
            }
        }
        
    }
}

#Preview {
    HomeView(viewModel: LoginViewModel())
}
