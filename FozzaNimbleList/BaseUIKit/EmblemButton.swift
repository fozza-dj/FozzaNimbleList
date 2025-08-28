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
            .font(.hero_Font(.smallText1))
            .foregroundColor(.white)
            .padding(.vertical, 1)
            .lineLimit(1)
            .frame(width: 100, height: 12)
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
    }
}
struct CapsuleWithCutEnds: Shape {
    func path(in rect: CGRect) -> Path {
        let h = rect.height
        let w = rect.width
        let cut = min(h * 0.9, w * 0.12)
        var p = Path()
        p.move(to: CGPoint(x: cut, y: 0))
        p.addLine(to: CGPoint(x: w - cut, y: 0))
        p.addLine(to: CGPoint(x: w, y: h / 2))
        p.addLine(to: CGPoint(x: w - cut, y: h))
        p.addLine(to: CGPoint(x: cut, y: h))
        p.addLine(to: CGPoint(x: 0, y: h / 2))
        p.closeSubpath()
        return p
    }
}
struct EmblemButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            EmblemButton(title: "蜀之五虎上将")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
