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
                    NavigationLink(hero.name) {
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

private struct DatabaseHeroEditorView: View {
    let hero: HeroModel
    var isNew: Bool = false
    var onSave: () -> Void

    @State private var jsonText: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 12) {
            TextEditor(text: $jsonText)
                .font(.system(.footnote, design: .monospaced))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                )

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            HStack {
                Button(isNew ? "新增" : "保存") {
                    save()
                }
                .buttonStyle(.borderedProminent)

                if !isNew {
                    Button("删除") {
                        deleteHero()
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
        .padding()
        .onAppear {
            jsonText = DatabaseDebugViewModel.encode(hero: hero)
        }
    }

    private func save() {
        do {
            let hero = try DatabaseDebugViewModel.decodeHero(from: jsonText)
            try HeroRepository.shared.upsertHero(hero)
            errorMessage = nil
            onSave()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteHero() {
        do {
            try HeroRepository.shared.deleteHero(number: hero.number.rawValue)
            onSave()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

@MainActor
final class DatabaseDebugViewModel: ObservableObject {
    @Published var heroes: [HeroModel] = []
    @Published var errorMessage: String?

    static let heroTemplate = HeroModel(
        number: .xiaHouDun,
        name: "新英杰",
        possessions: [.power],
        emblems: [.wei],
        mainEmblem: .wei,
        summonSkill: "技能描述",
        upgradeCondition: nil,
        uniqueTactics: "战法描述",
        activationCondition: ActivationCondition(),
        playerHeroTrait: "特性描述"
    )

    func refresh() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try HeroRepository.shared.setupIfNeeded()
                let heroes = try HeroRepository.shared.fetchAllHeroes()
                DispatchQueue.main.async {
                    self.heroes = heroes
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func seedMockData() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let count = try HeroRepository.shared.seedFromMockIfNeeded()
                DispatchQueue.main.async {
                    self.errorMessage = count > 0 ? "✅ 已写入 \(count) 条数据" : "⚠️ 未写入数据"
                    self.refresh()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func delete(hero: HeroModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try HeroRepository.shared.deleteHero(number: hero.number.rawValue)
                DispatchQueue.main.async {
                    self.refresh()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    static func encode(hero: HeroModel) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(hero),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "{}"
    }

    static func decodeHero(from json: String) throws -> HeroModel {
        guard let data = json.data(using: .utf8) else {
            throw NSError(domain: "DBDebug", code: 1, userInfo: [NSLocalizedDescriptionKey: "JSON 编码失败"])
        }
        let decoder = JSONDecoder()
        return try decoder.decode(HeroModel.self, from: data)
    }
}

#if DEBUG
#Preview {
    DatabaseDebugView()
}
#endif
