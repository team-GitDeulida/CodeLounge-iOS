//
//  iOSView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct iOSView: View {
    @EnvironmentObject var postVM: PostViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if !postVM.uiKitPosts.isEmpty {
                    Section(header: Text("Uikit")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                        .textCase(nil) // 대문자 변환 비활성화
                    ) {
                        ForEach(postVM.uiKitPosts) { post in
                            NavigationLink(destination: DetailView(post: post)) {
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                        .font(.headline)
                                }
                            }
                            .listRowBackground(Color.subBlack) // 행 배경색
                        }
                    }
                }
                
                if !postVM.swiftUIPosts.isEmpty {
                    Section(header: Text("SwiftUi")
                        .foregroundColor(Color.mainGreen)
                        .font(.system(size: 17, weight: .bold))
                        .padding(.leading, -10)
                        .textCase(nil) // 대문자 변환 비활성화
                    ) {
                        ForEach(postVM.swiftUIPosts) { post in
                            NavigationLink(destination: DetailView(post: post)) {
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                        .font(.headline)
                                }
                            }
                        }
                        .listRowBackground(Color.subBlack) // 행 배경색
                    }
                }
            }
            .navigationTitle("iOS")
            .scrollContentBackground(.hidden) // 기본 배경색 숨기기
            .background(Color.mainBlack) // 전체 배경색 설정
      
            
        }
        .tint(Color.mainWhite)
    }
}

#Preview {
    iOSView()
}

