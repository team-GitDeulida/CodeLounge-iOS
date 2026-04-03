//
//  RootViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation
import AuthenticationServices
import Combine

enum AuthenticationState {
  case unauthenticated
  case authenticated
  case firstTimeLogin
}

final class RootViewModel: ObservableObject {
  enum Action {
    case authLogin
    case appleLogin(ASAuthorizationRequest)
    case appleLoginCompletion(Result<ASAuthorization, Error>)
    case googleLogin
    case checkNickname(User)
    case checkNicknameDuplicate(String, (Bool) -> Void)
    case updateUserInfo(String, String, String)
    case logout
  }
  @Dependency private var authService: AuthServiceProtocol
  @Dependency private var userService: UserServiceProtocol
  @Published var authenticationState: AuthenticationState = .unauthenticated
  private var currentNonce: String?
  private var subscriptions = Set<AnyCancellable>()
  var userId: String?
  var user: User?

  func send(action: Action) {
    switch action {
      
    case .authLogin:
      if let userId = authService.checkAuthenticationState() {
        self.authenticationState = .authenticated
        self.userService.getUser(userId: userId)
          .sink { [weak self] completion in
            if case .failure = completion {
              self?.authenticationState = .unauthenticated
            }
          } receiveValue: { [weak self] user in
            self?.send(action: .checkNickname(user))
          }.store(in: &subscriptions)
      }
      
    case .appleLogin(let request):
      let nonce = authService.handleSignInWithAppleRequest(
        request as! ASAuthorizationAppleIDRequest
      )
      currentNonce = nonce
      
      
    case .appleLoginCompletion(let result):
      if case let .success(authorization) = result {
        guard let nonce = self.currentNonce else {
          print("Error: Missing nonce")
          return
        }
        
        authService.handleSignInWithAppleCompletion(
          authorization,
          nonce: nonce
        ).flatMap { user in
          self.userService.getUser(userId: user.id)
            // adduser
        }.sink { [weak self] completion in
          if case .failure(let error) = completion {
            print("애플 로그인 실패: \(error.localizedDescription)")
            self?.authenticationState = .unauthenticated
          }
        } receiveValue: { [weak self] user in
          self?.send(action: .checkNickname(user))
        }.store(in: &subscriptions)
      }
      
      
    case .googleLogin:
      authService.signInWithGoogle()
        .flatMap { user in
          /// 사용자가 존재하는지 getUser로 확인 후, 없으면 최초 로그인이므로 addUser호출 로직
          self.userService.getUser(userId: user.id)
            .catch { error -> AnyPublisher<User, ServiceError> in
              return self.userService.addUser(user)
            }
        }
        .sink { completion in
          switch completion {
          case .finished:
            print("✅ 유저가 성공적으로 추가/로그인 되었습니다!")
          case .failure(let error):
            print("❌ Service 기본 에러: \(error.localizedDescription)")
          }
        } receiveValue: { [weak self] user in
          self?.send(action: .checkNickname(user))
        }.store(in: &subscriptions)

      
      
    case .checkNickname(let user):
      if user.nickname.trimmingCharacters(in: .whitespaces).isEmpty {
        self.authenticationState = .firstTimeLogin
        self.userId = user.id
      } else {
        self.authenticationState = .authenticated
        self.user = user
      }
      
      
    case .checkNicknameDuplicate(let nickname, let completion):
      userService.checkNicknameDuplicate(nickname)
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
        }.store(in: &subscriptions)
      
      
    case .updateUserInfo(let nickname, let birthday, let gender):
      guard let userId = userId else { return }
      
      
    case .logout:
      authService.logout()
        .sink { _ in
          
        } receiveValue: { [weak self] _ in
          self?.authenticationState = .unauthenticated
          self?.user = nil
        }.store(in: &subscriptions)
    }
  }
}
