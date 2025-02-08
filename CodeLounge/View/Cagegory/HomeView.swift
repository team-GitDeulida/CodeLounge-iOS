//
//  HomeView.swift
//  CodeLounge
//
//  Created by 김동현 on 2/6/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBlack
                    .ignoresSafeArea()
                
                VStack {
                    
                    // 네비게이션 바
                    CustomNavigationBar()
                    
                    ScrollView(showsIndicators: false) {
                        
                        // 타이틀 뷰
                        TitleView()
                        
                        // 컨텐츠 뷰
                        ContentView()
                        
                        // 공지사항 뷰
                        SubTitleView()
                        
                        HStack(spacing: 20) {
                            Button {
                                
                            } label: {
                                Text("Blog")
                                    .contentRectangle(maxWidth: .infinity, height: calculateHeight(percentage: 0.3))
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

private struct CustomNavigationBar: View {
    
    fileprivate var body: some View {
        HStack {
            Text("CodeLounge")
                .font(.system(size: 20, weight: .bold))
            
            Spacer()
//            Image(systemName: "person.crop.circle")
//                .resizable()
//                .frame(width: 45, height: 45)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

private struct TitleView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    @AppStorage("nickname") private var storedNickname: String = "닉네임"
        @AppStorage("registerDate") private var storedRegisterDate: Int = 0
    
    fileprivate var body: some View {
        VStack(alignment: .leading) {
            HStack {
//                Text(authViewModel.user?.nickname ?? "닉네임")
                Text(storedNickname)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.mainGreen)
                Text("님은")
            }
            
            HStack {
//                Text("코드라운지 \(calculateDaySince(authViewModel.user?.registerDate ?? Date()))일 째")
                Text("코드라운지 \(storedRegisterDate)일 째")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
        .foregroundStyle(Color.mainWhite)
        .font(.system(size: 25))
    }
}

private struct ContentView: View {
    fileprivate var body: some View {
        VStack {
            HStack(spacing: 20) {
                NavigationLink {
                    CSView()
                    
                } label: {
                    
                    VStack {
                        Image(systemName: "desktopcomputer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("CS")
                    }
                        .contentRectangle(
                            maxWidth: .infinity,
                            height: calculateHeight(percentage: 0.3))
                }
                
                VStack(spacing: 20) {
                    NavigationLink {
                        iOSView()
                    } label: {
                        VStack {
                            Image(systemName: "apple.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("iOS")
                        }
                            .contentRectangle(
                                maxWidth: .infinity,
                                height: calculateHeight(percentage: 0.15))
                    }
                    
                    NavigationLink {
                        AosView()
                    } label: {
                        VStack {
                            Image(systemName: "smartphone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("AOS")
                        }
                            .contentRectangle(
                                maxWidth: .infinity,
                                height: calculateHeight(percentage: 0.15))
                    }
                }
            }
        }
    }
}

private struct SubTitleView: View {
    fileprivate var body: some View {
        Text("추가 컨텐츠 구현 예정(블로그)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .foregroundStyle(Color.mainWhite)
            .font(.system(size: 25))
    }
}

extension View {
    func contentRectangle(maxWidth: CGFloat, height: CGFloat) -> some View {
        self
            .padding()
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.mainWhite)
            .frame(maxWidth: maxWidth)
            .frame(height: height)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
    }
}

#Preview {
    HomeView()
        .environmentObject(PostViewModel()) // 필요한 객체 주입
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: StubServices())))
}

#Preview {
    MainTabView()
        .environmentObject(PostViewModel()) // 필요한 객체 주입
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: StubServices())))
}
