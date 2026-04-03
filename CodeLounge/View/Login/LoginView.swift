//
//  LoginView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

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
        SocialButtonView(type: .apple) {
          rootViewModel.send(action: .appleLogin)
        }
        
        // google
        SocialButtonView(type: .google) {
          
        }
        
        Spacer()
            .frame(height:130.scaled)
      }
      .padding(.horizontal, 30.scaled)
    }
  }
}

#Preview {
  LoginView(navigator: .preview)
    .environmentObject(RootViewModel())
}
