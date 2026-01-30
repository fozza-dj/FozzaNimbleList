//
//  HeroRepository.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import Foundation
import WCDBSwift

final class HeroRepository {
    static let shared = HeroRepository()

    private let database: Database

    private init() {
        database = HeroDatabase.shared.database
    }

    func setupIfNeeded() throws {
        try HeroDatabase.shared.setupIfNeeded()
    }

    func fetchAllHeroes() throws -> [HeroModel] {
        let heroEntities: [HeroEntity] = try database.getObjects(fromTable: HeroEntity.tableName)
        let heroes = try heroEntities.compactMap { entity in
            try buildHero(from: entity)
        }
        return heroes.sorted { $0.number.rawValue < $1.number.rawValue }
    }

    func fetchHero(number: Int) throws -> HeroModel? {
        let heroEntities: [HeroEntity] = try database.getObjects(
            fromTable: HeroEntity.tableName,
            where: HeroEntity.Properties.number == number
        )
        guard let entity = heroEntities.first else { return nil }
        return try buildHero(from: entity)
    }

    func upsertHero(_ hero: HeroModel) throws {
        try setupIfNeeded()
        try database.run(transaction: { _ in
            try self.upsertHeroInTransaction(hero)
        })
    }

    func upsertHeroes(_ heroes: [HeroModel]) throws {
        try setupIfNeeded()
        try database.run(transaction: { _ in
            for hero in heroes {
                try self.upsertHeroInTransaction(hero)
            }
        })
    }

    func deleteHero(number: Int) throws {
        try setupIfNeeded()
        try database.run(transaction: { _ in
            try self.database.delete(fromTable: HeroEntity.tableName, where: HeroEntity.Properties.number == number)
            try self.deleteRelations(for: number)
        })
    }

    func deleteAllHeroes() throws {
        try setupIfNeeded()
        try database.run(transaction: { _ in
            try self.database.delete(fromTable: HeroEntity.tableName)
            try self.database.delete(fromTable: HeroPossessionEntity.tableName)
            try self.database.delete(fromTable: HeroEmblemEntity.tableName)
            try self.database.delete(fromTable: HeroRequiredHeroEntity.tableName)
            try self.database.delete(fromTable: HeroRequiredAttributeEntity.tableName)
            try self.database.delete(fromTable: HeroRequiredEmblemEntity.tableName)
        })
    }

    func seedFromMockIfNeeded() throws -> Int {
        try setupIfNeeded()
        let existing: [HeroEntity] = try database.getObjects(fromTable: HeroEntity.tableName)
        if !existing.isEmpty {
            return existing.count
        }
        guard let heroes = HeroJSONLoader.loadHeroList(fromFile: "MockedHeroList") else {
            return 0
        }
        try upsertHeroes(heroes)
        return heroes.count
    }

    private func buildHero(from entity: HeroEntity) throws -> HeroModel? {
        guard let heroNumber = MusouHero(rawValue: entity.number) else {
            return nil
        }

        let possessions = try fetchPossessions(for: entity.number)
        let emblems = try fetchEmblems(for: entity.number)

        let activation = try fetchCondition(for: entity.number, kind: .activation)
        let upgrade = try fetchCondition(for: entity.number, kind: .upgrade)

        return HeroModel(
            number: heroNumber,
            name: entity.name,
            possessions: possessions,
            emblems: emblems,
            mainEmblem: EmblemType(rawValue: entity.mainEmblem) ?? .wei,
            summonSkill: entity.summonSkill,
            upgradeCondition: upgrade,
            uniqueTactics: entity.uniqueTactics,
            activationCondition: activation ?? ActivationCondition(),
            playerHeroTrait: entity.playerHeroTrait
        )
    }

    private func fetchPossessions(for heroNumber: Int) throws -> [PossessionsType] {
        let items: [HeroPossessionEntity] = try database.getObjects(
            fromTable: HeroPossessionEntity.tableName,
            where: HeroPossessionEntity.Properties.heroNumber == heroNumber
        )
        return items.compactMap { PossessionsType(rawValue: $0.possessionRawValue) }
    }

    private func fetchEmblems(for heroNumber: Int) throws -> [EmblemType] {
        let items: [HeroEmblemEntity] = try database.getObjects(
            fromTable: HeroEmblemEntity.tableName,
            where: HeroEmblemEntity.Properties.heroNumber == heroNumber
        )
        return items.compactMap { EmblemType(rawValue: $0.emblemRawValue) }
    }

