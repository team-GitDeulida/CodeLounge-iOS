//
//  PostViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import Foundation
import FirebaseDatabase

final class PostViewModel: ObservableObject {
    @Published var postsByCategory: [String: [Post]] = [:] // 전체 카테고리별 posts 저장
    @Published var filteredPostsByCategory: [String: [Post]] = [:] // 검색 결과
    @Published var searchText: String = "" // 검색어
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    // 카테고리 키와 한글 이름 매핑
    let categoryNames: [String: String] = [
        "OperatingSystems": "운영체제",
        "Algorithms": "알고리즘",
//        "Swift": "Swift",
//        "SwiftUI": "SwiftUI"
    ]

    // MARK: - 전체 Posts 가져오기
    func fetchAllPosts() {
        databaseRef.child("Posts").observeSingleEvent(of: .value) { snapshot in
            var categoryPosts: [String: [Post]] = [:]
            
            guard let value = snapshot.value as? [String: [String: Any]] else {
                print("Posts 데이터를 읽는 데 실패했습니다.")
                return
            }
            
            for (category, posts) in value {
                var postsArray: [Post] = []
                
                for (postId, postData) in posts {
                    if let postDict = postData as? [String: Any],
                       let title = postDict["title"] as? String,
                       let content = postDict["content"] as? String,
                       let authorID = postDict["author_id"] as? String,
                       let createdAtString = postDict["created_at"] as? String,
                       let createdAt = ISO8601DateFormatter().date(from: createdAtString) {
                        
                        let post = Post(
                            id: postId,
                            title: title,
                            content: content,
                            authorID: authorID,
                            createdAt: createdAt
                        )
                        postsArray.append(post)
                    }
                }
                
                postsArray.sort {
                    if $0.createdAt != $1.createdAt {
                        return $0.createdAt < $1.createdAt
                    } else {
                        return $0.title < $1.title
                    }
                }
                categoryPosts[category] = postsArray
            }
            
            DispatchQueue.main.async {
                self.postsByCategory = categoryPosts
                self.filteredPostsByCategory = categoryPosts // 초기화
            }
        } withCancel: { error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    }

    // MARK: - 특정 카테고리와 검색어를 기준으로 필터링
    func filterPosts(for categories: [String]) {
        let lowercasedSearchText = searchText.lowercased() // 검색어를 소문자로 변환
        
        if searchText.isEmpty {
            filteredPostsByCategory = postsByCategory.filter { categories.contains($0.key) }
        } else {
            filteredPostsByCategory = postsByCategory.filter { categories.contains($0.key) }
                .mapValues { posts in
                    posts.filter {
                        $0.title.lowercased().contains(lowercasedSearchText) || // 제목에서 검색
                        $0.content.lowercased().contains(lowercasedSearchText) // 내용에서 검색
                    }
                }
                .filter { !$0.value.isEmpty }
        }
    }
}

