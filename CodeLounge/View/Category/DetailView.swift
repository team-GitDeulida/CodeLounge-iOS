//
//  DetailView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/13/24.
//

//import SwiftUI
//
//struct DetailView: View {
//    let post: Post
//
//    var body: some View {
//        ZStack {
//            Color.mainBlack // 원하는 배경색
//                            .ignoresSafeArea() // 안전 영역까지 배경 적용
//            VStack {
//                Text(post.content.replacingOccurrences(of: "\\n", with: "\n"))
//                    //.font(.title)
//                    .multilineTextAlignment(.leading)
//                    .padding()
//                Spacer()
//            }
//            .navigationTitle("\(post.title)")
//            .navigationBarTitleDisplayMode(.inline)
//            //.background(Color.mainBlack)
//        }
//    }
//}
//
////#Preview {
////    DetailView()
////}




//
//import SwiftUI
//
//struct DetailView: View {
//    let post: Post
//
//
//    var body: some View {
//        ZStack {
//            Color.mainBlack // 원하는 배경색
//                .ignoresSafeArea() // 안전 영역까지 배경 적용
//            VStack {
//                formatText(post.content)
//                    .multilineTextAlignment(.leading)
//                    .padding()
//                Spacer()
//            }
//            .navigationTitle("\(post.title)")
//            .navigationBarTitleDisplayMode(.inline)
//            
//            // 흰색글자 및 불투명
//            .toolbarColorScheme(.dark, for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
//        }
//    }
//
//    // Helper 함수: 텍스트 포매팅
//    private func formatText(_ content: String) -> Text {
//        let replacedContent = content.replacingOccurrences(of: "\\n", with: "\n")
//        let components = replacedContent.components(separatedBy: "**") // '**' 기준으로 나눔
//
//        var formattedText = Text("")
//        var isHighlighted = false
//
//        for component in components {
//            if isHighlighted {
//                formattedText = formattedText + Text(component)
//                    .font(.title) // 강조된 텍스트를 title 크기로 설정
//                    .foregroundColor(.mainGreen) // 강조된 텍스트 색상
//            } else {
//                formattedText = formattedText + Text(component)
//                    .font(.body) // 일반 텍스트를 body 크기로 설정
//            }
//            isHighlighted.toggle() // 다음 텍스트는 반대 상태로 처리
//        }
//        
//        return formattedText
//    }
//}
//
//
//import SwiftUI
//
//struct DetailView: View {
//    let post: Post
//    
//    @Environment(\.dismiss) var dismiss // 뒤로 가기 동작을 위한 dismiss 환경 변수
//    
//    var body: some View {
//        ZStack {
//            // 배경
//            Color.mainBlack
//                .ignoresSafeArea()
//            
//            // 컨텐츠
//            VStack {
//                formatText(post.content)
//                    .multilineTextAlignment(.leading)
//                    .padding()
//                Spacer()
//            }
//        }
//        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss() // 뒤로가기 동작
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.mainGreen) // 원하는 색상
//                }
//            }
//        }
//        .navigationBarTitle("\(post.title)", displayMode: .inline)
//        .toolbarColorScheme(.dark, for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
//        
//    }
//
//    // Helper 함수: 텍스트 포매팅
//    private func formatText(_ content: String) -> Text {
//        let replacedContent = content.replacingOccurrences(of: "\\n", with: "\n")
//        let components = replacedContent.components(separatedBy: "**") // '**' 기준으로 나눔
//
//        var formattedText = Text("")
//        var isHighlighted = false
//
//        for component in components {
//            if isHighlighted {
//                formattedText = formattedText + Text(component)
//                    .font(.title) // 강조된 텍스트를 title 크기로 설정
//                    .foregroundColor(.mainGreen) // 강조된 텍스트 색상
//            } else {
//                formattedText = formattedText + Text(component)
//                    .font(.body) // 일반 텍스트를 body 크기로 설정
//            }
//            isHighlighted.toggle() // 다음 텍스트는 반대 상태로 처리
//        }
//        
//        return formattedText
//    }
//}
//
//import SwiftUI
//
//struct DetailView: View {
//    let post: Post
//    
//    @Environment(\.dismiss) var dismiss // 뒤로 가기 동작을 위한 dismiss 환경 변수
//    
//    var body: some View {
//        ZStack {
//            // 배경
//            Color.mainBlack
//                .ignoresSafeArea()
//            
//            // 컨텐츠
//            VStack {
//                formatText(post.content)
//                    .multilineTextAlignment(.leading)
//                    .padding()
//                Spacer()
//            }
//        }
//        .navigationBarTitle("\(post.title)", displayMode: .inline)
//        .navigationBarBackButtonHidden(true) // 기본 뒤로 가기 버튼 숨김
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss() // 뒤로 가기 동작
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 18, weight: .bold))
//                        Text("Back") // 원하는 텍스트 추가
//                            .font(.body)
//                    }
//                    .foregroundColor(.mainGreen) // 버튼 색상
//                }
//            }
//        }
//        
//    }
//
//    // Helper 함수: 텍스트 포매팅
//    private func formatText(_ content: String) -> Text {
//        let replacedContent = content.replacingOccurrences(of: "\\n", with: "\n")
//        let components = replacedContent.components(separatedBy: "**")
//
//        var formattedText = Text("")
//        var isHighlighted = false
//
//        for component in components {
//            if isHighlighted {
//                formattedText = formattedText + Text(component)
//                    .font(.title)
//                    .foregroundColor(.mainGreen)
//            } else {
//                formattedText = formattedText + Text(component)
//                    .font(.body)
//            }
//            isHighlighted.toggle()
//        }
//        return formattedText
//    }
//}


import SwiftUI

// UINavigationController 확장: 스와이프 제스처 활성화
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

struct DetailView: View {
    let post: Post
    @Environment(\.dismiss) var dismiss // 뒤로 가기 동작을 위한 dismiss 환경 변수

    var body: some View {
        ZStack {
            // 배경
            Color.mainBlack
                .ignoresSafeArea()

            // 컨텐츠
            VStack {
                formatText(post.content)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle("\(post.title)", displayMode: .inline)
        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
        
        //.toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss() // 뒤로 가기 동작
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                        //Text("Back") // 원하는 텍스트 추가
                        //    .font(.body)
                    }
                    .foregroundColor(.mainGreen) // 버튼 색상
                }
            }
        }
    }

    // Helper 함수: 텍스트 포매팅
    private func formatText(_ content: String) -> Text {
        let replacedContent = content.replacingOccurrences(of: "\\n", with: "\n")
        let components = replacedContent.components(separatedBy: "**")

        var formattedText = Text("")
        var isHighlighted = false

        for component in components {
            if isHighlighted {
                formattedText = formattedText + Text(component)
                    .font(.title)
                    .foregroundColor(.mainGreen)
            } else {
                formattedText = formattedText + Text(component)
                    .font(.body)
            }
            isHighlighted.toggle()
        }
        return formattedText
    }
}

