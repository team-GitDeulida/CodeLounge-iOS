//
//  iOSView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

struct iOSView: View {
  let navigator: Navigator<AppDependencies, MainRoute>

  private let categories = ["Swift", "UIKit", "SwiftUI"]

  var body: some View {
    BoardView(title: "iOS", categories: categories, navigator: navigator)
  }
}

#Preview {
  iOSView(navigator: .preview)
}
