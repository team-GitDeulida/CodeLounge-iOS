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
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    /*
                    RectView(width: .infinity, height: 50, color: .subBlack, radius: 20)
                        .overlay {
                            Button {
                                
                            } label: {
                                HStack {
                                    Text(authViewModel.user?.nickname ?? "닉네임")
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(.leading)
                            }
                        }
                     */
                    
                    Button {
                        
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(authViewModel.user?.nickname ?? "닉네임")
                                    .font(.system(size: 30, weight: .bold))
//                                Text(formatDate(authViewModel.user?.registerDate) ?? "가입일")
                                Text("\(String(describing: authViewModel.user!.registerDate))")
                                Text("CodeLounge 100일 째")
                            }
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white, lineWidth: 1)
                        }
                    }
                        
                    RectView(height: 100, color: .subBlack, radius: 20)
                        .overlay {
                            VStack(alignment: .leading) {
                                Text("공지사항")
                                    .padding(.leading, 20)
                                    .padding(.bottom, 5)
                                Rectangle()
                                    .fill(Color.mainGray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                                Text("문의하기")
                                    .padding(.leading, 20)
                                    .padding(.top, 5)
                            }
                        }
                    
                    RectView(height: 100, color: .subBlack, radius: 20)
                        .overlay {
                            VStack(alignment: .leading) {
                                Text("개인정보처리방침")
                                    .padding(.leading, 20)
                                    .padding(.bottom, 5)
                                Rectangle()
                                    .fill(Color.mainGray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                                Text("버전정보")
                                    .padding(.leading, 20)
                                    .padding(.top, 5)
                            }
                        }
                    
                    
                    RectView(height: 50, color: .subBlack, radius: 20)
                        .overlay {
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("계정탈퇴")
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(.leading)
                            }
                        }
                     
                    
                    Button {
                        authViewModel.send(action: .logout)
                    } label: {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                //.frame(maxWidth: .infinity)
            }
        }
    }
    
    // 날짜 포맷 함수
    func formatDate(_ dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 날짜 문자열 포맷에 맞게 설정
        guard let date = formatter.date(from: dateString) else { return nil }
        
        // 표시할 형식 지정
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}
