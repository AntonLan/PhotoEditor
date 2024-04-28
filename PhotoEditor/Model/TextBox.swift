//
//  TextBox.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 28.04.2024.
//

import Foundation
import SwiftUI

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .black
}
