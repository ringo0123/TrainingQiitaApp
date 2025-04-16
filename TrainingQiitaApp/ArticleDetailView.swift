//
//  ArticleDetailView .swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/16.
//

import SwiftUI

struct ArticleDetailView: View {
    @Environment(\.dismiss) var dismiss
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                let cleanedBody = article.body?.replacingOccurrences(of: "<br>", with: "") ?? ""
                let lines = cleanedBody.components(separatedBy: "\n")
                
                ForEach(lines, id: \.self) { line in
                    if line.starts(with: "## ") {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(line.replacingOccurrences(of: "## ", with: ""))
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical,4)
                            Divider()
                                .padding(.bottom, 12)
                        }
                    }
                    else if line.starts(with: "#### ") {
                        Text(line.replacingOccurrences(of: "#### ", with: ""))
                            .font(.title2)
                            .padding(.bottom, 8)
                    }
                    else if line.contains("<img src=") {
                        // 正規表現 or シンプルな分割でURLを取り出す
                        if let urlStart = line.range(of: "src=\"")?.upperBound,
                           let urlEnd = line[urlStart...].range(of: "\"")?.lowerBound {
                            
                            let urlString = String(line[urlStart..<urlEnd])
                            
                            if let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    else {
                        Text(line)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("戻る")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("記事本文")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(article: Article(
            id: "id",
            title: "タイトル",
            url: "https://example.com/article",
            body: "本文がここに表示されます",
            user: User(
                id: "id",
                name: "SwiftUI",
                profileImageUrl: nil
            )
        ))
    }
}
