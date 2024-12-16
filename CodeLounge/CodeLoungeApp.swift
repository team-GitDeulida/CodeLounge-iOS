//
//  CodeLoungeApp.swift
//  CodeLounge
//
//  Created by 김동현 on 12/10/24.
//

import SwiftUI

@main
struct CodeLoungeApp: App {
    // delegate 설정
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .background(Color.mainBlack) // 앱의 기본 배경색 설정
            // LoginView()
        }
        
        
    }
}
