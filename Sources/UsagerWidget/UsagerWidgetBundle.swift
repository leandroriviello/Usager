import SwiftUI
import WidgetKit

@main
struct UsagerWidgetBundle: WidgetBundle {
    var body: some Widget {
        UsagerSwitcherWidget()
        UsagerUsageWidget()
        UsagerHistoryWidget()
        UsagerCompactWidget()
        UsagerBurnDownWidget()
        UsagerCombinedBurnDownWidget()
    }
}

struct UsagerSwitcherWidget: Widget {
    private let kind = "UsagerSwitcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: self.kind,
            provider: UsagerSwitcherTimelineProvider())
        { entry in
            UsagerSwitcherWidgetView(entry: entry)
        }
        .configurationDisplayName("Usager Switcher")
        .description("Usage widget with a provider switcher.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct UsagerUsageWidget: Widget {
    private let kind = "UsagerUsageWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: self.kind,
            intent: ProviderSelectionIntent.self,
            provider: UsagerTimelineProvider())
        { entry in
            UsagerUsageWidgetView(entry: entry)
        }
        .configurationDisplayName("Usager Usage")
        .description("Session and weekly usage with credits and costs.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct UsagerHistoryWidget: Widget {
    private let kind = "UsagerHistoryWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: self.kind,
            intent: ProviderSelectionIntent.self,
            provider: UsagerTimelineProvider())
        { entry in
            UsagerHistoryWidgetView(entry: entry)
        }
        .configurationDisplayName("Usager History")
        .description("Usage history chart with recent totals.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct UsagerCompactWidget: Widget {
    private let kind = "UsagerCompactWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: self.kind,
            intent: CompactMetricSelectionIntent.self,
            provider: UsagerCompactTimelineProvider())
        { entry in
            UsagerCompactWidgetView(entry: entry)
        }
        .configurationDisplayName("Usager Metric")
        .description("Compact widget for credits or cost.")
        .supportedFamilies([.systemSmall])
    }
}

struct UsagerBurnDownWidget: Widget {
    private let kind = "UsagerBurnDownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: self.kind,
            intent: BurnDownSelectionIntent.self,
            provider: BurnDownTimelineProvider())
        { entry in
            BurnDownWidgetView(entry: entry)
        }
        .configurationDisplayName("Usager Burn Down")
        .description("Remaining budget compared with an ideal steady burn rate.")
        .supportedFamilies([.systemMedium])
    }
}

struct UsagerCombinedBurnDownWidget: Widget {
    private let kind = "UsagerCombinedBurnDownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: self.kind,
            intent: BurnProviderSelectionIntent.self,
            provider: CombinedBurnDownTimelineProvider())
        { entry in
            CombinedBurnDownWidgetView(entry: entry)
        }
        .configurationDisplayName("Usager Burn Down (Combined)")
        .description("Session and weekly burn-down charts in one tile.")
        .supportedFamilies([.systemMedium])
    }
}
