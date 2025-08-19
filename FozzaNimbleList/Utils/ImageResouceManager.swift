//
//  ImageResouceManager.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/19/25.
//

struct ImageResouceManager {
    static let shared = ImageResouceManager()
    
    func getAvatarImageName(_ number: UInt) -> String {
        guard number <= 999 else {
            fatalError("输入数字必须小于等于999")
        }
        return String(format: "Avatar_%03d", number)
    }
    
    func getPossessionsImageName(_ possession: PossessionsType) -> String {
        return possession.name.capitalized
    }
}
