//
//  DatabaseDebugViewModel.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 9/1/25.
//

import Foundation

@MainActor
final class DatabaseDebugViewModel: ObservableObject {
    @Published var heroes: [HeroModel] = []
    @Published var errorMessage: String?

    static let heroTemplate = HeroModel(
        number: .xiaHouDun,
        name: "新英杰",
        possessions: [.power],
        emblems: [.wei],
        mainEmblem: .wei,
        summonSkill: "技能描述",
        upgradeCondition: nil,
        uniqueTactics: "战法描述",
        activationCondition: ActivationCondition(),
        playerHeroTrait: "特性描述"
    )

    func refresh() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try HeroRepository.shared.setupIfNeeded()
                let heroes = try HeroRepository.shared.fetchAllHeroes()
                DispatchQueue.main.async {
                    self.heroes = heroes
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func seedMockData() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let count = try HeroRepository.shared.seedFromMockIfNeeded()
                DispatchQueue.main.async {
                    self.errorMessage = count > 0 ? "✅ 已写入 \(count) 条数据" : "⚠️ 未写入数据"
                    self.refresh()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func delete(hero: HeroModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try HeroRepository.shared.deleteHero(number: hero.number.rawValue)
                DispatchQueue.main.async {
                    self.refresh()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
