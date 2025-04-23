//
//  LoginView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        GeometryReader {
            let _ = $0.size
            HeaderView()
        }
        .background(.black.gradient)
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        @Environment(\.dismiss) var dismiss

        VStack {
            Spacer()
            
            Image("CodeLounge")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: UIScreen.main.bounds.width * 0.4,
                    height: UIScreen.main.bounds.height * 0.4
                )
            
            Spacer()
            
            // MARK: - 애플 로그인 버튼은 직접 커스텀할 수 없기 때문에 실제 버튼 위에 커스텀 버튼을 올려준다.
            ZStack {
                // MARK: - 실제 Apple 로그인 버튼
                SignInWithAppleButton { result in
                    authViewModel.send(action: .appleLogin(result))
                } onCompletion: { result in
                    authViewModel.send(action: .appleLoginCompletion(result))
                }
                .frame(maxWidth: .infinity, maxHeight: 60.scaled)
                .accessibilityIdentifier("appleLoginButton") // 식별자 추가
                .opacity(0) // 버튼 숨김 대신 투명도 적용 (배경처럼 동작)
                
                
                // MARK: - 애플 커스텀 Ui
                Button {
                    triggerAppleLoginButtonTap()
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24.scaled, height: 24.scaled)
                        
                        
                        Spacer()
                        
                        Text("Apple로 계속하기")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .padding(.horizontal, 45.scaled)
                }.buttonStyle(SocialButtonStyle(buttonType: "Apple"))
            }
            
            // MARK: - Google 버튼
            Button {
                authViewModel.send(action: .googleLogin)
            } label: {
                HStack {
                    Image("Google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30.scaled, height: 30.scaled)
                        
                    Spacer()
                    
                    Text("Google로 계속하기")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 45.scaled)
            }.buttonStyle(SocialButtonStyle(buttonType: "Google"))
            
            
            Spacer()
                .frame(height:130.scaled)
        }
        .padding(.horizontal, 30.scaled)
        
    }
    
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

// 로그인 버튼 스타일
struct SocialButtonStyle: ButtonStyle {
    let buttonType: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16.scaled, weight: .semibold))
            .foregroundColor(
                buttonType == "Google" ? Color.black :
                    buttonType == "Kakao" ? Color.black.opacity(0.85) :
                Color.white // 애플 버튼 레이블 색상
            )
            .frame(maxWidth: .infinity, maxHeight: 60.scaled)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        buttonType == "Google" ? Color.white :
                        buttonType == "Kakao" ? Color("#FEE500") :
                        Color.black // 애플 버튼 배경색
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        buttonType == "Google" ? Color.black :
                        buttonType == "Kakao" ? Color("#FEE500") :
                        Color.white, lineWidth: 0.8 // 테두리 색상
                    )
            )
            .opacity(configuration.isPressed ? 0.5 : 1)
            //.padding(.horizontal, 15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LoginView()
}
