//
//  CodeLoungeApp.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import SwiftUI

@main
struct CodeLoungeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = DIContainer.init(services: Services())
    @StateObject private var postViewModel = PostViewModel()
    
    // MARK: - 최신 버전 확인
    @State private var showUpdateAlert = false
    @State private var latestVersion: String?
    

    // MARK: - navigationTitle 색상 흰색으로 지정
    init() {
         // Large Navigation Title
         UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
         // Inline Navigation Title
         UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authViewModel: AuthenticationViewModel(container: container))
                .environmentObject(postViewModel)
                .onAppear {
                    postViewModel.fetchAllPosts()
                    checkForAppUpdates()
                }
                .alert(isPresented: $showUpdateAlert) {
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
    }
    
    // 최신 버전 확인 로직
    func checkForAppUpdates() {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        
        fetchLatestVersionFromAppStore { latest in
            if let latest = latest, isUpdateRequired(currentVersion: currentVersion, latestVersion: latest) {
                self.latestVersion = latest
                self.showUpdateAlert = true
            }
        }
    }
    
    // iTunes API에서 최신 버전 가져오기
    func fetchLatestVersionFromAppStore(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=com.indextrown.CodeLounge") else { return }
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
    
    // 버전 비교 로직
    func isUpdateRequired(currentVersion: String, latestVersion: String) -> Bool {
        return currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending
    }
}
