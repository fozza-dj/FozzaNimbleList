//
//  HeroCell.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/31/25.
//

import SwiftUI

struct HeroCell: View {
    let hero: HeroModel
    
    let resourceManager = ImageResouceManager.shared
    
    init(hero: HeroModel) {
        self.hero = hero
    }

    var body: some View {
        // 使用NavigationLink实现点击跳转
        NavigationLink(destination: HeroDetailView(hero: hero)) {
            HStack(alignment: .center, spacing: 16) {
                Image(resourceManager.getAvatarImageName(hero.number))
                    .resizable()
                    .frame(width: 60, height: 60)
                    .shadow(radius: 5)

                // 英雄信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(hero.name)
                        .font(.hero_Font(.H2, weight: .regular))
                    HStack(spacing: 4) {
                        ForEach(hero.possessions, id: \.self) { possession in
                            Image(resourceManager.getPossessionsImageName(possession))
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                
                Spacer()

            }
            .padding(12)
        }
    }
}

// 预览
struct HeroCell_Previews: PreviewProvider {
    static var previews: some View {
        let sampleHero = HeroModel(
            number: 1,
            name: "夏侯惇",
            possessions: [.power, .slash],
            emblems: [.wei, .braveGeneral],
            summonSkill: "龙胆亮银枪",
            upgradeCondition: ActivationCondition(),
            uniqueTactics: "七进七出",
            activationCondition: ActivationCondition(),
            playerHeroTrait: "忠义"
        )
        HeroCell(hero: sampleHero)
            .frame(height: 80)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding()
    }
}
