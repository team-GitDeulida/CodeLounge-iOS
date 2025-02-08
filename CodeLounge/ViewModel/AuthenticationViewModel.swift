//
//  AuthenticationViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation
import Combine
import AuthenticationServices
import FirebaseAuth
import SwiftUI

enum AuthenticationState {
    case unauthenticated
    case authenticated
    case firstTimeLogin
}

final class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case appleLogin(ASAuthorizationRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case checkNickname(User)
        case checkNicknameDuplicate(String, (Bool) -> Void)
        case updateUserInfo(String, String, String)
        case logout
        case deleteUser
    }
    
    @AppStorage("nickname") private var storedNickname: String = ""
    @AppStorage("registerDate") private var storedRegisterDate: Int = 0
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    
    var userId: String?
    var user: User?

    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var currentNonce: String?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
                // MARK: - Firebase에서 사용자 정보를 가져와 닉네임 확인
                container.services.userService.getUser(userId: userId)
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.authenticationState = .unauthenticated
                        }
                    } receiveValue: { [weak self] user in
                        // 닉네임 유무 확인
                        self?.send(action: .checkNickname(user))
                    }
                    .store(in: &subscriptions)
            }
            
        case .googleLogin:
            isLoading = true
            container.services.authService.signInWithGoogle()
                .flatMap { user in
                    // MARK: - 사용자가 존재하는지 getUser로 확인 후, 없으면 최초 로그인이므로 addUser호출 로직
                    self.container.services.userService.getUser(userId: user.id)
                        .catch { error -> AnyPublisher<User, ServiceError> in
                            return self.container.services.userService.addUser(user)
                        }
                }
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("✅ 유저가 성공적으로 추가/로그인 되었습니다!")
                        
                    case .failure(let error):
                        if case .dbError(let dbError) = error {
                            // ❌ error가 .dbError 케이스일 경우 실행 - ServiceError{DBError}
                            print(dbError.errorDescription)
                        } else {
                            // ❌ 다른 ServiceError 처리
                            print("❌ Service 기본 에러: \(error.localizedDescription)")
                        }
                        self?.isLoading = false
                    }
                } receiveValue: { [weak self] user in
                    self?.isLoading = false
                    self?.userId = user.id
                    
                    
                    // MARK: - 닉네임 유무를 확인하는 구간
                    self?.send(action: .checkNickname(user))
                }.store(in: &subscriptions)
            
        case let .appleLogin(request):
            let nonce = container.services.authService.handleSignInWithAppleRequest(request as! ASAuthorizationAppleIDRequest)
            currentNonce = nonce
            
        case .checkNickname(let user):
            if user.nickname.trimmingCharacters(in: .whitespaces).isEmpty {
                self.authenticationState = .firstTimeLogin
            } else {
                self.authenticationState = .authenticated
                self.user = user
                
                // 추가
                self.storedNickname = user.nickname
                self.storedRegisterDate = calculateDaySince(user.registerDate ?? Date())
            }
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = self.currentNonce else {
                    print("Error: Missing nonce")
                    return
                }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
                    .flatMap { user in
                        self.container.services.userService.getUser(userId: user.id)
                            .catch { error -> AnyPublisher<User, ServiceError> in
                                return self.container.services.userService.addUser(user)
                            }
                    }
                    .sink { [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.isLoading = false
                            // 구체적인 에러 정보 출력
                            print("애플 로그인 실패: \(error.localizedDescription)")
                            
                            
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id
                        
                        
                        // MARK: - 닉네임 유무를 확인하는 구간
                        self?.send(action: .checkNickname(user))
                        
                    }.store(in: &subscriptions)
            }
            
        case .checkNicknameDuplicate(let nickname, let completion):
            container.services.userService.checkNicknameDuplicate(nickname)
                .sink { result in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("닉네임 중복 확인 오류: \(error.localizedDescription)")
                            completion(false) // 오류 발생 시 false 반환
                        }
                    case .finished:
                        break
                    }
                } receiveValue: { isDuplicate in
                    DispatchQueue.main.async {
                        if isDuplicate {
                            completion(true) // 중복된 경우 클로저에 true 전달
                        } else {
                            completion(false) // 중복되지 않은 경우 클로저에 false 전달
                        }
                    }
                }
                .store(in: &subscriptions)
            
        case .updateUserInfo(let nickname, let birthday, let gender):
           guard let userId = userId else { return } // 사용자 ID가 없으면 리턴
           
           // container.services.userService를 통해 닉네임 업데이트 호출
           container.services.userService.updateUserInfo(userId: userId, nickname: nickname, birthday: birthday, gender: gender)
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .finished:
                       self.authenticationState = .authenticated // 닉네임 설정 후 인증 상태 변경
                   case .failure(let error):
                       print("닉네임 업데이트 실패: \(error)") // 오류 처리
                   }
               }, receiveValue: { [weak self] user in
                   self?.user = user
                   
                   // 추가
                   self?.storedNickname = user.nickname
                   self?.storedRegisterDate = calculateDaySince(user.registerDate ?? Date())
               })
               .store(in: &subscriptions)
            
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
        
        case .deleteUser:
            guard let userId = self.userId else { return }
            
            // 1단계: Realtime Database에서 유저 데이터를 삭제
            container.services.userService.deleteUser(userId: userId)
                .tryMap { _ -> FirebaseAuth.User in
                    // 2단계: Firebase Auth 계정 삭제
                    guard let currentUser = Auth.auth().currentUser else {
                        throw ServiceError.dbError(.userNotFound)
                    }
                    return currentUser
                }
                .flatMap { currentUser -> AnyPublisher<Void, Error> in
                    return Future<Void, Error> { promise in
                        currentUser.delete { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    }.eraseToAnyPublisher()
                }
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("계정 삭제 실패: \(error)")
                    }
                } receiveValue: { [weak self] _ in
                    // 계정과 데이터가 성공적으로 삭제된 경우
                    DispatchQueue.main.async {
                        self?.authenticationState = .unauthenticated
                        self?.userId = nil
                    }
                }
                .store(in: &subscriptions)
        }
    }
}
