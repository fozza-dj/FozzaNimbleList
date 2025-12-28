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

    var body: some View {
        ZStack(alignment: .leading) {
            // 1. 你的原生布局（没有任何箭头干扰）
            HStack(alignment: .center, spacing: 4) {
                Image(hero.avatarImageName)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .shadow(radius: 5)

                VStack(alignment: .leading, spacing: 4) {
                    Text(hero.name)
                        .font(.hero_Font(.H2, weight: .regular))
                    HStack(spacing: 4) {
                        ForEach(hero.possessions, id: \.self) { possession in
                            Image(resourceManager.getPossessionsImageName(possession))
                                .resizable()
                                .frame(width: 20, height: 20)
                                .shadow(radius: 3)
                        }
                    }
                }
                
                Spacer() // 将 EmblemsStack 推向右侧
                EmblemsStack(emblems: hero.emblems)
            }
            .padding(12)

            // 2. 隐藏的跳转逻辑
            NavigationLink(destination: HeroDetailView(hero: hero)) {
                EmptyView()
            }
            .opacity(0) // 隐藏箭头和背景
        }
    }
}

// 预览
struct HeroCell_Previews: PreviewProvider {
    static var previews: some View {
        if let sampleHero = HeroJSONLoader.loadHeroList(fromFile: "MockedHeroList")?.first {
            HeroCell(hero: sampleHero)
                .frame(height: 80)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding()
        }
    }
}
