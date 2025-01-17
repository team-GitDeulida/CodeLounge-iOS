//
//  CategoryView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/17/25.
//

import SwiftUI

struct CategoryView: View {
    var body: some View {
        ZStack {
            Color.mainBlack
                .ignoresSafeArea()
            
            VStack {
                TitleView()
                TestView()
            }
        }
    }
}

private struct TitleView: View {
    fileprivate var body: some View {
        VStack {
            Text("Dev Place")
                .font(.title)
                .foregroundColor(.mainWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
    }
}

private struct TestView: View {
    fileprivate var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Text("123")
                            .textRectangle()
                    }
                    
                    Button {
                        
                    } label: {
                        Text("123")
                            .textRectangle()
                    }
                }
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Text("123")
                            .textRectangle()
                    }
                    
                    Button {
                        
                    } label: {
                        Text("123")
                            .textRectangle()
                    }
                }
            }.padding()
        }
        
    }
}

#Preview {
    CategoryView()
}

extension View {
    func textRectangle() -> some View {
        self
            .padding()
            .foregroundColor(.mainWhite)
            .frame(width: 170, height: 120)
            //.background(Color.black)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.mainGreen, lineWidth: 1)
            }
    }
}
