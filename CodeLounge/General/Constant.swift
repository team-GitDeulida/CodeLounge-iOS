//
//  Constant.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import Foundation

enum Constant {}
extension Constant {
  enum AdUnitID {
    static let postDetailBanner = "ca-app-pub-6798240605221343/7424023393"
  }

  enum DBKey {
    static let Users = "Users"
  }
  
  enum URL {
    static let appStore = "https://itunes.apple.com/lookup?bundleId=com.indextrown.CodeLounge"
  }
}

typealias AdUnitID = Constant.AdUnitID
typealias DBKey = Constant.DBKey
