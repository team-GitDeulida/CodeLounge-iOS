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
            Color.mainBlack2
            VStack {
                
                Text("\(Color.mainBlack2)")
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(height: 100)
                
                Rectangle()
                    .frame(width: 200, height: 150)
                    .foregroundColor(Color.rectangle)
                    .cornerRadius(10)
                    .overlay(Text("\(Color.rectangle)"))
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AosView()
}
