//
//  ContentView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/10/24.
//

import SwiftUI


// MARK: - Model
struct Post: Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var author: String
    var date = Date()
    
    // 편리하게 사용할 수 있는 날짜 포맷터
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - ViewModel
final class ViewModel: ObservableObject {
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
                author: "김동현"),
            
            
            Post(title: "SwiftUI의 강점", content: "SwiftUI는 선언적 방식으로 UI를 작성할 수 있는 프레임워크입니다.", author: "김동현"),
            Post(title: "코드 라운지 시작", content: "코드를 공유하고 협업할 수 있는 플랫폼입니다.", author: "이철수"),
            Post(title: "Swift의 미래", content: "Swift는 계속 발전 중이며, 많은 가능성을 제공합니다.", author: "박영희")
        ]
    }
    
}

/*
struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        NavigationStack {
            List(viewModel.posts) { post in
                NavigationLink(destination: DetailView(post: post)) {
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
//                        Text(post.formattedDate())
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("\("CS")")
            }

        }
    }
}



#Preview {
    ContentView()
}



//ForEach([1, 2, 3], id: \.self) { item in
//    NavigationLink(destination: DetailView(item: item)) {
//        Text("Item \(item)")
//    }
//}
*/
