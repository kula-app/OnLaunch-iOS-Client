import Foundation

struct RequestContext {
    let bundleId: String?
    let bundleVersion: String?
    let locale: String
    let localeLanguageCode: String?
    let localeRegionCode: String?
    let platformName: String
    let platformVersion: String
    let releaseVersion: String?

    func applyTo(request: inout URLRequest) {
        request.setValue(bundleId, forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-ID")
        request.setValue(bundleVersion, forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-VERSION")
        request.setValue(locale, forHTTPHeaderField: "X-ONLAUNCH-LOCALE")
        request.setValue(localeLanguageCode, forHTTPHeaderField: "X-ONLAUNCH-LOCALE-LANGUAGE-CODE")
        request.setValue(localeRegionCode, forHTTPHeaderField: "X-ONLAUNCH-LOCALE-REGION-CODE")
        request.setValue(platformName, forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-NAME")
        request.setValue(platformVersion, forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-VERSION")
        request.setValue(releaseVersion, forHTTPHeaderField: "X-ONLAUNCH-RELEASE-VERSION")
    }
}
