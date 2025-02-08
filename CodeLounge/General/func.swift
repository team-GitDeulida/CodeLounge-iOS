//
//  func.swift
//  CodeLounge
//
//  Created by 김동현 on 2/7/25.
//

import SwiftUI

// MARK: - 몇일 쨰 날짜 비교 함수
func calculateDaySince(_ registerDate: Date) -> Int {
    let currentDate = Date()
    let calendar = Calendar(identifier: .gregorian)
    var calendarInKorea = calendar
    calendarInKorea.timeZone = TimeZone(identifier: "Asia/Seoul")! // 한국 시간대 설정
    
    // 날짜 단위로 비교하여 차이를 계산
    let startOfRegisterDate = calendarInKorea.startOfDay(for: registerDate)
    let startOfCurrentDate = calendarInKorea.startOfDay(for: currentDate)
    
    let days = calendarInKorea.dateComponents([.day], from: startOfRegisterDate, to: startOfCurrentDate).day ?? 0
    return days
}

/*
 MARK: - iphone 15 pro max 기준
 높이 - 932pt
 vstack spacing - 20
 petecntae = 0.3 (화면 높이의 30%)
 
 좌측버튼 높이 - 259.59999999999997
 우측버튼 높이 - 119.79999999999998
 */
func calculateHeight(percentage: CGFloat) -> CGFloat {
    let totalHeight = UIScreen.main.bounds.height
    let spacing: CGFloat = 20 // VStack 내부 spacing(20 * 2) 고려

    return (totalHeight * percentage) - spacing
}

