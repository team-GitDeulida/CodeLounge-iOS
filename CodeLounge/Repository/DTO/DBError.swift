//
//  DBError.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

enum DBError: Error {
    // MARK: - UserDBRepository
    case addUserError(Error)
    case getUserError(Error)
    case loadUsersError(Error)
    case updateUserError(Error)
    case emptyValue
    case invalidatedType
    
    // MARK: - OtherDBRepository
    // ...
    case error(Error)
    
    // MARK: - 에러 상세 설명
    var errorDescription: String {
        switch self {
        case .addUserError(let error):
            return "❌ 에러 [addUserError]: \(error.localizedDescription)"
        case .getUserError(let error):
            return "❌ 에러 [getUserError]: \(error.localizedDescription)"
        case .loadUsersError(let error):
            return "❌ 에러 [loadUsersError] \(error.localizedDescription)"
        case .updateUserError(let error):
            return "❌ 에러 [updateUserError]: \(error.localizedDescription)"
        case .emptyValue:
            return "❌ 에러 [emptyValue]: 값이 없습니다"
        case .invalidatedType:
            return "❌ 에러 [invalidatedType]: 유효하지 않은 타입입니다"
        case .error:
            return "❌ 에러 [invalidatedType]: error"
        }
    }
}
