//
//  AOSView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

struct AOSView: View {
  let navigator: Navigator<AppDependencies, MainRoute>

  private let categories = ["Kotlin", "Jetpack Compose UI"]

  var body: some View {
    BoardView(title: "AOS", categories: categories, navigator: navigator)
  }
}

#Preview {
  AOSView(navigator: .preview)
}
