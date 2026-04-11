//
//  BoardView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/4/26.
//

import SwiftUI
import TurboNavigator

struct BoardView: View {
  let title: String
  let categories: [String]
  let navigator: Navigator<AppDependencies, MainRoute>

  @EnvironmentObject private var postViewModel: PostViewModel
  
  private var filteredPostsByCategory: [String: [Post]] {
    postViewModel.filteredPosts(for: categories)
  }

  var body: some View {
    ZStack {
      Color.mainBlack.ignoresSafeArea()

      VStack(spacing: 0) {
        BoardHeaderView(title: title, searchText: $postViewModel.searchText)

        BoardPostListView(
          categories: categories,
          postsByCategory: filteredPostsByCategory,
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
    }
    .refreshable {
      postViewModel.fetchAllPosts()
      postViewModel.searchText = ""
    }
  }
}

struct BoardHeaderView: View {
  let title: String
  @Binding var searchText: String

  var body: some View {
    HStack {
      Text(title)
        .font(.system(size: 35, weight: .bold))
        .padding(.leading, 20)

      Spacer()

      CustomTextField(text: $searchText, placeholder: "검색")
        .frame(width: 200, height: 40)
        .padding(.horizontal)
    }
    .padding(.top, 30)
    .padding(.vertical, 10)
    .background(Color.mainBlack)
  }
}

struct BoardPostListView: View {
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
            categoryName: categoryNames[category] ?? category,
            onSelect: onSelect
          )
        }
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.clear)
    .scrollIndicators(.hidden)
  }
}

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

struct ListRowButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
      .contentShape(.rect)
      .background {
        if configuration.isPressed {
          Rectangle()
            .fill(Color.mainGreen)
            .padding(-20)
        }
      }
  }
}
