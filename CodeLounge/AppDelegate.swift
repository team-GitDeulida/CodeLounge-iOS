//
//  AppDelegate.swift
//  CodeLounge
//
//  Created by 김동현 on 1/16/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // MARK: - Firebase
        // gRPC 관련 환경 변수 설정 (GRPC_TRACE 제거)
        setenv("GRPC_VERBOSITY", "ERROR", 1)
        // GRPC_TRACE 환경 변수 제거 (트레이싱 로그가 비활성화)
        unsetenv("GRPC_TRACE")
        
        // Firebase 디버그 로그 활성화
        // FirebaseConfiguration.shared.setLoggerLevel(.debug)
        
        // MARK: - Admob
        MobileAds.shared.start(completionHandler: nil)

        return true
    }
    
    
    
    // MARK: - Google Login
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
