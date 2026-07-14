import AppKit
import SwiftUI

/// Hosts a menu-card SwiftUI row whose selection highlight is rendered entirely by AppKit/Core
/// Animation instead of SwiftUI, so moving the highlight while scrolling costs no SwiftUI body
/// re-evaluation or content re-rasterization.
///
/// The reported Overview scroll stutter comes from driving the native selection look through SwiftUI:
/// each scroll step flips `menuItemHighlighted`, which re-renders the entire rich row subtree
/// (header, usage bars, storage line). A headless benchmark measured ~3–10 ms per toggle with
/// spikes past one 120 Hz frame, matching the dropped frames in the bug report.
///
/// This view keeps the SwiftUI content pinned to its normal (unselected) appearance and draws a
/// subtle brand-green layer behind it. Keeping the foreground unchanged preserves contrast and
/// avoids the system's pale native menu-selection treatment.
/// Toggling selection then costs a layer property change (~0.05 ms) rather than a SwiftUI pass.
@MainActor
final class GPUSelectionHostingView<Content: View>: NSView, MenuCardHighlighting, MenuCardMeasuring {
    private let hosting: NSHostingView<MenuCardSectionContainerView<Content>>
    private let selectionView = NSView()
    private var isRowHighlighted = false
    private var onClick: (() -> Void)?

    private(set) var allowsMenuHighlight: Bool

    /// Selection inset/radius mirror the SwiftUI `MenuCardSectionContainerView` highlight
    /// (`.padding(.horizontal, 6).padding(.vertical, 2)` with a 6 pt corner radius) so the AppKit
    /// background lands in the same place the SwiftUI one used to.
    private static var selectionHorizontalInset: CGFloat {
        6
    }

    private static var selectionVerticalInset: CGFloat {
        2
    }

    private static var selectionCornerRadius: CGFloat {
        6
    }

    /// Short enough that a fast flick still looks crisp, long enough to read as a glide rather than
    /// a hard cut. Tunable from real-device recordings.
    private static var selectionFadeDuration: CFTimeInterval {
        0.06
    }

    init(
        rootView: MenuCardSectionContainerView<Content>,
        allowsMenuHighlight: Bool,
        onClick: (() -> Void)?)
    {
        self.hosting = NSHostingView(rootView: rootView)
        self.allowsMenuHighlight = allowsMenuHighlight
        self.onClick = onClick
        super.init(frame: .zero)
        self.wantsLayer = true
        self.setupSelectionView()
        self.setupHosting()
        if onClick != nil {
            self.installClickRecognizer()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var allowsVibrancy: Bool {
        true
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: self.frame.width, height: self.hosting.intrinsicContentSize.height)
    }

    override func acceptsFirstMouse(for _: NSEvent?) -> Bool {
        true
    }

    /// Forward accessibility activation to the click handler, mirroring `MenuCardItemHostingView`.
    override func accessibilityRole() -> NSAccessibility.Role? {
        self.onClick == nil ? super.accessibilityRole() : .button
    }

    override func accessibilityPerformPress() -> Bool {
        guard let onClick = self.onClick else {
            return super.accessibilityPerformPress()
        }
        onClick()
        return true
    }

    override func layout() {
        super.layout()
        self.selectionView.frame = self.bounds.insetBy(
            dx: Self.selectionHorizontalInset,
            dy: Self.selectionVerticalInset)
        self.selectionView.layer?.cornerRadius = Self.selectionCornerRadius
        self.hosting.frame = self.bounds
    }

    func setHighlighted(_ highlighted: Bool) {
        guard self.isRowHighlighted != highlighted else { return }
        self.isRowHighlighted = highlighted
        // Crossfade the selection background instead of hard-cutting it. As the wheel moves the
        // highlight, the leaving row fades out while the arriving row fades in, which reads as the
        // selection gliding between rows rather than teleporting. The fade is short so fast flicks
        // still resolve crisply. Runs entirely on the GPU via Core Animation.
        let layer = self.selectionView.layer
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = layer?.presentation()?.opacity ?? (highlighted ? 0 : 1)
        fade.toValue = highlighted ? 1 : 0
        fade.duration = Self.selectionFadeDuration
        fade.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer?.add(fade, forKey: "selectionFade")
        layer?.opacity = highlighted ? 1 : 0
    }

    func measuredHeight(width: CGFloat) -> CGFloat {
        self.hosting.frame = NSRect(origin: self.hosting.frame.origin, size: NSSize(width: width, height: 1))
        self.hosting.layoutSubtreeIfNeeded()
        return self.hosting.fittingSize.height
    }

    #if DEBUG
    /// True once the menu marks this row highlighted via `setHighlighted`.
    var isHighlightedForTesting: Bool {
        self.isRowHighlighted
    }

    /// The hosted SwiftUI highlight state, which must stay `false` for GPU-selected rows — proving
    /// selection never re-invalidates the SwiftUI graph while scrolling.
    var swiftUIHighlightStateIsHighlightedForTesting: Bool {
        self.hosting.rootView.highlightState.isHighlighted
    }
    #endif

    private func setupSelectionView() {
        self.selectionView.wantsLayer = true
        self.selectionView.layer?.masksToBounds = true
        self.selectionView.layer?.backgroundColor = UsagerBrand.signalNS.withAlphaComponent(0.16).cgColor
        // Visibility is driven by layer opacity (crossfaded in `setHighlighted`) rather than
        // `isHidden`, so the selection can glide in and out instead of hard-cutting.
        self.selectionView.layer?.opacity = 0
        self.selectionView.autoresizingMask = [.width, .height]
        self.addSubview(self.selectionView)
    }

    private func setupHosting() {
        self.hosting.wantsLayer = true
        self.hosting.autoresizingMask = [.width, .height]
        self.addSubview(self.hosting)
    }

    private func installClickRecognizer() {
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(self.handlePrimaryClick(_:)))
        recognizer.buttonMask = 0x1
        self.addGestureRecognizer(recognizer)
    }

    @objc private func handlePrimaryClick(_ recognizer: NSClickGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        self.onClick?()
    }
}
