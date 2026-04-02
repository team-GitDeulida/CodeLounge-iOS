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
      AppDependencies.init()
    }
}

enum AppRoute: Hashable {
  case intro
  case home
}

enum AppRouter {
  static func buildNavigator() -> Navigator<AppDependencies, AppRoute> {
    let registry = RouteRegistry<AppDependencies, AppRoute>()
      .registering(.intro) { context in
        WrappingController(
          route: context.route) {
            IntroView(navigator: context.navigator)
          }
      }
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
