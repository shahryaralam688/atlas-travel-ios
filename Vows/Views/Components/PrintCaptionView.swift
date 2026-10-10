import SwiftUI

struct PrintCaptionView: View {
    let item: PortfolioItem
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title.uppercased())
                    .font(.custom("InstrumentSans-Regular", size: 11).weight(.medium))
                    .tracking(1.1)
                    .foregroundStyle(.black)

                Spacer(minLength: 16)

                Text("\(pad(index))")
                    .foregroundStyle(.black.opacity(0.45))
                + Text("/")
                    .foregroundStyle(.black.opacity(0.2))
                + Text("\(pad(total))")
                    .foregroundStyle(.black.opacity(0.45))
            }
            .font(.custom("InstrumentSans-Regular", size: 11).weight(.medium))
            .tracking(1.1)
            .monospacedDigit()

            HStack(spacing: 0) {
                Text(item.settings.season)
                Text(" · ")
                    .foregroundStyle(.black.opacity(0.2))
                Text(item.settings.length)
                Text(" · ")
                    .foregroundStyle(.black.opacity(0.2))
                Text(item.settings.vibe)
            }
            .font(.custom("InstrumentSans-Regular", size: 11).weight(.medium))
            .tracking(1.1)
            .textCase(.uppercase)
            .foregroundStyle(.black.opacity(0.45))
        }
        .padding(.bottom, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .frame(height: 1)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: item.id)
    }

    private func pad(_ value: Int) -> String {
        String(format: "%02d", value)
    }
}
