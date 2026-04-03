//
//  UserService.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation
import Combine

protocol UserServiceProtocol {
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
  func updateUserInfo(
    userId: String,
    nickname: String,
    birthday: String,
    gender: String
  ) -> AnyPublisher<User, ServiceError>
  func deleteUser(userId: String) -> AnyPublisher<Void, ServiceError>
  func getUser(userId: String) -> AnyPublisher<User, ServiceError>
  func checkNicknameDuplicate(_ nickname: String) -> AnyPublisher<Bool, ServiceError>
}

final class UserService: UserServiceProtocol {
  private var dbRepository: UserDBRepositoryProtocol
  
  init(dbRepository: UserDBRepositoryProtocol) {
    self.dbRepository = dbRepository
  }
  
  func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
    dbRepository.addUser(user.toDTO())
      .map { user }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  func updateUserInfo(
    userId: String,
    nickname: String,
    birthday: String,
    gender: String
  ) -> AnyPublisher<User, ServiceError> {
    dbRepository.getUser(userId: userId)
      .mapError { ServiceError.error($0) } // Map DBError to ServiceError
      .flatMap { userObject -> AnyPublisher<User, ServiceError> in
        var updatedUserObject = userObject
        updatedUserObject.nickname = nickname
        updatedUserObject.birthdayDate = birthday
        updatedUserObject.gender = gender
        
        // Update the user and fetch the updated user object
        return self.dbRepository.updateUser(updatedUserObject)
          .mapError { ServiceError.error($0) } // Map DBError to ServiceError
          .flatMap { _ in
            self.dbRepository.getUser(userId: userId)
              .map { $0.toModel() }
              .mapError { ServiceError.error($0) }
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  func deleteUser(userId: String) -> AnyPublisher<Void, ServiceError> {
    dbRepository.deleteUser(userId: userId)
      .mapError { ServiceError.error($0) } // DBError를 ServiceError로 매핑
      .eraseToAnyPublisher()
  }
  
  func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
    dbRepository.getUser(userId: userId)
      .map { $0.toModel() }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
  
  
  /// 닉네임 유무
  /// - Parameter nickname: 닉네임
  /// - Returns: 닉네임이 이미 존재하면 true, 없어서 사용 가능하면 false
  func checkNicknameDuplicate(_ nickname: String) -> AnyPublisher<Bool, ServiceError> {
    dbRepository.loadUsers()
      .map { users in
        users.contains { $0.nickname == nickname }
      }
      .mapError { .error($0) }
      .eraseToAnyPublisher()
  }
}
