//
//  ProfileView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var showDeleteUserAlarm: Bool = false
    @State private var showContactView: Bool = false
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    var body: some View {
        
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - 타이틀
                    TitleView()
                        .padding(.top, 20)
                    
                    // MARK: - 닉네임
                    NicknameView()
                    
                    // MARK: - 공지사항, 문의하기
                    RectView(height: 100, color: .subBlack, radius: 20)
                        .overlay {
                            VStack(alignment: .leading) {
                                NavigationLink {
                                    NoticeView()
                                } label: {
                                    HStack {
                                        Text("공지사항")
                                            .foregroundStyle(Color.mainWhite)
                                            .padding(.leading, 20)
                                            .padding(.bottom, 5)
                                        Spacer()
                                    }
                                }

                                Rectangle()
                                    .fill(Color.mainGray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                                
                                Button {
                                    showContactView.toggle()
                                } label: {
                                    HStack {
                                        Text("문의하기")
                                            .foregroundStyle(Color.mainWhite)
                                            .padding(.leading, 20)
                                            .padding(.top, 5)
                                        Spacer()
                                    }
                                }
                                
                            }
                        }
                    
                    // MARK: - 개인정보처리방침, 버전정보
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
                                
                                HStack {
                                    Text("버전정보")
                                        .padding(.leading, 20)
                                        .padding(.top, 5)
                                    Spacer()
                                    Text(version)
                                        .padding(.trailing, 20)
                                        .padding(.top, 5)
                                }
                            }
                        }
                    
                    // MARK: - 계정탈퇴
                    RectView(height: 50, color: .subBlack, radius: 20)
                        .overlay {
                            Button {
                                showDeleteUserAlarm.toggle()
                            } label: {
                                HStack {
                                    Text("계정탈퇴")
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(.leading)
                            }
                        }
                    
                    // MARK: - 로그아웃
                    Button {
                        authViewModel.send(action: .logout)
                    } label: {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .alert(isPresented: $showDeleteUserAlarm) {
                    Alert(
                        title: Text("계정 삭제"),
                        message: Text("정말로 계정을 삭제하시겠습니가?"),
                        primaryButton: .destructive(Text("삭제")) {
                            authViewModel.send(action: .deleteUser)
                        },
                        secondaryButton: .cancel()
                    )
                }
                .fullScreenCover(isPresented: $showContactView) {
                    let urlString = Bundle.main.infoDictionary?["KAKAO_URL"] as? String ?? ""
                    
                    SafriWebView(url: URL(string: "https://" + urlString)!)
                        .ignoresSafeArea()
                }
                
            }
            .background(Color.mainBlack)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("Profile")
                .font(.system(size: 30, weight: .bold))
                .padding(.leading, 10)
            Spacer()
        }
    }
}

// MARK: - 닉네임 뷰
private struct NicknameView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    fileprivate var body: some View {
        NavigationLink {
            ProfileSettingView()
            // NicknameSettingView()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(authViewModel.user?.nickname ?? "닉네임")
                        .font(.system(size: 25, weight: .bold))
                    
                    if let registerDate = authViewModel.user?.registerDate {
                        Text("CodeLounge \(calculateDaySince(registerDate))일 째")
                    }
                }
                .padding(.leading, 20)
                .foregroundColor(.white)
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.mainWhite)
                    .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white, lineWidth: 0.5)
            }
        }
    }
    
    // MARK: - 날짜 비교 함수
    func calculateDaySince_legacy(_ registerDate: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var calendarInKorea = calendar
        calendarInKorea.timeZone = TimeZone(identifier: "Asia/Seoul")! // 한국 시간대 설정
        
        let days = calendarInKorea.dateComponents([.day], from: registerDate, to: currentDate).day ?? 0
        return days
    }
    
    // MARK: - 날짜 비교 함수
    func calculateDaySince(_ registerDate: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var calendarInKorea = calendar
        calendarInKorea.timeZone = TimeZone(identifier: "Asia/Seoul")! // 한국 시간대 설정
        
        // 날짜 단위로 비교하여 차이를 계산
        let startOfRegisterDate = calendarInKorea.startOfDay(for: registerDate)
        let startOfCurrentDate = calendarInKorea.startOfDay(for: currentDate)
        
        let days = calendarInKorea.dateComponents([.day], from: startOfRegisterDate, to: startOfCurrentDate).day ?? 0
        return days
    }
}

// MARK: - 공지사항 뷰
private struct NoticeView: View {
    fileprivate var body: some View {
        VStack {
            Text("공지사항")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}
