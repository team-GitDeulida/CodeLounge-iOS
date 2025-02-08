//
//  CategoryView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/17/25.
//

import SwiftUI

struct HomeView_save: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBlack
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        TitleView()
                        
                        AdView()
                        
                        TopicView()
                        
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        Text("Dev Lounge")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(.mainWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
    }
}

// MARK: - 광고 View
private struct AdView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrollingRight = true
    
    fileprivate var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 20) {
                ScrollViewReader { proxy in
                    HStack(spacing: 20) {
                        ForEach(0..<2, id: \.self) { index in
                            Button {
                                
                            } label: {
                                Text("공지사항 \(index + 1)")
                                    .textRectangle(maxWidth: .infinity, height: 120)
                                    .frame(width: UIScreen.main.bounds.width - 20)
                            }
                            .id(index)
                        }
                    }
                    .onAppear {
                        startAutoScroll(proxy: proxy)
                    }
                }
            }
        }
    }
    
    // MARK: - 자동 스크롤 함수
    // 실제 멈춰 있는 시간은 (6-2)초, 그리고 애니메이션 이동 시간이 2초
    private func startAutoScroll(proxy: ScrollViewProxy) {
        Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
            DispatchQueue.main.async {
                // 느리게 시작 → 점점 빨라짐 → 다시 느려짐
                withAnimation(.easeInOut(duration: 2)) {
                    if isScrollingRight {
                        scrollOffset += 1
                        if scrollOffset >= 1 {
                            isScrollingRight = false
                        }
                    } else {
                        scrollOffset -= 1
                        if scrollOffset <= 0 {
                            isScrollingRight = true
                        }
                    }
                    proxy.scrollTo(Int(scrollOffset), anchor: .center)
                }
            }
        }
    }
}

// MARK: - TopicView
private struct TopicView: View {
    fileprivate var body: some View {
        //ScrollView() {
            HStack(spacing: 20) {
                
                NavigationLink {
                    CSView()
                } label: {
                    Text("CS")
                        .textRectangle(maxWidth: .infinity, height: 120)
                }
                
                NavigationLink {
                    iOSView()
                } label: {
                    Text("iOS")
                        .textRectangle(maxWidth: .infinity, height: 120)
                }
            }
            
            //Spacer()
            //    .frame(height: 20)
            
            HStack(spacing: 20) {
                NavigationLink {
                    AosView()
                } label: {
                    Text("aOS")
                        .textRectangle(maxWidth: .infinity, height: 120)
                }
                
                NavigationLink {
                    ProfileView()
                } label: {
                    Text("블로그")
                        .textRectangle(maxWidth: .infinity, height: 120)
                }
            }
        //}
    }
}

#Preview {
    HomeView_save()
}

extension View {
    func textRectangle(maxWidth: CGFloat, height: CGFloat) -> some View {
        self
            .padding()
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.mainWhite)
            .frame(maxWidth: maxWidth)
            .frame(height: height)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            }
    }
}


// MARK: - SubView
/*
private struct SubView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrollingRight = true
    
    fileprivate var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - 공지사항 (자동 스크롤)
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        HStack(spacing: 20) {
                            ForEach(0..<2, id: \.self) { index in
                                Button {
                                    
                                } label: {
                                    Text("공지사항 \(index + 1)")
                                        .textRectangle(width: 360, height: 120)
                                }
                                .id(index)
                            }
                        }
                        .padding(.horizontal, 20)
                        .onAppear {
                            startAutoScroll(proxy: proxy)
                        }
                    }
                }
                
                /*
                // MARK: - 버튼
                HStack(spacing: 20) {
                    NavigationLink {
                        CSView()
                    } label: {
                        Text("CS")
                            .textRectangle(width: 170, height: 120)
                    }
                    
                    NavigationLink {
                        iOSView()
                    } label: {
                        Text("iOS")
                            .textRectangle(width: 170, height: 120)
                    }
                }
                HStack(spacing: 20) {
                    NavigationLink {
                        AosView()
                    } label: {
                        Text("aOS")
                            .textRectangle(width: 170, height: 120)
                    }
                    
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Text("블로그")
                            .textRectangle(width: 170, height: 120)
                    }
                }
                 */
            }
        }
    }
    
    // MARK: - 자동 스크롤 함수
    private func startAutoScroll(proxy: ScrollViewProxy) {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            DispatchQueue.main.async {
                // 느리게 시작 → 점점 빨라짐 → 다시 느려짐
                withAnimation(.easeInOut(duration: 2)) {
                    if isScrollingRight {
                        scrollOffset += 1
                        if scrollOffset >= 1 {
                            isScrollingRight = false
                        }
                    } else {
                        scrollOffset -= 1
                        if scrollOffset <= 0 {
                            isScrollingRight = true
                        }
                    }
                    proxy.scrollTo(Int(scrollOffset), anchor: .center)
                }
            }
        }
    }
}
*/
