//
//  AosView.swift
//  CodeLounge
//
//  Created by 김동현 on 12/11/24.
//

import SwiftUI

struct AosView: View {
    @EnvironmentObject var postVM: PostViewModel
    @State private var selectedPost: Post? // 선택된 게시물을 저장
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Aos")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    /*
                    ZStack {
                        TextField("Search", text: $postVM.searchQuery)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(width: 150, height: 30)
                            .onChange(of: postVM.searchQuery) { _,_ in
                                postVM.filterPosts() // 검색어 변경 시 필터링
                            }
                            .padding()
                            .onDisappear {
                                DispatchQueue.main.async {
                                    // 키보드 닫기
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        
                        HStack {
                            Spacer()
                            
                            Image(systemName: "magnifyingglass")
                                .padding(.trailing, 10)
                        }
                        .frame(width: 150, height: 30)
                    }
                     */
                    
                    TextField("Search", text: $postVM.searchQuery)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(width: 200, height: 30)
                        .onChange(of: postVM.searchQuery) { _,_ in
                            postVM.filterPosts() // 검색어 변경 시 필터링
                        }
                    
                    
                        .padding()
                        .onDisappear {
                            DispatchQueue.main.async {
                                // 키보드 닫기
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                        .overlay {
                            if postVM.searchQuery.isEmpty {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(width: 170, height: 30, alignment: .trailing)
                            }
                                
                        }
                }
                .padding(.top, 30)
                
                List {
                      // 선택된 섹션에 맞는 필터링된 게시물 출력
                      if let kotlinPosts = postVM.filteredPosts["Kotlin"], !kotlinPosts.isEmpty {
                          Section(header: Text("Kotlin")
                              .foregroundColor(Color.mainGreen)
                              .font(.system(size: 17, weight: .bold))
                              .padding(.leading, -10)
                              .textCase(nil)
                          ) {
                              ForEach(kotlinPosts) { post in
                                  Button {
                                      selectedPost = post // 게시물을 선택
                                  } label: {
                                      HStack {
                                          VStack(alignment: .leading) {
                                              Text(post.title)
                                                  .font(.headline)
                                          }
                                          Spacer()
                                          Image(systemName: "chevron.right")
                                              .font(.system(size: 15))
                                              .foregroundColor(.gray)
                                      }
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                  }
                                  .buttonStyle(ListRowButton()) // 커스텀 버튼 스타일 적용
                                  .listRowBackground(Color.subBlack)
                              }
                          }
                      }

                      // 다른 섹션들도 동일하게 필터링된 데이터 사용
                      if let jetpackPosts = postVM.filteredPosts["Jetpack Compose UI"], !jetpackPosts.isEmpty {
                          Section(header: Text("Jetpack Compose UI")
                              .foregroundColor(Color.mainGreen)
                              .font(.system(size: 17, weight: .bold))
                              .padding(.leading, -10)
                              .textCase(nil)
                          ) {
                              ForEach(jetpackPosts) { post in
                                  Button {
                                      selectedPost = post // 게시물을 선택
                                  } label: {
                                      HStack {
                                          VStack(alignment: .leading) {
                                              Text(post.title)
                                                  .font(.headline)
                                          }
                                          Spacer()
                                          Image(systemName: "chevron.right")
                                              .font(.system(size: 15))
                                              .foregroundColor(.gray)
                                      }
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                  }
                                  .buttonStyle(ListRowButton()) // 커스텀 버튼 스타일 적용
                                  .listRowBackground(Color.subBlack)
                              }
                          }
                      }
                  }
                .refreshable {
                    // 새로고침 시 진행할 작업
                    postVM.fetchAllSections()
                }
                //.navigationTitle("aOS")
                .scrollContentBackground(.hidden) // 리스트 기본 배경 숨가
                //.background(Color.mainBlack)
                
                // 화면 전환
                .navigationDestination(item: $selectedPost) { post in
                    DetailView(post: post) // 선택된 게시물의 상세 뷰
                }
                .padding(.top, -20)
                
            }
            .background(Color.mainBlack)
        }
        .onAppear {
            // 초기 섹션 설정 및 필터링
            if postVM.selectedSections.isEmpty {
                postVM.selectedSections = ["Kotlin", "Jetpack Compose UI"]
            }
            postVM.filterPosts() // 필터링
        }
    }
}

#Preview {
    AosView()
        .environmentObject(PostViewModel())
}


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

extension ButtonStyle where Self == ListRowButton {
    static var listRow: Self {
        ListRowButton()
    }
}
