//
//  UserDBRepository.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryProtocol {
  func addUser(_ dto: UserDTO)    -> AnyPublisher<Void, DBError>
  func updateUser(_ dto: UserDTO) -> AnyPublisher<Void, DBError>
  func deleteUser(userId: String) -> AnyPublisher<Void, DBError>
  func getUser(userId: String)    -> AnyPublisher<UserDTO, DBError>
  
  func loadUsers() -> AnyPublisher<[UserDTO], DBError>
}

final class UserDBRepository: UserDBRepositoryProtocol {
  
  private let db: DatabaseReference = Database.database().reference()
  
  func addUser(_ dto: UserDTO) -> AnyPublisher<Void, DBError> {
    return Just(dto)
    /// dto > data
      .compactMap { try? JSONEncoder().encode($0) }
    /// data > dict
      .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
      .flatMap { value in
        Future<Void, Error> { [weak self] promise in
          self?.db
            .child(DBKey.Users)
            .child(dto.id)
            .setValue(value) { error, _ in
              if let error {
                promise(.failure(error))
              } else {
                promise(.success(()))
              }
            }
        }
      }
      .mapError { DBError.addUserError($0) }
      .eraseToAnyPublisher()
  }
  
  func updateUser(_ dto: UserDTO) -> AnyPublisher<Void, DBError> {
    return Just(dto)
      .compactMap { try? JSONEncoder().encode($0) }
      .flatMap { value in
        Future<Void, DBError> { [weak self] promise in
          // 업데이트할 필드들을 딕셔너리로 설정
          let updates: [String: Any?] = [
            "nickname": dto.nickname,
            "birthdayDate": dto.birthdayDate,
            "gender": dto.gender,
          ].compactMapValues { $0 } // nil 값은 제외
          
          self?.db
            .child(DBKey.Users)
            .child(dto.id)
            .updateChildValues(updates as [AnyHashable : Any]) { error, _ in
              if let error = error {
                promise(.failure(DBError.updateUserError(error))) // DBError로 변환
              } else {
                promise(.success(()))
              }
            }
        }
      }
      .eraseToAnyPublisher()
  }
  
  func deleteUser(userId: String) -> AnyPublisher<Void, DBError> {
    return Future { promise in
      self.db
        .child(DBKey.Users)
        .child(userId)
        .removeValue() { error, _ in
          if let error = error {
              promise(.failure(DBError.error(error)))
          } else {
              promise(.success(()))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func getUser(userId: String) -> AnyPublisher<UserDTO, DBError> {
    return Future<Any?, DBError> { [weak self] promise in
      self?.db
        .child(DBKey.Users)
        .child(userId)
        .getData { error, snapshot in
          if let error {
            promise(.failure(.getUserError(error)))
          } else if snapshot?.value is NSNull {
            promise(.success(nil))
          } else {
            promise(.success(snapshot?.value))
          }
        }
    }
    .flatMap { value in
      if let value {
        return Just(value)
          /// dic -> data
          .tryMap { try JSONSerialization.data(withJSONObject: $0)}
          /// data -> dto
          .decode(type: UserDTO.self, decoder: JSONDecoder())
          .mapError { DBError.getUserError($0) }
          .eraseToAnyPublisher()
        // 값이 없다면
      } else {
        return Fail(error: .emptyValue).eraseToAnyPublisher()
      }
    }
    .eraseToAnyPublisher()
  }

  func loadUsers() -> AnyPublisher<[UserDTO], DBError> {
    return Future<Any?, DBError> { [weak self] promise in
        self?.db.child(DBKey.Users).getData { error, snapshot in
            if let error = error {
                print("데이터베이스 오류 발생: \(error.localizedDescription)") // 오류 메시지 출력
                promise(.failure(DBError.loadUsersError(error)))
            } else if snapshot?.value is NSNull {
                print("데이터베이스에 해당 유저 정보가 없습니다.") // 유저 정보 없음 출력
                promise(.success(nil))
            } else {
                print("데이터베이스에서 사용자 정보를 성공적으로 불러왔습니다.") // 성공 메시지 출력
                promise(.success(snapshot?.value))
            }
        }
    }
    .flatMap { value in
      if let dic = value as? [String: [String: Any]] {
        return Just(dic)
            .tryMap { try JSONSerialization.data(withJSONObject: $0) }
            .decode(type: [String: UserDTO].self, decoder: JSONDecoder()) // 형식
            .map { $0.values.map { $0 as UserDTO } }
            .mapError { DBError.loadUsersError($0) }
            .eraseToAnyPublisher()
      } else if value == nil {
          // print("불러온 데이터가 nil입니다.") // nil 데이터 출력
          return Just([]).setFailureType(to: DBError.self)
          .eraseToAnyPublisher()
      } else {
          // print("유효하지 않은 데이터 타입입니다.") // 유효하지 않은 타입 출력
          return Fail(error: .invalidatedType)
          .eraseToAnyPublisher()
      }
    }
    .eraseToAnyPublisher()
  }
}
