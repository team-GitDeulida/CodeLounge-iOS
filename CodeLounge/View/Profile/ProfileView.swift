//
//  ProfileView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack {
                Button {
                    authViewModel.send(action: .logout)
                } label: {
                    Text("로그아웃")
                        .padding()
                        .foregroundColor(.mainWhite)
                        .frame(width: 150, height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.mainGreen, lineWidth: 1)
                        }
                }
            }
        }
    }
    
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}
