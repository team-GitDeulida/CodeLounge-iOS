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
        NavigationStack {
            ZStack {
                Color.mainBlack
                    .ignoresSafeArea() // ✅ 배경이 네비게이션 바까지 덮이도록
                
                VStack(spacing: 0) {
                    
                    // MARK: - 타이틀뷰 & 검색바
                    HStack {
                        
                        Text("AOS")
                            .font(.system(size: 35, weight: .bold))
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        // ✅ UIKit 기반 입력 필드로 변경
                        CustomTextField(text: $postViewModel.searchText, placeholder: "검색")
                            .frame(width: 200, height: 40)
                            .padding(.horizontal)
                            .onChange(of: postViewModel.searchText) { _, _ in
                                postViewModel.filterPosts(for: categories)
                            }
                    }
                    .padding(.top, 30)
                    .padding(.vertical, 10)
                    .background(Color.mainBlack)
                    
                    // MARK: - 리스트
                    List {
                        ForEach(categories, id: \.self) { category in
                            if let posts = postViewModel.filteredPostsByCategory[category], !posts.isEmpty {
                                Section(header: Text(postViewModel.categoryNames[category] ?? category.capitalizeFirstLetter())
                                    .foregroundColor(Color.mainGreen)
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.leading, -10)
                                    .textCase(.none) // ✅ 대소문자 자동 변환 방지
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
                    .padding(.bottom, 70) // ✅ 하단 패딩 추가
                    .scrollContentBackground(.hidden) // ✅ 리스트 배경 제거
                    .background(Color.clear) // ✅ 리스트 배경을 완전히 투명하게 설정
                    .scrollIndicators(.hidden) // ✅ 스크롤 인디케이터 숨기기
                    .navigationDestination(item: $selectedPost) { post in
                        DetailView(post: post)
                    }
                }
                .onTapGesture {
                    CustomTextField.hideKeyboard() // ✅ 외부 터치 시 키보드 닫기
                }
            }
            .tint(Color.mainWhite)
        }
        .onAppear {
            postViewModel.searchText = "" // 검색어 초기화
            postViewModel.filterPosts(for: categories) // 현재 탭에 맞는 데이터 필터링
        }
        .refreshable {
            postViewModel.fetchAllPosts()
            postViewModel.searchText = "" // 검색어 초기화
            postViewModel.filterPosts(for: categories) // 현재 탭에 맞는 데이터 필터링
        }
    }
}

#Preview {
    AosView()
        .environmentObject(PostViewModel())
}
