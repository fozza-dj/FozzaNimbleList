//
//  EmblemButton.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import SwiftUI
struct EmblemButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .regular, design: .serif)) // 可换字体
            .foregroundColor(.white)
            .padding(.horizontal, 36)
            .padding(.vertical, 8)
            .background(
                CapsuleWithCutEnds()
                    .fill(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 0.06, green: 0.31, blue: 0.55, alpha: 1)), location: 0),
                            .init(color: Color(#colorLiteral(red: 0.07, green: 0.42, blue: 0.67, alpha: 1)), location: 0.5),
                            .init(color: Color(#colorLiteral(red: 0.05, green: 0.25, blue: 0.44, alpha: 1)), location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .overlay(
                        CapsuleWithCutEnds()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            .blendMode(.overlay)
                    )
                    .overlay(
                        // 内阴影效果（通过叠加模糊黑色透明, 并裁剪）
                        CapsuleWithCutEnds()
                            .stroke(Color.black.opacity(0.25), lineWidth: 8)
                            .blur(radius: 8)
                            .offset(y: 2)
                            .mask(CapsuleWithCutEnds().fill(LinearGradient(
                                gradient: Gradient(colors: [.black, .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )))
                            .opacity(0.6)
                    )
            )
            .fixedSize() // 防止被父布局无限拉伸
    }
}
// 自定义 Shape：长条中间为矩形，两端为对称菱形切角
struct CapsuleWithCutEnds: Shape {
    func path(in rect: CGRect) -> Path {
        // 通过计算在长条左右各取一个等边菱形（或三角）宽度
        let h = rect.height
        let w = rect.width
        // 切角宽度（左右平行于高度的比例）
        let cut = min(h * 0.9, w * 0.12) // 调整两端切角宽度
        var p = Path()
        // 从左中上开始顺时针绘制类似 capsule with angled ends
        p.move(to: CGPoint(x: cut, y: 0))
        p.addLine(to: CGPoint(x: w - cut, y: 0))
        p.addLine(to: CGPoint(x: w, y: h / 2))
        p.addLine(to: CGPoint(x: w - cut, y: h))
        p.addLine(to: CGPoint(x: cut, y: h))
        p.addLine(to: CGPoint(x: 0, y: h / 2))
        p.closeSubpath()
        // 平滑角（可选）：对 path 做 cornerRadius 风格处理 - 这里用内切圆弧近似
        return p
    }
}
struct EmblemButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            EmblemButton(title: "北条")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
