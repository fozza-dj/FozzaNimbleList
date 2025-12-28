//
//  ImageResouceManager.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/19/25.
//

struct ImageResouceManager {
    static let shared = ImageResouceManager()
    
    func getAvatarImageName(_ number: UInt) -> String {
        guard number <= 9999 else {
            fatalError("输入数字必须小于等于9999")
        }
        return String(format: "Avatar_%03d", number)
    }
    
    func getPortraitImageName(_ number: UInt) -> String {
        guard number <= 9999 else {
            fatalError("输入数字必须小于等于9999")
        }
        return String(format: "Portrait_%03d", number)
    }
    
    func getPossessionsImageName(_ possession: PossessionsType) -> String {
        let key = String(describing: possession)
        return key.prefix(1).uppercased() + key.dropFirst()
    }
}
