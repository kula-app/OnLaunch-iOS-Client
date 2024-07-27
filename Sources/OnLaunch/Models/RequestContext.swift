import Foundation

struct RequestContext {
    let bundleId: String?
    let bundleVersion: String?
    let releaseVersion: String?
    let platformName: String
    let platformVersion: String

    func applyTo(request: inout URLRequest) {
        if let bundleId = bundleId {
            request.setValue(bundleId, forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-ID")
        }
        if let bundleVersion = bundleVersion {
            request.setValue(bundleVersion, forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-VERSION")
        }
        if let releaseVersion = releaseVersion {
            request.setValue(releaseVersion, forHTTPHeaderField: "X-ONLAUNCH-RELEASE-VERSION")
        }
        request.setValue(platformName, forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-NAME")
        request.setValue(platformVersion, forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-VERSION")
    }
}
