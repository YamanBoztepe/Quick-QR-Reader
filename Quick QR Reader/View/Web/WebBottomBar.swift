//
//  WebBottomBar.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 22.10.2021.
//

import SwiftUI

struct WebBottomBar: View {
    @Binding var actions: WebActions
    
    var body: some View {
        HStack(spacing: 24) {
            redirectButtons
            Spacer()
            safariButton
            shareButton
        }
        .padding(8)
        .foregroundColor(.white)
        .background(Color.black)
    }
    
    var redirectButtons: some View {
        HStack(spacing: 48) {
            Button(action: { actions.backButtonTapped.toggle() }) {
                Image(systemName: "chevron.backward")
            }
            .disabled(!actions.canGoBack)
            .foregroundColor(!actions.canGoBack ? .gray : .white)
            
            Button(action: { actions.forwardButtonTapped.toggle() }) {
                Image(systemName: "chevron.forward")
            }
            .disabled(!actions.canGoForward)
            .foregroundColor(!actions.canGoForward ? .gray : .white)
        }
    }
    
    var safariButton: some View {
        Button(action: { actions.safariButtonTapped.toggle() }) {
            Image(systemName: "safari")
        }
    }
    
    var shareButton: some View {
        Button(action: { actions.shareButtonTapped.toggle() }) {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
}

struct WebBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        WebBottomBar(actions: .constant(WebActions(shouldLoad: .load, backButtonTapped: false, safariButtonTapped: false, forwardButtonTapped: false, shareButtonTapped: false)))
            .previewLayout(.sizeThatFits)
    }
}
