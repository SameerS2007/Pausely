import SwiftUI

/// Yellow popping 3D wordmark. The A’s legs are the pause bars; thin lines connect them.
struct PauselyLogo: View {
    var size: CGFloat = 44

    var body: some View {
        HStack(spacing: size * 0.08) {
            logoLetter("P")
            PauseAMark(size: size)
            logoLetter("U")
            logoLetter("S")
            logoLetter("E")
            logoLetter("L")
            logoLetter("Y")
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Pausely")
    }

    private func logoLetter(_ text: String) -> some View {
        ZStack {
            Text(text)
                .offset(x: 0, y: size * 0.08)
                .foregroundStyle(PauselyTheme.yellowDeep)
            Text(text)
                .offset(x: 0, y: size * 0.04)
                .foregroundStyle(PauselyTheme.yellowDeep.opacity(0.85))
            Text(text)
                .foregroundStyle(
                    LinearGradient(
                        colors: [PauselyTheme.yellowHighlight, PauselyTheme.yellow, PauselyTheme.yellowDeep],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: PauselyTheme.yellow.opacity(0.55), radius: 8, y: 2)
        }
        .font(.system(size: size, weight: .black, design: .rounded))
    }
}

/// Straight || pause legs. Reads as A via: full top cap, lower crossbar, long legs below.
struct PauseAMark: View {
    var size: CGFloat

    var body: some View {
        let barW = size * 0.26
        let barH = size * 0.72
        let gap = size * 0.12
        let totalW = barW * 2 + gap

        ZStack(alignment: .top) {
            // Full-width top cap (A “roof”) — sits on the tops of the bars
            connector(width: totalW * 0.92)
                .offset(y: (size - barH) / 2 - size * 0.01)

            // Crossbar mid-low — hole of the A above, legs below
            connector(width: gap + barW * 0.35)
                .offset(y: (size - barH) / 2 + barH * 0.48)

            // Straight pause legs
            HStack(spacing: gap) {
                pauseBar(width: barW, height: barH)
                pauseBar(width: barW, height: barH)
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .frame(width: totalW, height: size)
    }

    private func connector(width: CGFloat) -> some View {
        // Same thickness as each other; quieter color so pause legs own the focus
        Capsule()
            .fill(PauselyTheme.yellowDeep.opacity(0.9))
            .overlay(
                Capsule()
                    .fill(PauselyTheme.yellow.opacity(0.55))
            )
            .frame(width: width, height: size * 0.14)
    }

    private func pauseBar(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            // Soft glow bloom behind the pause legs
            RoundedRectangle(cornerRadius: width * 0.32, style: .continuous)
                .fill(PauselyTheme.yellowHighlight.opacity(0.55))
                .blur(radius: size * 0.12)
                .scaleEffect(x: 1.25, y: 1.08)

            RoundedRectangle(cornerRadius: width * 0.32, style: .continuous)
                .fill(PauselyTheme.yellowDeep)
                .offset(y: size * 0.08)
            RoundedRectangle(cornerRadius: width * 0.32, style: .continuous)
                .fill(PauselyTheme.yellowDeep.opacity(0.85))
                .offset(y: size * 0.04)

            // Brighter fill than connectors — stands out as the pause
            RoundedRectangle(cornerRadius: width * 0.32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.97, blue: 0.55),
                            PauselyTheme.yellowHighlight,
                            PauselyTheme.yellow
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: PauselyTheme.yellowHighlight.opacity(0.9), radius: 10, y: 0)
                .shadow(color: PauselyTheme.yellow.opacity(0.65), radius: 16, y: 2)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    ZStack {
        PauselyTheme.background
        PauselyLogo(size: 52)
    }
}
