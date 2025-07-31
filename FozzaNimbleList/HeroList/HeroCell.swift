//
//  HeroCell.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/31/25.
//

import SwiftUI

struct HeroCell: View {
    let hero = HeroJSONLoader.loadZhaoYun()
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Color(.blue)
                .scaledToFit()
                .frame(width: 70, height: 70)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hero?.name ?? "")
                   .font(.headline)
            }
        }
    }
}

#Preview {
    HeroCell()
}
