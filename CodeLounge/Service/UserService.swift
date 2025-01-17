//
//  UserService.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation
import Combine

protocol UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func checkNicknameDuplicate(_ nickname: String) -> AnyPublisher<Bool, ServiceError>
    func updateUserInfo(userId: String, nickname: String, birthday: String, gender: String) -> AnyPublisher<Void, ServiceError>
}

final class UserService: UserServiceType {
    
    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        dbRepository.addUser(user.toObject())
            .map { user }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func checkNicknameDuplicate(_ nickname: String) -> AnyPublisher<Bool, ServiceError> {
        dbRepository.loadUsers()
            .map { users in
                users.contains { $0.nickname == nickname }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateUserInfo(userId: String, nickname: String, birthday: String, gender: String) -> AnyPublisher<Void, ServiceError> {
        dbRepository.getUser(userId: userId)
            .mapError { ServiceError.error($0) }
            .flatMap { userObject -> AnyPublisher<Void, ServiceError> in
                var updatedUserObject = userObject
                updatedUserObject.nickname = nickname  // 닉네임 업데이트
                updatedUserObject.birthdayDate = birthday // 생일 업데이트
                updatedUserObject.gender = gender      // 성별 업데이트
                
                // 업데이트
                return self.dbRepository.updateUser(updatedUserObject)
                    .mapError { ServiceError.error($0) } // 반환된 AnyPublisher의 에러도 변환
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

final class StubUserService: UserServiceType {
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func checkNicknameDuplicate(_ nickname: String) -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func updateUserInfo(userId: String, nickname: String, birthday: String, gender: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
