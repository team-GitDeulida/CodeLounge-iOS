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
    ZStack {
      Color.mainBlack.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 16) {
        Text(post.title)
          .font(.system(size: 28, weight: .bold))
          .foregroundStyle(Color.mainWhite)
        
        Text(post.content)
          .font(.system(size: 16))
          .foregroundStyle(Color.mainWhite)
        
        Spacer()
      }
      .padding(24)
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  PostDetailView(
    navigator: .preview,
    post: Post(
      id: "preview",
      title: "샘플 게시글",
      content: "상세 화면 미리보기입니다.",
      authorID: "author",
      createdAt: Date()
    )
  )
}
