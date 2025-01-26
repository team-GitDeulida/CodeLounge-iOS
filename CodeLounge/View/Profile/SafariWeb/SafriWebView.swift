//
//  SafriWebView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/26/25.
//

import SwiftUI
import SafariServices

struct SafriWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
