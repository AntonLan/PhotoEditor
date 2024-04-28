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
    
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @MainActor
    func createUser() async throws {
        try await authService.createUser(withEmail: email, password: password)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
      }
      
      func isValidPassword() -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
      }
    
    func checkUniqueEmail() async throws -> Bool {
        let userEmails = try await UserService.getAllUsers().compactMap { $0.email }
        return userEmails.contains(email)
    }
}

