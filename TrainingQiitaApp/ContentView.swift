//
//  ContentView.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        switch viewModel.loginStatus {
        case .idle, .loading, .failure:
            LoginView(viewModel: viewModel)
        case .success:
            HomeView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
