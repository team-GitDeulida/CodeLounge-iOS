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
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack {
                    MarkdownView(markdown: post.content)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .topLeading) // 좌측 상단 정렬
            }
            // BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2435281174")
            BannerAdView(adUnitID: "ca-app-pub-6798240605221343/7424023393")
        }
        .background(Color.mainBlack.ignoresSafeArea())
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


//import SwiftUI
//
//struct DetailView: View {
//    // 뒤로가기 동작
//    @Environment(\.dismiss) private var dismiss
//    
//    let post: Post
//    var body: some View {
//        ZStack {
//            // 배경
//            Color.mainBlack
//                .ignoresSafeArea()
//            
//            ScrollView(showsIndicators: false) {
//                VStack {
//                    MarkdownView(markdown: post.content)
//                        .padding()
//                    BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2435281174")
//                }
//                .frame(maxWidth: .infinity, alignment: .topLeading) // 좌측 상단 정렬
//            }
//        }
//        .navigationBarTitle("\(post.title)", displayMode: .inline)
//        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
//        //.toolbarBackground(Color.mainBlack, for: .navigationBar) // 네비게이션 바 배경 색상
//        .toolbarBackground(.visible, for: .navigationBar)        // 배경 색상 강제 적용
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "chevron.left")
//                }
//                .foregroundColor(Color.mainGreen)
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
//                                .font(.system(size: 13.scaled, design: .monospaced))
//                                .padding()
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(8)
//                        }
//                        .padding(.top, -10)
//                    )
//                )
//            } else { // 일반 텍스트 처리
//                let subcomponents = component.components(separatedBy: "**")
//                var formattedText = Text("")
//                for (index, subcomponent) in subcomponents.enumerated() {
//                    if index % 2 == 1 { // `**`로 감싸진 텍스트
//                        formattedText = formattedText
//                            + Text(subcomponent)
//                            .font(.system(size: 20.scaled, weight: .bold))
//                                .foregroundColor(.mainGreen)
//                    } else { // 일반 텍스트
//                        let underlinedComponents = subcomponent.components(separatedBy: "##")
//                        for (index, part) in underlinedComponents.enumerated() {
//                            if index % 2 == 1 { // `##`로 감싸진 텍스트
//                                formattedText = formattedText
//                                    + Text(part)
//                                        .underline()
//                                        //.font(.body)
//                                        .font(.system(size: 17.scaled))
//                                        .foregroundColor(.mainGreen)
//                            } else { // 일반 텍스트
//                                formattedText = formattedText
//                                    + Text(part)
//                                        //.font(.body)
//                                    .font(.system(size: 15.scaled))
//                                        .foregroundColor(.white)
//                            }
//                        }
//                    }
//                }
//                formattedViews.append(
//                    AnyView(formattedText.lineSpacing(8.scaled))
//                )
//            }
//        }
//
//        return AnyView(
//            ScrollView {
//                VStack(alignment: .leading, spacing: 12.scaled) {
//                    ForEach(0..<formattedViews.count, id: \.self) { index in
//                        formattedViews[index]
//                    }
//                }
//            }
//        )
//    }
//}



#Preview {
    DetailView(post: Post(
        id: "테스트",
        title: "타겟과 모듈",
        content: """

        ## Q. Swift의 struct와 class의 주요 차이점은 무엇인가요?

        **1. 값 타입 vs 참조 타입**  
        struct는 값을 복사하지만, class는 참조를 전달합니다.

        **2. 상속**  
        class는 상속이 가능하지만, struct는 불가능합니다.

        **3. ARC 영향**  
        class는 ARC(Automatic Reference Counting)의 영향을 받지만, struct는 받지 않습니다.

        ```swift
        // 구조체
        struct Person {
            var name: String
        }

        // 클래스
        class Animal {
            var species: String
            init(species: String) {
                self.species = species
            }
        }
        ```

        """,
        authorID: "김동현", createdAt: Date()))
}






//#Preview {
//    DetailView(post: Post(
//        id: "테스트",
//        title: "타겟과 모듈",
//        content: """
//
//        ## Q. Swift의 struct와 class의 주요 차이점은 무엇인가요?
//
//        **1. 값 타입 vs 참조 타입**  
//        struct는 값을 복사하지만, class는 참조를 전달합니다.
//
//        **2. 상속**  
//        class는 상속이 가능하지만, struct는 불가능합니다.
//
//        **3. ARC 영향**  
//        class는 ARC(Automatic Reference Counting)의 영향을 받지만, struct는 받지 않습니다.
//
//        ```swift
//        // 구조체
//        struct Person {
//            var name: String
//        }
//
//        // 클래스
//        class Animal {
//            var species: String
//            init(species: String) {
//                self.species = species
//            }
//        }
//        ```
//
//        """,
//        authorID: "김동현", createdAt: Date()))
//}












//#Preview {
//    DetailView(post: Post(
//        id: "테스트",
//        title: "타겟과 모듈",
//        content: """
//        
//        **타겟과 모듈이 무엇인가요?**\n\n##타겟##\n- Xcode에서 앱 빌드를 위해 정의된 설정의 집합입니다.\n\n##모듈##\n- 코드의 ##재사용성##을 높이기 위한 코드 묶음입니다.\n- 앱과 라이브러리는 각각 하나의 모듈로 간주되고 `import` 키워드를 사용해 다른 모듈을 가져옵니다.\n- 모듈은 ##컴파일 속도##를 높이고 코드의 ##의존성을 분리##하는 데 유용합니다.
//        ---------------------------------------
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
//        
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




