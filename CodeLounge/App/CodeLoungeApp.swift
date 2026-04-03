//
//  CodeLoungeApp.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import SwiftUI
import ScaleKit
import TurboNavigator

@main
struct CodeLoungeApp: App {
  private let authNavigator = AppRouter.buildAuthNavigator()
  private let mainNavigator = AppRouter.buildMainNavigator()
  @StateObject private var rootViewModel = RootViewModel()
  
  // MARK: - navigationTitle 색상 흰색으로 지정
  init() {
    /// Large Navigation Title
    UINavigationBar
      .appearance()
      .largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    /// Inline Navigation Title
    UINavigationBar
      .appearance()
      .titleTextAttributes = [.foregroundColor: UIColor.white]
  }

  var body: some Scene {
    WindowGroup {
      RootView(
        rootViewModel: rootViewModel,
        authNavigator: authNavigator,
        mainNavigator: mainNavigator
      )
    }
  }
}


/*
 @State private var loggedIn: Bool = false
Group {
  if loggedIn {
    TabNavigationContainer(
      navigator: navigator,
      items: [
        .init(
          tag: 0,
          route: .home,
          tabBarItem: UITabBarItem(title: "Home", image: nil, tag: 0)),
        .init(
          tag: 1,
          route: .home,
          tabBarItem: UITabBarItem(title: "Home", image: nil, tag: 1)),
      ],
    )
  } else {
    NavigationContainer(
      navigator: navigator,
      initialRoutes: [.intro]
    )
  }
}
.ignoresSafeArea(.container, edges: .all)
.versionUpdateAlert()
.task {
  try? await Task.sleep(nanoseconds: 3_000_000_000)
  loggedIn = true
}
*/
