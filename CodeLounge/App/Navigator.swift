//
//  Navigator.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import TurboNavigator
import SwiftUI

struct AppDependencies {

}

extension AppDependencies: PreviewDependencies {
  @MainActor
  static var preview: Self {
    AppDependencies()
  }
}

enum AuthRoute: Hashable {
  case intro
  case login
  case register
}

enum MainRoute: Hashable {
  case home
}

enum AppRouter {
  static func buildAuthNavigator() -> Navigator<AppDependencies, AuthRoute> {
    let registry = RouteRegistry<AppDependencies, AuthRoute>()
      .registering(.intro) { context in
        WrappingController(
          route: context.route) {
            IntroView(navigator: context.navigator)
          }
      }
      .registering(.login) { context in
        WrappingController(
          route: context.route) {
            LoginView(navigator: context.navigator)
          }
      }
      .registering(.register) { context in
        WrappingController(
          route: context.route) {
            RegisterView(navigator: context.navigator)
          }
      }
    return Navigator(
      dependencies: AppDependencies(),
      registry: registry
    )
  }
  
  static func buildMainNavigator() -> Navigator<AppDependencies, MainRoute> {
    let registry = RouteRegistry<AppDependencies, MainRoute>()
      .registering(.home) { context in
        WrappingController(
          route: context.route) {
            HomeView(navigator: context.navigator)
          }
      }
    return Navigator(
      dependencies: AppDependencies(),
      registry: registry
    )
  }
}
