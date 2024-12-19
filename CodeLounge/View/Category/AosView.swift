//
//  AosView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct AosView: View {
    @EnvironmentObject var postVM: PostViewModel
    @State private var selectedPost: Post? // 선택된 게시물을 저장
    
    var body: some View {
        NavigationStack {
            List {
                if !postVM.kotlinPosts.isEmpty {
                    Section(header: Text("Kotlin")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                        .textCase(nil)
                    ) {
                        ForEach(postVM.kotlinPosts) { post in
                            Button {
                                selectedPost = post // 게시물을 선택
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                        .font(.headline)
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
            .navigationTitle("aOS")
            .scrollContentBackground(.hidden) // 리스트 기본 배경 숨가
            .background(Color.mainBlack)

            // 화면 전환
            .navigationDestination(item: $selectedPost) { post in
                DetailView(post: post) // 선택된 게시물의 상세 뷰
            }
        }
    }
}

#Preview {
    AosView()
        .environmentObject(PostViewModel())
}


struct ListRowButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
        // to cover the whole length of the cell
            .frame(
                maxWidth: .greatestFiniteMagnitude,
                alignment: .leading)
        // to make all the cell tapable, not just the text
            .contentShape(.rect)
            .background {
                if configuration.isPressed {
                    Rectangle()
                        .fill(Color.mainGreen)
                    // Arbitrary negative padding, adjust accordingly
                        .padding(-20)
                }
            }
    }
}

extension ButtonStyle where Self == ListRowButton {
    static var listRow: Self {
        ListRowButton()
    }
}
