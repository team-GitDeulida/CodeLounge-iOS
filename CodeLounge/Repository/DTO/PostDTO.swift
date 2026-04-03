//
//  PostDTO.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation

struct PostDTO {
    let id: String
    let title: String
    let content: String
    let authorID: String
    let createdAt: String
}

extension PostDTO {
    func toDomain() -> Post {
        return Post(
            id: id,
            title: title,
            content: content,
            authorID: authorID,
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date()
        )
    }
}
