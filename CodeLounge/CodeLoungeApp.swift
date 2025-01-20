//
//  CodeLoungeApp.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import SwiftUI

@main
struct CodeLoungeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = DIContainer.init(services: Services())
    @StateObject private var postViewModel = PostViewModel()
    

    // MARK: - navigationTitle 색상 흰색으로 지정
    init() {
         // Large Navigation Title
         UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
         // Inline Navigation Title
         UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authViewModel: AuthenticationViewModel(container: container))
                .environmentObject(postViewModel)
                .onAppear {
                    postViewModel.fetchAllPosts()
                }
//            MainTabView()
//                .environmentObject(postViewModel)
//                .onAppear {
//                    postViewModel.fetchAllPosts()
//                }
        }
    }
}
