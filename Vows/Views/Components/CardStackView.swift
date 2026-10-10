import SwiftUI

struct StackLayerStyle: Equatable {
    var yOffsetRatio: CGFloat
    var scale: CGFloat
    var rotation: Double
    var zIndex: Double
}

private let layerPresets: [StackLayerStyle] = [
    StackLayerStyle(yOffsetRatio: 0, scale: 1, rotation: 0, zIndex: 20),
    StackLayerStyle(yOffsetRatio: -0.05, scale: 0.84, rotation: -1, zIndex: 5),
    StackLayerStyle(yOffsetRatio: -0.075, scale: 0.72, rotation: 1, zIndex: 0),
]

struct ThrowImpulse: Equatable {
    var xRatio: CGFloat
    var rotation: Double

    static func random() -> ThrowImpulse {
        let drift = CGFloat.random(in: -0.5...0.5)
        return ThrowImpulse(
            xRatio: drift * 0.07,
            rotation: Double(drift) * 6 + Double.random(in: -0.75...0.75)
        )
    }
}

@MainActor
final class CardStackModel: ObservableObject {
    @Published private(set) var items: [PortfolioItem]
    @Published private(set) var isAnimating = false
    @Published private(set) var isPressed = false
    @Published var flyaway: FlyawayCard?

    let depth: Int
    private var autoplayEnabled = false
    private var autoplayTask: Task<Void, Never>?
    private let interval: TimeInterval

    struct FlyawayCard: Identifiable, Equatable {
        let item: PortfolioItem
        let impulse: ThrowImpulse
        var id: String { item.id }
    }

    init(
        items: [PortfolioItem] = Destinations.portfolio,
        depth: Int = PortfolioTheme.stackDepth,
        interval: TimeInterval = PortfolioTheme.autoplayInterval
    ) {
        self.items = items
        self.depth = min(max(1, depth), layerPresets.count)
        self.interval = interval
    }

    var visibleItems: [PortfolioItem] {
        Array(items.prefix(depth))
    }

    var activeItem: PortfolioItem? {
        items.first
    }

    var activeIndex: Int {
        guard let active = activeItem else { return 0 }
        return Destinations.portfolio.firstIndex(where: { $0.id == active.id }) ?? 0
    }

    func setAutoplay(_ enabled: Bool) {
        autoplayEnabled = enabled
        if enabled {
            scheduleAutoplay()
        } else {
            autoplayTask?.cancel()
            autoplayTask = nil
        }
    }

    func press(_ active: Bool) {
        guard !isAnimating else { return }
        withAnimation(.spring(response: 0.12, dampingFraction: 1)) {
            isPressed = active
        }
    }

    func advance() {
        guard items.count > 1, !isAnimating else { return }

        autoplayTask?.cancel()
        isPressed = false
        let outgoing = items[0]
        let impulse = ThrowImpulse.random()

        isAnimating = true

        // Rotate first so the deck doesn't briefly show the same print twice
        var next = items
        next.append(next.removeFirst())
        items = next
        flyaway = FlyawayCard(item: outgoing, impulse: impulse)

        Task { @MainActor in
            // Let the flyaway spring finish
            try? await Task.sleep(nanoseconds: 380_000_000)
            flyaway = nil
            isAnimating = false
            scheduleAutoplay()
        }
    }

    private func scheduleAutoplay() {
        autoplayTask?.cancel()
        guard autoplayEnabled, items.count > 1 else { return }

        autoplayTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            guard !Task.isCancelled else { return }
            advance()
        }
    }
}

struct CardStackView: View {
    @ObservedObject var model: CardStackModel

    var body: some View {
        GeometryReader { geo in
            let cardHeight = geo.size.width * 5 / 4

            ZStack(alignment: .top) {
                ForEach(Array(model.visibleItems.enumerated().reversed()), id: \.element.id) { index, item in
                    let style = layerPresets[min(index, layerPresets.count - 1)]
                    let pressScale: CGFloat = (index == 0 && model.isPressed) ? 0.985 : 1

                    printCard(item: item, showViewfinder: index == 0)
                        .frame(width: geo.size.width, height: cardHeight)
                        .scaleEffect(style.scale * pressScale, anchor: .top)
                        .rotationEffect(.degrees(style.rotation), anchor: .top)
                        .offset(y: style.yOffsetRatio * cardHeight)
                        .zIndex(style.zIndex)
                        .animation(.spring(response: 0.22, dampingFraction: 1), value: style)
                        .animation(.spring(response: 0.12, dampingFraction: 1), value: model.isPressed)
                }

                if let fly = model.flyaway {
                    FlyawayPrint(
                        item: fly.item,
                        impulse: fly.impulse,
                        width: geo.size.width,
                        height: cardHeight
                    )
                    .zIndex(40)
                }
            }
            .frame(width: geo.size.width, height: cardHeight, alignment: .top)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in model.press(true) }
                    .onEnded { _ in
                        model.press(false)
                        model.advance()
                    }
            )
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Show next photo")
        }
        .aspectRatio(4 / 5, contentMode: .fit)
    }

    @ViewBuilder
    private func printCard(item: PortfolioItem, showViewfinder: Bool) -> some View {
        ZStack {
            Color.black.opacity(0.05)
            FillImage(name: item.imageName)
                .clipped()
            if showViewfinder {
                ViewfinderFrame()
            }
        }
        .clipped()
    }
}

private struct FlyawayPrint: View {
    let item: PortfolioItem
    let impulse: ThrowImpulse
    let width: CGFloat
    let height: CGFloat

    @State private var progress: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.05)
            FillImage(name: item.imageName)
                .clipped()
            ViewfinderFrame()
        }
        .frame(width: width, height: height)
        .clipped()
        .offset(x: impulse.xRatio * width * progress, y: height * 2.05 * progress)
        .rotationEffect(.degrees(impulse.rotation * Double(progress)), anchor: .top)
        .scaleEffect(1 - 0.1 * progress, anchor: .top)
        .opacity(1 - Double(progress) * 0.95)
        .onAppear {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                progress = 1
            }
        }
    }
}
