//
//  SocialButtonStyle.swift
//  CodeLounge
//
//  Created by 김동현 on 4/3/26.
//

import SwiftUI

struct SocialButtonView: View {
  
  enum SocialType {
    case kakao
    case google
    case apple
    
    var title: String {
      switch self {
      case .kakao: return "카카오로 계속하기"
      case .google: return "Google로 계속하기"
      case .apple: return "Apple로 계속하기"
      }
    }
    
    var imageName: String {
      switch self {
      case .kakao: return "Logo Kakao"
      case .google: return "Logo Google"
      case .apple: return "Logo Apple"
      }
    }
    
    var foregroundColor: Color {
      switch self {
      case .kakao: return Color.black.opacity(0.85)
      case .google: return .black
      case .apple: return .white
      }
    }
    
    var backgroundColor: Color {
      switch self {
      case .kakao: return Color("#FEE500")
      case .google: return .white
      case .apple: return .black
      }
    }
    
    var borderColor: Color {
      switch self {
      case .kakao: return .clear
      case .google: return .black
      case .apple: return .white
      }
    }
    
    var borderWidth: CGFloat {
      switch self {
      case .kakao: return 0
      case .google: return 1
      case .apple: return 0.8
      }
    }
    
    var iconColor: Color {
      switch self {
      case .kakao: return .black
      case .google: return .clear
      case .apple: return .white
      }
    }
  }
  
  let type: SocialType
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      
      ZStack {
        // MARK: - 가운데 텍스트
        Text(type.title)
          .font(.system(size: 16, weight: .semibold))
          .frame(maxWidth: .infinity)
        
        // MARK: - 왼쪽 아이콘
        HStack {
          Image(type.imageName)
            .resizable()
            .renderingMode(type == .google ? .original : .template)
            .foregroundColor(type.iconColor)
            .frame(width: 30, height: 30)
          
          Spacer()
        }
      }
      .padding(.horizontal, 45)
      .frame(maxWidth: .infinity)
      .frame(height: 60)
    }
    .frame(maxWidth: .infinity, maxHeight: 60.scaled)
    .foregroundStyle(type.foregroundColor)
    .background(type.backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(type.borderColor, lineWidth: type.borderWidth)
    }
    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
}
