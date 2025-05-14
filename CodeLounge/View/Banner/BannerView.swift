//
//  BannerView.swift
//  CodeLounge
//
//  Created by 김동현 on 5/14/25.
//

import SwiftUI
import UIKit
import GoogleMobileAds

// SwiftUI에서 사용할 배너 광고 뷰
struct BannerAdView: View {
    
    // 광고 유닛 ID
    let adUnitID: String

    var body: some View {
        // UIKit의 UIView를 SwiftUI에서 사용할 수 있도록 래핑한 View
        BannerAdViewController(adUnitID: adUnitID)
            .frame(height: 50) // 배너 높이는 일반적으로 50pt로 고정
    }
}

// UIViewRepresentable을 통해 UIKit의 GADBannerView를 SwiftUI에서 사용
struct BannerAdViewController: UIViewRepresentable {
    
    // 광고 유닛 ID
    let adUnitID: String
    
    // 실제 UIKit 뷰를 생성하는 함수
    func makeUIView(context: Context) -> BannerView {
        // GADBannerView 객체 생성 (광고 사이즈 지정)
        let banner = BannerView(adSize: AdSizeBanner)
        // 광고 ID 설정
        banner.adUnitID = adUnitID
        // 루트 뷰 컨트롤러 설정 (광고 클릭 시 사용)
        banner.rootViewController = findRootViewController()
        // 광고 로드 요청
        banner.load(Request())
        return banner
    }
    
    // SwiftUI 상태 변경 시 업데이트할 내용 (여기서는 필요 없음)
    func updateUIView(_ uiView: BannerView, context: Context) {}
    
    // 현재 앱의 루트 뷰 컨트롤러를 찾는 메서드
    // 광고 클릭 시 새 창을 띄우기 위해 필요함
    private func findRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            return nil
        }
        return root
    }
}
