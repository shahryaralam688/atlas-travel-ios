import SwiftUI

/// Intro copy for Atlas & Co. — a small travel studio.
struct HeroStoryView: View {
    var appear: Bool

    private var typeFont: Font {
        .custom("InstrumentSans-Regular", size: 22).weight(.medium)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            firstLine
            secondLine
            bookingLine
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 18)
        .animation(.spring(response: 0.7, dampingFraction: 0.88).delay(0.1), value: appear)
    }

    private var firstLine: some View {
        HStack(alignment: .center, spacing: 6) {
            (
                Text("Hi, we're ")
                    .foregroundStyle(PortfolioTheme.mute)
                + Text(Agency.name)
                    .foregroundStyle(PortfolioTheme.ink)
            )
            .font(typeFont)
            .tracking(-0.4)

            avatar

            Image(systemName: "airplane")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black)
                .frame(width: 26, height: 26)
                .accessibilityHidden(true)

            Image(systemName: "mappin")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black.opacity(0.55))
                .frame(width: 22, height: 26)
                .accessibilityHidden(true)
        }
    }

    private var secondLine: some View {
        (
            Text("We plan ")
                .foregroundStyle(PortfolioTheme.mute)
            + Text("slow, beautiful trips")
                .foregroundStyle(PortfolioTheme.ink)
            + Text(" to places worth the flight — from ")
                .foregroundStyle(PortfolioTheme.mute)
            + Text("Santorini to Kyoto")
                .foregroundStyle(PortfolioTheme.ink)
            + Text(" and everywhere in between.")
                .foregroundStyle(PortfolioTheme.mute)
        )
        .font(typeFont)
        .tracking(-0.4)
        .lineSpacing(6)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityLabel(
            "We plan slow, beautiful trips to places worth the flight — from Santorini to Kyoto and everywhere in between."
        )
    }

    private var bookingLine: some View {
        Button {
            if let url = URL(string: "mailto:\(Agency.email)") {
                UIApplication.shared.open(url)
            }
        } label: {
            (
                Text("Spring dates open. ")
                    .foregroundStyle(PortfolioTheme.mute)
                + Text("Tell us where next.")
                    .foregroundStyle(PortfolioTheme.ink)
                    .underline(true, color: .black.opacity(0.35))
            )
            .font(typeFont)
            .tracking(-0.4)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }

    private var avatar: some View {
        FillImage(name: Agency.avatarName)
            .frame(width: 28, height: 28)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(Color.black.opacity(0.1), lineWidth: 1)
            }
            .accessibilityHidden(true)
    }
}
