import Foundation
import SwiftUI

enum PortfolioTheme {
    static let canvas = Color.white
    static let ink = Color.black
    static let mute = Color.black.opacity(0.4)
    static let autoplayInterval: TimeInterval = 4.5
    static let stackDepth = 3
}

/// Travel metadata shown under each destination title (season · length · vibe).
struct TripMeta: Equatable {
    let season: String
    let length: String
    let vibe: String
}

struct PortfolioItem: Identifiable, Equatable {
    let id: String
    let imageName: String
    let title: String
    let tagline: String
    let settings: TripMeta
}

enum Agency {
    static let studio = "Atlas & Co."
    static let name = "Atlas"
    static let location = "worldwide"
    static let email = "hello@atlasandco.travel"
    static let avatarName = "avatar"
}

enum Destinations {
    static let portfolio: [PortfolioItem] = [
        PortfolioItem(
            id: "santorini",
            imageName: "santorini",
            title: "Santorini",
            tagline: "Aegean sunset cliffs",
            settings: TripMeta(season: "Apr–Oct", length: "5 days", vibe: "Coastal")
        ),
        PortfolioItem(
            id: "kyoto",
            imageName: "kyoto",
            title: "Kyoto",
            tagline: "Temple paths at dawn",
            settings: TripMeta(season: "Mar–May", length: "7 days", vibe: "Culture")
        ),
        PortfolioItem(
            id: "amalfi",
            imageName: "amalfi",
            title: "Amalfi",
            tagline: "Cliffside drive",
            settings: TripMeta(season: "May–Sep", length: "6 days", vibe: "Scenic")
        ),
        PortfolioItem(
            id: "bali",
            imageName: "bali",
            title: "Bali",
            tagline: "Rice terraces & sea",
            settings: TripMeta(season: "Apr–Oct", length: "8 days", vibe: "Escape")
        ),
        PortfolioItem(
            id: "swiss",
            imageName: "swiss",
            title: "Alps",
            tagline: "Peak light, quiet air",
            settings: TripMeta(season: "Jun–Sep", length: "6 days", vibe: "Alpine")
        ),
        PortfolioItem(
            id: "morocco",
            imageName: "morocco",
            title: "Marrakech",
            tagline: "Souks after dark",
            settings: TripMeta(season: "Oct–Apr", length: "5 days", vibe: "Desert")
        ),
    ]

    static var preloadImageNames: [String] {
        [Agency.avatarName] + portfolio.map(\.imageName)
    }
}
