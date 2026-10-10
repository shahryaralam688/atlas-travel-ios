import SwiftUI

struct ViewfinderFrame: View {
    var body: some View {
        GeometryReader { geo in
            let inset: CGFloat = geo.size.width < 360 ? 12 : 16
            let arm: CGFloat = 16

            ZStack {
                // Corner brackets
                Path { path in
                    // Top-left
                    path.move(to: CGPoint(x: inset, y: inset + arm))
                    path.addLine(to: CGPoint(x: inset, y: inset))
                    path.addLine(to: CGPoint(x: inset + arm, y: inset))
                    // Top-right
                    path.move(to: CGPoint(x: geo.size.width - inset - arm, y: inset))
                    path.addLine(to: CGPoint(x: geo.size.width - inset, y: inset))
                    path.addLine(to: CGPoint(x: geo.size.width - inset, y: inset + arm))
                    // Bottom-left
                    path.move(to: CGPoint(x: inset, y: geo.size.height - inset - arm))
                    path.addLine(to: CGPoint(x: inset, y: geo.size.height - inset))
                    path.addLine(to: CGPoint(x: inset + arm, y: geo.size.height - inset))
                    // Bottom-right
                    path.move(to: CGPoint(x: geo.size.width - inset - arm, y: geo.size.height - inset))
                    path.addLine(to: CGPoint(x: geo.size.width - inset, y: geo.size.height - inset))
                    path.addLine(to: CGPoint(x: geo.size.width - inset, y: geo.size.height - inset - arm))
                }
                .stroke(Color.white.opacity(0.8), lineWidth: 2)

                // Center crosshair
                Path { path in
                    let cx = geo.size.width / 2
                    let cy = geo.size.height / 2
                    path.move(to: CGPoint(x: cx - 10, y: cy))
                    path.addLine(to: CGPoint(x: cx + 10, y: cy))
                    path.move(to: CGPoint(x: cx, y: cy - 10))
                    path.addLine(to: CGPoint(x: cx, y: cy + 10))
                }
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
            }
        }
        .allowsHitTesting(false)
    }
}
