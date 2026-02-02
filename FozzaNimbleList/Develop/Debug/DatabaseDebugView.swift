//
//  DatabaseDebugView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import SwiftUI

struct DatabaseDebugView: View {
    @StateObject private var viewModel = DatabaseDebugViewModel()
    @State private var isPresentingAdd = false

    var body: some View {
        NavigationStack {
            List {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                ForEach(viewModel.heroes) { hero in
                    NavigationLink("\(hero.name) #\(hero.number.rawValue)") {
                        DatabaseHeroEditorView(hero: hero) {
                            viewModel.refresh()
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let hero = viewModel.heroes[index]
                        viewModel.delete(hero: hero)
                    }
                }
            }
            .navigationTitle("DB 调试工具")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Seed Mock") {
                        viewModel.seedMockData()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAdd) {
                NavigationStack {
                    DatabaseHeroEditorView(hero: DatabaseDebugViewModel.heroTemplate, isNew: true) {
                        viewModel.refresh()
                        isPresentingAdd = false
                    }
                    .navigationTitle("新增英雄")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("关闭") {
                                isPresentingAdd = false
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}

#if DEBUG
#Preview {
    DatabaseDebugView()
}
#endif
