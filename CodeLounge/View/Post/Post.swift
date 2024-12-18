//
//  ContentView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/10/24.
//

import SwiftUI
import FirebaseDatabase
import Combine

/*
 Identifiable
 - 각 데이터를 고유하게 식별할 수 있는 ID를 제공하는 프로토콜
 - Identifiable을 채택하면 반드시 id라는 속성을 제공해야 합니다.
 - SwiftUI의 List나 ForEach에서 데이터 요소를 구분할 때 사용합니다.
 
 Codable
 - Encodable**과 **Decodable**을 결합한 프로토콜입니다.
 - JSON 데이터를 Swift 객체로 변환하거나, Swift 객체를 JSON으로 변환할 때 사용됩니다.
 - 데이터를 인코딩 (Swift → JSON)하거나, 디코딩 (JSON → Swift)할 수 있습니다.
 
 CodingKey
 - CodingKey는 Codable을 사용할 때 JSON 키와 Swift의 변수 이름이 다를 경우 매핑할 수 있도록 돕는 프로토콜입니다.
 
 String
 - String은 CodingKeys 열거형에서 각 case를 JSON 키에 자동으로 매핑하거나 명시적으로 매핑할 때 사용됩니다.
 - case authorID = "author_id" // JSON 키 "author_id" → Swift 변수 authorID
 */

// MARK: - Model
struct Post: Identifiable, Hashable {
    var id: String // 고유 ID는 Firebase의 key를 그대로 사용
    var title: String // Firebase의 "title"과 매핑
    var content: String // Firebase의 "content"와 매핑
    var authorID: String // Firebase의 "author_id"와 매핑
    var createdAt: Date // Firebase의 "created_at"과 매핑
    
    // 편리하게 사용할 수 있는 날짜 포맷터
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    /*
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case authorID = "author_id"
        case createdAt = "created_at"
    }
     */
}

final class PostViewModel: ObservableObject {
    @Published var osPosts: [Post] = []
    @Published var algoPosts: [Post] = []
    @Published var swiftUIPosts: [Post] = []
    @Published var uiKitPosts: [Post] = []
    @Published var kotlinPosts: [Post] = []

    private var ref: DatabaseReference!

    init() {
        ref = Database.database().reference()
        fetchAllSections()
    }

    func fetchAllSections_() {
        ref.observeSingleEvent(of: .value) { snapshot in
            var osPosts: [Post] = []
            var algoPosts: [Post] = []
            var swiftUIPosts: [Post] = []
            var uiKitPosts: [Post] = []
            var kotlinPosts: [Post] = []
            
            if let rootDict = snapshot.value as? [String: Any] {
                for (sectionName, sectionData) in rootDict {
                    if let postsDict = sectionData as? [String: Any] {
                        let posts = postsDict.compactMap { (key, value) -> Post? in
                            guard let dict = value as? [String: Any],
                                  let title = dict["title"] as? String,
                                  let content = dict["content"] as? String,
                                  let authorID = dict["author_id"] as? String,
                                  let createdAtString = dict["created_at"] as? String else { return nil }

                            let formatter = ISO8601DateFormatter()
                            let createdAt = formatter.date(from: createdAtString) ?? Date()

                            return Post(id: key, title: title, content: content, authorID: authorID, createdAt: createdAt)
                        }
                        switch sectionName {
                        case "OperatingSystems": osPosts = posts
                        case "Algorithms": algoPosts = posts
                        case "SwiftUI": swiftUIPosts = posts
                        case "UIKit": uiKitPosts = posts
                        case "Kotlin": kotlinPosts = posts
                        default: break
                        }
                    }
                }
            }
            
            // 메인 스레드에서 업데이트
            DispatchQueue.main.async {
                self.osPosts = osPosts
                self.algoPosts = algoPosts
                self.swiftUIPosts = swiftUIPosts
                self.uiKitPosts = uiKitPosts
                self.kotlinPosts = kotlinPosts
            }
        }
    }

    
    // 섹션별 데이터를 가져오는 함수
    func fetchAllSections() {
        fetchSection("OperatingSystems") { posts in
            DispatchQueue.main.async {
                self.osPosts = posts
            }
        }
        fetchSection("Algorithms") { posts in
            DispatchQueue.main.async {
                self.algoPosts = posts
            }
        }
        fetchSection("SwiftUI") { posts in
            DispatchQueue.main.async {
                self.swiftUIPosts = posts
            }
        }
        fetchSection("UIKit") { posts in
            DispatchQueue.main.async {
                self.uiKitPosts = posts
            }
        }
        fetchSection("Kotlin") { posts in
            DispatchQueue.main.async {
                self.kotlinPosts = posts
            }
        }
    }

    // 특정 섹션 데이터를 가져오는 함수
    private func fetchSection(_ sectionName: String, completion: @escaping ([Post]) -> Void) {
        ref.child(sectionName).observeSingleEvent(of: .value) { snapshot in
            var tempPosts: [Post] = []

            for child in snapshot.children {
                // 각 항목을 DataSnapshot으로 변환
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let title = dict["title"] as? String,
                   let content = dict["content"] as? String,
                   let authorID = dict["author_id"] as? String,
                   let createdAtString = dict["created_at"] as? String {
                    
                    // 날짜 변환
                    let formatter = ISO8601DateFormatter()
                    let createdAt = formatter.date(from: createdAtString) ?? Date()
                    
                    // Post 모델 생성
                    let post = Post(
                        id: childSnapshot.key,
                        title: title,
                        content: content,
                        authorID: authorID,
                        createdAt: createdAt
                    )
                    tempPosts.append(post)
                }
            }
            completion(tempPosts)
        }
    }
}











// MARK: - ViewModel
/*
final class PostViewModel: ObservableObject {
    @Published var posts: [Post]
    
    init() {
        posts = [
            //Post(title: "지원동기", content: "iOS개발자 지원동기", author: "김동현"),
            Post(
                title: "타겟과 모듈",
                content: """
                **타겟**
                - xcode에서 앱 빌드를 위해 정의된 설정의 집합입니다
                 
                **모듈**
                - 코드의 재사용성을 높이기 위한 코드묶음입니다
                
                - 앱과 라이브러리는 각각 하나의 모듈로 간주되고
                  import 키워들를 사용해 다른 모듈을 가져옵니다
                
                - 모듈은 컴파일 속도를 높이고 코드의 의존성을 분리하는 데 유용합니다
                
                """,
                authorID: "김동현", createdAt: Date()),
            
            
            Post(title: "SwiftUI의 강점", content: "SwiftUI는 선언적 방식으로 UI를 작성할 수 있는 프레임워크입니다.", authorID: "김동현", createdAt: Date()),
            Post(title: "코드 라운지 시작", content: "코드를 공유하고 협업할 수 있는 플랫폼입니다.", authorID: "이철수", createdAt: Date()),
            Post(title: "Swift의 미래", content: "Swift는 계속 발전 중이며, 많은 가능성을 제공합니다.", authorID: "박영희", createdAt: Date())
        ]
    }
}
*/
