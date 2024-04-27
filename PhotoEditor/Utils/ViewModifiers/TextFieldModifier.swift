//
//  ThreadsTextFieldModifier.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
