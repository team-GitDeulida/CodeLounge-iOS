//
//  ProfileSettingView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/26/25.
//

import SwiftUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var nickname: String = ""                             // 닉네임입력
    @State private var nicknameMessage: String? = nil                    // 닉네임 오류 메시지
    @State private var birthdate: Date = Date()                          // 기본값: 2000년 1월 1일
    @State private var isDatePickerActive: Bool = false                  // 생일입력
    @State private var selectedGender: Gender = .male                    // 성별입력

    
    // 닉네임이 유효한지 검사하는 프로퍼티
    private var isNicknameValid: Bool {
        !nickname.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // 생년월일 날짜 포맷터
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }
    
    // 전송용 생년월일 날짜 포맷터
    private var isoDateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // KST 설정
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("프로필 수정")
                .font(.system(size: 30, weight: .bold))
                .padding(.bottom, 10)
                .foregroundColor(Color.mainWhite)
            
            Spacer()
                .frame(height: 10)
            
            Text("닉네임")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.mainWhite)
            
            TextField("2자 이상 20자 이하로 입력해주세요", text: $nickname)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.5)
                        .foregroundColor(Color.mainWhite)
                )
  
                
            if let message = nicknameMessage {
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
                .frame(height: 10)
            
            Text("생년월일")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.mainWhite)
            
            Button {
                isDatePickerActive.toggle()
            } label: {
                Text("\(dateFormatter.string(from: birthdate))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.mainWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    //.background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1.5)
                            .foregroundColor(Color.mainWhite)
                    )
            }
            
            Spacer()
                .frame(height: 10)
            
            Text("성별")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                GenderButton(gender: .male, isSelected: $selectedGender)
                GenderButton(gender: .female, isSelected: $selectedGender)
                GenderButton(gender: .other, isSelected: $selectedGender)
            }
            
            Spacer()
            
            Button {
                
                if isNicknameValid {
                    authViewModel.send(action: .checkNicknameDuplicate(nickname) { isDuplicate in
                        
                        if isDuplicate {
                            nicknameMessage = "닉네임이 중복되었습니다"
                        } else {
                            // 업데이트 성공
                            nicknameMessage = nil
                            let birthdayString = isoDateFormatter.string(from: birthdate)
                            let genderString = selectedGender.rawValue
                            authViewModel.send(action: .updateUserInfo(nickname, birthdayString, genderString))
                            dismiss()
                        }
                    })
                }
                 
                
            } label: {
                Text("완료")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.mainBlack)
                    .background(!nickname.isEmpty ? Color.mainWhite : Color.gray)
                    .cornerRadius(20)
            }
            .disabled(nickname.isEmpty)
            .padding(.bottom, 50)
            
            
        }
        .padding(.horizontal, 25)
        .sheet(isPresented: $isDatePickerActive) {
            BirthdayPickerView(birthdate: $birthdate)
                .presentationDetents([.fraction(0.5)])
        }
        .background(Color.mainBlack)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .foregroundColor(Color.mainGreen)
            }
        }
    }
    
}

#Preview {
    ProfileSettingView()
}


// MARK: - 생년월일 선택
private struct BirthdayPickerView: View {
    @Binding var birthdate: Date
    @Environment(\.dismiss) private var dismiss // sheet 닫기
    
    fileprivate var body: some View {
        VStack {
             Text("생년월일 선택")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 50)
                .font(.system(size: 20, weight: .bold))
                
            DatePicker(
                "생년얼일",
                selection: $birthdate,
                in: ...Date(), // 현재 날짜까지 선택 가능
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
                    .foregroundColor(Color.mainBlack)
                    .background(Color.mainWhite)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 40)
            
        }
    }
}

// MARK: - 성별 버튼
private struct GenderButton: View {
    
    // 성별
    var gender: Gender
    
    // 선택유무
    @Binding var isSelected: Gender
    
    fileprivate var  body: some View {
        Button {
            isSelected = gender
        } label: {
            Text(gender.rawValue)
                .foregroundColor(isSelected == gender ? Color.mainBlack : Color.mainWhite)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected == gender ? Color.mainWhite : Color.mainBlack) // 선택 여부에 따라 배경색 변경
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1.5)
                .foregroundColor(Color.mainWhite)
        )
    }
}
