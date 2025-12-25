//
//  HeroFont.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/27/25.
//

import SwiftUI
import UIKit

enum HeroFontFamily: String {
    case KaiTi = "KaiTi_GB2312"
}

enum HeroFontSize: CGFloat {
    case H1 = 24
    case H2 = 20
    case H3 = 17
    case Headline = 16
    case H4 = 15
    case P1 = 14
    case P2 = 13
    case P3 = 12
    case smallText1 = 11
    case smallText2 = 10
    case largeTitle = 32
}

enum HeroFontWeight: Int {
    case ultraLight = 1
    case thin = 2
    case light = 3
    case regular = 4
    case medium = 5
    case semibold = 6
    case bold = 7
    case heavy = 8
    case black = 9
    
    // 转换为SwiftUI的Font.Weight
    var toFontWeight: Font.Weight {
        switch self {
        case .ultraLight:
            return .ultraLight
        case .thin:
            return .thin
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        case .black:
            return .black
        }
    }
}

// Font扩展
extension Font {
    static func hero_Font(_ size: HeroFontSize, weight: HeroFontWeight = .regular, family: HeroFontFamily = .KaiTi) -> Font {
        let finalWeight: HeroFontWeight
        if UIAccessibility.isBoldTextEnabled {
            let newWeightRawValue = min(weight.rawValue + 2, HeroFontWeight.black.rawValue)
            finalWeight = HeroFontWeight(rawValue: newWeightRawValue) ?? weight
        } else {
            finalWeight = weight
        }
        
        return Font.custom(
            HeroFontFamily.KaiTi.rawValue,
            size: size.rawValue
        ).weight(finalWeight.toFontWeight)
    }
    
    static func regular_Font(_ size: HeroFontSize, weight: HeroFontWeight = .regular, family: HeroFontFamily = .KaiTi) -> Font {
        // 后期再调整
        return hero_Font(size, weight: weight, family: family)
    }
}
