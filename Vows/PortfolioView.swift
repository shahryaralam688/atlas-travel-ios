import SwiftUI

struct PortfolioView: View {
    @StateObject private var stack = CardStackModel()
    @State private var showPreloader = true
    @State private var contentReady = false

    var body: some View {
        ZStack {
            PortfolioTheme.canvas
                .ignoresSafeArea()

            // Page sits under the shutters from the first frame
            GeometryReader { geo in
                let bottomPad = max(geo.safeAreaInsets.bottom, 12) + 20

                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    VStack(alignment: .leading, spacing: 0) {
                        if let active = stack.activeItem {
                            PrintCaptionView(
                                item: active,
                                index: stack.activeIndex + 1,
                                total: Destinations.portfolio.count
                            )
                        }

                        // Peek so behind prints read above the top frame
                        Color.clear
                            .aspectRatio(8 / 1, contentMode: .fit)

                        CardStackView(model: stack)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)

                    HeroStoryView(appear: contentReady)
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, bottomPad)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .allowsHitTesting(!showPreloader)

            if showPreloader {
                SplitRevealView(imageNames: Destinations.preloadImageNames) {
                    stack.setAutoplay(true)
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.88)) {
                        contentReady = true
                    }
                    // Drop overlay after shutters have cleared
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        showPreloader = false
                    }
                }
                .zIndex(120)
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    PortfolioView()
}
