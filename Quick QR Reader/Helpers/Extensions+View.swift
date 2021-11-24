//
//  Extensions+View.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

extension View {
    var screenName: String {
        var screenName = String(describing: Self.self)
        if screenName.hasSuffix("View") {
            screenName = String(screenName.dropLast(4))
        }
        return screenName
    }
    
    func createImage(systemName: String, size: CGFloat) -> some View {
        Image(systemName: systemName)
            .renderingMode(.original)
            .resizable()
            .frame(width: size, height: size)
    }
    
    func loading(isPresented: Binding<Bool>) -> some View {
        modifier(Loading(isPresented: isPresented))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
    
    func share(items: [Any], completion: @escaping (() -> Void) = {}) {
        let shareSheet = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        UIApplication.shared.windows.last?.rootViewController?.present(
            shareSheet,
            animated: true,
            completion: { completion() }
        )
    }
    
    @ViewBuilder
    func presentOutput(_ value: String) -> some View {
        if let url = URL(string: value), UIApplication.shared.canOpenURL(url) {
            Web(url: url)
        } else {
            OutputView(previousScreen: screenName, content: value)
        }
    }
}
