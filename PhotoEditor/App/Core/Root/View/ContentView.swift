//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
