//
//  SingINGoogleHelper.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import GoogleSignIn
import GoogleSignInSwift

struct GoogleSingInResultModel {
    var idToken: String
    var accessToken: String
    var email: String
}

final class SingINGoogleHelper {
    
    @MainActor
    func singIn() async throws -> GoogleSingInResultModel {
        guard let topVc = Utilites.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSingInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVc)
        
        guard let idToken = gidSingInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSingInResult.user.accessToken.tokenString
        
        guard let email = gidSingInResult.user.profile?.email else {
            throw URLError(.badServerResponse)
        }


        let tokens = GoogleSingInResultModel(idToken: idToken, accessToken: accessToken, email: email)
        
        return tokens
    }

}

