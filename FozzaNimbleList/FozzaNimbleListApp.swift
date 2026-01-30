//
//  FozzaNimbleListApp.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/24/25.
//

import SwiftUI

@main
struct FozzaNimbleListApp: App {
    init() {
        // 启动时加载自定义字体
//        FontLoader.loadCustomFonts()
        do {
            try HeroRepository.shared.setupIfNeeded()
        } catch {
            print("❌ 数据库初始化失败: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
