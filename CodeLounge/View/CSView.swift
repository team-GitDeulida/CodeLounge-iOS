//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct CSView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        NavigationStack {
            
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
            
            List {
                Section(header: Text("운영체제")) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(destination: DetailView(post: post)) {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
//                                Text(post.author)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section(header: Text("알고리즘")) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(destination: DetailView(post: post)) {
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
//                                Text(post.author)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("CS")
        }
        
    }
}

#Preview {
    CSView()
}
