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

import SwiftUI

struct DetailView: View {
    let post: Post

    var body: some View {
        ZStack {
            Color.mainBlack // 원하는 배경색
                .ignoresSafeArea() // 안전 영역까지 배경 적용
            VStack {
                formatText(post.content)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
            .navigationTitle("\(post.title)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Helper 함수: 텍스트 포매팅
    private func formatText(_ content: String) -> Text {
        let replacedContent = content.replacingOccurrences(of: "\\n", with: "\n")
        let components = replacedContent.components(separatedBy: "**") // '**' 기준으로 나눔

        var formattedText = Text("")
        var isHighlighted = false

        for component in components {
            if isHighlighted {
                formattedText = formattedText + Text(component)
                    .font(.title) // 강조된 텍스트를 title 크기로 설정
                    .foregroundColor(.mainGreen) // 강조된 텍스트 색상
            } else {
                formattedText = formattedText + Text(component)
                    .font(.body) // 일반 텍스트를 body 크기로 설정
            }
            isHighlighted.toggle() // 다음 텍스트는 반대 상태로 처리
        }
        
        return formattedText
    }
}
