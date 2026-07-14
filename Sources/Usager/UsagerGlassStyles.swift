import AppKit
import SwiftUI

enum UsagerBrand {
    static let signal = Color(red: 53 / 255, green: 209 / 255, blue: 90 / 255)
    static let primary = Color.white
    static let secondary = Color(white: 176 / 255)
    static let tertiary = Color(white: 118 / 255)
    static let line = Color(white: 36 / 255)

    static let signalNS = NSColor(deviceRed: 53 / 255, green: 209 / 255, blue: 90 / 255, alpha: 1)
    static let secondaryNS = NSColor(white: 176 / 255, alpha: 1)
    static let lineNS = NSColor(white: 36 / 255, alpha: 1)
}

extension View {
    @ViewBuilder
    func usagerGlassButtonStyle(prominent: Bool = false) -> some View {
        if #available(macOS 26.0, *) {
            if prominent {
                self.buttonStyle(.glassProminent)
            } else {
                self.buttonStyle(.glass)
            }
        } else {
            self.buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    func usagerMenuCardSurface(cornerRadius: CGFloat = 8) -> some View {
        if #available(macOS 26.0, *) {
            self
                .background(
                    Color.black.opacity(0.34),
                    in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            self.background(
                Color.black.opacity(0.5),
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}
