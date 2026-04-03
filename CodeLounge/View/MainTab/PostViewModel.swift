//
//  PostViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Combine
import Foundation
import FirebaseDatabase

final class PostViewModel: ObservableObject {
  @Published var postsByCategory: [String: [Post]] = [:] /// 전체 카테고리별 posts 저장
  @Published var filteredPostsByCategory: [String: [Post]] = [:] /// 검색 결과
  @Published var searchText: String = "" /// 검색어
  
  @Dependency private var postService: PostServiceProtocol
  private var cancellables = Set<AnyCancellable>()
  
  let categoryNames: [String: String] = [
      "OperatingSystems": "운영체제",
      "Algorithms": "알고리즘"
  ]
  
  // MARK: - 전체 Posts 가져오기
  func fetchAllPosts() {
    postService.fetchAllPosts()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          print("Error: \(error)")
        }
      } receiveValue: { [weak self] posts in
        self?.postsByCategory = posts
        self?.filteredPostsByCategory = posts
        print("결과: \(self?.postsByCategory ?? [:])")
      }.store(in: &cancellables)
  }
  
  // MARK: - 특정 카테고리와 검색어를 기준으로 필터링
  func filterPosts(for categories: [String]) {
    let lowercasedSearchText = searchText.lowercased()
    
    if searchText.isEmpty {
      filteredPostsByCategory = postsByCategory.filter { categories.contains($0.key) }
    } else {
      filteredPostsByCategory = postsByCategory.filter { categories.contains($0.key) }
        .mapValues { posts in
          posts.filter {
            $0.title.lowercased().contains(lowercasedSearchText) ||
            $0.content.lowercased().contains(lowercasedSearchText)
          }
        }
        .filter { !$0.value.isEmpty }
    }
  }
}
