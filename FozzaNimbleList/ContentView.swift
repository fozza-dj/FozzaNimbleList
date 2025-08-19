//
//  ContentView.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 7/24/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            if let image = UIImage(named: "Charm") {
                Image(uiImage: image)
                    .resizable()
                    .imageScale(.small)
                    .foregroundStyle(.tint)
                    .frame(width: 50, height: 50)
            } else {
                Text("图片未找到")
                    .foregroundColor(.red)
            }
            Image("Charm")
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
