//
//  MainTabView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

enum MainTabType: CaseIterable {
    case csView
    case iosView
    case aosView
    case frontendView
    
    var title: String {
        switch self {
        case .csView:
            return "CS"
        case .iosView:
            return "iOS"
        case .aosView:
            return "aOS"
        case .frontendView:
            return "Frontend"
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
        case .frontendView:
            return isSelected ? "calendar" : "calendar"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: MainTabType = .csView
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                switch selectedTab {
                case .csView:
                    CSView()
                case .iosView:
                    iOSView()
                case .aosView:
                    AosView()
                case .frontendView:
                    FrontendView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
                .background(Color.gray.opacity(0.3))
                .padding(.bottom, 10)
            
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
                    
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedTab = tab
                    }
                    Spacer()
                        .frame(width: 10)
                }
                .frame(height: 50) // 고정 높이
            }
        }
    }
}

#Preview {
    MainTabView()
}
