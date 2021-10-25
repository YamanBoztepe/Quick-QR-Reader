//
//  HistoryView.swift
//  Quick QR Reader
//
//  Created by Yaman Boztepe on 11.10.2021.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                topHeader
                    .padding(.top, geometry.safeAreaInsets.top + 8)
                historyBody
                favoritesBody
                Spacer()
            }
            .padding(.bottom, geometry.safeAreaInsets.bottom)
            .background(Color.black)
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .onAppear(perform: viewModel.getData)
            .onReceive(viewModel.timer) { _ in viewModel.winkEffect() }
            .onChange(of: viewModel.presentableData.shouldPresent) { _ in
                viewModel.stopTimer()
            }
            .fullScreenCover(isPresented: $viewModel.presentableData.shouldPresent) {
                presentOutput(viewModel.presentableData.content)
            }
        }
    }
    
    // MARK:- Top Header
    var topHeader: some View {
        TopHeader(previousScreen: "Main", color: .blue) {
            self.presentationMode.wrappedValue.dismiss()
        }
        .frame(height: 30)
        .padding(.bottom, 8)
        
    }
    
    // MARK:- History
    @ViewBuilder
    var historyBody: some View {
        if viewModel.isHistoryHidden {
            historyHeader
        } else {
            scrollableHistory
        }
    }
    
    var historyHeader: some View {
        SectionHeader(value: $viewModel.isHistoryHidden, text: "History", color: .white)
            .frame(height: 50)
            .background(
                Rectangle()
                    .foregroundColor(
                        .white.opacity(viewModel.isFavHidden ? 0.2 : viewModel.dynamicOpacity)
                    )
            )
            .cornerRadius(8)
            .padding(.bottom, 8)
    }
    
    var scrollableHistory: some View {
        ScrollView(.vertical) {
            SectionHeader(value: $viewModel.isHistoryHidden, text: "History", color: .white)
            if viewModel.data.isEmpty {
                Text("You don't have any scan history to display.")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
            } else {
                LazyVStack {
                    ForEach(viewModel.data.indices) { index in
                        HistoryDataView(qrModel: $viewModel.data[index],
                                        presentableData: $viewModel.presentableData,
                                        saveData: viewModel.saveData)
                    }
                }
            }
        }
    }
    
    // MARK:- Favorites
    @ViewBuilder
    var favoritesBody: some View {
        if viewModel.isFavHidden {
            favoritesHeader
        } else {
            scrollableFavorite
        }
    }
    
    var favoritesHeader: some View {
        SectionHeader(value: $viewModel.isFavHidden, text: "Favorites",color: .white)
            .frame(height: 50)
            .background(
                Rectangle()
                    .foregroundColor(
                        .white.opacity(viewModel.isHistoryHidden ? 0.2 : viewModel.dynamicOpacity)
                    )
            )
            .cornerRadius(8)
    }
    
    var scrollableFavorite: some View {
        ScrollView(.vertical) {
            SectionHeader(value: $viewModel.isFavHidden, text: "Favorites", color: .white)
            if viewModel.data.contains(where: { $0.isFavorite }) {
                LazyVStack {
                    ForEach(viewModel.data.indices) { index in
                        if viewModel.data[index].isFavorite {
                            HistoryDataView(qrModel: $viewModel.data[index],
                                            presentableData: $viewModel.presentableData,
                                            saveData: viewModel.saveData)
                        }
                    }
                }
            } else {
                Text("Please tap heart icons in the history section to add as favorites.")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
