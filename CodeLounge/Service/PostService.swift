//
//  PostService.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Combine

protocol PostServiceProtocol {
    func fetchAllPosts() -> AnyPublisher<[String: [Post]], ServiceError>
}

final class PostService: PostServiceProtocol {
    
    private let repository: PostRepositoryProtocol
    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchAllPosts() -> AnyPublisher<[String: [Post]], ServiceError> {
        repository.fetchAllPosts()
        
            // DTO → Domain 변환
            .map { dtoDict in
                dtoDict.mapValues { dtoArray in
                    dtoArray.map { $0.toDomain() }
                }
            }
            
            // 정렬
            .map { dict in
                dict.mapValues { posts in
                    posts.sorted {
                        if $0.createdAt != $1.createdAt {
                            return $0.createdAt < $1.createdAt
                        } else {
                            return $0.title < $1.title
                        }
                    }
                }
            }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}
