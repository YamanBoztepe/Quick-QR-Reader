//
//  KeyboardManager.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 21.11.2021.
//

import SwiftUI

class KeyboardManager: ObservableObject {
    @Published var offset: CGFloat = 0
    
    init() {
        observeKeyboard()
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getKeyboardHeight(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    @objc private func getKeyboardHeight(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let startFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
              let time = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let distanceY = endFrame.origin.y - startFrame.origin.y
        withAnimation(.linear(duration: time)) {
            offset += distanceY
        }
    }
}
