//
//  ArticleDetailView .swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/16.
//

import SwiftUI

struct ArticleDetailView: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let parsedBody: [MarkdownLine]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(parsedBody) { line in
                    switch line {
                    case .heading1(let text):
                        VStack(alignment: .leading, spacing: 0) {
                            Text(text)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.vertical, 8)
                            
                            Divider()
                                .padding(.bottom, 12)
                        }

                    case .heading2(let text):
                        VStack(alignment: .leading, spacing: 0) {
                            Text(text)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.vertical, 6)
                            
                            Divider()
                                .padding(.bottom, 12)
                        }

                    case .heading3(let text):
                        Text(text)
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.vertical, 4)

                    case .heading4(let text):
                        Text(text)
                            .font(.headline)
                            .padding(.bottom, 2)
                        
                    case .codeBlock(let code):
                        Text(code)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                    case .image(let url):
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                        }
                        
                    case .link(let url):
                        Link(destination: url) {
                            Text(url.absoluteString)
                                .foregroundColor(.blue)
                                .underline()
                                .font(.body)
                        }

                    case .text(let text):
                        Text(text)
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
        ArticleDetailView(
            title: "タイトル",
            parsedBody: []
        )
    }
}
