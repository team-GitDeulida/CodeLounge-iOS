//
//  DBError.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

enum DBError: Error {
    case addUserError(Error)
    case getUserError(Error)
    case loadUsersError(Error)
    case updateUserError(Error)
    case emptyValue
    case invalidatedType
    
    var errorDescription: String {
        switch self {
        case .addUserError(let error):
            return "❌ 에러 [addUserError]: \(error.localizedDescription)"
        case .getUserError(let error):
            return "❌ 에러 [getUserError]: \(error.localizedDescription)"
        case .loadUsersError(let error):
            return "❌ 에러 [loadUsersError]"
        case .updateUserError(let error):
            return "❌ 에러 [updateUserError]: \(error.localizedDescription)"
        case .emptyValue:
            return "❌ 에러 [emptyValue]"
        case .invalidatedType:
            return "❌ 에러 [invalidatedType]"
        }
    }
}
