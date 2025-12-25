//
//  EmblemsStack.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/28/25.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct EmblemsStack: View {
    let emblems: [EmblemType]
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            // 将emblems数组分组，每组最多2个元素
            ForEach(Array(emblems.chunked(into: 2).enumerated()), id: \.offset) { _, chunk in
                HStack(spacing: 4) {
                    ForEach(chunk, id: \.self) {
                        emblem in
                        EmblemButton(title: emblem.text(.ch))
                    }
                }
            }
        }
    }
}

#Preview {
    EmblemsStack(emblems: [.wei, .braveGeneral, .monarch, .fiveShuTigers, .talent])
}
