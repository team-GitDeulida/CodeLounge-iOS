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

enum MainRoute: Hashable, CaseIterable {
  case cs
  case ios
  case aos
  case profile
  
  var title: String {
    switch self {
    case .cs: return "CS"
    case .ios: return "iOS"
    case .aos: return "aOS"
    case .profile: return "Profile"
    }
  }
  
  func imageName(isSelected: Bool) -> String {
    switch self {
    case .cs:
      return "desktopcomputer"
    case .ios:
      return "apple.logo"
    case .aos:
      return "smartphone"
    case .profile:
      return isSelected ? "person.fill" : "person"
    }
  }
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
      .registering(.cs) { context in
        WrappingController(
          route: context.route) {
            CSView(navigator: context.navigator)
          }
      }
      .registering(.ios) { context in
        WrappingController(route: context.route) {
          iOSView(navigator: context.navigator)
        }
      }
      .registering(.aos) { context in
        WrappingController(route: context.route) {
          AOSView(navigator: context.navigator)
        }
      }
      .registering(.profile) { context in
        WrappingController(route: context.route) {
          ProfileView(navigator: context.navigator)
        }
      }
    return Navigator(
      dependencies: AppDependencies(),
      registry: registry
    )
  }
}
