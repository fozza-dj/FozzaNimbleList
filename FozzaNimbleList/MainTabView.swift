//
//  MainTabView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/24/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // 首页标签
            NavigationStack {
                NimbelListHomeView()
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("全国图鉴")
            }

            // 其他标签页
            Text("朱/紫")
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("朱/紫")
                }

            Text("我的队伍")
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("我的队伍")
                }

            Text("专题")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("专题")
                }

            Text("工具")
                .tabItem {
                    Image(systemName: "wrench.fill")
                    Text("工具")
                }
        }
    }
}

#Preview {
    MainTabView()
}
