//
//  HeroModelSerializer.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 8/26/25.
//

import Foundation

// MARK: - 序列化工具类
enum HeroModelSerializer {
    static func deserialize(from jsonString: String) -> HeroModel? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(HeroModel.self, from: data)
    }
}

enum HeroJSONLoader {
    static func loadZhaoYun() -> HeroModel? {
        // 获取JSON文件路径
        guard let url = Bundle.main.url(forResource: "ZhaoYunHeroModel",
                                        withExtension: "json",
                                        subdirectory: nil) else {
            return nil
        }

        do {
            // 读取文件数据
            let data = try Data(contentsOf: url)
            // 配置解码器（处理特殊数据类型）
            let decoder = JSONDecoder()
            // 解码为HeroModel对象
            let heroModel = try decoder.decode(HeroModel.self, from: data)
            return heroModel
        } catch let error as NSError {
            print("JSON解析失败: \(error.localizedDescription)")
            return nil
        }
    }
}
