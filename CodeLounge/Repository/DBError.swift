//
//  DBError.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation

enum DBError: Error {
  case addUserError(Error)
  case updateUserError(Error)
  case getUserError(Error)
  case loadUsersError(Error)
  case loadPostsError(Error)
  case emptyValue
  case invalidatedType
  
  case error(Error)
}
