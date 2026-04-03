//
//  RootView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

struct RootView: View {
  @StateObject var rootViewModel: RootViewModel
  let authNavigator: Navigator<AppDependencies, AuthRoute>
  let mainNavigator: Navigator<AppDependencies, MainRoute>
  
  var body: some View {
    Group {
      switch rootViewModel.authenticationState {
      case .unauthenticated:
        NavigationContainer(
          navigator: authNavigator,
          initialRoutes: [.intro]
        )
        .environmentObject(rootViewModel)
      case .authenticated:
        TabNavigationContainer(
          navigator: mainNavigator,
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
        .environmentObject(rootViewModel)
      case .firstTimeLogin:
        EmptyView()
      }
    }
    .ignoresSafeArea(.container, edges: .all)
  }
}
