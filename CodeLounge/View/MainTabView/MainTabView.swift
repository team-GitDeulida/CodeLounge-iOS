//
//  MainTabView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

enum MainTabType: CaseIterable {
    case homeView
    case profileView
    
    var title: String {
        switch self {
        case .homeView:
            return "Home"
        case .profileView:
            return "profile"
        }
    }
    
    func imageName(isSelected: Bool) -> String {
        switch self {
        case .homeView:
            return isSelected ? "folder.fill" : "folder.fill"
        case .profileView:
            return isSelected ? "person.fill" : "person"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .homeView
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 0) {
                switch selectedTab {
                case .homeView:
                    HomeView()
                case .profileView:
                    ProfileView()
                }
            }
            .padding(.bottom, 80)
            
            VStack(spacing: 0) {
                Spacer()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                // MARK: - 탭바
                HStack {
                    ForEach(MainTabType.allCases, id: \.self) { tab in
                        
                        Spacer()
                            .frame(width: 10)
                        
                        VStack {
                            Spacer()
                                .frame(height: 5)
                            Image(systemName: tab.imageName(isSelected: selectedTab == tab))
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                            Text(tab.title)
                                .font(.caption2)
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                            Spacer()
                                .frame(height: 20)
                        }
                        .padding(.horizontal, 20) // 좌우 터치 영역 추가
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle()) // 터치 가능한 영역을 명시적으로 지정
                        .onTapGesture {
                            // 진동 발생
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            selectedTab = tab
                        }
                        Spacer()
                            .frame(width: 10)
                    }
                    .frame(height: 100) // 고정 높이
                }
                .background(.black)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    MainTabView()
        .environmentObject(PostViewModel()) // 필요한 객체 주입
        .environmentObject(AuthenticationViewModel(container: DIContainer(services: Services())))
}

