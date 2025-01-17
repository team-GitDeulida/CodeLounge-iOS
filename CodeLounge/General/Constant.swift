//
//  Constant.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

enum Constant {}

extension Constant {
    struct DBKey {
        static let Users = "Users"
    }
}

typealias DBKey = Constant.DBKey
