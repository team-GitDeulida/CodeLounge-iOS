//
//  String+Extension.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import Foundation

extension String {
    // 문자열의 첫 글자만 대문자로 변환
    func capitalizeFirstLetter() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}
