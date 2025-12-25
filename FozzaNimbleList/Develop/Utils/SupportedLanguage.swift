//
//  SupportedLanguage.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/28/25.
//

enum SupportedLanguage {
    case system
    case en
    case ja
    case ch
    
    var code: String {
        switch self {
            case .system: return "system"
            case .en: return "en"
            case .ch: return "zh-Hans"
            case .ja: return "ja"
        }
    }
}
