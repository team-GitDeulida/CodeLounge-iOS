//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct CSView: View {
    @EnvironmentObject var postVM: PostViewModel
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("운영체제")
                    .foregroundColor(Color.mainGreen)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.leading, -10)
                
                ) {
                    ForEach(postVM.posts) { post in
                        NavigationLink(destination: DetailView(post: post)) {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
                            }
                        }
                        .listRowBackground(Color.subBlack) // 행 배경색
                    }
                }
                
                Section(header: Text("알고리즘")
                    .foregroundColor(Color.mainGreen)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.leading, -10)
                ) {
                    ForEach(postVM.posts) { post in
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
            .navigationTitle("CS")
            .scrollContentBackground(.hidden) // 기본 배경색 숨기기
            .background(Color.mainBlack) // 전체 배경색 설정
      
            
        }
    }
}

#Preview {
    CSView()
}



/*
List(viewModel.posts) { post in
    NavigationLink(destination: DetailView(post: post)) {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
        }
    }
    .navigationTitle("\("CS")")
}
 */
