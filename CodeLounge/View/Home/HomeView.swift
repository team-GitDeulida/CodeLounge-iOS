//
//  HomeView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import TurboNavigator

struct HomeView: View {
  let navigator: Navigator<AppDependencies, MainRoute>
  
  var body: some View {
    Text("HomeView")
  }
}

#Preview {
  HomeView(navigator: .preview)
}
