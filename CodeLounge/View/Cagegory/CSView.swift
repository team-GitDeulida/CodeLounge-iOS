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
        
        VStack {
            NavigationStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("CS")
                            .font(.system(size: 35, weight: .bold))
                            .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    .padding(.vertical, 10)
                    .background(Color.mainBlack)
                    
                    List {
                        if let posts = postViewModel.postsByCategory["OperatingSystems"], !posts.isEmpty {
                            Section(header: Text("운영체제")
                                .foregroundColor(Color.mainGreen)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, -10)
                            ) {
                                ForEach(postViewModel.postsByCategory["OperatingSystems"] ?? []) { post in
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
                        
                        if let posts = postViewModel.postsByCategory["Algorithms"], !posts.isEmpty {
                            Section(header: Text("알고리즘")
                                .foregroundColor(Color.mainGreen)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, -10)
                            ) {
                                ForEach(postViewModel.postsByCategory["Algorithms"] ?? []) { post in
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
                    }
                    .scrollContentBackground(.hidden) // 리스트 기본 배경 숨가
                    .background(Color.mainBlack)
                    
                    // 화면 전환
                    .navigationDestination(item: $selectedPost) { post in
                        DetailView(post: post)
                    }
                }
            }
            .tint(Color.mainWhite)
        }
        
        
        // 테스트용
        .onAppear {
            postViewModel.fetchAllPosts()
        }
    }
        
}

#Preview {
    CSView()
        .environmentObject(PostViewModel())
}




