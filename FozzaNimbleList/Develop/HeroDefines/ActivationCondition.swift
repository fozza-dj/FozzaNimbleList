//
//  ActivationCondition.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import Foundation

struct ActivationCondition: Codable {
    var requiredHeroes: [UInt]?
    var requiredAttributeDict: [PossessionsType: UInt]? // 需要对应多少个属性
    var requiredEmblemTypeDict: [EmblemType: UInt]? // 需要对应多少个特性
}

extension ActivationCondition {
    enum CodingKeys: String, CodingKey {
        case requiredHeroes
        case requiredAttributeDict
        case requiredEmblemTypeDict
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        requiredHeroes = try container.decodeIfPresent([UInt].self, forKey: .requiredHeroes)

        // 解码属性字典（PossessionsType）
        if let attrDict = try container.decodeIfPresent([String: UInt].self, forKey: .requiredAttributeDict) {
            requiredAttributeDict = try attrDict.reduce(into: [:]) { (acc, pair) in
                guard let key = Int(pair.key), let type = PossessionsType(rawValue: key) else {
                    throw DecodingError.dataCorruptedError(forKey: .requiredAttributeDict,
                                                          in: container,
                                                          debugDescription: "无效的PossessionsType值: \(pair.key)")
                }
                acc[type] = pair.value
            }
        }

        // 解码特殊系字典（EmblemType）
        if let emblemDict = try container.decodeIfPresent([String: UInt].self, forKey: .requiredEmblemTypeDict) {
            requiredEmblemTypeDict = try emblemDict.reduce(into: [:]) { (acc, pair) in
                guard let key = Int(pair.key), let type = EmblemType(rawValue: key) else {
                    throw DecodingError.dataCorruptedError(forKey: .requiredEmblemTypeDict,
                                                          in: container,
                                                          debugDescription: "无效的EmblemType值: \(pair.key)")
                }
                acc[type] = pair.value
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(requiredHeroes, forKey: .requiredHeroes)

        if let requiredAttributeDict {
            let encoded = requiredAttributeDict.reduce(into: [String: UInt]()) { acc, pair in
                acc[String(pair.key.rawValue)] = pair.value
            }
            try container.encode(encoded, forKey: .requiredAttributeDict)
        }

        if let requiredEmblemTypeDict {
            let encoded = requiredEmblemTypeDict.reduce(into: [String: UInt]()) { acc, pair in
                acc[String(pair.key.rawValue)] = pair.value
            }
            try container.encode(encoded, forKey: .requiredEmblemTypeDict)
        }
    }
}

