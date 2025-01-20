//
//  MainTabView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

enum MainTabType: CaseIterable {
    case csView
    case iosView
    case aosView
    case profileView
    
    var title: String {
        switch self {
        case .csView:
            return "CS"
        case .iosView:
            return "iOS"
        case .aosView:
            return "aOS"
        case .profileView:
            return "profile"
        }
    }
    
    func imageName(isSelected: Bool) -> String {
        switch self {
        case .csView:
            return isSelected ? "desktopcomputer" : "desktopcomputer"
        case .iosView:
            return isSelected ? "apple.logo" : "apple.logo"
        case .aosView:
            return isSelected ? "smartphone" : "smartphone"
        case .profileView:
            return isSelected ? "person.fill" : "person"
        }
    }
}

struct MainTabView: View {
    //@StateObject private var postVM = PostViewModel()
    @State private var selectedTab: MainTabType = .csView
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                switch selectedTab {
                case .csView:
                    CSView()
                    //.environmentObject(postVM)
                case .iosView:
                    iOSView()
                    //.environmentObject(postVM)
                case .aosView:
                    AosView()
                    //.environmentObject(postVM)
                case .profileView:
                    ProfileView()
                    // .environmentObject(postVM)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.bottom, 15)
                
                HStack {
                    ForEach(MainTabType.allCases, id: \.self) { tab in
                        Spacer()
                            .frame(width: 10)
                        
                        VStack(spacing: 4) {
                            Image(systemName: tab.imageName(isSelected: selectedTab == tab))
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                            Text(tab.title)
                                .font(.caption2)
                            //.font(.system(size: 9))
                                .lineLimit(1)    // 한 줄로 고정해 잘리지 않도록 설정
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                        }
                        .padding(.horizontal, 20) // 좌우 터치 영역 추가
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle()) // 콘텐츠 바깥쪽도 터치 가능
                        .onTapGesture {
                            // 진동 발생
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            selectedTab = tab
                        }
                        Spacer()
                            .frame(width: 10)
                    }
                    .frame(height: 50) // 고정 높이
                }
            }
            .background(.black)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    MainTabView()
        .environmentObject(PostViewModel()) // 필요한 객체 주입
}
