//
//  DatabaseDebugEditors.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import SwiftUI

struct RequiredHeroEditor: View {
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
            .buttonStyle(.bordered)
        }
    }
}

struct RequiredAttributeEditor: View {
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
            .buttonStyle(.bordered)
        }
    }
}

struct RequiredEmblemEditor: View {
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
            .buttonStyle(.bordered)
        }
    }
}
