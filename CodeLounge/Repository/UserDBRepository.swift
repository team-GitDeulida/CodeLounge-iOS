//
//  UserDBRepository.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func updateUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func deleteUser(userId: String) -> AnyPublisher<Void, DBError>
}

final class UserDBRepository: UserDBRepositoryType {
    
    var db: DatabaseReference = Database.database().reference()
    
    // MARK: - 사용자 추가
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }                                           // object > data
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) } // data > dict
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
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
    
    // MARK: - 앱 사용자 불러오기
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).child(userId).getData {error, snapshot in
                if let error {
                    promise(.failure(DBError.getUserError(error)))
                    // DB에 해당 유저정보가 없는걸 체크할때 없으면 nil이 아닌 NSNULL을 갖고있기 떄문에 NSNULL일경우 nil을 아웃풋으로 넘겨줌
                } else if snapshot?.value is NSNull {
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0)}
                    .decode(type: UserObject.self, decoder: JSONDecoder())
                    .mapError { DBError.getUserError($0) }
                    .eraseToAnyPublisher()
            // 값이 없다면
            } else {
                return Fail(error: .emptyValue).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - 앱 사용자 전체 불러오기(본인 제외)
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        print("사용자 목록 불러오기 요청") // 디버깅 출력 추가
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
        // 딕셔너리형태(userID: UserObject) -> 배열형태
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] {
                //print("불러온 사용자 데이터 딕셔너리: \(dic)") // 불러온 데이터 출력
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: UserObject].self, decoder: JSONDecoder()) // 형식
                    .map { $0.values.map { $0 as UserObject } }
                    .mapError { error in
                        print("JSON 디코딩 오류: \(error.localizedDescription)")
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                            case .keyNotFound(let key, let context):
                                print("키 누락: \(key.stringValue), \(context.debugDescription)")
                            case .typeMismatch(let type, let context):
                                print("타입 불일치: \(type), \(context.debugDescription)")
                            case .valueNotFound(let value, let context):
                                print("값 누락: \(value), \(context.debugDescription)")
                            case .dataCorrupted(let context):
                                print("데이터 손상: \(context.debugDescription)")
                            default:
                                print("디코딩 실패: \(error.localizedDescription)")
                            }
                        }
                        return DBError.loadUsersError(error)
                    }

                    .eraseToAnyPublisher()
            } else if value == nil {
                // print("불러온 데이터가 nil입니다.") // nil 데이터 출력
                return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
            } else {
                // print("유효하지 않은 데이터 타입입니다.") // 유효하지 않은 타입 출력
                return Fail(error: .invalidatedType).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - 사용자 정보 추가/수정
    func updateUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .flatMap { value in
                Future<Void, DBError> { [weak self] promise in
                    // 업데이트할 필드들을 딕셔너리로 설정
                    let updates: [String: Any?] = [
                        "nickname": object.nickname,
                        "birthdayDate": object.birthdayDate,
                        "gender": object.gender,
                    ].compactMapValues { $0 } // nil 값은 제외

                    self?.db.child(DBKey.Users).child(object.id).updateChildValues(updates as [AnyHashable : Any]) { error, _ in
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
    
    // MARK: - 회원 탈퇴
    func deleteUser(userId: String) -> AnyPublisher<Void, DBError> {
        Future { promise in
            self.db.child(DBKey.Users).child(userId).removeValue { error, _ in
                if let error = error {
                    promise(.failure(.error(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

