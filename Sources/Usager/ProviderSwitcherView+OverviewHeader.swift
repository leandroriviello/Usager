import AppKit

extension ProviderSwitcherView {
    static func overviewSwitcherHeight(
        isOverview: Bool,
        rowHeight: CGFloat,
        rowCount: Int,
        rowSpacing: CGFloat) -> CGFloat
    {
        isOverview
            ? 42
            : rowHeight * CGFloat(rowCount) + rowSpacing * CGFloat(max(0, rowCount - 1))
    }

    func configureBaseAppearance() {
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.9).cgColor
    }

    func installOverviewHeaderIfNeeded(_ isOverview: Bool) {
        guard isOverview else { return }
        self.buttons.forEach { $0.isHidden = true }

        let dot = NSView()
        dot.wantsLayer = true
        dot.layer?.backgroundColor = UsagerBrand.signalNS.cgColor
        dot.layer?.cornerRadius = 4
        dot.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 8),
            dot.heightAnchor.constraint(equalToConstant: 8),
        ])

        let title = NSTextField(labelWithString: "USAGER")
        title.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .medium)
        title.textColor = .white

        let spacer = NSView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let localTime = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .none,
            timeStyle: .short)
        let time = NSTextField(labelWithString: "LOCAL · \(localTime)")
        time.font = NSFont.monospacedSystemFont(ofSize: 9, weight: .medium)
        time.textColor = UsagerBrand.secondaryNS

        let refresh = self.overviewHeaderButton(
            symbol: "arrow.clockwise",
            toolTip: L("Refresh"),
            action: #selector(self.handleOverviewRefresh))
        refresh.isEnabled = self.onRefresh != nil

        let settings = self.overviewHeaderButton(
            symbol: "gearshape",
            toolTip: L("Settings…"),
            action: #selector(self.handleOverviewSettings))
        settings.isEnabled = self.onSettings != nil

        let stack = NSStackView(views: [dot, title, spacer, time, refresh, settings])
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    private func overviewHeaderButton(symbol: String, toolTip: String, action: Selector) -> NSButton {
        let image = NSImage(systemSymbolName: symbol, accessibilityDescription: toolTip)
        let button = NSButton(image: image ?? NSImage(), target: self, action: action)
        button.isBordered = false
        button.contentTintColor = UsagerBrand.secondaryNS
        button.toolTip = toolTip
        return button
    }

    @objc private func handleOverviewRefresh() {
        self.onRefresh?()
    }

    @objc private func handleOverviewSettings() {
        self.onSettings?()
    }
}
