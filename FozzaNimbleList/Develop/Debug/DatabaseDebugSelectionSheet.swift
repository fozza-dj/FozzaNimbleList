//
//  DatabaseDebugSelectionSheet.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import SwiftUI

struct SelectionSheet<Item: Hashable>: View {
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

extension MusouHero {
    var debugTitle: String {
        "\(rawValue) - \(String(describing: self))"
    }
}

extension EmblemType {
    var debugTitle: String {
        "\(rawValue) - \(String(describing: self))"
    }
}

extension PossessionsType {
    var debugTitle: String {
        "\(rawValue) - \(String(describing: self))"
    }
}
