//
//  WebBar.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 19.10.2021.
//

import SwiftUI

struct WebBar: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var actions: WebActions
    let url: String
    
    var body: some View {
        HStack(spacing: 24) {
            doneButton
            urlField
            reloadButton
                .disabled(actions.shouldLoad == .reload)
                .padding(.trailing, 8)
        }
        .background(Color.black)
        
    }
    
    var doneButton: some View {
        Button(action: {
            actions.reset()
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .font(.headline.bold())
                .foregroundColor(Color.white)
                .padding(.leading, 8)
        }
    }
    
    var urlField: some View {
        ZStack {
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(.white.opacity(0.2))
            Text(url)
                .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                .foregroundColor(.gray)
        }
    }
    
    var reloadButton: some View {
        Button(action: { actions.shouldLoad = .reload }) {
            if actions.shouldLoad != .idle {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Image(systemName: "arrow.clockwise")
                    .foregroundColor(.white)
            }
        }
    }
}

//struct WebBar_Previews: PreviewProvider {
//    static var previews: some View {
//        WebBar(shouldLoad: .constant(.load), url: "google.com")
//            .previewLayout(.sizeThatFits)
//    }
//}
