//
//  GlowingLine.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 2025/12/27.
//

import SwiftUI

struct GlowingLine: View {
    var color: Color = Color(red: 0.4, green: 0.7, blue: 1.0) // 游戏中的浅蓝色
    
    var body: some View {
        ZStack {
            // 1. 底层：发光光晕 (使用模糊处理)
            Capsule()
                .fill(color)
                .frame(height: 2)
                .blur(radius: 4)
                .opacity(0.8)
            
            // 2. 中层：核心亮线 (两侧渐变消失)
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: color, location: 0),
//                            .init(color: color, location: 0.5),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1.5)
            
            // 3. 顶层：极细的白色高亮 (增加锋利感)
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.2),
                            .init(color: .white.opacity(0.8), location: 0.5),
                            .init(color: .clear, location: 0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GlowingLine(color: .blue)
}
