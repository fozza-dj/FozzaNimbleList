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
                VStack {
                    Text("エラーが発生しました")
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.red)
                    Button("再试一次") {
                        viewModel.fetchHeroListData()
                    }
                }
            } else {
                // ✅ 关键调整：传递 viewModel.sections
                HeroList(sections: viewModel.sections)
            }
        }
        .onAppear {
            // 检查 sections 是否为空
            if viewModel.sections.isEmpty && !viewModel.isLoading {
                viewModel.fetchHeroListData()
            }
        }
    }
}

#Preview {
    NimbelListHomeView()
}
