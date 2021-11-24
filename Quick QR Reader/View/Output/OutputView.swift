//
//  OutputView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 22.10.2021.
//

import SwiftUI

struct OutputView: View {
    @Environment(\.presentationMode) var presentationMode
    let previousScreen: String
    let content: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                header
                    .padding(.top, geometry.safeAreaInsets.top + 8)
                contentBody
                Spacer()
                shareButton
                    .font(.system(size: geometry.size.height/35))
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
    
    var header: some View {
        TopHeader(previousScreen: previousScreen, color: .blue) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var contentBody: some View {
        ScrollView {
            Text(content)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    Rectangle()
                        .foregroundColor(.white.opacity(0.2))
                        .cornerRadius(8)
                )
        }
    }
    
    var shareButton: some View {
        HStack {
            Spacer()
            Button(action: {
                share(items: [content])
            }) {
                Image(systemName: "square.and.arrow.up")
                    .padding(8)
                    .background(Circle().stroke(lineWidth: 2))
            }
        }
        .foregroundColor(.white)
        .padding()
    }
}

struct OutputView_Previews: PreviewProvider {
    static var previews: some View {
        OutputView(previousScreen: "Main", content: "DenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDenemeDeneme")
    }
}
