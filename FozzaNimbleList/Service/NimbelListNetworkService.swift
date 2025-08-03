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
//    func fetchHeroList
    func fetchHeroList(completion: @escaping HeroDataHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let heroModel = HeroJSONLoader.loadZhaoYun() {
                completion(.success([heroModel]))
            } else {
                completion(.failure(NSError(domain: "Load Data Failed", code: -1)))
            }
        }
    }
}
