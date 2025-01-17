//
//  ServiceError.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import Foundation

enum ServiceError: Error {
    case dbError(DBError)
    case error(Error)
}
