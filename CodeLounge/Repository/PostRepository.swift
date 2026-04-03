//
//  PostRepository.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation
import Combine
import FirebaseDatabase

protocol PostRepositoryProtocol {
  func fetchAllPosts() -> AnyPublisher<[String: [PostDTO]], DBError>
}

final class PostRepository: PostRepositoryProtocol {
  private let db: DatabaseReference = Database.database().reference()
  
  func fetchAllPosts() -> AnyPublisher<[String : [PostDTO]], DBError> {
    Future<Any?, DBError> { [weak self] promise in
      self?.db
        .child("Posts")
        .getData { error, snapshot in
          if let error {
            promise(.failure(.loadUsersError(error)))
          } else {
            promise(.success(snapshot?.value))
          }
        }
    }.flatMap { value -> AnyPublisher<[String: [PostDTO]], DBError> in
      guard let dic = value as? [String: [String: Any]] else {
        return Just([:])
          .setFailureType(to: DBError.self)
          .eraseToAnyPublisher()
      }
      
      var result: [String: [PostDTO]] = [:]
      
      for (category, posts) in dic {
        var dtoArray: [PostDTO] = []
        
        for (postId, postData) in posts {
          guard let postDict = postData as? [String: Any],
                let title = postDict["title"] as? String,
                let content = postDict["content"] as? String,
                let authorID = postDict["author_id"] as? String,
                let createdAt = postDict["created_at"] as? String
          else { continue }
          
          dtoArray.append(
            PostDTO(
              id: postId,
              title: title,
              content: content,
              authorID: authorID,
              createdAt: createdAt
            )
          )
        }
        
        result[category] = dtoArray
      }
      
      return Just(result)
        .setFailureType(to: DBError.self)
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
    
    
  }
  
}
