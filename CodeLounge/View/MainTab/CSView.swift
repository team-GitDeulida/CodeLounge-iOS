//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

// MARK: - Main View
struct CSView: View {
    let navigator: Navigator<AppDependencies, MainRoute>
    
    @State private var selectedPost: Post?
    @EnvironmentObject private var postViewModel: PostViewModel
    
    private let categories: [String] = ["OperatingSystems", "Algorithms"]
    
    var body: some View {
        ZStack {
          Color.mainBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: - Header
                CSHeaderView(
                    searchText: $postViewModel.searchText
                ) {
                    postViewModel.filterPosts(for: categories)
                }
                
                // MARK: - List
                PostListView(
                    categories: categories,
                    postsByCategory: postViewModel.filteredPostsByCategory,
                    categoryNames: postViewModel.categoryNames
                ) { post in
                  navigator.push(.postDetail(post))
                }

                .simultaneousGesture(
                    TapGesture().onEnded {
                        CustomTextField.hideKeyboard()
                    }
                )
            }
        }
        .tint(Color.mainWhite)
        .onAppear {
            postViewModel.searchText = ""
            postViewModel.filterPosts(for: categories)
        }
        .refreshable {
            postViewModel.fetchAllPosts()
            postViewModel.searchText = ""
            postViewModel.filterPosts(for: categories)
        }
    }
}

// MARK: - Header
struct CSHeaderView: View {
    @Binding var searchText: String
    let onSearchChanged: () -> Void
    
    var body: some View {
        HStack {
            Text("CS")
                .font(.system(size: 35, weight: .bold))
                .padding(.leading, 20)
            
            Spacer()
            
            CustomTextField(text: $searchText, placeholder: "검색")
                .frame(width: 200, height: 40)
                .padding(.horizontal)
                .onChange(of: searchText) { _, _ in
                    onSearchChanged()
                }
        }
        .padding(.top, 30)
        .padding(.vertical, 10)
        .background(Color.mainBlack)
    }
}

// MARK: - List
struct PostListView: View {
    let categories: [String]
    let postsByCategory: [String: [Post]]
    let categoryNames: [String: String]
    let onSelect: (Post) -> Void
    
    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                if let posts = postsByCategory[category], !posts.isEmpty {
                    
                    PostSectionView(
                        posts: posts,
                        categoryName: categoryNames[category] ?? category
                    ) { post in
                        onSelect(post)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .scrollIndicators(.hidden)
    }
}

// MARK: - Section
struct PostSectionView: View {
    let posts: [Post]
    let categoryName: String
    let onSelect: (Post) -> Void
    
    var body: some View {
        Section(
            header: Text(categoryName)
                .foregroundColor(Color.mainGreen)
                .font(.system(size: 17, weight: .bold))
                .padding(.leading, -10)
                .textCase(.none)
        ) {
            ForEach(posts) { post in
                PostRowView(post: post) {
                    onSelect(post)
                }
            }
        }
    }
}

// MARK: - Row
struct PostRowView: View {
    let post: Post
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
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

#Preview {
    CSView(navigator: .preview)
}

// MARK: - 리스트 커스텀 버튼
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
