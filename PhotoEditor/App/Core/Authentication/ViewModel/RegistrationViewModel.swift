//
//  RegistrationViewModel.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import Foundation
import Observation
import Factory

@Observable
final class RegistrationViewModel {
    
    var email = ""
    var password = ""
    var fullName = ""
    var userName = ""
    
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @MainActor
    func createUser() async throws {
        try await authService.createUser(withEmail: email, password: password, fullName: fullName, userName: userName)
    }
}

