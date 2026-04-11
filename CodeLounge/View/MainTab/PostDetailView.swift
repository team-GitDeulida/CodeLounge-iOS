//
//  PostDetailView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/4/26.
//

import SwiftUI
import TurboNavigator

struct PostDetailView: View {
  let navigator: Navigator<AppDependencies, MainRoute>
  let post: Post
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          MarkdownView(markdown: post.content)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(24)
      }

      BannerAdView(adUnitID: AdUnitID.postDetailBanner)
    }
    .background(Color.mainBlack.ignoresSafeArea())
    .navigationBarTitleDisplayMode(.inline)
    // .navigationTitle(post.title)
    .tint(Color.mainWhite)
  }
}

#Preview {
  PostDetailView(
    navigator: .preview,
    post: Post(
      id: "preview",
      title: "샘플 게시글",
      content: """
      ## Q. Swift의 struct와 class의 주요 차이점은 무엇인가요?

      **1. 값 타입 vs 참조 타입**
      struct는 값을 복사하지만, class는 참조를 전달합니다.

      - **상속**
      class는 상속이 가능하지만, struct는 불가능합니다.

      ```swift
      struct Person {
        var name: String
      }
      ```
      """,
      authorID: "author",
      createdAt: Date()
    )
  )
}
