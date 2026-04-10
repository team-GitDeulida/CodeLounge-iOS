//
//  CodeLoungeApp.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import SwiftUI
import TurboNavigator

@main
struct CodeLoungeApp: App {
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  private let authNavigator: Navigator<AppDependencies, AuthRoute>
  private let mainNavigator: Navigator<AppDependencies, MainRoute>
  @StateObject private var rootViewModel = RootViewModel()
  
  init() {
    self.authNavigator = AppRouter.buildAuthNavigator()
    self.mainNavigator = AppRouter.buildMainNavigator()
    
    configureNavigationBar()
    configureTabBar()
  }

  var body: some Scene {
    WindowGroup {
      RootView(
        rootViewModel: rootViewModel,
        authNavigator: authNavigator,
        mainNavigator: mainNavigator
      )
      .versionUpdateAlert()
    }
  }
}

// MARK: - Appearance
private extension CodeLoungeApp {
  
  func configureNavigationBar() {
    let standardAppearance = UINavigationBarAppearance()
    standardAppearance.configureWithDefaultBackground()
    standardAppearance.shadowColor = .clear
    standardAppearance.largeTitleTextAttributes = [
      .foregroundColor: UIColor.white
    ]
    standardAppearance.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]

    let scrollEdgeAppearance = UINavigationBarAppearance()
    scrollEdgeAppearance.configureWithTransparentBackground()
    scrollEdgeAppearance.backgroundColor = .clear
    scrollEdgeAppearance.shadowColor = .clear
    scrollEdgeAppearance.largeTitleTextAttributes = [
      .foregroundColor: UIColor.white
    ]
    scrollEdgeAppearance.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]

    let backButtonAppearance = UIBarButtonItemAppearance()
    backButtonAppearance.normal.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]
    backButtonAppearance.highlighted.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]

    standardAppearance.backButtonAppearance = backButtonAppearance
    scrollEdgeAppearance.backButtonAppearance = backButtonAppearance

    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = standardAppearance
    navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    navigationBar.compactAppearance = standardAppearance
    navigationBar.tintColor = .white
  }
  
  func configureTabBar() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black

    appearance.stackedLayoutAppearance.selected.iconColor = .white
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .foregroundColor: UIColor.white
    ]

    appearance.stackedLayoutAppearance.normal.iconColor = .gray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .foregroundColor: UIColor.gray
    ]

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
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
