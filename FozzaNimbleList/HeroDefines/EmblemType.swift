//
//  EmblemType.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import Foundation

enum affiliation: Int, CaseIterable, Codable {
    case favorite
    // 夏侯惇 曹操
    case wei
    case shu
    case wu
    case jin
    case otherDW
    case oda
    case toyotomi
    case tokugawa
    case hojo
    case uesugi
    case takeda
    case otherSW
    case guest
}

enum EmblemType: Int, CaseIterable, Codable {
    // 三国势力
    case wei // 魏
    case shu // 蜀
    case wu // 吴
    case jin // 晋
    // 黄巾
    case luBuArmy // 吕布军
    case dongZhuoArmy // 董卓军
    case yuanshaoArmy // 袁绍军
    
    // 战国势力
    // 上杉
    case oda // 织田
    case sanada // 真田
    // 武田
    // 德川
    case toyotomi // 丰臣
    case hojo // 北条
    
    // 浅井
    // 今川
    // 立花
    // 毛利
    // 长宗我部
    // 伊达
    
    // 其他势力
    case independent // 无所属
    
    // 身份
    case monarch // 君主
    case daimyo // 大名
    case braveGeneral // 猛将
    case strategist // 军师
    case shinobi // 忍者
    case masterGunner // 铁炮名手
    case masterArcher // 弓箭名手
    case commandar // 大将军
    // 主君之盾
    // 继承人
    
    // 特性
    case grace // 优雅
    case talent // 才贤
    case might // 蛮力
    case flowerOfWar // 战场之花
    
    // 组合
    case threeHeroes // 三英杰
    case fiveShuTigers // 五虎上将
    case fiveWeiElite // 五子良将
    // 江东勇将
    
    // 地区
    // 西凉
    // 西国
    
    private var key: String {
        let raw = String(describing: self)
        let capitalized = raw.prefix(1).uppercased() + raw.dropFirst()
        return "EmblemType_\(capitalized)"
    }
    
    func text(_ language: SupportedLanguage = .system) -> String {
        switch language {
        case .system:
            return NSLocalizedString(key, comment: "")
        case .ch:
            return localizedString(forKey: key, language: "zh-Hans") ?? ""
        case .en:
            return localizedString(forKey: key, language: "en") ?? ""
        case .ja:
            return localizedString(forKey: key, language: "ja") ?? ""
        }
    }
}

func localizedString(forKey key: String, language: String) -> String? {
    guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
          let bundle = Bundle(path: path) else {
        return nil
    }
    return bundle.localizedString(forKey: key, value: nil, table: nil)
}
