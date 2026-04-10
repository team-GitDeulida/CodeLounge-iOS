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
    case autoLogin
    case appleLogin(ASAuthorizationRequest)
    case appleLoginCompletion(Result<ASAuthorization, Error>)
    case googleLogin
    case checkNickname(User)
    case checkNicknameDuplicate(String, (Bool) -> Void)
    case updateUserInfo(String, String, String)
    case deleteUser
    case logout
  }
  @Dependency private var authService: AuthServiceProtocol
  @Dependency private var userService: UserServiceProtocol
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var nicknameValidationMessage: String?
  private var currentNonce: String?
  private var subscriptions = Set<AnyCancellable>()
  var userId: String?
  var user: User?

  func send(action: Action) {
    switch action {
      
    case .autoLogin:
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
            .catch { _ in
              self.userService.addUser(user)
            }
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
      self.userId = user.id
      self.nicknameValidationMessage = nil
      if user.nickname.trimmingCharacters(in: .whitespaces).isEmpty {
        self.authenticationState = .firstTimeLogin
      } else {
        self.authenticationState = .authenticated
        self.user = user
      }
      
      
    case .checkNicknameDuplicate(let nickname, let completion):
      let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

      guard !trimmedNickname.isEmpty else {
        nicknameValidationMessage = "닉네임을 입력해주세요"
        completion(true)
        return
      }

      userService.checkNicknameDuplicate(trimmedNickname)
        .sink { [weak self] result in
          switch result {
          case .failure(let error):
            print("닉네임 확인 실패: \(error)")
            DispatchQueue.main.async {
              self?.nicknameValidationMessage = "닉네임 확인에 실패했습니다"
              completion(true)
            }
          case .finished:
            break
          }
        } receiveValue: { [weak self] isDuplicate in
          DispatchQueue.main.async {
            self?.nicknameValidationMessage = isDuplicate ? "닉네임이 중복되었습니다" : nil
            completion(isDuplicate)
          }
        }.store(in: &subscriptions)
      
      
    case .updateUserInfo(let nickname, let birthday, let gender):
      guard let userId = userId else { return }
      let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
      let currentNickname = user?.nickname.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

      guard !trimmedNickname.isEmpty else {
        nicknameValidationMessage = "닉네임을 입력해주세요"
        return
      }

      userService.checkNicknameDuplicate(trimmedNickname)
        .sink { [weak self] completion in
          if case .failure(let error) = completion {
            self?.nicknameValidationMessage = "닉네임 확인에 실패했습니다"
            print("닉네임 중복 확인 실패: \(error)")
          }
        } receiveValue: { [weak self] isDuplicate in
          guard let self else { return }

          if isDuplicate, trimmedNickname != currentNickname {
            self.nicknameValidationMessage = "닉네임이 중복되었습니다"
            return
          }

          self.nicknameValidationMessage = nil
          self.userService.updateUserInfo(
            userId: userId,
            nickname: trimmedNickname,
            birthday: birthday,
            gender: gender
          )
          .sink { [weak self] completion in
            switch completion {
            case .finished:
              self?.authenticationState = .authenticated
            case .failure(let error):
              print("닉네임 업데이트 실패: \(error)")
            }
          } receiveValue: { [weak self] user in
            self?.user = user
          }.store(in: &self.subscriptions)
        }.store(in: &subscriptions)

    case .deleteUser:
      guard let userId = userId ?? user?.id else { return }
      userService.deleteUser(userId: userId)
        .flatMap { [authService] _ in
          authService.logout()
        }
        .sink { completion in
          if case .failure(let error) = completion {
            print("계정 삭제 실패: \(error)")
          }
        } receiveValue: { [weak self] _ in
          self?.authenticationState = .unauthenticated
          self?.user = nil
          self?.userId = nil
        }.store(in: &subscriptions)

      
    case .logout:
      nicknameValidationMessage = nil
      authService.logout()
        .sink { _ in
          
        } receiveValue: { [weak self] _ in
          self?.authenticationState = .unauthenticated
          self?.user = nil
          self?.userId = nil
        }.store(in: &subscriptions)
    }
  }
}

extension RootViewModel: Hashable {
  static func == (lhs: RootViewModel, rhs: RootViewModel) -> Bool {
    lhs === rhs
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}
