//
//  EmblemType.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import Foundation

enum EmblemType: Int, CaseIterable, Codable {
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
    
    var text: String {
        let raw = String(describing: self)
        let capitalized = raw.prefix(1).uppercased() + raw.dropFirst()
        let key = "EmblemType_\(capitalized)"
        return NSLocalizedString(key, comment: "")
    }
}
