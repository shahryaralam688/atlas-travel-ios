import SwiftUI
import UIKit

/// Fixed overlay: warms bundled images, center-seam progress, then splits open.
struct SplitRevealView: View {
    let imageNames: [String]
    var onComplete: () -> Void

    @State private var progress: Double = 0
    @State private var isRevealing = false
    @State private var isFinished = false
    @State private var loadedCount = 0

    private let revealDuration: TimeInterval = 0.85

    var body: some View {
        GeometryReader { geo in
            let half = geo.size.height / 2

            ZStack {
                PortfolioTheme.canvas
                    .frame(height: half + 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .offset(y: isRevealing ? -(half + 40) : 0)

                PortfolioTheme.canvas
                    .frame(height: half + 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: isRevealing ? (half + 40) : 0)

                if !isRevealing {
                    VStack(spacing: 0) {
                        Spacer()

                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.12))
                                .frame(height: 1)

                            GeometryReader { barGeo in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: barGeo.size.width * progress, height: 1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(height: 1)
                        }
                        .padding(.horizontal, 48)

                        Spacer()
                    }
                    .transition(.opacity)
                }
            }
            .ignoresSafeArea()
        }
        .opacity(isFinished ? 0 : 1)
        .allowsHitTesting(!isFinished)
        .task {
            await preloadAll()
        }
    }

    @MainActor
    private func preloadAll() async {
        let total = max(imageNames.count, 1)

        for name in imageNames {
            // Decode off the main actor a bit so the progress bar can tick
            await Task.detached(priority: .userInitiated) {
                _ = BundleImage.uiImage(named: name)
            }.value

            loadedCount += 1
            withAnimation(.easeOut(duration: 0.18)) {
                progress = Double(loadedCount) / Double(total)
            }
            try? await Task.sleep(nanoseconds: 90_000_000)
        }

        try? await Task.sleep(nanoseconds: 280_000_000)

        withAnimation(.timingCurve(0.76, 0, 0.24, 1, duration: revealDuration)) {
            isRevealing = true
        }

        try? await Task.sleep(nanoseconds: UInt64(revealDuration * 1_000_000_000) + 80_000_000)

        isFinished = true
        onComplete()
    }
}
