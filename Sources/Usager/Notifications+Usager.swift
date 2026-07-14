import Foundation
import UsagerCore

extension Notification.Name {
    static let usagerOpenSettings = Notification.Name("usagerOpenSettings")
    static let usagerDebugBlinkNow = Notification.Name("usagerDebugBlinkNow")
    #if DEBUG
    static let usagerDebugSimulateMemoryPressure =
        Notification.Name("com.leandroriviello.usager.debug.simulateMemoryPressure")
    #endif
    static let usagerSessionLimitReset = Notification.Name("usagerSessionLimitReset")
    static let usagerWeeklyLimitReset = Notification.Name("usagerWeeklyLimitReset")
    static let usagerProviderConfigDidChange = Notification.Name("usagerProviderConfigDidChange")
    static let usagerQuotaWarningDidPost = Notification.Name("usagerQuotaWarningDidPost")
}

@MainActor
final class SessionLimitResetEvent: NSObject {
    let provider: UsageProvider
    let accountIdentifier: String
    let accountLabel: String?
    let usedPercent: Double

    init(provider: UsageProvider, accountIdentifier: String, accountLabel: String?, usedPercent: Double) {
        self.provider = provider
        self.accountIdentifier = accountIdentifier
        self.accountLabel = accountLabel
        self.usedPercent = usedPercent
    }
}

@MainActor
final class WeeklyLimitResetEvent: NSObject {
    let provider: UsageProvider
    let accountIdentifier: String
    let accountLabel: String?
    let usedPercent: Double

    init(provider: UsageProvider, accountIdentifier: String, accountLabel: String?, usedPercent: Double) {
        self.provider = provider
        self.accountIdentifier = accountIdentifier
        self.accountLabel = accountLabel
        self.usedPercent = usedPercent
    }
}

@MainActor
final class QuotaWarningPostedEvent: NSObject {
    let provider: UsageProvider
    let window: QuotaWarningWindow
    let threshold: Int
    let postedAt: Date

    init(provider: UsageProvider, window: QuotaWarningWindow, threshold: Int, postedAt: Date) {
        self.provider = provider
        self.window = window
        self.threshold = threshold
        self.postedAt = postedAt
    }
}
