//
//  HomeView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/24/25.
//

import SwiftUI

// 宝可梦数据模型
struct Pokemon: Identifiable {
    let id = UUID()
    let name: String
    let japaneseName: String
    let number: String
    let types: [String]
    let imageName: String
}

struct HomeView: View {
    // 示例数据
    let pokemonList: [Pokemon] = [
        Pokemon(name: "妙蛙种子", japaneseName: "フシギダネ", number: "No.001", types: ["草", "毒"], imageName: "bulbasaur"),
        Pokemon(name: "妙蛙草", japaneseName: "フシギソウ", number: "No.002", types: ["草", "毒"], imageName: "ivysaur"),
        Pokemon(name: "妙蛙花", japaneseName: "フシギバナ", number: "No.003", types: ["草", "毒"], imageName: "venusaur"),
        Pokemon(name: "小火龙", japaneseName: "ヒトカゲ", number: "No.004", types: ["火"], imageName: "charmander"),
        Pokemon(name: "火恐龙", japaneseName: "リザード", number: "No.005", types: ["火"], imageName: "charmeleon")
    ]

    var body: some View {
        List(pokemonList) {
            pokemon in
            HStack(alignment: .top, spacing: 16) {
                // 宝可梦图片
                Image(pokemon.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(radius: 3)

                // 信息区域
                VStack(alignment: .leading, spacing: 4) {
                    Text(pokemon.name)
                        .font(.headline)
                    Text(pokemon.japaneseName)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // 属性标签
                    HStack(spacing: 8) {
                        ForEach(pokemon.types, id: \.self) {
                            type in
                            Text(type)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(typeColor(for: type))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.vertical, 8)

                Spacer()

                // 编号
                Text(pokemon.number)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("全国图鉴")
        .searchable(text: .constant(""), prompt: "搜索全国图鉴宝可梦")
    }

    // 根据属性获取对应的颜色
    private func typeColor(for type: String) -> Color {
        switch type {
        case "草": return .green
        case "毒": return .purple
        case "火": return .orange
        default: return .gray
        }
    }
}

// 预览视图
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
