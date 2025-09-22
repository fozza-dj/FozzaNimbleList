//
//  HeroList.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/1/25.
//

import SwiftUI

struct HeroList: View {
    let heroList: [HeroModel]
    
    var body: some View {
        List(heroList) { hero in
            HeroCell(hero: hero)
        }
    }
}

#Preview {
    let xiahouDun = HeroModel(
        number: 1,
        name: "夏侯惇",
        possessions: [.power, .slash],
        emblems: [.wei, .braveGeneral], mainEmblem: .wei,
        summonSkill: "龙胆亮银枪",
        upgradeCondition: ActivationCondition(),
        uniqueTactics: "七进七出",
        activationCondition: ActivationCondition(),
        playerHeroTrait: "忠义"
    )
    let zhaoYun = HeroModel(
        number: 2,
        name: "赵云",
        possessions: [.power, .thunder, .skill],
        emblems: [.shu, .braveGeneral], mainEmblem: .shu,
        summonSkill: "龙胆亮银枪",
        upgradeCondition: ActivationCondition(),
        uniqueTactics: "七进七出",
        activationCondition: ActivationCondition(),
        playerHeroTrait: "忠义"
    )
     HeroList(heroList: [xiahouDun,zhaoYun])
}
