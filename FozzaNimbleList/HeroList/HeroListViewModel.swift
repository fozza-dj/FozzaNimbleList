//
//  HeroListViewModel.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/3/25.
//

import Foundation

class HeroListViewModel: ObservableObject {
    @Published var heroList: [HeroModel] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchHeroList() {
        isLoading = true
        NimbelListNetworkService.shared.fetchHeroList { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let heroList):
                    print("NimbelListNetworkService fetchHeroList数据返回 heros count = \(heroList.count)")
                    self?.heroList = heroList
                case .failure(let error):
                    print("NimbelListNetworkService fetchHeroList数据返回失败")
                    self?.error = error
                }
            }
        }
    }

}
