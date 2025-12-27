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
            HeroTitle(hero: hero)
            
            VStack(alignment: .center, spacing: 20) {
                // 英雄名称和编号
                Image(ImageResouceManager.shared.getPortraitImageName(hero.number))
                    .scaledToFit()
                    .frame(width: 200, height: 400)
                    .shadow(radius: 5)
                

                // 其他英雄信息（根据需要添加）
                Text("召唤技: \(hero.summonSkill)")
                    .font(.hero_Font(.H3))
                    .padding(.horizontal)
                Text("固有战法: \(hero.uniqueTactics)")
                    .font(.hero_Font(.H3))
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

        NavigationStack {
            HeroDetailView(hero: HeroModel.shared)
        }
    }
}
