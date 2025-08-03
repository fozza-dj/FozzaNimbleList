//
//  HeroCell.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/31/25.
//

import SwiftUI

//struct HeroCell: View {
//    let hero: HeroModel
//
//    var body: some View {
//        // 使用NavigationLink实现点击跳转
//        NavigationLink(destination: HeroDetailView(hero: hero)) {
//            HStack(spacing: 16) {
//                // 英雄头像
////                Image(hero.name)
////                    .resizable()
////                    .scaledToFit()
////                    .frame(width: 60, height: 60)
////                    .cornerRadius(8)
//                Color(.blue)
//                    .scaledToFit()
//                    .frame(width: 70, height: 70)
//                    .shadow(radius: 3)
//
//                // 英雄信息
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(hero.name)
//                        .font(.headline)
////                    Text(hero.number)
////                        .font(.subheadline)
////                        .foregroundColor(.gray)
//
//                    // 属性标签
//                    HStack(spacing: 6) {
//                        ForEach(hero.possessions.prefix(2), id: \.self) {
//                            Text($0.rawValue)
//                                .font(.system(size: 10))
//                                .padding(4)
//                                .background(Color.gray.opacity(0.1))
//                                .cornerRadius(4)
//                        }
//                    }
//                }
//                Spacer()
//
//                // 箭头图标
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//            .padding(12)
//        }
//    }
//}

struct HeroCell: View {
    let hero: HeroModel

    var body: some View {
        // 使用NavigationLink实现点击跳转
        NavigationLink(destination: HeroDetailView(hero: hero)) {
            HStack(spacing: 16) {
                Color(.blue)
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(radius: 3)

                // 英雄信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(hero.name)
                        .font(.headline)
                }
                Spacer()

                // 箭头图标
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
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
            name: "赵云",
            possessions: [.fire, .thunder],
            emblems: [.shu, .braveGeneral],
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
