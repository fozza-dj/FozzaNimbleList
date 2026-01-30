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
                Text("英杰列表")
            }

            // 其他标签页
            Text("素材")
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("素材")
                }

            Text("阵型")
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("阵型")
                }

            Text("专题")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("专题")
                }

            #if DEBUG
            DatabaseDebugView()
                .tabItem {
                    Image(systemName: "ladybug.fill")
                    Text("数据库")
                }
            #else
            Text("工具")
                .tabItem {
                    Image(systemName: "wrench.fill")
                    Text("工具")
                }
            #endif
        }
    }
}

#Preview {
    MainTabView()
}
