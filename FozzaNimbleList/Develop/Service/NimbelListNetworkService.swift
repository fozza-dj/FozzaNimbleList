//
//  NetworkService.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/3/25.
//

import Foundation

typealias HeroDataHandler = (Result<[HeroModel], Error>) -> Void

class NimbelListNetworkService {
    static let shared = NimbelListNetworkService()

    func fetchHeroListData() async throws -> [HeroModel] {
        // 0.5s
        try await Task.sleep(nanoseconds: 500_000_000)
        if let heroList = HeroJSONLoader.loadHeroList(fromFile: "MockedHeroList") {
            return heroList
        } else {
            throw NSError(domain: "Load Data Failed", code: -1)
        }
    }
}
