//
//  DetailView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import SwiftUI

struct DetailView: View {
    // 뒤로가기 동작
    @Environment(\.dismiss) private var dismiss
    
    let post: Post
    var body: some View {
        ZStack {
            // 배경
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack {
                Text(post.title)
                Text(post.content)
            }
            .foregroundColor(Color.mainWhite)
        }
        .navigationBarTitle("\(post.title)", displayMode: .inline)
        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
        //.toolbarBackground(Color.mainBlack, for: .navigationBar) // 네비게이션 바 배경 색상
        .toolbarBackground(.visible, for: .navigationBar)        // 배경 색상 강제 적용
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .foregroundColor(Color.mainGreen)
            }
        }
    }
}


#Preview {
    DetailView(post: Post(
        id: "테스트",
        title: "타겟과 모듈",
        content: """
        **타겟**
        - xcode에서 앱 빌드를 위해 정의된 설정의 집합입니다
        
        **모듈**
        - 코드의 ##재사용성##을 높이기 위한 코드묶음입니다
        - 앱과 라이브러리는 각각 하나의 ##모듈##로 간주되고
          import 키워들를 사용해 다른 모듈을 가져옵니다
        - 모듈은 컴파일 ##속도를 높이고## 코드의 ##의존성을 분리## 하는 데 유용합니다
        
        ```swift
        import SwiftUI
        struct ContentView: View {
            var body: some View {
                Text("Hello, world!")
            }
        }
        ```
        ```kotlin
        import SwiftUI
        struct ContentView: View {
            var body: some View {
                Text("Hello, world!")
            }
        }
        ```
        """,
        authorID: "김동현", createdAt: Date()))
}




//#Preview {
//    DetailView(
//        post: .init(
//            id: "1",
//            title: "제목 테스트",
//            content: "내용 테스트",
//            authorID: "관리자",
//            createdAt: .now))
//}





//
////
////  DetailView.swift
////  CodeLounge
////
////  Created by 김동현 on 12/13/24.
////
//
//import SwiftUI
////import Highlightr
//
//// UINavigationController 확장: 스와이프 제스처 활성화
//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//
//    public func gestureRecognizer(
//        _ gestureRecognizer: UIGestureRecognizer,
//        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
//    ) -> Bool {
//        return true
//    }
//}
//
//struct DetailView: View {
//    let post: Post
//    @Environment(\.dismiss) var dismiss // 뒤로 가기 동작을 위한 dismiss 환경 변수
//
//    var body: some View {
//        ZStack {
//            // 배경
//            Color.mainBlack
//                .ignoresSafeArea()
//            ScrollView(showsIndicators: false) {
//                // 컨텐츠
//                VStack(alignment: .leading) {
//                    formatText(post.content)
//                        .multilineTextAlignment(.leading)
//                        .tint(.indigo)
//                        .padding()
//                }
//                .frame(maxWidth: .infinity, alignment: .topLeading) // 좌측 상단 정렬
//            }
//        }
//        .navigationBarTitle("\(post.title)", displayMode: .inline)
//        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
//        .toolbarBackground(.visible, for: .navigationBar)
//        
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss() // 뒤로 가기 동작
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 18, weight: .bold))
////                        Text("Back") // 원하는 텍스트 추가
////                            .font(.body)
//                    }
//                    .foregroundColor(.mainGreen) // 버튼 색상
//                }
//            }
//        }
//    }
//
//    private func formatText(_ content: String) -> AnyView {
//        let replacedContent = content.replacingOccurrences(of: "\\n", with: "\n")
//        let components = replacedContent.components(separatedBy: "\n```")
//
//        var formattedViews: [AnyView] = []
//
//        for (index, component) in components.enumerated() {
//            if index % 2 == 1 { // 코드 블록 처리
//                let lines = component.split(separator: "\n", maxSplits: 1)
//                let language = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "코드"
//                let codeContent = lines.count > 1 ? lines[1] : ""
//
//                // 코드 블록 스타일 적용
//                formattedViews.append(
//                    AnyView(
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("\(language.uppercased()) CODE")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Text(codeContent.trimmingCharacters(in: .whitespacesAndNewlines))
//                                //.font(.system(.body, design: .monospaced))
//                                .font(.system(size: 13, design: .monospaced))
//                                .padding()
//                                .background(Color.gray.opacity(0.2)) // 배경색 추가
//                                .cornerRadius(8) // 모서리를 둥글게 처리
//                        }
//                        .padding(.top, -10)
//                        //.padding(.vertical, 8)
//                    )
//                )
//            } else { // 일반 텍스트 처리
//                let subcomponents = component.components(separatedBy: "**")
//                var formattedText = Text("")
//                for (index, subcomponent) in subcomponents.enumerated() {
//                    if index % 2 == 1 { // 양쪽이 **로 감싸진 경우
//                        formattedText = formattedText
//                            + Text(subcomponent)
//                                //.font(.title)
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundColor(.mainGreen)
//                    } else { // 일반 텍스트r
//                        let underlinedComponents = subcomponent.components(separatedBy: "##")
//                        for (index, part) in underlinedComponents.enumerated() {
//                            if index % 2 == 1 { // 양쪽이 ##로 감싸진 경우
//                                formattedText = formattedText
//                                    + Text(part)
//                                        .underline()
//                                        .font(.body)
//                                        .foregroundColor(.mainGreen)
//                            } else { // 일반 텍스트
//                                formattedText = formattedText
//                                    + Text(part)
//                                        .font(.body)
//                                        .foregroundColor(.white)
//                            }
//                        }
//                    }
//                }
//                formattedViews.append(
//                    AnyView(formattedText.lineSpacing(8))
//                        
//                )
//            }
//        }
//
//        return AnyView(
//            ScrollView {
//                VStack(alignment: .leading, spacing: 12) {
//                    ForEach(0..<formattedViews.count, id: \ .self) { index in
//                        formattedViews[index]
//                    }
//                }
//                //.padding()
//            }
//        )
//    }
//}
//
//
//
//#Preview {
//    DetailView(post: Post(
//        id: "테스트",
//        title: "타겟과 모듈",
//        content: """
//        **타겟**
//        - xcode에서 앱 빌드를 위해 정의된 설정의 집합입니다
//        
//        **모듈**
//        - 코드의 ##재사용성##을 높이기 위한 코드묶음입니다
//        - 앱과 라이브러리는 각각 하나의 ##모듈##로 간주되고
//          import 키워들를 사용해 다른 모듈을 가져옵니다
//        - 모듈은 컴파일 ##속도를 높이고## 코드의 ##의존성을 분리## 하는 데 유용합니다
//        
//        ```swift
//        import SwiftUI
//        struct ContentView: View {
//            var body: some View {
//                Text("Hello, world!")
//            }
//        }
//        ```
//        ```kotlin
//        import SwiftUI
//        struct ContentView: View {
//            var body: some View {
//                Text("Hello, world!")
//            }
//        }
//        ```
//        """,
//        authorID: "김동현", createdAt: Date()))
//}
//
//
