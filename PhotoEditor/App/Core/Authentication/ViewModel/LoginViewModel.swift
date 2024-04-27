//
//  LoginViewModel.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import Foundation
import Observation
import GoogleSignIn
import GoogleSignInSwift
import Factory

@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @MainActor
    func login() async throws {
        try await authService.login(withEmail: email, password: password)
    }
    
    
    @MainActor
    func singInGoogle() async throws {
        let helper = SingINGoogleHelper()
        let tokens = try await helper.singIn()
        try await authService.singInWithGoogle(tokkens: tokens)
    }
    
}
