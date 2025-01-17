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
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authViewModel: AuthenticationViewModel(container: container))
        }
    }
}
