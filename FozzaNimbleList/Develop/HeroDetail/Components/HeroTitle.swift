//
//  HeroTitle.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 2025/12/27.
//

import SwiftUI

struct HeroTitle: View {
    let hero: HeroModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(hero.name)
                .font(.hero_Font(.largeTitle))
                .fontWeight(.bold)
            
            GlowingLine(color: .black)
                .frame(width: UIScreen.main.bounds.width * 0.7)
        }
        // 关键点 1：让整个组件撑满横向空间
        // 关键点 2：指定容器内部的内容靠左对齐
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    HeroTitle(hero: HeroJSONLoader.loadHeroList(fromFile: "MockedHeroList")?.first ?? HeroModel.shared)
}
