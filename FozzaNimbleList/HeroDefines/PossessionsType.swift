//
//  PossessionsType.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

enum PossessionsType: Int, CaseIterable, Codable {
    // 特性
    case power = 0 // 力
    case wisdom = 1 // 智
    case charm = 2 // 魅
    case speed = 3 // 速
    case skill = 4 // 技
    case shield = 5 // 坚
    // 属性
    case fire = 11 // 火
    case ice = 12 // 冰
    case thunder = 13 // 雷
    case wind = 14 // 风
    case slash = 15 // 斬
    
    var name: String {
        switch self {
        case .power: return "power"
        case.wisdom: return "wisdom"
        case.charm: return "charm"
        case.speed: return "speed"
        case.skill: return "skill"
        case.shield: return "shield"
        case.fire: return "fire"
        case.ice: return "ice"
        case.thunder: return "thunder"
        case.wind: return "wind"
        case.slash: return "slash"
        }
    }
}

