//
//  LoginView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator
import AuthenticationServices

struct LoginView: View {
  let navigator: Navigator<AppDependencies, AuthRoute>
  @EnvironmentObject private var rootViewModel: RootViewModel
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(.black.gradient)
        .ignoresSafeArea()
      
      VStack {
        // MARK: - Logo
        Spacer()
        Image("CodeLounge")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(
            width: UIScreen.main.bounds.width * 0.4,
            height: UIScreen.main.bounds.height * 0.4
          )
        Spacer()
        
        // apple
        ZStack {
          SignInWithAppleButton { result in
            rootViewModel.send(action: .appleLogin(result))
          } onCompletion: { result in
            rootViewModel.send(action: .appleLoginCompletion(result))
          }
          .frame(maxWidth: .infinity, maxHeight: 60.scaled)
          .accessibilityIdentifier("appleLoginButton") // 식별자 추가
          .opacity(0) // 버튼 숨김 대신 투명도 적용 (배경처럼 동작)
          
          SocialButtonView(type: .apple) {
            triggerAppleLoginButtonTap()
          }
        }
        
        // google
        SocialButtonView(type: .google) {
          rootViewModel.send(action: .googleLogin)
        }
        
        Spacer()
            .frame(height:130.scaled)
      }
      .padding(.horizontal, 30.scaled)
    }
  }
}

private extension LoginView {
  // MARK: - 커스텀 애플 버튼을 누르면 실제 애플 로그인 버튼을 누르도록 트리거 하는 함수
  // Apple 로그인 버튼을 찾고 동작 트리거
  func triggerAppleLoginButtonTap() {
      guard let keyWindow = UIApplication.shared.connectedScenes
              .compactMap({ $0 as? UIWindowScene })
              .flatMap({ $0.windows })
              .first(where: { $0.isKeyWindow }),
            let appleButton = findAppleSignInButton(in: keyWindow) else {
          print("Apple 로그인 버튼을 찾을 수 없습니다.")
          return
      }

      // 버튼 액션 강제 실행
      appleButton.sendActions(for: .touchUpInside)
  }
  
  func findAppleSignInButton(in view: UIView) -> ASAuthorizationAppleIDButton? {
      for subview in view.subviews {
          if let appleButton = subview as? ASAuthorizationAppleIDButton {
              return appleButton
          }
          if let found = findAppleSignInButton(in: subview) {
              return found
          }
      }
      return nil
  }
}

#Preview {
  LoginView(navigator: .preview)
    .environmentObject(RootViewModel())
}
