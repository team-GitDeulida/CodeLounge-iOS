//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI

struct CSView: View {
    @EnvironmentObject private var postViewModel: PostViewModel
    @State private var selectedPost: Post?
    private let categories: [String] = ["OperatingSystems", "Algorithms"]
    
    var body: some View {

        NavigationStack {
            ZStack {
                Color.mainBlack
                    .ignoresSafeArea() // ✅ 배경이 네비게이션 바까지 덮이도록
                
                VStack(spacing: 0) {
                    
                    // MARK: - 타이틀뷰 & 검색바
                    HStack {
                        
                        Text("CS")
                            .font(.system(size: 35, weight: .bold))
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        // ✅ UIKit 기반 입력 필드로 변경
                        CustomTextField(text: $postViewModel.searchText, placeholder: "검색")
                                .frame(width: 200, height: 40)
                                .padding(.horizontal)
                                .onChange(of: postViewModel.searchText) { _, _ in
                                    postViewModel.filterPosts(for: categories)
                                }
                    }
                    .padding(.top, 30)
                    .padding(.vertical, 10)
                    .background(Color.mainBlack)
                    
                    // MARK: - 리스트
                    List {
                        ForEach(categories, id: \.self) { category in
                            if let posts = postViewModel.filteredPostsByCategory[category], !posts.isEmpty {
                                Section(header: Text(postViewModel.categoryNames[category] ?? category.capitalizeFirstLetter())
                                    .foregroundColor(Color.mainGreen)
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.leading, -10)
                                ) {
                                    ForEach(posts) { post in
                                        Button {
                                            selectedPost = post
                                        } label: {
                                            HStack {
                                                Text(post.title)
                                                    .font(.headline)
                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .buttonStyle(ListRowButton())
                                        .listRowBackground(Color.subBlack)
                                        .listRowSeparatorTint(Color.gray.opacity(0.4), edges: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden) // ✅ 리스트 배경 제거
                    .background(Color.clear) // ✅ 리스트 배경을 완전히 투명하게 설정
                    .navigationDestination(item: $selectedPost) { post in
                        DetailView(post: post)
                    }
                }
            }
            .tint(Color.mainWhite)
        }

        .onAppear {
            postViewModel.searchText = "" // 검색어 초기화
            postViewModel.filterPosts(for: categories) // 현재 탭에 맞는 데이터 필터링
        
        }
        .refreshable {
            postViewModel.fetchAllPosts()
            postViewModel.searchText = "" // 검색어 초기화
            postViewModel.filterPosts(for: categories) // 현재 탭에 맞는 데이터 필터링
        }
    }
}

#Preview {
    // CSView()
    MainTabView()
        .environmentObject(PostViewModel())
}

import UIKit

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String // ✅ 플레이스홀더 추가

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // ✅ 엔터 누르면 키보드 닫기
            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder // ✅ 플레이스홀더 적용
        textField.backgroundColor = UIColor(Color.subBlack) // ✅ 배경색
        textField.layer.cornerRadius = 10
        textField.textColor = .white // ✅ 입력된 텍스트 색상
        textField.returnKeyType = .done // ✅ 완료 버튼 스타일
        
        // ✅ 왼쪽 패딩 추가
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChangeSelection(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder // ✅ 업데이트 시 플레이스홀더 적용
    }
}

//.modifier(KeyboardAvoidanceModifier()) // ✅ 키보드 올라올 때 배경 깜빡임 제거
struct KeyboardAvoidanceModifier: ViewModifier {
    @State private var keyboardVisible = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    keyboardVisible = true
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardVisible = false
                }
            }
            .background(keyboardVisible ? Color.clear : Color.mainBlack) // ✅ 키보드 올라오면 배경 제거
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
    }
}


