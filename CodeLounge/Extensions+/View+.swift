//
//  View+.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI

extension View {
  func versionUpdateAlert() -> some View {
    self.modifier(VersionUpdateModifier())
  }
}

struct VersionUpdateModifier: ViewModifier {
  @Environment(\.scenePhase) private var scenePhase
  @State private var showAlert = false
  @State private var latestVersion: String?
  
  func body(content: Content) -> some View {
    content
      .onChange(of: scenePhase) { _, newPhase in
        guard newPhase == .active else { return }
        checkForAppUpdates()
      }
      .alert(isPresented: $showAlert) {
        Alert(
          title: Text("앱 업데이트 필요"),
          message: Text("새로운 기능과 성능 개선을 위해 최신 버전 (\(latestVersion ?? ""))을 사용해 보세요!"),
          dismissButton: .default(Text("업데이트")) {
            if let url = URL(string: "https://apps.apple.com/app/id6741165577") {
              UIApplication.shared.open(url)
            }
          }
        )
      }
  }
  
  // 최신 버전 확인 로직
  func checkForAppUpdates() {
    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    
    fetchLatestVersionFromAppStore { latest in
      guard let latest = latest else { return }
      print("앱버전: \(currentVersion)\n스토어버전: \(latest)")
      
      if isUpdateRequired(
        currentVersion: currentVersion,
        lastestVersion: latest
      ) {
        DispatchQueue.main.async {
          self.latestVersion = latest
          self.showAlert = true
          
        }
      }
    }
  }
}

private extension VersionUpdateModifier {
  // 버전 비교 로직
  func isUpdateRequired(
    currentVersion: String,
    lastestVersion: String
  ) -> Bool {
    return currentVersion.compare(
      lastestVersion,
      options: .numeric
    ) == .orderedAscending
  }
  
  // iTunes API에서 최신 버전 가져오기
  func fetchLatestVersionFromAppStore(
    completion: @escaping (String?) -> Void
  ) {
    guard let url = URL(string: Constant.URL.appStore) else {
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data else {
        completion(nil)
        return
      }
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let results = json["results"] as? [[String: Any]],
           let latestVersion = results.first?["version"] as? String {
          completion(latestVersion)
        } else {
          completion(nil)
        }
      } catch {
        completion(nil)
      }
    }.resume()
  }
}
