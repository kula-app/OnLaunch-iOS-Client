@testable import OnLaunch
import XCTest

final class RequestContextTests: XCTestCase {
    // MARK: - Bundle ID

    func testApplyTo_bundleIdIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-ID")
        XCTAssertNil(value)
    }

    func testApplyTo_bundleIdIsDefined_headerShouldBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: "BUNDLE ID",
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-ID")
        XCTAssertEqual(value, "BUNDLE ID")
    }

    // MARK: - Bundle Version

    func testApplyTo_bundleVersionIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-VERSION")
        XCTAssertNil(value)
    }

    func testApplyTo_bundleVersionIsDefined_headerShouldBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: "BUNDLE VERSION",
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-VERSION")
        XCTAssertEqual(value, "BUNDLE VERSION")
    }

    // MARK: - Locale

    func testApplyTo_localeShouldBeSetInHeader() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "LOCALE",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-LOCALE")
        XCTAssertEqual(value, "LOCALE")
    }

    // MARK: - Locale Language Code

    func testApplyTo_localeLanguageCodeIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-LOCALE-LANGUAGE-CODE")
        XCTAssertNil(value)
    }

    func testApplyTo_localeLanguageCodeIsDefined_headerShouldBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: "",
            locale: "",
            localeLanguageCode: "en",
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-LOCALE-LANGUAGE-CODE")
        XCTAssertEqual(value, "en")
    }

    // MARK: - Locale Region Code

    func testApplyTo_localeRegionCodeIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-VERSION")
        XCTAssertNil(value)
    }

    func testApplyTo_localeRegionCodeIsDefined_headerShouldBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: "AT",
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-LOCALE-REGION-CODE")
        XCTAssertEqual(value, "AT")
    }

    // MARK: - Platform Name

    func testApplyTo_platformNameShouldBeSetInHeader() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "PLATFORM NAME",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-NAME")
        XCTAssertEqual(value, "PLATFORM NAME")
    }

    // MARK: - Platform Version

    func testApplyTo_platformVersionShouldBeSetInHeader() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "PLATFORM VERSION",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-VERSION")
        XCTAssertEqual(value, "PLATFORM VERSION")
    }

    // MARK: - Release Version

    func testApplyTo_releaseVersionIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: nil
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-RELEASE-VERSION")
        XCTAssertNil(value)
    }

    func testApplyTo_releaseVersionIsDefined_headerShouldBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            locale: "",
            localeLanguageCode: nil,
            localeRegionCode: nil,
            platformName: "",
            platformVersion: "",
            releaseVersion: "RELEASE VERSION"
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-RELEASE-VERSION")
        XCTAssertEqual(value, "RELEASE VERSION")
    }
}
