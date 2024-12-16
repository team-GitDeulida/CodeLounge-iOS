//
//  AuthenticationService.swift
//  CodeLounge
//
//  Created by 김동현 on 12/15/24.
//

import Foundation
import Combine
import GoogleSignIn
import FirebaseAuth

enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidated
}

enum ServiceError: Error {
    case error(Error)
    case userNotFound
}

protocol AuthenticationServiceType {
    // 구글 로그인
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>
}

