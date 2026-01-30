//
//  HeroEntities.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import Foundation
import WCDBSwift

enum ConditionKind: Int, CaseIterable, Codable {
    case activation = 0
    case upgrade = 1
}

struct HeroEntity: TableCodable {
    var number: Int
    var name: String
    var mainEmblem: Int
    var summonSkill: String
    var uniqueTactics: String
    var playerHeroTrait: String

    static let tableName = "hero"

    enum CodingKeys: String, CodingTableKey {
        typealias Root = HeroEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(number, isPrimary: true)
        }

        case number
        case name
        case mainEmblem
        case summonSkill
        case uniqueTactics
        case playerHeroTrait
    }
}

struct HeroPossessionEntity: TableCodable {
    var id: Int64?
    var heroNumber: Int
    var possessionRawValue: Int

    static let tableName = "hero_possession"

    enum CodingKeys: String, CodingTableKey {
        typealias Root = HeroPossessionEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }

        case id
        case heroNumber
        case possessionRawValue
    }
}

struct HeroEmblemEntity: TableCodable {
    var id: Int64?
    var heroNumber: Int
    var emblemRawValue: Int

    static let tableName = "hero_emblem"

    enum CodingKeys: String, CodingTableKey {
        typealias Root = HeroEmblemEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }

        case id
        case heroNumber
        case emblemRawValue
    }
}

struct HeroRequiredHeroEntity: TableCodable {
    var id: Int64?
    var heroNumber: Int
    var conditionKind: Int
    var requiredHeroNumber: Int

    static let tableName = "hero_required_hero"

    enum CodingKeys: String, CodingTableKey {
        typealias Root = HeroRequiredHeroEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }

        case id
        case heroNumber
        case conditionKind
        case requiredHeroNumber
    }
}

struct HeroRequiredAttributeEntity: TableCodable {
    var id: Int64?
    var heroNumber: Int
    var conditionKind: Int
    var attributeRawValue: Int
    var count: Int

    static let tableName = "hero_required_attribute"

    enum CodingKeys: String, CodingTableKey {
        typealias Root = HeroRequiredAttributeEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }

        case id
        case heroNumber
        case conditionKind
        case attributeRawValue
        case count
    }
}

struct HeroRequiredEmblemEntity: TableCodable {
    var id: Int64?
    var heroNumber: Int
    var conditionKind: Int
    var emblemRawValue: Int
    var count: Int

    static let tableName = "hero_required_emblem"

    enum CodingKeys: String, CodingTableKey {
        typealias Root = HeroRequiredEmblemEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }

        case id
        case heroNumber
        case conditionKind
        case emblemRawValue
        case count
    }
}
