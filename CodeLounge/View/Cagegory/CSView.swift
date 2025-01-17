//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

struct CSView: View {
    var body: some View {
        ZStack {
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack {
                Button {
                    
                } label: {
                    Text("123")
                        .textRectangle()
                }
            }
            
        }
    }
}

#Preview {
    CSView()
}




