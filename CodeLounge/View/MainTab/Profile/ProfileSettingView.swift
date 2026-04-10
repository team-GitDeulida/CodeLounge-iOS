//
//  ProfileSettingView.swift
//  CodeLounge
//
//  Created by 김동현 on 4/9/26.
//

import SwiftUI

struct ProfileSettingView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var rootViewModel: RootViewModel

  @State private var nickname: String = ""
  @State private var birthdate: Date = Date()
  @State private var isDatePickerActive = false
  @State private var selectedGender: Gender = .male

  private var isNicknameValid: Bool {
    !nickname.trimmingCharacters(in: .whitespaces).isEmpty
  }

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy. MM. dd"
    return formatter
  }

  private var isoDateFormatter: ISO8601DateFormatter {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }

  var body: some View {
    VStack(spacing: 12) {
      Text("프로필 수정")
        .font(.system(size: 28, weight: .bold))
        .foregroundStyle(Color.mainWhite)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)

      profileFieldTitle("닉네임")

      TextField("2자 이상 20자 이하로 입력해주세요", text: $nickname)
        .padding()
        .foregroundStyle(Color.mainWhite)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.mainWhite, lineWidth: 1.5)
        )

      if let nicknameMessage = rootViewModel.nicknameValidationMessage {
        Text(nicknameMessage)
          .font(.caption)
          .foregroundStyle(.red)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      profileFieldTitle("생년월일")

      Button {
        isDatePickerActive = true
      } label: {
        Text(dateFormatter.string(from: birthdate))
          .frame(maxWidth: .infinity, alignment: .leading)
          .foregroundStyle(Color.mainWhite)
          .padding()
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.mainWhite, lineWidth: 1.5)
          )
      }

      profileFieldTitle("성별")

      HStack {
        ProfileGenderButton(gender: .male, isSelected: $selectedGender)
        ProfileGenderButton(gender: .female, isSelected: $selectedGender)
        ProfileGenderButton(gender: .other, isSelected: $selectedGender)
      }

      Spacer()
    }
    .padding(.horizontal, 24)
    .padding(.top, 24)
    .safeAreaInset(edge: .bottom) {
      Button {
        submit()
      } label: {
        Text("완료")
          .padding()
          .frame(maxWidth: .infinity)
          .foregroundStyle(Color.mainBlack)
          .background(isNicknameValid ? Color.mainWhite : Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: 20))
      }
      .disabled(!isNicknameValid)
      .padding(.horizontal, 24)
      .padding(.top, 12)
      .padding(.bottom, 20)
      .background(Color.mainBlack)
    }
    .background(Color.mainBlack.ignoresSafeArea())
    .sheet(isPresented: $isDatePickerActive) {
      ProfileBirthdayPickerView(birthdate: $birthdate)
        .presentationDetents([.fraction(0.5)])
    }
    // 커스텀 네비게이션바 사용
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .foregroundStyle(Color.mainGreen)
        }
      }
    }
    .toolbar(.hidden, for: .tabBar)
    .onAppear {
      setTabBarHidden(true)
      rootViewModel.nicknameValidationMessage = nil
      nickname = rootViewModel.user?.nickname ?? ""
      birthdate = rootViewModel.user?.birthdayDate ?? Date()
      selectedGender = rootViewModel.user?.gender ?? .male
    }
    .onDisappear {
      setTabBarHidden(false)
    }
    .onChange(of: nickname) { _, _ in
      rootViewModel.nicknameValidationMessage = nil
    }
  }

  @ViewBuilder
  private func profileFieldTitle(_ title: String) -> some View {
    Text(title)
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(Color.mainWhite)
  }

  private func submit() {
    guard isNicknameValid else { return }

    rootViewModel.send(action: .checkNicknameDuplicate(nickname) { isDuplicate in
      let currentNickname = rootViewModel.user?.nickname ?? ""

      if isDuplicate, nickname != currentNickname {
        return
      }

      rootViewModel.send(
        action: .updateUserInfo(
          nickname,
          isoDateFormatter.string(from: birthdate),
          selectedGender.rawValue
        )
      )
      dismiss()
    })
  }

  private func setTabBarHidden(_ isHidden: Bool) {
    DispatchQueue.main.async {
      let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
      let windows = windowScenes.flatMap(\.windows)

      for window in windows {
        if let rootViewController = window.rootViewController {
          updateTabBarVisibility(in: rootViewController, isHidden: isHidden)
        }
        updateTabBarVisibilityInViewHierarchy(in: window, isHidden: isHidden)
      }
    }
  }

  private func updateTabBarVisibility(in viewController: UIViewController, isHidden: Bool) {
    if let tabBarController = viewController as? UITabBarController {
      tabBarController.tabBar.isHidden = isHidden
    }

    for child in viewController.children {
      updateTabBarVisibility(in: child, isHidden: isHidden)
    }

    if let presentedViewController = viewController.presentedViewController {
      updateTabBarVisibility(in: presentedViewController, isHidden: isHidden)
    }
  }

  private func updateTabBarVisibilityInViewHierarchy(in view: UIView, isHidden: Bool) {
    if let tabBar = view as? UITabBar {
      tabBar.isHidden = isHidden
      tabBar.alpha = isHidden ? 0 : 1
      tabBar.isUserInteractionEnabled = !isHidden
    }

    for subview in view.subviews {
      updateTabBarVisibilityInViewHierarchy(in: subview, isHidden: isHidden)
    }
  }
}

private struct ProfileBirthdayPickerView: View {
  @Binding var birthdate: Date
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack {
      Text("생년월일 선택")
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 40)
        .font(.system(size: 20, weight: .bold))

      DatePicker(
        "생년월일",
        selection: $birthdate,
        in: ...Date(),
        displayedComponents: .date
      )
      .datePickerStyle(.wheel)
      .labelsHidden()
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.mainWhite, lineWidth: 1.5)
      )
      .environment(\.locale, Locale(identifier: "ko_KR"))

      Spacer()
        .frame(height: 30)

      Button {
        dismiss()
      } label: {
        Text("완료")
          .padding()
          .frame(maxWidth: .infinity)
          .foregroundStyle(Color.mainBlack)
          .background(Color.mainWhite)
          .clipShape(RoundedRectangle(cornerRadius: 20))
      }
      .padding(.horizontal, 40)
    }
    .padding(.top, 20)
    .background(Color.mainBlack.ignoresSafeArea())
  }
}

private struct ProfileGenderButton: View {
  let gender: Gender
  @Binding var isSelected: Gender

  var body: some View {
    Button {
      isSelected = gender
    } label: {
      Text(gender.rawValue)
        .foregroundStyle(isSelected == gender ? Color.mainBlack : Color.mainWhite)
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected == gender ? Color.mainWhite : Color.mainBlack)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.mainWhite, lineWidth: 1.5)
    )
  }
}
