//
//  testappApp.swift
//  testapp
//
//  Created by Elias Just on 13.03.23.
//

import SwiftUI

@main
struct ChessApp: App {
    let viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewmodel: viewModel)
        }
    }
}
