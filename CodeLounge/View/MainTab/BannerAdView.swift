//
//  BannerAdView.swift
//  CodeLounge
//
//  Created by 김동현 on 5/14/25.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct BannerAdView: View {
  let adUnitID: String

  var body: some View {
    BannerAdRepresentable(adUnitID: adUnitID)
      .frame(height: 50)
  }
}

struct BannerAdRepresentable: UIViewRepresentable {
  let adUnitID: String

  func makeUIView(context: Context) -> BannerView {
    let bannerView = BannerView(adSize: AdSizeBanner)
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = findRootViewController()
    bannerView.load(Request())
    return bannerView
  }

  func updateUIView(_ uiView: BannerView, context: Context) {}

  private func findRootViewController() -> UIViewController? {
    guard
      let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let rootViewController = scene.windows.first?.rootViewController
    else {
      return nil
    }

    return rootViewController
  }
}
