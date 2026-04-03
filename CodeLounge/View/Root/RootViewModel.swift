//
//  RootViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation

enum AuthenticationState {
  case unauthenticated
  case authenticated
  case firstTimeLogin
}

final class RootViewModel: ObservableObject {
  enum Action {
    case appleLogin
  }
  
  @Published var authenticationState: AuthenticationState = .unauthenticated

  func send(action: Action) {
    switch action {
    case .appleLogin:
      self.authenticationState = .authenticated
    }
  }
}
