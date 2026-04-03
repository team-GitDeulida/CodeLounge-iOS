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
    var body: some View {
      VStack {
        Text("AOSView")
        Spacer()
      }
    }
}

#Preview {
  AOSView(navigator: .preview)
}