    private func fetchCondition(for heroNumber: Int, kind: ConditionKind) throws -> ActivationCondition? {
        let requiredHeroes: [HeroRequiredHeroEntity] = try database.getObjects(
            fromTable: HeroRequiredHeroEntity.tableName,
            where: HeroRequiredHeroEntity.Properties.heroNumber == heroNumber
                && HeroRequiredHeroEntity.Properties.conditionKind == kind.rawValue
        )

        let requiredAttributes: [HeroRequiredAttributeEntity] = try database.getObjects(
            fromTable: HeroRequiredAttributeEntity.tableName,
            where: HeroRequiredAttributeEntity.Properties.heroNumber == heroNumber
                && HeroRequiredAttributeEntity.Properties.conditionKind == kind.rawValue
        )

        let requiredEmblems: [HeroRequiredEmblemEntity] = try database.getObjects(
            fromTable: HeroRequiredEmblemEntity.tableName,
            where: HeroRequiredEmblemEntity.Properties.heroNumber == heroNumber
                && HeroRequiredEmblemEntity.Properties.conditionKind == kind.rawValue
        )

        if requiredHeroes.isEmpty && requiredAttributes.isEmpty && requiredEmblems.isEmpty {
            return nil
        }

        let heroNumbers = requiredHeroes.map { UInt($0.requiredHeroNumber) }
        let attributeDict = requiredAttributes.reduce(into: [PossessionsType: UInt]()) { acc, item in
            if let type = PossessionsType(rawValue: item.attributeRawValue) {
                acc[type] = UInt(item.count)
            }
        }
        let emblemDict = requiredEmblems.reduce(into: [EmblemType: UInt]()) { acc, item in
            if let type = EmblemType(rawValue: item.emblemRawValue) {
                acc[type] = UInt(item.count)
            }
        }

        return ActivationCondition(
            requiredHeroes: heroNumbers.isEmpty ? nil : heroNumbers,
            requiredAttributeDict: attributeDict.isEmpty ? nil : attributeDict,
            requiredEmblemTypeDict: emblemDict.isEmpty ? nil : emblemDict
        )
    }

    private func deleteRelations(for heroNumber: Int) throws {
        try database.delete(
            fromTable: HeroPossessionEntity.tableName,
            where: HeroPossessionEntity.Properties.heroNumber == heroNumber
        )
        try database.delete(
            fromTable: HeroEmblemEntity.tableName,
            where: HeroEmblemEntity.Properties.heroNumber == heroNumber
        )
        try database.delete(
            fromTable: HeroRequiredHeroEntity.tableName,
            where: HeroRequiredHeroEntity.Properties.heroNumber == heroNumber
        )
        try database.delete(
            fromTable: HeroRequiredAttributeEntity.tableName,
            where: HeroRequiredAttributeEntity.Properties.heroNumber == heroNumber
        )
        try database.delete(
            fromTable: HeroRequiredEmblemEntity.tableName,
            where: HeroRequiredEmblemEntity.Properties.heroNumber == heroNumber
        )
    }

    private func upsertHeroInTransaction(_ hero: HeroModel) throws {
        let heroNumber = hero.number.rawValue
        let entity = HeroEntity(
            number: heroNumber,
            name: hero.name,
            mainEmblem: hero.mainEmblem.rawValue,
            summonSkill: hero.summonSkill,
            uniqueTactics: hero.uniqueTactics,
            playerHeroTrait: hero.playerHeroTrait
        )

        try database.insertOrReplace([entity], intoTable: HeroEntity.tableName)
        try deleteRelations(for: heroNumber)
        try insertRelations(for: hero)
    }

    private func insertRelations(for hero: HeroModel) throws {
        let heroNumber = hero.number.rawValue

        let possessionEntities = hero.possessions.map {
            HeroPossessionEntity(id: nil, heroNumber: heroNumber, possessionRawValue: $0.rawValue)
        }
        if !possessionEntities.isEmpty {
            try database.insert(possessionEntities, intoTable: HeroPossessionEntity.tableName)
        }

        let emblemEntities = hero.emblems.map {
            HeroEmblemEntity(id: nil, heroNumber: heroNumber, emblemRawValue: $0.rawValue)
        }
        if !emblemEntities.isEmpty {
            try database.insert(emblemEntities, intoTable: HeroEmblemEntity.tableName)
        }

        try insertCondition(hero.activationCondition, kind: .activation, heroNumber: heroNumber)
        if let upgradeCondition = hero.upgradeCondition {
            try insertCondition(upgradeCondition, kind: .upgrade, heroNumber: heroNumber)
        }
    }

    private func insertCondition(_ condition: ActivationCondition, kind: ConditionKind, heroNumber: Int) throws {
        if let requiredHeroes = condition.requiredHeroes, !requiredHeroes.isEmpty {
            let entities = requiredHeroes.map {
                HeroRequiredHeroEntity(
                    id: nil,
                    heroNumber: heroNumber,
                    conditionKind: kind.rawValue,
                    requiredHeroNumber: Int($0)
                )
            }
            try database.insert(entities, intoTable: HeroRequiredHeroEntity.tableName)
        }

        if let requiredAttributeDict = condition.requiredAttributeDict, !requiredAttributeDict.isEmpty {
            let entities = requiredAttributeDict.map {
                HeroRequiredAttributeEntity(
                    id: nil,
                    heroNumber: heroNumber,
                    conditionKind: kind.rawValue,
                    attributeRawValue: $0.key.rawValue,
                    count: Int($0.value)
                )
            }
            try database.insert(entities, intoTable: HeroRequiredAttributeEntity.tableName)
        }

        if let requiredEmblemTypeDict = condition.requiredEmblemTypeDict, !requiredEmblemTypeDict.isEmpty {
            let entities = requiredEmblemTypeDict.map {
                HeroRequiredEmblemEntity(
                    id: nil,
                    heroNumber: heroNumber,
                    conditionKind: kind.rawValue,
                    emblemRawValue: $0.key.rawValue,
                    count: Int($0.value)
                )
            }
            try database.insert(entities, intoTable: HeroRequiredEmblemEntity.tableName)
        }
    }
}
