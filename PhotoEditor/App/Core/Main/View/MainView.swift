//
//  MainView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI
import Factory

struct MainView: View {
    
    @Injected(\.authService) private var authService
    
    
    var body: some View {
        Text("Hello, World!")
        Button {
            authService.singOut()
        } label: {
            Text("Sing out")
        }
    }
}

#Preview {
    MainView()
}
