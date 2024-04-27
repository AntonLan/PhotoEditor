//
//  ContentViewModel.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import Foundation
import Observation
import Firebase
import Combine
import Factory

@Observable
final class ContentViewModel {
    var userSession: FirebaseAuth.User?
    private var cancellable = Set<AnyCancellable>()
    
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        authService.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellable)
    }
    
}
