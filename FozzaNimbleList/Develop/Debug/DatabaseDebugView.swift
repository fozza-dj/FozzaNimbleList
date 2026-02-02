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

private struct DatabaseHeroEditorView: View {
    let hero: HeroModel
    var isNew: Bool = false
    var onSave: () -> Void

    @State private var form: HeroFormModel
    @State private var errorMessage: String?
    @State private var isShowingPossessionPicker = false
    @State private var isShowingEmblemPicker = false

    init(hero: HeroModel, isNew: Bool = false, onSave: @escaping () -> Void) {
        self.hero = hero
        self.isNew = isNew
        self.onSave = onSave
        _form = State(initialValue: HeroFormModel.from(hero: hero))
    }

    var body: some View {
        Form {
            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }

            Section("基础信息") {
                Picker("编号", selection: $form.number) {
                    ForEach(MusouHero.allCases, id: \.self) { hero in
                        Text(hero.debugTitle).tag(hero)
                    }
                }
                TextField("名称", text: $form.name)
                Picker("主势力", selection: $form.mainEmblem) {
                    ForEach(EmblemType.allCases, id: \.self) { emblem in
                        Text(emblem.debugTitle).tag(emblem)
                    }
                }
            }

            Section("印") {
                ForEach(form.possessions.indices, id: \.self) { index in
                    HStack {
                        Picker("印记", selection: $form.possessions[index]) {
                            ForEach(PossessionsType.allCases, id: \.self) { type in
                                Text(type.debugTitle).tag(type)
                            }
                        }
                        Button(role: .destructive) {
                            form.possessions.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }
                    }
                }
                Button {
                    isShowingPossessionPicker = true
                } label: {
                    Label("添加印记", systemImage: "plus.circle")
                }
            }

            Section("特殊系") {
                ForEach(form.emblems.indices, id: \.self) { index in
                    HStack {
                        Picker("特殊系", selection: $form.emblems[index]) {
                            ForEach(EmblemType.allCases, id: \.self) { type in
                                Text(type.debugTitle).tag(type)
                            }
                        }
                        Button(role: .destructive) {
                            form.emblems.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }
                    }
                }
                Button {
                    isShowingEmblemPicker = true
                } label: {
                    Label("添加特殊系", systemImage: "plus.circle")
                }
            }

            Section("召唤技") {
                TextEditor(text: $form.summonSkill)
                    .frame(minHeight: 80)
            }

            Section("固有战法") {
                TextEditor(text: $form.uniqueTactics)
                    .frame(minHeight: 80)
            }

            Section("操作特性") {
                TextEditor(text: $form.playerHeroTrait)
                    .frame(minHeight: 80)
            }

            Section("发动条件") {
                RequiredHeroEditor(title: "指定英杰", heroes: $form.activationRequiredHeroes)
                RequiredAttributeEditor(title: "属性需求", items: $form.activationRequiredAttributes)
                RequiredEmblemEditor(title: "特性需求", items: $form.activationRequiredEmblems)
            }

            Section {
                Toggle("启用强化条件", isOn: $form.upgradeEnabled)
            }

            if form.upgradeEnabled {
                Section("强化条件") {
                    RequiredHeroEditor(title: "指定英杰", heroes: $form.upgradeRequiredHeroes)
                    RequiredAttributeEditor(title: "属性需求", items: $form.upgradeRequiredAttributes)
                    RequiredEmblemEditor(title: "特性需求", items: $form.upgradeRequiredEmblems)
                }
            }

            Section {
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
        .sheet(isPresented: $isShowingPossessionPicker) {
            SelectionSheet(
                title: "选择印记",
                items: PossessionsType.allCases,
                display: { $0.debugTitle }
            ) { selected in
                form.possessions.append(selected)
                isShowingPossessionPicker = false
            }
        }
        .sheet(isPresented: $isShowingEmblemPicker) {
            SelectionSheet(
                title: "选择特殊系",
                items: EmblemType.allCases,
                display: { $0.debugTitle }
            ) { selected in
                form.emblems.append(selected)
                isShowingEmblemPicker = false
            }
        }
    }

    private func save() {
        do {
            let hero = try form.toHeroModel()
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

private struct RequiredHeroEditor: View {
    let title: String
    @Binding var heroes: [MusouHero]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(heroes.indices, id: \.self) { index in
                HStack {
                    Picker("英杰", selection: $heroes[index]) {
                        ForEach(MusouHero.allCases, id: \.self) { hero in
                            Text(hero.debugTitle).tag(hero)
                        }
                    }
                    Button(role: .destructive) {
                        heroes.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                    }
                }
            }

            Button {
                heroes.append(.xiaHouDun)
            } label: {
                Label("添加英杰", systemImage: "plus.circle")
            }
        }
    }
}

private struct RequiredAttributeEditor: View {
    let title: String
    @Binding var items: [AttributeCountItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(items.indices, id: \.self) { index in
                HStack {
                    Picker("属性", selection: $items[index].type) {
                        ForEach(PossessionsType.allCases, id: \.self) { type in
                            Text(type.debugTitle).tag(type)
                        }
                    }
                    Stepper("数量 \(items[index].count)", value: $items[index].count, in: 1...99)
                    Button(role: .destructive) {
                        items.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                    }
                }
            }

            Button {
                items.append(AttributeCountItem(type: .power, count: 1))
            } label: {
                Label("添加属性", systemImage: "plus.circle")
            }
        }
    }
}

private struct RequiredEmblemEditor: View {
    let title: String
    @Binding var items: [EmblemCountItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(items.indices, id: \.self) { index in
                HStack {
                    Picker("特性", selection: $items[index].type) {
                        ForEach(EmblemType.allCases, id: \.self) { type in
                            Text(type.debugTitle).tag(type)
                        }
                    }
                    Stepper("数量 \(items[index].count)", value: $items[index].count, in: 1...99)
                    Button(role: .destructive) {
                        items.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                    }
                }
            }

            Button {
                items.append(EmblemCountItem(type: .wei, count: 1))
            } label: {
                Label("添加特性", systemImage: "plus.circle")
            }
        }
    }
}

