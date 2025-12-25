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
    
    /// 通用的加载方法
    /// - Parameter fileName: JSON文件名（不需要带.json后缀）
    /// - Returns: 解析后的英雄数组，失败则返回 nil
    static func loadHeroList(fromFile fileName: String) -> [HeroModel]? {
        // 1. 获取文件路径
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("❌ 错误：找不到文件 \(fileName).json")
            return nil
        }
        
        do {
            // 2. 读取 Data
            let data = try Data(contentsOf: url)
            
            // 3. 创建解码器
            let decoder = JSONDecoder()
            
            // 如果你的 JSON 里的 key 仍然包含下划线（比如 trigger_type），
            // 建议保留下面这行，否则可以注释掉。
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // 4. 开始解析数组
            let heroes = try decoder.decode([HeroModel].self, from: data)
            print("✅ 成功解析 \(heroes.count) 个英雄数据")
            return heroes
            
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ 解析失败：缺失字段 '\(key.stringValue)' - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("❌ 解析失败：字段类型不匹配，期望类型 '\(type)' - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("❌ 解析失败：数据损坏 - \(context.debugDescription)")
        } catch {
            print("❌ 解析失败：未知错误 \(error.localizedDescription)")
        }
        
        return nil
    }
}
