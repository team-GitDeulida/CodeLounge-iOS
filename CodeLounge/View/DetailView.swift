//
//  DetailView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/13/24.
//

import SwiftUI

struct DetailView: View {
    let post: Post

    var body: some View {
        ZStack {
            Color.mainBlack // 원하는 배경색
                            .ignoresSafeArea() // 안전 영역까지 배경 적용
            VStack {
                Text("\(post.content)")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .navigationTitle("\(post.title)")
            .navigationBarTitleDisplayMode(.inline)
            //.background(Color.mainBlack)
        }
    }
}

//#Preview {
//    DetailView()
//}
