//
//  PostViewModel.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import Foundation

final class PostViewModel: ObservableObject {
    // MARK: - Stub Data
    @Published var stubPosts: [Post] = [
        .init(id: "1", title: "제목1", content: "내용1", authorID: "인덱스", createdAt: .now),
        .init(id: "2", title: "제목2", content: "내용2", authorID: "인덱스", createdAt: .now),
        .init(id: "3", title: "제목3", content: "내용3", authorID: "인덱스", createdAt: .now)
    ]
}
