//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

struct CSView: View {
    @EnvironmentObject private var postViewModel: PostViewModel
    @State private var selectedPost: Post?
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("운영체제")
                    .foregroundColor(Color.mainGreen)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.leading, -10)
                ) {
                    ForEach(postViewModel.stubPosts) { post in
                        Button {
                            selectedPost = post
                        } label: {
                            HStack {
                                Text(post.title)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        .buttonStyle(ListRowButton())
                        .listRowBackground(Color.subBlack)
                        .listRowSeparatorTint(Color.gray.opacity(0.4), edges: .bottom) // 구분선 색상 설정
                    }
                }
            }
            .navigationTitle("CS")
            .scrollContentBackground(.hidden) // 리스트 기본 배경 숨가
            .background(Color.mainBlack)
            
            // 화면 전환
            .navigationDestination(item: $selectedPost) { post in
                DetailView(post: post)
            }
        }
        .tint(Color.mainWhite)
    }
}

#Preview {
    CSView()
        .environmentObject(PostViewModel())
}




