//
//  User.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

struct User {
    var id: String
    var nickname: String
    var registerDate: Date?
    var birthdayDate: Date?
    var gender: Gender?
    var loginPlatform: LoginPlatform?
}

enum Gender: String {
    case male = "남자"
    case female = "여자"
    case other = "비공개"
}

enum LoginPlatform: String {
    case google = "Google"
    case apple = "Apple"
}

extension User {
    func toObject() -> UserObject {
        let formatter = ISO8601DateFormatter()                              // 날짜를 ISO8601 문자열로 변환
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")             // KST (UTC+9)
        
        return UserObject(
            id: id,
            nickname: nickname,
            registerDate: formatter.string(from: registerDate ?? Date()),
            birthdayDate: formatter.string(from: registerDate ?? Date()),//formatter.string(from: birthdayDate!),
            gender: (gender ?? .male).rawValue,
            loginPlatform: loginPlatform!.rawValue
        )
    }
}

extension User {
    static var stub1: User {
        .init(
            id: "12345",
              nickname: "인덱스",
              registerDate: Date(),
              birthdayDate: Calendar.current.date(byAdding: .year, value: -25, to: Date()),
              gender: .male,
              loginPlatform: .google
        )
    }
    
    static var stub2: User {
        .init(
            id: "67890",
            nickname: "관리자",
            registerDate: Date(),
            birthdayDate: Calendar.current.date(byAdding: .year, value: -20, to: Date()),
            gender: .female,
            loginPlatform: .apple
        )
    }
}





/*
 
 User(
 id: "12345",
 nickname: "인덱스",
 registerDate: Optional(2025-01-16 09:21:32 +0000),
 birthdayDate: Optional(2000-01-16 09:21:32 +0000),
 gender: Optional(CodeLounge.Gender.male),
 loginPlatform: Optional(CodeLounge.LoginPlatform.google)
 )
 
 UserObject(
 id: "12345",
 nickname: "인덱스",
 registerDate: "2025-01-16T18:21:32+09:00",
 birthdayDate: "2000-01-16T18:21:32+09:00",
 gender: "남자",
 loginPlatform: "Google"
 )
 */
