import UIKit
import CoreText

final class FontLoader {
    static func loadCustomFonts() {
        // 注册 STKaiti.ttf（文件应在 bundle 中）
        loadFont(name: "STKaiti", fileExtension: "ttf")
    }
    private static func loadFont(name: String, fileExtension: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("无法找到字体文件: \(name).\(fileExtension)")
            return
        }
        if #available(iOS 18.0, *) {
            // iOS 18+: 推荐使用 CTFontManagerRegisterFontsForURL
            var error: Unmanaged<CFError>?
            let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            if success {
                print("成功注册字体（URL）: \(name)")
            } else {
                let msg = error?.takeRetainedValue().localizedDescription ?? "未知错误"
                print("注册字体失败（URL）: \(name) -> \(msg)")
            }
        } else {
            // iOS < 18: 兼容旧方法，使用 CGDataProvider + CGFont + CTFontManagerRegisterGraphicsFont
            guard let fontData = try? Data(contentsOf: fontURL),
                  let provider = CGDataProvider(data: fontData as CFData),
                  let cgFont = CGFont(provider) else {
                print("无法加载字体数据: \(name)")
                return
            }
            var error: Unmanaged<CFError>?
            if CTFontManagerRegisterGraphicsFont(cgFont, &error) {
                print("成功注册字体（GraphicsFont）: \(name)")
            } else {
                let msg = error?.takeRetainedValue().localizedDescription ?? "未知错误"
                print("注册字体失败（GraphicsFont）: \(name) -> \(msg)")
            }
        }
    }
    
    // 可选：尝试返回字体的 PostScript 名称（用于调试）
    static func postScriptName(forFontFile name: String, fileExtension: String) -> String? {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: fileExtension),
              let fontData = try? Data(contentsOf: fontURL) else {
            return nil
        }
        if #available(iOS 18.0, *) {
            // 使用 CTFontManagerCreateFontDescriptorsFromData（iOS18+）
            let descriptors = CTFontManagerCreateFontDescriptorsFromData(fontData as CFData) as? [CTFontDescriptor]
            let psName = descriptors?.first.flatMap { descriptor -> String? in
                let key = kCTFontNameAttribute as CFString
                return (CTFontDescriptorCopyAttribute(descriptor, key) as? String)
            }
            return psName
        } else {
            // 旧方式，使用 CGFont
            guard let provider = CGDataProvider(data: fontData as CFData),
                  let cgFont = CGFont(provider) else {
                return nil
            }
            return cgFont.postScriptName as String?
        }
    }
}
