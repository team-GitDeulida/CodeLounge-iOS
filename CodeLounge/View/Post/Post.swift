//
//  ContentView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/10/24.
//

import SwiftUI


// MARK: - Model
struct Post: Identifiable {
    let id = UUID() // 고유 ID 생성
    var title: String // Firebase의 "title"과 매핑
    var content: String // Firebase의 "content"와 매핑
    var author_id: String // Firebase의 "author_id"와 매핑
    var created_at: Date // Firebase의 "created_at"과 매핑
    
    // 편리하게 사용할 수 있는 날짜 포맷터
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: created_at)
    }
}

// MARK: - ViewModel
final class PostViewModel: ObservableObject {
    @Published var posts: [Post]
    
    init() {
        posts = [
            //Post(title: "지원동기", content: "iOS개발자 지원동기", author: "김동현"),
            Post(
                title: "타겟과 모듈",
                content: """
                **타겟**
                - xcode에서 앱 빌드를 위해 정의된 설정의 집합입니다
                 
                **모듈**
                - 코드의 재사용성을 높이기 위한 코드묶음입니다
                
                - 앱과 라이브러리는 각각 하나의 모듈로 간주되고
                  import 키워들를 사용해 다른 모듈을 가져옵니다
                
                - 모듈은 컴파일 속도를 높이고 코드의 의존성을 분리하는 데 유용합니다
                
                """,
                author_id: "김동현", created_at: Date()),
            
            
            Post(title: "SwiftUI의 강점", content: "SwiftUI는 선언적 방식으로 UI를 작성할 수 있는 프레임워크입니다.", author_id: "김동현", created_at: Date()),
            Post(title: "코드 라운지 시작", content: "코드를 공유하고 협업할 수 있는 플랫폼입니다.", author_id: "이철수", created_at: Date()),
            Post(title: "Swift의 미래", content: "Swift는 계속 발전 중이며, 많은 가능성을 제공합니다.", author_id: "박영희", created_at: Date())
        ]
    }
    
}
