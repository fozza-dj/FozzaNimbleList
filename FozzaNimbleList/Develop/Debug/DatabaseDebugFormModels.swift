//
//  DatabaseDebugFormModels.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import Foundation

struct AttributeCountItem {
    var type: PossessionsType
    var count: Int
}

struct EmblemCountItem {
    var type: EmblemType
    var count: Int
}

struct HeroFormModel {
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
