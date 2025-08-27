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
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
