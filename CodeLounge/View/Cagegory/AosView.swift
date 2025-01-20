//
//  AosView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

struct AosView: View {
    @EnvironmentObject private var postViewModel: PostViewModel
    @State private var selectedPost: Post?
    private let categories: [String] = ["Kotlin", "Jetpack Compose UI"]
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("aOS")
                            .font(.system(size: 35, weight: .bold))
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        TextField("검색", text: $postViewModel.searchText)
                            .padding()
                            .frame(width: 200, height: 40)
                            .background(Color.subBlack)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .onChange(of: postViewModel.searchText) { _, _ in
                                postViewModel.filterPosts(for: categories)
                            }
                    }
                    .padding(.top, 30)
                    .padding(.vertical, 10)
                    .background(Color.mainBlack)
                    
                    List {
                        ForEach(categories, id: \.self) { category in
                            if let posts = postViewModel.filteredPostsByCategory[category], !posts.isEmpty {
                                Section(header: Text(postViewModel.categoryNames[category] ?? category.capitalizeFirstLetter())
                                    .foregroundColor(Color.mainGreen)
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.leading, -10)
                                    .textCase(nil) // 대문자 변환 비활성화
                                ) {
                                    ForEach(posts) { post in
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
                                        .listRowSeparatorTint(Color.gray.opacity(0.4), edges: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .background(Color.mainBlack)
                    .navigationDestination(item: $selectedPost) { post in
                        DetailView(post: post)
                    }
                }
            }
            .tint(Color.mainWhite)
        }
        .onAppear {
            postViewModel.searchText = "" // 검색어 초기화
            postViewModel.filterPosts(for: categories) // 현재 탭에 맞는 데이터 필터링
        
        }
    }
}

#Preview {
    AosView()
        .environmentObject(PostViewModel())
}
