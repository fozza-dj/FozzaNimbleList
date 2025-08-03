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
