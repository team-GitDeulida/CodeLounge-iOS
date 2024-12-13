//
//  AosView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct AosView: View {
    var body: some View {
        ZStack {
            Color.mainBlack
            VStack {
                
                Text("\(Color.mainBlack)")
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(height: 100)
                
                Rectangle()
                    .frame(width: 200, height: 150)
                    .foregroundColor(Color.mainGreen)
                    .cornerRadius(10)
                    .overlay(Text("\(Color.mainGreen)"))
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AosView()
}
