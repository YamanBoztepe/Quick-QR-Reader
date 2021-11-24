//
//  GeneratorView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 21.11.2021.
//

import SwiftUI

struct GeneratorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var keyboardManager = KeyboardManager()
    @State var text: String = ""
    let viewModel = GeneratorViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                header
                    .padding(.top, geometry.safeAreaInsets.top + 8)
                content
                Spacer()
                generateButton
                    .frame(width: geometry.size.width/3, height: geometry.size.width/3)
                    .offset(x: 0, y: keyboardManager.offset)
            }
            .background(Color.black)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .onTapGesture { hideKeyboard() }
            .onAppear {
                text = StoreData.getData(as: String.self, key: .generatorText) ?? ""
                viewModel.isCodeGenerated = false
            }
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    viewModel.save(text: text)
                }
            }
        }
    }
    
    var header: some View {
        TopHeader(previousScreen: "Main", color: .blue) {
            viewModel.save(text: text)
            presentationMode.wrappedValue.dismiss()
        }
        .frame(height: 30)
        .padding(.bottom, 8)
    }
    
    var content: some View {
        TextEditor(text: $text)
            .foregroundColor(.white)
            .padding()
            .background(
                Rectangle()
                    .foregroundColor(.white.opacity(0.2))
                    .cornerRadius(8)
            )
    }
    
    var generateButton: some View {
        Button(action: {
            viewModel.generateQRCode(from: text) { image in
                if let image = image {
                    share(items: [image]) {
                        hideKeyboard()
                        viewModel.isCodeGenerated = true
                    }
                }
            }
        }) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                Text("Generate")
                    .bold()
                    .padding()
            }
            .foregroundColor(.blue)
            .padding(.vertical, 10)
        }
    }
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
}

struct GeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
