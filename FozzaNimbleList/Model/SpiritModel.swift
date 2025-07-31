//
//  SpiritModel.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/24/25.
//

import Foundation

enum AttributeType: Int, CaseIterable, Codable {
    // 属性
    case fire // 火
    case ice // 冰
    case thunder // 雷
    case wind // 风
    case slash // 斬
    // 特性
    case wisdom // 智
    case charm // 魅
    case power // 力
    case speed // 速
    case skill // 技
}

enum emblemType: Int, CaseIterable, Codable {
    // 势力
    case wei // 魏
    case shu // 蜀
    case wu // 吴
    case luBuArmy // 吕布军
    case dongZhuoArmy // 董卓军
    case yuanshaoArmy // 袁绍军
    case sanada // 真田
    case oda // 织田
    // 特性
    case braveGeneral // 猛将
    case monarch // 君主
    case daimyo // 大名
    case strategist // 军师
    case ninja // 忍者
    case grace // 优雅
    case talent // 才贤
    case might // 蛮力
    case masterGunner // 铁炮名手
    // 组合
    case threeHeroes // 三英杰
    case fiveShuTigers // 五虎上将
    case fiveWeiElite // 五子良将
}

struct ActivationCondition: Codable {
    var requiredHeroes: [UInt]?
    var requiredAttributeDict: [AttributeType: UInt]? // 需要对应多少个属性
    var requiredEmblemTypeDict: [emblemType: UInt]? // 需要对应多少个特性
}

struct HeroTrait: Codable {
    var name: String
    var originalEffect: String
    var upgradeEffect: String
}

struct PlayerHeroTraits: Codable {
    var traitA: HeroTrait
    var traitB: HeroTrait
}

public struct HeroModel: Codable {
    // 序号
    var number: UInt
    // 名称
    var name: String
    // 印
    var possessions: [AttributeType]
    // 特殊系
    var emblems: [emblemType]
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

extension ActivationCondition {
    enum CodingKeys: String, CodingKey {
        case requiredHeroes
        case requiredAttributeDict
        case requiredEmblemTypeDict
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        requiredHeroes = try container.decodeIfPresent([UInt].self, forKey: .requiredHeroes)

        // 解码属性字典（AttributeType）
        if let attrDict = try container.decodeIfPresent([String: UInt].self, forKey: .requiredAttributeDict) {
            requiredAttributeDict = try attrDict.reduce(into: [:]) { (acc, pair) in
                guard let key = Int(pair.key), let type = AttributeType(rawValue: key) else {
                    throw DecodingError.dataCorruptedError(forKey: .requiredAttributeDict,
                                                          in: container,
                                                          debugDescription: "无效的AttributeType值: \(pair.key)")
                }
                acc[type] = pair.value
            }
        }

        // 解码特殊系字典（emblemType）
        if let emblemDict = try container.decodeIfPresent([String: UInt].self, forKey: .requiredEmblemTypeDict) {
            requiredEmblemTypeDict = try emblemDict.reduce(into: [:]) { (acc, pair) in
                guard let key = Int(pair.key), let type = emblemType(rawValue: key) else {
                    throw DecodingError.dataCorruptedError(forKey: .requiredEmblemTypeDict,
                                                          in: container,
                                                          debugDescription: "无效的emblemType值: \(pair.key)")
                }
                acc[type] = pair.value
            }
        }
    }
}

// MARK: - 序列化工具类
enum HeroModelSerializer {
    static func deserialize(from jsonString: String) -> HeroModel? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(HeroModel.self, from: data)
    }
}

enum HeroJSONLoader {
    static func loadZhaoYun() -> HeroModel? {
        // 获取JSON文件路径
        guard let url = Bundle.main.url(forResource: "ZhaoYunHeroModel",
                                        withExtension: "json",
                                        subdirectory: nil) else {
            return nil
        }

        do {
            // 读取文件数据
            let data = try Data(contentsOf: url)
            // 配置解码器（处理特殊数据类型）
            let decoder = JSONDecoder()
            // 解码为HeroModel对象
            let heroModel = try decoder.decode(HeroModel.self, from: data)
            return heroModel
        } catch let error as NSError {
            print("JSON解析失败: \(error.localizedDescription)")
            return nil
        }
    }
}
