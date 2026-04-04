//
//  RootView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator
import UIKit

struct RootView: View {
  @StateObject var rootViewModel: RootViewModel
  @StateObject private var postViewModel = PostViewModel()
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
        
      case .authenticated:
        TabNavigationContainer(
          navigator: mainNavigator,
          items: MainRoute.tabCases.enumerated().map { (index, tab) -> TabNavigationItem<MainRoute> in

            TabNavigationItem(
              tag: index,
              route: tab,  
              tabBarItem: {
                let item = UITabBarItem(
                  title: tab.title,
                  image: paddedTabBarImage(
                    systemName: tab.imageName(isSelected: false),
                    topPadding: 6
                  ),
                  selectedImage: paddedTabBarImage(
                    systemName: tab.imageName(isSelected: true),
                    topPadding: 6
                  )
                )
                item.tag = index
                return item
              }(),
              hapticStyle: .medium
            )
          }
        )
        .environmentObject(postViewModel)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
          postViewModel.fetchAllPosts()
        }
        
      case .firstTimeLogin:
        NavigationContainer(
          navigator: authNavigator,
          initialRoutes: [.register]
        )
      }
    }
    // .ignoresSafeArea(edges: .all)
    .ignoresSafeArea(.container, edges: .all)
    .environmentObject(rootViewModel)
    .onAppear {
       rootViewModel.send(action: .autoLogin)
//      rootViewModel.send(action: .logout)
    }
  }
}

private func paddedTabBarImage(systemName: String, topPadding: CGFloat) -> UIImage? {
  let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
  guard let image = UIImage(systemName: systemName, withConfiguration: configuration) else { return nil }

  let newSize = CGSize(
    width: image.size.width,
    height: image.size.height + topPadding
  )
  let renderer = UIGraphicsImageRenderer(size: newSize)

  return renderer.image { _ in
    image.draw(at: CGPoint(x: 0, y: topPadding))
  }.withRenderingMode(.alwaysTemplate)
}

//
//  .init(
//    tag: 0,
//    route: .cs,
//    tabBarItem: {
//      let item = UITabBarItem(
//        title: "Home",
//        image: nil,
//        selectedImage: nil
//      )
//      item.tag = 0
//      return item
//    }()
//  ),
//  .init(
//    tag: 1,
//    route: .cs,
//    tabBarItem: {
//      let item = UITabBarItem(
//        title: "Home",
//        image: nil,
//        selectedImage: nil
//      )
//      item.tag = 0
//      return item
//    }()
//  )
