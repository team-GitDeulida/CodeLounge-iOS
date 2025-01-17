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
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.mainWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
        }
    }
}

private struct TestView: View {
    @State private var  offsetX: CGFloat = 0 // 버튼의 x축 오프셋
    private let animationDuration = 0.8      // 애니메이션 시간
    
    fileprivate var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Button {
                                
                            } label: {
                                Text("공지사항")
                                    .textRectangle(width: 360, height: 120)
                            }
                            Button {
                                
                            } label: {
                                Text("광고")
                                    .textRectangle(width: 360, height: 120)
                            }
                        }
                        .padding(.horizontal, 20)
                        .offset(x: offsetX)
                        .onAppear {
                            Task {
                                while true {
                                    // 첫 번째 애니메이션
                                    withAnimation(Animation.easeInOut(duration: animationDuration)) {
                                        offsetX = -380
                                    }
                                    
                                    // 애니메이션 후 4초 대기
                                    try? await Task.sleep(nanoseconds: 4_000_000_000)
                                    
                                    // 두 번째 애니메이션
                                    withAnimation(Animation.easeInOut(duration: animationDuration)) {
                                        offsetX = 0
                                    }
                                    
                                    // 다시 1초 대기
                                    try? await Task.sleep(nanoseconds: 4_000_000_000)
                                }
                            }
                            /*
                            withAnimation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
                                offsetX = -380
                            }
                             */
                        }
                }
                
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Text("CS")
                            .textRectangle(width: 170, height: 120)
                    }
                    
                    Button {
                        
                    } label: {
                        Text("iOS")
                            .textRectangle(width: 170, height: 120)
                    }
                }
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Text("aOS")
                            .textRectangle(width: 170, height: 120)
                    }
                    
                    Button {
                        
                    } label: {
                        Text("준비중")
                            .textRectangle(width: 170, height: 120)
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
    func textRectangle(width: CGFloat, height: CGFloat) -> some View {
        self
            .padding()
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.mainWhite)
            .frame(width: width, height: height)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            }
    }
}
