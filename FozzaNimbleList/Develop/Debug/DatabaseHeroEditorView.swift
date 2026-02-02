//
//  DatabaseHeroEditorView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import SwiftUI

struct DatabaseHeroEditorView: View {
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
                .buttonStyle(.bordered)
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
                .buttonStyle(.bordered)
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
