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
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  private let authNavigator: Navigator<AppDependencies, AuthRoute>
  private let mainNavigator: Navigator<AppDependencies, MainRoute>
  @StateObject private var rootViewModel = RootViewModel()
  
  // MARK: - navigationTitle 색상 흰색으로 지정
  init() {
    self.authNavigator = AppRouter.buildAuthNavigator()
    self.mainNavigator = AppRouter.buildMainNavigator()

    /// Large Navigation Title
    UINavigationBar
      .appearance()
      .largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    /// Inline Navigation Title
    UINavigationBar
      .appearance()
      .titleTextAttributes = [.foregroundColor: UIColor.white]
    
    /// 뒤로가기 버튼 텍스트/아이콘 색상
    let barButtonAppearance = UIBarButtonItemAppearance()
    barButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
    barButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().standardAppearance.backButtonAppearance = barButtonAppearance
    UINavigationBar.appearance().scrollEdgeAppearance?.backButtonAppearance = barButtonAppearance
    UINavigationBar.appearance().compactAppearance?.backButtonAppearance = barButtonAppearance
    UINavigationBar.appearance().tintColor = .white
    
    // TabBar 색상 설정
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black

    // 선택된 아이콘 색상
    appearance.stackedLayoutAppearance.selected.iconColor = .white
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

    // 선택 안된 아이콘 색상
    appearance.stackedLayoutAppearance.normal.iconColor = .gray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
    
    //
    // appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
    // appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
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
