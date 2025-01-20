//
//  PostViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import Foundation
import FirebaseDatabase

final class PostViewModel: ObservableObject {
    // MARK: - Stub Data
    @Published var stubPosts: [Post] = [
        .init(id: "1", title: "제목1", content: "내용1", authorID: "인덱스", createdAt: .now),
        .init(id: "2", title: "제목2", content: "내용2", authorID: "인덱스", createdAt: .now),
        .init(id: "3", title: "제목3", content: "내용3", authorID: "인덱스", createdAt: .now)
    ]
    
    @Published var postsByCategory: [String: [Post]] = [:] // 카테고리별 posts 저장
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    // MARK: - Posts 데이터 가져오기
    func fetchAllPosts() {
        databaseRef.child("Posts").observeSingleEvent(of: .value) { snapshot in
            var categoryPosts: [String: [Post]] = [:]
            
            guard let value = snapshot.value as? [String: [String: Any]] else {
                print("Posts 데이터를 읽는 데 실패했습니다.")
                return
            }
            
            for (category, posts) in value { // 카테고리별 데이터 순회
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
                categoryPosts[category] = postsArray // 카테고리별로 배열 저장
            }
            
            DispatchQueue.main.async {
                self.postsByCategory = categoryPosts
            }
        } withCancel: { error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}





/*
func fetchPosts() {
    databaseRef.child("Posts").observeSingleEvent(of: .value) { [weak self] snapshot in
        guard let self = self else { return }
        
        guard let value = snapshot.value as? [String: Any] else {
            print("posts 데이터를 가져올 수 없습니다.")
            return
        }
        
        
        
//            // Posts 데이터를 Post 모델 배열로 변환
//            self.posts = value.compactMap { (key, data) -> Post? in
//                guard let postDict = data as? [String: Any],
//                      let title = postDict["title"] as? String,
//                      let content = postDict["content"] as? String,
//                      let authorID = postDict["authorID"] as? String,
//                      let timestamp = postDict["createdAt"] as? Double else {
//                    return nil
//                }
//                return Post(
//                    id: key,
//                    title: title,
//                    content: content,
//                    authorID: authorID,
//                    createdAt: Date(timeIntervalSince1970: timestamp))
//            }
        
        print(self.posts)
    }
}
 */
