//
//  HeroList.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/1/25.
//

import SwiftUI

struct HeroList: View {
    let sections: [HeroSection]
    
    var body: some View {
        List {
            ForEach(sections) { section in
                // 使用 section.type 的描述作为 Header
                Section(header: Text("系别：\(section.type.text())")) {
                    ForEach(section.heroes) { hero in
                        HeroCell(hero: hero)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

//#Preview {
//    HeroList(sections: HeroJSONLoader.loadHeroList(fromFile: "MockedHeroList") ?? [])
//}
