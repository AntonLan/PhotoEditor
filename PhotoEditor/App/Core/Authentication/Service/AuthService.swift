//
//  AuthService.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import Firebase
import FirebaseFirestoreSwift
import Factory
import Combine


enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    @Injected(\.userService) private var userService
    
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func getProvider() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    @MainActor
    func login(
        withEmail email: String,
        password: String
    ) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            if result.user.isEmailVerified {
                        try await uploadUserData(withEmail: email, id: result.user.uid)
                    }

            try await userService.fetchCurrentUser()
        } catch {
            print("Debug: failed to create user \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await result.user.sendEmailVerification()
        } catch {
            print("Debug: failed to create user \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func resetPassword(withEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("Debug: failed to reset \(error.localizedDescription)")
        }
    }
    
    func singOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        userService.reset()
    }
    
    
    @MainActor
    private func uploadUserData(
        withEmail email: String,
        id: String
    ) async throws {
        let user = User(id: id, email: email)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        userService.currentUser = user
    }
}

// MARK: Sing in google
extension AuthService {
    
    func singInWithGoogle(tokkens: GoogleSingInResultModel) async throws {
        let credential  = GoogleAuthProvider.credential(withIDToken: tokkens.idToken, accessToken: tokkens.accessToken)
        
        try await singIn(credential: credential)
        try await checkUser(tokkens: tokkens)
        try await userService.fetchCurrentUser()
    }
    
    func singIn(credential: AuthCredential) async throws {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
        } catch {
            print("Debug: failed to create google user \(error.localizedDescription)")
        }
    }
    
    func checkUser(tokkens: GoogleSingInResultModel) async throws {
        let usersId = try await UserService.getAllUsers().map { $0.id }
        guard let id = userSession?.uid else { return }
        if !usersId.contains(id) {
            try await uploadUserData(withEmail: tokkens.email, id: id)
        }
    }
}

