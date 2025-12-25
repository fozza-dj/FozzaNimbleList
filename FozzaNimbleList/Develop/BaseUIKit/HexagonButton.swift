//
//  HexagonButton.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import SwiftUI

struct HexagonButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .stroke(Color(red: 0.3, green: 0.6, blue: 1.0, opacity: 0.7), lineWidth: 2)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.5, blue: 0.9), Color(red: 0.3, green: 0.7, blue: 1.0)]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(20)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle()) // 移除系统默认按钮样式
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
    }
}

struct HexagonButton_Previews: PreviewProvider {
    static var previews: some View {
        HexagonButton(title: "北条") {
            // 按钮点击动作
            print("Button tapped")
        }
        .background(Color.black) // 为了预览效果添加黑色背景
        .previewLayout(.sizeThatFits)
    }
}
