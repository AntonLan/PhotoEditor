//
//  User.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let email: String
}
