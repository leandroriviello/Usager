import AppKit
import SwiftUI
import UsagerCore

extension ProviderSwitcherSelection {
    var provider: UsageProvider? {
        switch self {
        case .overview:
            nil
        case let .provider(provider):
            provider
        }
    }
}

struct OverviewMenuCardRowView: View {
    let model: UsageMenuCardView.Model
    let storageText: String?
    let width: CGFloat
    @Environment(\.menuItemHighlighted) private var isHighlighted

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(self.model.providerName)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)

                Spacer()

                Circle()
                    .fill(self.model.subtitleStyle == .error ? UsagerBrand.tertiary : UsagerBrand.signal)
                    .frame(width: 6, height: 6)
                Text(self.model.subtitleStyle == .error ? L("Error") : L("Live"))
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(
                        self.model.subtitleStyle == .error
                            ? MenuHighlightStyle.secondary(self.isHighlighted)
                            : UsagerBrand.signal)

                if let plan = self.model.planText {
                    Text(plan)
                        .font(.caption)
                        .foregroundStyle(MenuHighlightStyle.secondary(self.isHighlighted))
                        .lineLimit(1)
                }
            }

            if self.model.metrics.isEmpty {
                Text(self.model.subtitleText)
                    .font(.footnote)
                    .foregroundStyle(MenuHighlightStyle.secondary(self.isHighlighted))
                    .lineLimit(2)
            } else {
                HStack(alignment: .top, spacing: 18) {
                    ForEach(Array(self.model.metrics.prefix(2))) { metric in
                        OverviewMetricSummaryView(metric: metric)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            if let storageText {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(L("Storage")):")
                        .font(.footnote)
                        .foregroundStyle(MenuHighlightStyle.secondary(self.isHighlighted))
                    Text(storageText)
                        .font(.footnote)
                        .foregroundStyle(MenuHighlightStyle.secondary(self.isHighlighted))
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, UsageMenuCardLayout.horizontalPadding)
        .padding(.vertical, 12)
        .frame(width: self.width, alignment: .leading)
    }
}

private struct OverviewMetricSummaryView: View {
    let metric: UsageMenuCardView.Model.Metric
    @Environment(\.menuItemHighlighted) private var isHighlighted

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(self.metric.title.uppercased())
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(MenuHighlightStyle.secondary(self.isHighlighted))
                .lineLimit(1)

            if let statusText = self.metric.statusText {
                Text(statusText)
                    .font(.footnote)
                    .lineLimit(1)
            } else {
                Text(self.metric.percentLabel)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)

                UsageProgressBar(
                    percent: self.metric.percent,
                    tint: UsagerBrand.signal,
                    accessibilityLabel: self.metric.percentStyle.accessibilityLabel,
                    pacePercent: self.metric.pacePercent,
                    paceOnTop: self.metric.paceOnTop,
                    warningMarkerPercents: self.metric.warningMarkerPercents,
                    workdayMarkerPercents: self.metric.workdayMarkerPercents)

                if let resetText = self.metric.resetText {
                    Text(resetText)
                        .font(.caption2)
                        .foregroundStyle(MenuHighlightStyle.secondary(self.isHighlighted))
                        .monospacedDigit()
                        .lineLimit(1)
                }
            }
        }
    }
}

struct OpenAIWebMenuItems {
    let hasUsageBreakdown: Bool
    let hasCreditsHistory: Bool
    let hasCostHistory: Bool
    let canShowBuyCredits: Bool
}

struct TokenAccountMenuDisplay: Equatable {
    let provider: UsageProvider
    let accounts: [ProviderTokenAccount]
    let snapshots: [TokenAccountUsageSnapshot]
    let activeIndex: Int
    let layout: MultiAccountMenuLayout

    var showAll: Bool {
        self.layout == .stacked
    }

    var showSwitcher: Bool {
        self.layout == .segmented
    }

    static func == (lhs: TokenAccountMenuDisplay, rhs: TokenAccountMenuDisplay) -> Bool {
        lhs.provider == rhs.provider &&
            lhs.accountIdentity == rhs.accountIdentity &&
            lhs.activeIndex == rhs.activeIndex &&
            lhs.layout == rhs.layout &&
            lhs.snapshotIdentity == rhs.snapshotIdentity
    }

    private var accountIdentity: [AccountIdentity] {
        self.accounts.map { account in
            AccountIdentity(
                id: account.id,
                label: account.label,
                externalIdentifier: account.externalIdentifier,
                usageScope: account.usageScope,
                organizationID: account.organizationID,
                workspaceID: account.workspaceID)
        }
    }

    private var snapshotIdentity: [SnapshotIdentity] {
        self.snapshots.map { snapshot in
            SnapshotIdentity(
                id: snapshot.id,
                hasSnapshot: snapshot.snapshot != nil,
                error: snapshot.error,
                sourceLabel: snapshot.sourceLabel)
        }
    }

    private struct AccountIdentity: Equatable {
        let id: UUID
        let label: String
        let externalIdentifier: String?
        let usageScope: String?
        let organizationID: String?
        let workspaceID: String?
    }

    private struct SnapshotIdentity: Equatable {
        let id: UUID
        let hasSnapshot: Bool
        let error: String?
        let sourceLabel: String?
    }
}

struct CodexAccountMenuDisplay: Equatable {
    let accounts: [CodexVisibleAccount]
    let snapshots: [CodexAccountUsageSnapshot]
    let activeVisibleAccountID: String?
    let layout: MultiAccountMenuLayout

    var showAll: Bool {
        self.layout == .stacked
    }

    var showSwitcher: Bool {
        self.layout == .segmented
    }

    var workspaceSections: [CodexAccountWorkspaceSection] {
        self.accounts.codexWorkspaceSections()
    }

    var showsWorkspaceGroups: Bool {
        Set(self.workspaceSections.map(\.title)).count > 1
    }

    static func == (lhs: CodexAccountMenuDisplay, rhs: CodexAccountMenuDisplay) -> Bool {
        lhs.accounts == rhs.accounts &&
            lhs.activeVisibleAccountID == rhs.activeVisibleAccountID &&
            lhs.layout == rhs.layout &&
            lhs.snapshotIdentity == rhs.snapshotIdentity
    }

    private var snapshotIdentity: [SnapshotIdentity] {
        self.snapshots.map { snapshot in
            SnapshotIdentity(
                id: snapshot.id,
                hasSnapshot: snapshot.snapshot != nil,
                error: snapshot.error,
                sourceLabel: snapshot.sourceLabel)
        }
    }

    private struct SnapshotIdentity: Equatable {
        let id: String
        let hasSnapshot: Bool
        let error: String?
        let sourceLabel: String?
    }
}
