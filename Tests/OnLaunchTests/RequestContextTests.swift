@testable import OnLaunch
import XCTest

final class RequestContextTests: XCTestCase {
    func testApplyTo_bundleIdIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            releaseVersion: nil,
            platformName: "",
            platformVersion: ""
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
            releaseVersion: nil,
            platformName: "",
            platformVersion: ""
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-ID")
        XCTAssertEqual(value, "BUNDLE ID")
    }

    func testApplyTo_bundleVersionIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            releaseVersion: nil,
            platformName: "",
            platformVersion: ""
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
            releaseVersion: nil,
            platformName: "",
            platformVersion: ""
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-BUNDLE-VERSION")
        XCTAssertEqual(value, "BUNDLE VERSION")
    }

    func testApplyTo_releaseVersionIsNotDefined_headerShouldNotBeSet() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            releaseVersion: nil,
            platformName: "",
            platformVersion: ""
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
            releaseVersion: "RELEASE VERSION",
            platformName: "",
            platformVersion: ""
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-RELEASE-VERSION")
        XCTAssertEqual(value, "RELEASE VERSION")
    }

    func testApplyTo_platformNameShouldBeSetInHeader() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            releaseVersion: nil,
            platformName: "PLATFORM NAME",
            platformVersion: ""
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-NAME")
        XCTAssertEqual(value, "PLATFORM NAME")
    }

    func testApplyTo_platformVersionShouldBeSetInHeader() throws {
        // -- Arrange --
        var request = URLRequest(url: URL(string: "http://testing.local")!)
        let context = RequestContext(
            bundleId: nil,
            bundleVersion: nil,
            releaseVersion: nil,
            platformName: "",
            platformVersion: "PLATFORM VERSION"
        )
        // -- Act ---
        context.applyTo(request: &request)
        // -- Assert --
        let value = request.value(forHTTPHeaderField: "X-ONLAUNCH-PLATFORM-VERSION")
        XCTAssertEqual(value, "PLATFORM VERSION")
    }
}
