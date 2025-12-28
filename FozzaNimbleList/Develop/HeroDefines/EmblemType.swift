//
//  EmblemType.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import Foundation

enum affiliation: Int, CaseIterable, Codable {
    case favorite = 0
    // 夏侯惇 曹操
    case wei = 1 // 魏
    case shu = 2 // 蜀
    case wu = 3 // 吴
    case jin = 4 // 晋
    case otherDW = 5 // 三国群雄
    case oda = 6 // 织田
    case toyotomi = 7 // 丰臣
    case tokugawa = 8// 德川
    case hojo = 9 // 北条
    case uesugi = 10 // 上杉
    case takeda = 11 // 武田
    case otherSW = 12 // 战国群雄
    case guest = 13 // 其他
}

enum EmblemType: Int, CaseIterable, Codable {
    // MARK: - 势力
    // 三国势力
    case wei = 0 // 魏
    case shu = 1 // 蜀
    case wu = 2// 吴
    case jin = 3// 晋
    case yellowTurbans = 4 // 黄巾
    case luBuArmy = 5// 吕布军
    case dongZhuoArmy = 6 // 董卓军
    case yuanShaoArmy = 7 // 袁绍军
    
    // 战国势力
    case uesugi = 8 // 上杉
    case oda = 9 // 织田
    case sanada = 10 // 真田
    case takeda = 11 // 武田
    case tokugawa = 12 // 德川
    case toyotomi = 13 // 丰臣
    case hojo = 14 // 北条
    
    case azai = 15 // 浅井
    case imagawa = 16 // 今川
    case tachibana = 17 // 立花
    case mori = 18 // 毛利
    case chosokabe = 19 // 长宗我部
    case date = 20 // 伊达
    
    // 其他势力
    case independent = 30 // 无所属
    
    // MARK: - 身份
    case monarch = 101 // 君主
    case daimyo = 102 // 大名
    case braveGeneral = 103 // 猛将
    case strategist = 104 // 军师
    case shinobi = 105 // 忍者
    case masterGunner = 106 // 铁炮名手
    case masterArcher = 107 // 弓箭名手
    case commandar = 108 // 大将军
    case kingsShield = 109 // 主君之盾
    case torchbearer = 110 // 继承人
    
    // MARK: - 特性
    case grace = 201 // 优雅
    case talent = 202 // 才贤
    case might = 203 // 蛮力
    case flowerOfWar = 204 // 战场之花
    
    // MARK: - 组合
    case threeHeroes = 301 // 三英杰
    case fiveShuTigers = 302 // 五虎上将
    case fiveWeiElite = 303 // 五子良将
    case jiangDongHero = 304 // 江东勇将
    
    // MARK: - 地区
    case xiLiang = 401// 西凉
    case weaternRegion = 402 // 西国
    
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