private struct SelectionSheet<Item: Hashable>: View {
    let title: String
    let items: [Item]
    let display: (Item) -> String
    let onSelect: (Item) -> Void

    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                Button(display(item)) {
                    onSelect(item)
                }
            }
            .navigationTitle(title)
        }
    }
}

private struct AttributeCountItem {
    var type: PossessionsType
    var count: Int
}

private struct EmblemCountItem {
    var type: EmblemType
    var count: Int
}

private struct HeroFormModel {
    var number: MusouHero
    var name: String
    var possessions: [PossessionsType]
    var emblems: [EmblemType]
    var mainEmblem: EmblemType
    var summonSkill: String
    var uniqueTactics: String
    var playerHeroTrait: String

    var activationRequiredHeroes: [MusouHero]
    var activationRequiredAttributes: [AttributeCountItem]
    var activationRequiredEmblems: [EmblemCountItem]

    var upgradeEnabled: Bool
    var upgradeRequiredHeroes: [MusouHero]
    var upgradeRequiredAttributes: [AttributeCountItem]
    var upgradeRequiredEmblems: [EmblemCountItem]

    static func from(hero: HeroModel) -> HeroFormModel {
        let activationHeroes = (hero.activationCondition.requiredHeroes ?? [])
            .compactMap { MusouHero(rawValue: Int($0)) }
        let activationAttributes = (hero.activationCondition.requiredAttributeDict ?? [:]).map {
            AttributeCountItem(type: $0.key, count: Int($0.value))
        }
        let activationEmblems = (hero.activationCondition.requiredEmblemTypeDict ?? [:]).map {
            EmblemCountItem(type: $0.key, count: Int($0.value))
        }

        let upgrade = hero.upgradeCondition
        let upgradeHeroes = (upgrade?.requiredHeroes ?? [])
            .compactMap { MusouHero(rawValue: Int($0)) }
        let upgradeAttributes = (upgrade?.requiredAttributeDict ?? [:]).map {
            AttributeCountItem(type: $0.key, count: Int($0.value))
        }
        let upgradeEmblems = (upgrade?.requiredEmblemTypeDict ?? [:]).map {
            EmblemCountItem(type: $0.key, count: Int($0.value))
        }

        return HeroFormModel(
            number: hero.number,
            name: hero.name,
            possessions: hero.possessions,
            emblems: hero.emblems,
            mainEmblem: hero.mainEmblem,
            summonSkill: hero.summonSkill,
            uniqueTactics: hero.uniqueTactics,
            playerHeroTrait: hero.playerHeroTrait,
            activationRequiredHeroes: activationHeroes,
            activationRequiredAttributes: activationAttributes,
            activationRequiredEmblems: activationEmblems,
            upgradeEnabled: upgrade != nil,
            upgradeRequiredHeroes: upgradeHeroes,
            upgradeRequiredAttributes: upgradeAttributes,
            upgradeRequiredEmblems: upgradeEmblems
        )
    }

    func toHeroModel() throws -> HeroModel {
        let activation = ActivationCondition(
            requiredHeroes: activationRequiredHeroes.isEmpty
                ? nil
                : activationRequiredHeroes.map { UInt($0.rawValue) },
            requiredAttributeDict: makeAttributeDict(from: activationRequiredAttributes),
            requiredEmblemTypeDict: makeEmblemDict(from: activationRequiredEmblems)
        )

        let upgrade: ActivationCondition?
        if upgradeEnabled {
            upgrade = ActivationCondition(
                requiredHeroes: upgradeRequiredHeroes.isEmpty
                    ? nil
                    : upgradeRequiredHeroes.map { UInt($0.rawValue) },
                requiredAttributeDict: makeAttributeDict(from: upgradeRequiredAttributes),
                requiredEmblemTypeDict: makeEmblemDict(from: upgradeRequiredEmblems)
            )
        } else {
            upgrade = nil
        }

        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw NSError(domain: "DBDebug", code: 2, userInfo: [NSLocalizedDescriptionKey: "名称不能为空"])
        }

        return HeroModel(
            number: number,
            name: name,
            possessions: possessions,
            emblems: emblems,
            mainEmblem: mainEmblem,
            summonSkill: summonSkill,
            upgradeCondition: upgrade,
            uniqueTactics: uniqueTactics,
            activationCondition: activation,
            playerHeroTrait: playerHeroTrait
        )
    }

    private func makeAttributeDict(from items: [AttributeCountItem]) -> [PossessionsType: UInt]? {
        let filtered = items.filter { $0.count > 0 }
        if filtered.isEmpty {
            return nil
        }
        return filtered.reduce(into: [PossessionsType: UInt]()) { acc, item in
            acc[item.type] = UInt(item.count)
        }
    }

    private func makeEmblemDict(from items: [EmblemCountItem]) -> [EmblemType: UInt]? {
        let filtered = items.filter { $0.count > 0 }
        if filtered.isEmpty {
            return nil
        }
        return filtered.reduce(into: [EmblemType: UInt]()) { acc, item in
            acc[item.type] = UInt(item.count)
        }
    }
}

private extension MusouHero {
    var debugTitle: String {
        "\(rawValue) - \(String(describing: self))"
    }
}

private extension EmblemType {
    var debugTitle: String {
        "\(rawValue) - \(String(describing: self))"
    }
}

private extension PossessionsType {
    var debugTitle: String {
        "\(rawValue) - \(String(describing: self))"
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
