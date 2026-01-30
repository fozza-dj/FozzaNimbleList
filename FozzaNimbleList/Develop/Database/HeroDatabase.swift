//
//  HeroDatabase.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import Foundation
import WCDBSwift

final class HeroDatabase {
    static let shared = HeroDatabase()

    let database: Database
    private let databasePath: String

    private init() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbURL = documentsURL?.appendingPathComponent("fozza_hero.db")
        databasePath = dbURL?.path ?? NSTemporaryDirectory().appending("fozza_hero.db")
        database = Database(at: databasePath)
    }

    func setupIfNeeded() throws {
        try createTableIfNeeded(HeroEntity.tableName, of: HeroEntity.self)
        try createTableIfNeeded(HeroPossessionEntity.tableName, of: HeroPossessionEntity.self)
        try createTableIfNeeded(HeroEmblemEntity.tableName, of: HeroEmblemEntity.self)
        try createTableIfNeeded(HeroRequiredHeroEntity.tableName, of: HeroRequiredHeroEntity.self)
        try createTableIfNeeded(HeroRequiredAttributeEntity.tableName, of: HeroRequiredAttributeEntity.self)
        try createTableIfNeeded(HeroRequiredEmblemEntity.tableName, of: HeroRequiredEmblemEntity.self)
    }

    func resetDatabase() throws {
        try database.drop(table: HeroEntity.tableName)
        try database.drop(table: HeroPossessionEntity.tableName)
        try database.drop(table: HeroEmblemEntity.tableName)
        try database.drop(table: HeroRequiredHeroEntity.tableName)
        try database.drop(table: HeroRequiredAttributeEntity.tableName)
        try database.drop(table: HeroRequiredEmblemEntity.tableName)
        try setupIfNeeded()
    }

    private func createTableIfNeeded<T: TableCodable>(_ name: String, of type: T.Type) throws {
        if try !database.isTableExists(name) {
            try database.create(table: name, of: type)
        }
    }
}
