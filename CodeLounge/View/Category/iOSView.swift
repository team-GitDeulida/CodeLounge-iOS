//
//  iOSView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct iOSView: View {
    @EnvironmentObject var postVM: PostViewModel
    @State private var selectedPost: Post? // 선택된 게시물을 저장
    
    var body: some View {
        NavigationStack {
            List {
                if !postVM.swiftPosts.isEmpty {
                    Section(header: Text("Swift")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                        .textCase(nil)
                    ) {
                        ForEach(postVM.swiftPosts) { post in
                            Button {
                                selectedPost = post // 게시물을 선택
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(post.title)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(ListRowButton()) // 커스텀 버튼 스타일 적용
                            .listRowBackground(Color.subBlack)
                        }
                    }
                }
                
                if !postVM.uiKitPosts.isEmpty {
                    Section(header: Text("Uikit")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                        .textCase(nil)
                    ) {
                        ForEach(postVM.uiKitPosts) { post in
                            Button {
                                selectedPost = post // 게시물을 선택
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(post.title)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(ListRowButton()) // 커스텀 버튼 스타일 적용
                            .listRowBackground(Color.subBlack)
                        }
                    }
                }
                
                if !postVM.swiftUIPosts.isEmpty {
                    Section(header: Text("SwiftUi")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                        .textCase(nil)
                    ) {
                        ForEach(postVM.swiftUIPosts) { post in
                            Button {
                                selectedPost = post // 게시물을 선택
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(post.title)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(ListRowButton()) // 커스텀 버튼 스타일 적용
                            .listRowBackground(Color.subBlack)
                        }
                    }
                }
            }
            .refreshable {
                // 새로고침 시 진행할 작업
                postVM.fetchAllSections()
            }
            .navigationTitle("iOS")
            .scrollContentBackground(.hidden) // 기본 배경색 숨기기
            .background(Color.mainBlack) // 전체 배경색 설정
      
            // 화면 전환
            .navigationDestination(item: $selectedPost) { post in
                DetailView(post: post) // 선택된 게시물의 상세 뷰
            }
        }
        .tint(Color.mainWhite)
    }
}

#Preview {
    iOSView()
}

