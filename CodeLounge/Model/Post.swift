//
//  Post.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import Foundation

struct Post: Identifiable, Hashable {
    var id: String // 고유 ID는 Firebase의 key를 그대로 사용
    var title: String // Firebase의 "title"과 매핑
    var content: String // Firebase의 "content"와 매핑
    var authorID: String // Firebase의 "author_id"와 매핑
    var createdAt: Date // Firebase의 "created_at"과 매핑
}
