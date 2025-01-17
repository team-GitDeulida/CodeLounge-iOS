//
//  AuthenticationViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation
import Combine

enum AuthenticationState {
    case unauthenticated
    case authenticated
    case firstTimeLogin
}

final class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case checkNickname(User)
        case checkNicknameDuplicate(String, (Bool) -> Void)
        case updateUserInfo(String, String, String)
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    
    var userId: String?
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
                        print("✅ 유저가 성공적으로 추가되었습니다!")
                        
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
            
        case .checkNickname(let user):
            if user.nickname.trimmingCharacters(in: .whitespaces).isEmpty {
                self.authenticationState = .firstTimeLogin
            } else {
                self.authenticationState = .authenticated
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
               }, receiveValue: { _ in })
               .store(in: &subscriptions)
            
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
        
        }
    }
}
