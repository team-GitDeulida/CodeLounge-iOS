//
//  ProfileView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI
import SwiftUI_Kit
import SafariServices
import TurboNavigator

struct ProfileView: View {
  let navigator: Navigator<AppDependencies, MainRoute>
  @EnvironmentObject private var rootViewModel: RootViewModel

  @State private var showDeleteUserAlert = false
  @State private var showContactView = false
  @State private var showAnnounceView = false
  @State private var showPrivacyPolicy = false

  private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 20) {
        ProfileTitleView()
          .padding(.top, 20)

        ProfileSummaryCard {
          navigator.push(.profileSettings(rootViewModel))
        }

        ProfileMenuCard(
          rows: [
            .init(title: "공지사항") { showAnnounceView = true },
            .init(title: "문의하기") { showContactView = true }
          ]
        )

        ProfileInfoCard(
          version: version,
          onPrivacyPolicyTap: { showPrivacyPolicy = true }
        )

        ProfileDangerCard(title: "계정탈퇴") {
          showDeleteUserAlert = true
        }

        Button {
          rootViewModel.send(action: .logout)
        } label: {
          Text("로그아웃")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 40)
    }
    .background(Color.mainBlack.ignoresSafeArea())
    .alert("계정 삭제", isPresented: $showDeleteUserAlert) {
      Button("삭제", role: .destructive) {
        rootViewModel.send(action: .deleteUser)
      }
      Button("취소", role: .cancel) {}
    } message: {
      Text("정말로 계정을 삭제하시겠습니까?")
    }
    .fullScreenCover(isPresented: $showContactView) {
      ProfileSafariView(url: profileURL(for: "KAKAO_URL"))
    }
    .fullScreenCover(isPresented: $showAnnounceView) {
      ProfileSafariView(url: profileURL(for: "NOTION_URL"))
    }
    .fullScreenCover(isPresented: $showPrivacyPolicy) {
      ProfileSafariView(url: profileURL(for: "NOTION_POLICY_URL"))
    }
  }

  private func profileURL(for key: String) -> URL? {
    guard let rawValue = Bundle.main.infoDictionary?[key] as? String else {
      return nil
    }

    if let url = URL(string: rawValue), url.scheme != nil {
      return url
    }

    return URL(string: "https://" + rawValue)
  }
}

#Preview {
  PreviewProfileView()
}

private struct PreviewProfileView: View {
  @StateObject private var rootViewModel: RootViewModel

  init() {
    DIContainer.config()
    _rootViewModel = StateObject(wrappedValue: RootViewModel())
  }

  var body: some View {
    ProfileView(navigator: .preview)
      .environmentObject(rootViewModel)
  }
}

private struct ProfileTitleView: View {
  var body: some View {
    HStack {
      Text("Profile")
        .font(.system(size: 30, weight: .bold))
        .foregroundStyle(Color.mainWhite)

      Spacer()
    }
  }
}

private struct ProfileSummaryCard: View {
  @EnvironmentObject private var rootViewModel: RootViewModel
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 6) {
          Text(rootViewModel.user?.nickname ?? "닉네임")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.mainWhite)

          Text(dayCountText)
            .font(.system(size: 15))
            .foregroundStyle(Color.mainGray)
        }

        Spacer()

        Image(systemName: "chevron.right")
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(Color.mainWhite)
      }
      .padding(20)
      .frame(maxWidth: .infinity, minHeight: 100)
      .background(Color.subBlack)
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.mainWhite.opacity(0.4), lineWidth: 0.5)
      )
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .buttonStyle(.plain)
  }

  private var dayCountText: String {
    guard let registerDate = rootViewModel.user?.registerDate else {
      return "CodeLounge에 오신 걸 환영해요"
    }

    return "CodeLounge \(calculateDaySince(registerDate))일 째"
  }

  private func calculateDaySince(_ registerDate: Date) -> Int {
    let currentDate = Date()
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current

    let startOfRegisterDate = calendar.startOfDay(for: registerDate)
    let startOfCurrentDate = calendar.startOfDay(for: currentDate)

    return calendar.dateComponents([.day], from: startOfRegisterDate, to: startOfCurrentDate).day ?? 0
  }
}

private struct ProfileMenuCard: View {
  struct Row {
    let title: String
    let action: () -> Void
  }

  let rows: [Row]

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
        Button(action: row.action) {
          HStack {
            Text(row.title)
              .foregroundStyle(Color.mainWhite)
            Spacer()
          }
          .padding(.horizontal, 20)
          .frame(height: 50)
        }
        .buttonStyle(.plain)

        if index < rows.count - 1 {
          Rectangle()
            .fill(Color.mainGray)
            .frame(height: 1)
            .padding(.horizontal, 20)
        }
      }
    }
    .background(Color.subBlack)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

private struct ProfileInfoCard: View {
  let version: String
  let onPrivacyPolicyTap: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      Button(action: onPrivacyPolicyTap) {
        HStack {
          Text("개인정보처리방침")
            .foregroundStyle(Color.mainWhite)
          Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 50)
      }
      .buttonStyle(.plain)

      Rectangle()
        .fill(Color.mainGray)
        .frame(height: 1)
        .padding(.horizontal, 20)

      HStack {
        Text("버전정보")
          .foregroundStyle(Color.mainWhite)
        Spacer()
        Text(version)
          .foregroundStyle(Color.mainGray)
      }
      .padding(.horizontal, 20)
      .frame(height: 50)
    }
    .background(Color.subBlack)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

private struct ProfileDangerCard: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack {
        Text(title)
          .foregroundStyle(Color.mainWhite)
        Spacer()
      }
      .padding(.horizontal, 20)
      .frame(height: 50)
      .background(Color.subBlack)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .buttonStyle(.plain)
  }
}

private struct ProfileSafariView: UIViewControllerRepresentable {
  let url: URL?

  func makeUIViewController(context: Context) -> UIViewController {
    guard let url else {
      let controller = UIViewController()
      controller.view.backgroundColor = .black
      return controller
    }

    return SFSafariViewController(url: url)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

