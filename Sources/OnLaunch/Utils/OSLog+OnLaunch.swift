import OSLog

extension OSLog {
    /// `OSLog` used internally to log messages
    static let onlaunch = OSLog(subsystem: "app.kula.OnLaunch", category: "OnLaunch")
}
