//
//  HeroDetailView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/1/25.
//

import SwiftUI

struct HeroDetailView: View {
    // 接收从列表传递的英雄数据
    let hero: HeroModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 英雄名称和编号
                VStack(alignment: .center) {
                    Text(hero.name)
                        .font(.title)
                        .fontWeight(.bold)
//                    Text(hero.number)
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                }
                .padding()

                // 英雄属性信息
                VStack(alignment: .leading) {
                    Text("属性")
                        .font(.headline)
//                    HStack(spacing: 8) {
//                        ForEach(hero.possessions, id: \.self) {
//                            Text($0.rawValue)
//                                .padding(.horizontal, 12)
//                                .padding(.vertical, 6)
//                                .background(Color.blue.opacity(0.1))
//                                .cornerRadius(16)
//                        }
//                    }
                }
                .padding(.horizontal)

                // 其他英雄信息（根据需要添加）
                Text("召唤技: \(hero.summonSkill)")
                    .padding(.horizontal)
                Text("固有战法: \(hero.uniqueTactics)")
                    .padding(.horizontal)
            }
        }
        .navigationTitle(hero.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 预览
struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // 使用示例数据预览
        let sampleHero = HeroModel(
            number: 1,
            name: "赵云",
            possessions: [.fire, .thunder],
            emblems: [.shu, .braveGeneral],
            mainEmblem: .shu,
            summonSkill: "龙胆亮银枪",
            upgradeCondition: ActivationCondition(),
            uniqueTactics: "七进七出",
            activationCondition: ActivationCondition(),
            playerHeroTrait: "忠义"
        )
        NavigationStack {
            HeroDetailView(hero: sampleHero)
        }
    }
}
