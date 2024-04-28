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
import SwiftUI

@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    
    var isShowAlert = false
    var message = ""
    
    var isShowFogotPassword = false
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @MainActor
    func login() async throws {
        do {
            try await authService.login(withEmail: email, password: password)
        } catch {
            isShowAlert = true
            message = error.localizedDescription
        }
    }
    
    
    @MainActor
    func singInGoogle() async throws {
        let helper = SingINGoogleHelper()
        let tokens = try await helper.singIn()
        try await authService.singInWithGoogle(tokkens: tokens)
    }

    func resetPassword() async throws {
        try await authService.resetPassword(withEmail: email)
    }
}


struct LoginVmKey: EnvironmentKey {
    static var defaultValue: LoginViewModel = LoginViewModel()
}

extension EnvironmentValues {
    var loginVm: LoginViewModel {
        get { self[LoginVmKey.self] }
        set { self[LoginVmKey.self] = newValue }
    }
}
