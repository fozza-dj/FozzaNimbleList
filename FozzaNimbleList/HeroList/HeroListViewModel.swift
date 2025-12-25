//
//  HeroListViewModel.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/3/25.
//

import Foundation

struct HeroSection: Identifiable {
    let type: EmblemType
    let heroes: [HeroModel]
    var id: Int { type.rawValue } // 使用枚举的原始值作为 ID
}

@MainActor
class HeroListViewModel: ObservableObject {
    @Published var sections: [HeroSection] = [] // View 直接绑定这个
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchHeroListData() {
        Task { // 开启一个异步任务
            isLoading = true
            defer { isLoading = false } // 无论成功失败，结束后都会执行
            
            do {
                let heroList = try await NimbelListNetworkService.shared.fetchHeroListData()
                // 直接赋值，无需担心线程问题和 [weak self]（Task 会自动处理闭包捕获）
                self.sections = self.groupHeroes(heroList)
            } catch {
                self.error = error
            }
        }
    }
    
    private func groupHeroes(_ list: [HeroModel]) -> [HeroSection] {
        // 1. 使用 Dictionary 分组，取第一个 emblem 为 key
        let groupedDict = Dictionary(grouping: list) { hero in
            hero.emblems.first ?? .independent // 假设你的枚举里有个 .none
        }
        
        // 2. 将字典转换为有序数组，并按 EmblemType 排序
        return groupedDict
            .map { HeroSection(type: $0.key, heroes: $0.value) }
            .sorted { $0.type.rawValue < $1.type.rawValue }
    }
}
