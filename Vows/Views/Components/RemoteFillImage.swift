import SwiftUI
import UIKit

enum BundleImage {
    /// Loads a bundled JPEG by name. `UIImage(named:)` often fails for loose `.jpg`
    /// resources, so we fall back to an explicit bundle path.
    static func uiImage(named name: String) -> UIImage? {
        if let image = UIImage(named: name) {
            return image
        }

        let extensions = ["jpg", "jpeg", "png"]
        for ext in extensions {
            if let url = Bundle.main.url(forResource: name, withExtension: ext),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                return image
            }
        }

        // Last resort: scan the bundle (handles odd copy paths)
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) {
            for url in urls where url.deletingPathExtension().lastPathComponent == name {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    return image
                }
            }
        }

        return nil
    }
}

/// Bundled destination / avatar image, cropped to fill its container.
struct FillImage: View {
    let name: String
    var fallback: Color = Color.black.opacity(0.05)

    var body: some View {
        GeometryReader { geo in
            if let uiImage = BundleImage.uiImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            } else {
                fallback
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

typealias RemoteFillImage = FillImage
