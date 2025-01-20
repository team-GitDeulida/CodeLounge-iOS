//
//  ButtonStyle.swift
//  CodeLounge
//
//  Created by 김동현 on 1/20/25.
//

import SwiftUI

// MARK: - 리스트 커스텀 버튼
struct ListRowButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            // to cover the whole length of the cell
            .frame(
                maxWidth: .greatestFiniteMagnitude,
                alignment: .leading)
            // to make all the cell tapable, not just the text
            .contentShape(.rect)
            .background {
                if configuration.isPressed {
                    Rectangle()
                        .fill(Color.mainGreen)
                    // Arbitrary negative padding, adjust accordingly
                        .padding(-20)
                }
            }
    }
}
