//
//  NimbelListHomeView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/3/25.
//

import SwiftUI

struct NimbelListHomeView: View {
    @StateObject private var viewModel = HeroListViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("...loading")
            } else if let error = viewModel.error {
                Text("エラーが発生しました: \(error.localizedDescription)")
            } else {
                HeroList(heroList: viewModel.heroList)
            }
        }
        .onAppear {
            viewModel.fetchHeroList()
        }
    }
}

#Preview {
    NimbelListHomeView()
}
