//
//  UserDTO.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation

struct UserDTO: Codable {
  var id: String
  var nickname: String
  var registerDate: String
  var birthdayDate: String
  var gender: String
  var loginPlatform: String
}

extension UserDTO {
    func toModel() -> User {
        let formatter = ISO8601DateFormatter()                              // 날짜를 ISO8601 문자열로 변환
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")             // KST (UTC+9)
        
        return User(
            id: id,
            nickname: nickname,
            registerDate: formatter.date(from: registerDate) ?? Date(),
            birthdayDate: formatter.date(from: birthdayDate) ?? Date(),
            gender: Gender(rawValue: gender),
            loginPlatform: LoginPlatform(rawValue: loginPlatform)
        )
    }
}
