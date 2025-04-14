//
//  TrainingQiitaAppApp.swift
//  TrainingQiitaApp
//
//  Created by  hayato on 2025/04/10.
//

import SwiftUI

@main
struct TrainingQiitaAppApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 137/255, green: 201/255, blue: 151/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // タイトル文字白
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
