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
    func updateUserInfo(userId: String, nickname: String, birthday: String, gender: String) -> AnyPublisher<User, ServiceError>
    func deleteUser(userId: String) -> AnyPublisher<Void, ServiceError>
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
    
    func updateUserInfo(userId: String, nickname: String, birthday: String, gender: String) -> AnyPublisher<User, ServiceError> {
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
    
    func updateUserInfo(userId: String, nickname: String, birthday: String, gender: String) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func deleteUser(userId: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
