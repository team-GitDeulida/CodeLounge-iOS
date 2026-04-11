//
//  User.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
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
  func toDTO() -> UserDTO {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

    return UserDTO(
      id: id,
      nickname: nickname,
      registerDate: formatter.string(from: registerDate ?? Date()),
      birthdayDate: formatter.string(from: birthdayDate ?? Date()),
      gender: (gender ?? .male).rawValue,
      loginPlatform: (loginPlatform ?? .google).rawValue
    )
  }
}
