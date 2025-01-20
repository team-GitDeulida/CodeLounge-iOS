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

// MARK: - 프로필 뷰 버튼 디자인
extension View {
    func indexButtonStyle(color: Color) -> some View {
        self
            .padding()
            .foregroundColor(color)
            .frame(width: 150, height: 100)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.mainGreen, lineWidth: 1)
            }
    }
    
//    func boxStyle(color: Color, width: CGFloat,height: CGFloat, radius: CGFloat) -> some View {
//        
//        self
//            .padding()
//            .background(color)
//            .frame(width: width, height: height)
//            .cornerRadius(radius)
//    }
}

/*
 Button {
 authViewModel.send(action: .logout)
 } label: {
 Text("로그아웃")
 .greenButtonStyle()
 }
 */

struct RectView: View {
    var height: CGFloat = 100
    var color: Color = .gray
    var radius: CGFloat = 20
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .cornerRadius(radius)
    }
}

struct StroketView: View {
    var width: CGFloat = 100
    var height: CGFloat = 100
    var color: Color = .gray
    var radius: CGFloat = 20
    
    var body: some View {
        Rectangle()
            .stroke(Color.white, lineWidth: 10)
            .frame(width: width, height: height)
            .cornerRadius(radius)
            
    }
}
