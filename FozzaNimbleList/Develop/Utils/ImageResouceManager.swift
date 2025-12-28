//
//  ImageResouceManager.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/19/25.
//

struct ImageResouceManager {
    static let shared = ImageResouceManager()
    
    func getPossessionsImageName(_ possession: PossessionsType) -> String {
        let key = String(describing: possession)
        return key.prefix(1).uppercased() + key.dropFirst()
    }
}
