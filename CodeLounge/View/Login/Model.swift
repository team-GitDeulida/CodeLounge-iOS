//
//  Model.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import Foundation

enum Page: String, CaseIterable {
    case page1 = "leaf.circle.fill"
    case page2 = "desktopcomputer"
    case page3 = "iphone"
    case page4 = "text.bubble.fill"
    // case page5 = ""
    
    var title: String {
        switch self {
        case .page1: return "코드라운지에 오신 것을 환영합니다"
        case .page2: return "컴퓨터 공학 기초 (CS)"
        case .page3: return "모바일 개발 (iOS & Android)"
        case .page4: return "코딩 팁과 모범 사례"
        // case .page5: return ""
        }
    }
    
    var subTitle: String {
        switch self {
        case .page1: return "개발자를 위한 지식 공유와 학습의 공간에 오신 것을 환영합니다."
        case .page2: return "운영체제, 네트워크, 자료구조 등 CS의 핵심 개념을 정리합니다."
        case .page3: return "iOS와 Android 개발에 필요한 필수 지식과 기술을 다룹니다."
        case .page4: return "효율적인 개발을 위한 유용한 팁과 트릭을 확인하세요."
        // case .page5: return ""
        }
    }
    
    var description: String {
        switch self {
        case .page1:
            return """
            코드라운지는 개발자를 위한 지식 공유와 학습의 허브입니다.
            최신 기술, 심화된 개념, 실무 노하우까지
            모든 것을 이곳에서 만나보세요.
            """
        case .page2:
            return """
            컴퓨터 공학(CS)의 기본부터 심화까지 다룹니다.
            운영체제(OS), 네트워크, 자료구조, 데이터베이스 등
            개발자로서 알아야 할 모든 기초 지식을 체계적으로 학습할 수 있습니다.
            """
        case .page3:
            return """
            모바일 개발의 모든 것을 한 곳에서 배워보세요.
            iOS(Swift, UIKit, SwiftUI)와 Android(Kotlin, Jetpack Compose) 기술을 다루며,
            실무에서 바로 사용할 수 있는 내용을 제공합니다.
            """
        case .page4:
            return """
            개발 효율성을 높이고 협업을 원활하게 만드는 다양한 팁과 모범 사례를 제공합니다.
            코드 리팩토링, 디버깅, 협업 도구 활용 등 실무 중심의 정보를 확인하세요.
            """
        // case .page5: return ""
        }
    }
    
    var index: CGFloat {
        switch self {
        case .page1: return 0
        case .page2: return 1
        case .page3: return 2
        case .page4: return 3
        // case .page5: return 4
        }
    }
    
    // MARK: - 다음 페이지 가져오기
    var nextPage: Page {
        let index = Int(self.index) + 1
        if index < Page.allCases.count {
            return Page.allCases[index]
        }
        return self
    }
    
    // MARK: - 이전 페이지 가져오기
    var previousPage: Page {
        let index = Int(self.index) - 1
        if index >= 0 {
            return Page.allCases[index]
        }
        return self
    }
}
