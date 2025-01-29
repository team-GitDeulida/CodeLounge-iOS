//
//  CustomTextField.swift
//  CodeLounge
//
//  Created by 김동현 on 1/29/25.
//

import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var horizontalPadding: CGFloat = 15 // ✅ 좌우 패딩 값을 하나의 변수로 추가

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // ✅ 엔터 누르면 키보드 닫기
            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor(Color.subBlack)
        textField.layer.cornerRadius = 10
        textField.textColor = .white
        textField.returnKeyType = .done

        // ✅ 좌측 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: horizontalPadding, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always

        // ✅ 우측 패딩 추가
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: horizontalPadding, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always

        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChangeSelection(_:)), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
    
    // ✅ 외부 터치 시 키보드를 닫는 메서드 추가
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
