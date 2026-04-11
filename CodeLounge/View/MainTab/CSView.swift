//
//  CSView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

struct CSView: View {
  let navigator: Navigator<AppDependencies, MainRoute>

  private let categories = ["OperatingSystems", "Algorithms"]

  var body: some View {
    BoardView(title: "CS", categories: categories, navigator: navigator)
  }
}

#Preview {
  CSView(navigator: .preview)
}
