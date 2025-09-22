//
//  SpiritModel.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/24/25.
//

import Foundation

struct HeroTrait: Codable {
    var name: String
    var originalEffect: String
    var upgradeEffect: String
}

struct PlayerHeroTraits: Codable {
    var traitA: HeroTrait
    var traitB: HeroTrait
}

public struct HeroModel: Codable, Identifiable {
    public var id: UInt { number }
    // 序号
    var number: UInt
    // 名称
    var name: String
    // 印
    var possessions: [PossessionsType]
    // 特殊系
    var emblems: [EmblemType]
    // 主要势力
    var mainEmblem: EmblemType
    // 召唤技
//    var summonSkill: PlayerHeroTraits
    var summonSkill: String
    // 强化条件
    var upgradeCondition: ActivationCondition
    // 固有战法[唯一性战法，先用文本记述]
    var uniqueTactics: String
    // 发动条件 这里有点问题，发送条件通常是印记*n 或者要求特定英杰，不能直接用字符串
    var activationCondition: ActivationCondition
    // 操作时特性 最好是个struct
    var playerHeroTrait: String
}
